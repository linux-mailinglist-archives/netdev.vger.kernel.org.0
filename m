Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD9569E9A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiGGJem convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Jul 2022 05:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbiGGJek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:34:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB7E545056
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:34:39 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-63-m_q81HC3OZ-aBD9J6788Ew-1; Thu, 07 Jul 2022 10:34:37 +0100
X-MC-Unique: m_q81HC3OZ-aBD9J6788Ew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 7 Jul 2022 10:34:36 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 7 Jul 2022 10:34:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "'linyunsheng@huawei.com'" <linyunsheng@huawei.com>
Subject: RE: rawip: delayed and mis-sequenced transmits
Thread-Topic: rawip: delayed and mis-sequenced transmits
Thread-Index: AdiRRdPsy1CkLIz2RqC6CNg1z+fBBwAVkGiAABGYDNA=
Date:   Thu, 7 Jul 2022 09:34:36 +0000
Message-ID: <20b3f85b4fa24f8f86ea479383580eed@AcuMS.aculab.com>
References: <433be56da42f4ab2b7722c1caed3a747@AcuMS.aculab.com>
 <20220706185417.2fcbcdf0@kernel.org>
In-Reply-To: <20220706185417.2fcbcdf0@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 07 July 2022 02:54
> 
> On Wed, 6 Jul 2022 15:54:18 +0000 David Laight wrote:
> > Anyone any ideas before I start digging through the kernel code?
> 
> If the qdisc is pfifo_fast and kernel is old there could be races.
> But I don't think that's likely given you probably run something
> recent and next packet tx would usually flush the stuck packet.
> In any case - switching qdisc could be a useful test, also bpftrace
> is your friend for catching patckets with long sojourn time.

Reading the sources I think I've found something:
In core/dev.c line 3818 there is:

static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
				 struct net_device *dev,
				 struct netdev_queue *txq)
{
	spinlock_t *root_lock = qdisc_lock(q);
	struct sk_buff *to_free = NULL;
	bool contended;
	int rc;

	qdisc_calculate_pkt_len(skb, q);

	if (q->flags & TCQ_F_NOLOCK) {
		if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
		    qdisc_run_begin(q)) {
			/* Retest nolock_qdisc_is_empty() within the protection
			 * of q->seqlock to protect from racing with requeuing.
			 */
			if (unlikely(!nolock_qdisc_is_empty(q))) {
				rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
				__qdisc_run(q);
				qdisc_run_end(q);

				goto no_lock_out;
			}

I think I'm getting into the code below with a packet queued.
Unlike the code above this sends the current packet before the
queued one - which is exactly what I'm seeing.
Which must mean that the global flags are out of sync with
the per-cpu flags and a transmit from the cpu that queued
the packet is needed to unblock things.

This seems to have been added by c4fef01ba4793

			qdisc_bstats_cpu_update(q, skb);
			if (sch_direct_xmit(skb, q, dev, txq, NULL, true) &&
			    !nolock_qdisc_is_empty(q))
				__qdisc_run(q);

			qdisc_run_end(q);
			return NET_XMIT_SUCCESS;
		}

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

