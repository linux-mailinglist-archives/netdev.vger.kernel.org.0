Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0E25FF1F9
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJNQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJNQDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:03:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD7B17D861;
        Fri, 14 Oct 2022 09:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD4961B98;
        Fri, 14 Oct 2022 16:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5040C433C1;
        Fri, 14 Oct 2022 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665763393;
        bh=GhT+2uwoWbVxlknQK8yOBQWtY4Zr0UcbQ0bqCKmzgRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SWLx2h2KdSCGExSD13RuEN268mxxtVyyTXF/CzGYRAL6LqxDjBLAuPIqEykXEeABL
         XpgTuQfurIDRJCPFkjLTTGs6xc4uLWscsCMw7Cs97oZp5QmmjDd00lF+2ws+z7iegK
         43k9VBPV2NPjeHwHVN3hwYDtZVu46DOdLi/Cee8sJLjk211jXjn9o/pGYhyMWQvaUL
         iSoYEHSU2QMARIIoPZiPCdGh/ECNJal7LfIUmTl+d74662HL3E3XMDZZC6ClYbu5bZ
         LiX+1ZmFB7eTiIiEf+KzQu3ES/d2tLAjBsRFQ5i+RqfXF7vwF5LLBqAP8v2aCsraAX
         uDRDBuhMlUing==
Date:   Fri, 14 Oct 2022 09:03:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     guoren@kernel.org, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <20221014090311.392e0546@kernel.org>
In-Reply-To: <Y0jowX4zIZMMVc0H@yury-laptop>
References: <20221014030459.3272206-1-guoren@kernel.org>
        <20221014030459.3272206-2-guoren@kernel.org>
        <20221013203544.110a143c@kernel.org>
        <20221013203911.2705eccc@kernel.org>
        <Y0jowX4zIZMMVc0H@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 21:42:41 -0700 Yury Norov wrote:
> > Oh, it was reposted today:
> >=20
> > https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail.c=
om/
> >=20
> > But we need a revert of 854701ba4c as well to cover the issue back up
> > for 6.1, AFAIU. =20
>=20
> The patch 854701ba4c is technically correct. I fixed most of warnings in
> advance, but nobody can foresee everything, right? I expected some noise,
> and now we have just a few things to fix.

I got 6 warnings booting my machine after pulling back from Linus
(which included your patches in net for the first time).
And that's not including the XPS and the virtio warning.

> This is what for -rc releases exist, didn't they?
>=20
> I suggest to keep the patch, because this is the only way to make
> cpumask_check()-related issues visible to people. If things will go as
> they go now, I expect that -rc3 will be clean from cpumask_check()
> warnings.

This sounds too close to saying that "it's okay for -rc1 to be broken".
Why were your changes not in linux-next for a month before the merge
window? :(

We will not be merging a refactoring series into net to silence an
arguably over-eager warning. We need a minimal fix, Guo Ren's patches
seem to miss the mark so I reckon the best use of everyone's time is=20
to just drop the exposing patch and retry in -next =F0=9F=A4=B7
