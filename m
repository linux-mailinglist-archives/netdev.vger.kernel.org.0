Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B087F536F00
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 03:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiE2BIJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 28 May 2022 21:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiE2BII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 21:08:08 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6145B8A6
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 18:08:05 -0700 (PDT)
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id BA5CCCD04F
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 01:07:05 +0000 (UTC)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id BA85B1C0003;
        Sun, 29 May 2022 01:06:59 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 29 May 2022 03:06:55 +0200
Message-Id: <CKBUCV5XNA5W.1WFEM5DTPSCHV@enhorning>
Cc:     "David Ahern" <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        "Linux NetDev" <netdev@vger.kernel.org>
Subject: Re: REGRESSION?? ping ipv4 sockets and binding to 255.255.255.255
 without IP_TRANSPARENT
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski?= <maze@google.com>
X-Mailer: aerc 0.9.0
References: <CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com>
In-Reply-To: <CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat May 28, 2022 at 10:48 AM CEST, Maciej Żenczykowski wrote:
> [...]
> Looking at the commit message of the above commit, this change in behaviour
> isn't actually described as something it does... so it might be an
> unintended consequence (ie. bug).
I confirm that, indeed, it was unintended. While my patch was getting
reviewed, it was reported by someone that 0ce779a9f501 introduced the
following logic, which I removed in my patch:

-               if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
-                       chk_addr_ret = RTN_LOCAL;
-               else
-                       chk_addr_ret = inet_addr_type(net,
addr->sin_addr.s_addr);

I proposed a revert of ping.c, but as the reporter did not respond to
the request to clarify, the patch was applied as it was. Needless to
say, the point is now clear. :)

Digging a bit further, it seems that the logic was actually already
implemented in c319b4d76b9, the original ICMP socket implementation.
Nothing about the behaviour of broadcast and multicast bind addresses is
mentioned in the commit message or linked Mac OS X documentation
(although it would be interesting to test how Mac OS X behaves - anyone
with a Mac around here that can do that?)

To recap the pre-5.17 and 5.17+ behaviours, without IP_TRANSPARENT
(and similar flags):
+--------------------------------------------+
| addr                         | pre | 5.17+ |
+------------------------------+-----+-------+
| 0.0.0.0 / any                | OK  | OK    |
| 255.255.255.255 / broadcast  | ERR | OK :( |
| 224.x.x.x / multicast        | ERR | OK :( |
| address present              | OK  | OK    |
| address absent               | ERR | ERR   |
+------------------------------+-----+-------+


>
> I can easily relax the test to skip this test case on 5.17+...
> although I'm not entirely certain
> we don't depend on this somewhere... While I sort of doubt that, I
> wonder if this has some security implications???.
>
> My main problem is that binding the source of a ping socket to a
> multicast or broadcast address does seem pretty bogus...
> and this is not something I would want unprivileged users to be able to do...
>
> I've verified reverting the net/ipv4/ping.c chunk of the above commit
> does indeed fix the testcase.
>
> Thoughts? Skip test? or fix the kernel to disallow it?
I agree, it doesn't make sense to be able to do that. That's probably
why the check was done that way in the first place. I think the previous
behaviour should be restored. Not by reverting (part of) the patch,
because honestly the original code sucked, but by rewriting it properly.
And more importantly I think that test cases for that should be added in
the kernel (this has been in two released minor versions before even
being caught...)

I should be able to roll up a patch inside a few days, if this sounds
like a good approach to everyone.

Riccardo P. Bestetti

