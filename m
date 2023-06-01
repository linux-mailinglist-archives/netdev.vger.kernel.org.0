Return-Path: <netdev+bounces-7080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 625D5719B2B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACC0D1C20F06
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A58A23430;
	Thu,  1 Jun 2023 11:51:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD423420
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:51:56 +0000 (UTC)
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF7097
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 04:51:54 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
	id AD7A958740D5C; Thu,  1 Jun 2023 13:51:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id AC3F260D1A541;
	Thu,  1 Jun 2023 13:51:52 +0200 (CEST)
Date: Thu, 1 Jun 2023 13:51:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Sam Edwards <cfsworks@gmail.com>
cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
    "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression in IPv6 autoconf, maybe "ipv6/addrconf: fix timing
 bug in tempaddr regen"
In-Reply-To: <7ea57097-b458-c30b-bb53-517b901d3751@gmail.com>
Message-ID: <s5n6r540-o061-3n7o-28qo-16r6s4354ns0@vanv.qr>
References: <4n64q633-94rr-401n-s779-pqp2q0599438@vanv.qr> <7ea57097-b458-c30b-bb53-517b901d3751@gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday 2023-05-31 18:31, Sam Edwards wrote:
> On 5/31/23 03:20, Jan Engelhardt wrote:
>> Greetings.
>> 
>> I am observing that between kernel 5.19 and 6.0, a change was introduced
>> that makes the system just stop generating IPv6 Privacy Addresses after
>> some time.
>
> I'd been encountering this exact problem very reliably since at least the
> early 4.x days, which was my motivation for authoring this patch (which had
> fully fixed the problem for me). [...] So imagine my surprise to learn that
> [...] but that my patch is evidently making the problem happen *more*
> frequently in your case!

Interesting. So then, I will abandon the hypothesis of a regression
(and the bisect so far) and instead focus on finding the deeper
cause. If you say it has been a problem since 4.x, then my
observation that it seemingly worked in 5.19 doesn't hold water.
Also, more frequent occurrence with 6.x is decidedly a good thing for
me debugging this.

With some classic try-it-and-see printk'ing, my current of insight is
that this branch was taken when things start to go wrong:

        age = (now - tmp_tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
        if (cfg.preferred_lft <= regen_advance + age) {
                in6_ifa_put(ifp);
                in6_dev_put(idev);
                ret = -1;
                goto out;
        }

Now, I just need to dump the timer numbers to see how
this came together, and correlate with the RAs from the CPE.

> Since we're having some pretty extreme Works On My Machine Syndrome here, we
> should really figure out what's different in your case from mine. What arch are
> you building these kernels for? Could you share the defconfig? Are you able to
> see this on multiple machines/networks or have you only tried the one? Is this
> machine real hardware or a VM?

Fujitsu U7311 x86_64, http://inai.de/files/ipv6-config.txt
Tried only one so far.

