Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342F8569C5E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiGGICP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Jul 2022 04:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiGGICM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:02:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE6FA2BB34
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:02:08 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-209-zgEQLzY5O3my-9MC0q_Epw-1; Thu, 07 Jul 2022 09:02:06 +0100
X-MC-Unique: zgEQLzY5O3my-9MC0q_Epw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 7 Jul 2022 09:02:05 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 7 Jul 2022 09:02:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: rawip: delayed and mis-sequenced transmits
Thread-Topic: rawip: delayed and mis-sequenced transmits
Thread-Index: AdiRRdPsy1CkLIz2RqC6CNg1z+fBBwAVkGiAAA5PJ1A=
Date:   Thu, 7 Jul 2022 08:02:05 +0000
Message-ID: <fd92e34c41b94cd1ac9bfcadd4a94ee6@AcuMS.aculab.com>
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

Yes, I forgot to mention the system is running a 5.18-rc6 kernel.
(I've already got some diagnostics in the receive path.)

I'd expect bugs in the qdisc layer to (mostly) keep packets
in order.
In this case I'm sending several packets at 20ms intervals that
overtake the 'stuck' packet.
So it really must be on a per socket queue.
Also the 'stuck' packet is sent after the packet that unblocks it.

I'm not sure normal tracing will help.
I'm seeing one mis-sequence every couple of million packets.
I can add code to the ethernet tx code to call ftrace_stop()
when the delayed packet gets sent.
(I've got the same check in the rx path to detect lost packets.)
That should show where it came from and probably why it got queued.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

