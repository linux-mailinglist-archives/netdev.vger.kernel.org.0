Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2A5FCD94
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJLV43 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJLV41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:56:27 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C91217D0
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:56:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 5EF1E141165;
        Wed, 12 Oct 2022 23:56:19 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id TusglJuBq2RE; Wed, 12 Oct 2022 23:56:13 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 3F363141032;
        Wed, 12 Oct 2022 23:56:12 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id C90986138A; Wed, 12 Oct 2022 23:56:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id C470260FAB;
        Wed, 12 Oct 2022 23:56:11 +0200 (CEST)
Date:   Wed, 12 Oct 2022 23:56:11 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <Y0c0Yw1FjmR0m+Cs@lunn.ch>
Message-ID: <93ce7034-a26f-b68d-f27f-ef90b6b01bf8@tarent.de>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com> <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de> <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de> <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de> <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com> <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de> <Y0c0Yw1FjmR0m+Cs@lunn.ch>
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

On Wed, 12 Oct 2022, Andrew Lunn wrote:

> > Ooh! Will try! That’s what I get for getting, ahem, inspiration
> > from other qdiscs.
> 
> Are other qdiscs also missing RTNL, or are you just using the
> inspiration in a different context?

I think I was probably confused between which of the functions can
be used when. Eric explained the why. What I was missing was… well,
basically what I asked for weeks ago — what functions I need to
provide when writing a qdisc, and which guarantees and expectations
these have. That rtnl is held for… apparently all but enqueue/dequeue…
was one of these. I doubt other qdiscs miss it, or their users would
also run into this crash or so :/

The thing I did first was to add ASSERT_RTNL(); directly before the
rtnl_* call, just like it was in the other place. That, of course,
crashed immediately. Now *this* could be done systematically.

In OpenBSD, things like that are often hidden behind #if DIAGNOSTIC
which is a global option, disabled in “prod” or space-constrained
(installer) kernels but enabled for the “generic” one for wide testing.
Something to think about?

I’m sure there’s lots of things like flow analysis around in the
Linux world, however that wouldn’t help out-of-tree code being
developed, whereas extra checks like that would. Just some thoughts,
as said earlier this is basically¹ my start in Linux kernel dev.

bye,
//mirabilos
① some small patching of existing code over the years excepted
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
