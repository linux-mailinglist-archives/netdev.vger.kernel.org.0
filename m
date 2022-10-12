Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106CA5FCBEA
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 22:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJLUSH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 16:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJLUSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 16:18:06 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB02C4C39
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 13:18:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 53149141165;
        Wed, 12 Oct 2022 22:18:03 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 8MTBr_XlpVDQ; Wed, 12 Oct 2022 22:17:56 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id D79C81410A9;
        Wed, 12 Oct 2022 22:17:56 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 827426228E; Wed, 12 Oct 2022 22:17:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 7CD1F6228D;
        Wed, 12 Oct 2022 22:17:56 +0200 (CEST)
Date:   Wed, 12 Oct 2022 22:17:56 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Dave Taht <dave.taht@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
Message-ID: <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com> <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de> <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dixi quod…

> > I'll take a harder look, but does it crash if you rip out debugfs?
[…]
> And yes, it (commit dbb99579808dcf106264f28f3c8cf5ef2f2c05bf) still
> crashes even if this time I get yet another message… all of those I

I may have found the case by reducing further. Disabling the periodic
dropping of too-old packets wasn’t it, but apparently, the code now
guarded by JANZ_HEADDROP is it. Replacing it (dropping the oldest
packet returning NET_XMIT_CN) with trivial code that rejects the new
packet-to-be-enqueued with qdisc_drop() instead… seems to not crash.

So, the code in question that seems to introduce the crash is:


u32 prev_backlog = sch->qstats.backlog;
//… normal code to add the passed skb (timestamp, etc.)
// q->memusage += cb->truesz;
if (unlikely(overlimit = (++sch->q.qlen > sch->limit))) {
	struct sk_buff *skbtodrop;
	/* skbtodrop = head of FIFO and remove it from the FIFO */
	skbtodrop = q->q[1].first;
	if (!(q->q[1].first = skbtodrop->next))
		q->q[1].last = NULL;
	--sch->q.qlen;
	/* accounting */
	q->memusage -= get_janz_skb(skbtodrop)->truesz;
	qdisc_qstats_backlog_dec(sch, skbtodrop);
	/* free the skb */
	rtnl_kfree_skbs(skbtodrop, skbtodrop)
}
//… normal code to add:
// line 879-885 enqueue into the FIFO
// qdisc_qstats_backlog_inc(sch, skb);
//… now code protected by the flag again:
if (unlikely(overlimit)) {
	qdisc_qstats_overlimit(sch);
	qdisc_tree_reduce_backlog(sch, 0,
	    prev_backlog - sch->qstats.backlog);
	return (NET_XMIT_CN);
}
// normal code remaining: return (NET_XMIT_SUCCESS);


This *seems* pretty straightforward to me, given similar code
in other qdiscs, and what I could learn from their header and
implementation.

TIA,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
