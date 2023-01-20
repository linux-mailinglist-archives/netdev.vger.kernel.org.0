Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFB674C04
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjATFT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjATFTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:19:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902D47DFAE
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:09:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D5561DEF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27A7C433EF;
        Fri, 20 Jan 2023 05:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674191324;
        bh=smw6bvnN4L3m5B8KrSxBWIVZBzpkAFwXLeYLet0J0+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HoX0Qto2k4+noLSTAe5OXKwLm/+PN8Oc53A3+Kg0NwOpQEob2klaPlvt3j+linBrO
         ZQyzWI1jtYd0AbQ/AClWLYTuTXPJetz3Yzwhn6Xlc11+JdAXAf5/uxMTXhcKe+O5SY
         M/QyjllG62nDrzxr7Q9uYPIUhfqbnHrF8VeJmcUPK3gtMNoZDB30iNTdwrabfiGfWc
         CJ/wZVCtsrIxApU2HDpx0safC6upeZ4Trs/YLrvA7FbvxClsMpFf1U83gPS7+rHG4E
         PACgdyBOFVSQq0PUKiZV890ZGW6/Suq2akvSiG8s2Amm8aHuUcVHGDHis2aqi0e5ND
         ICcnjOTalT44w==
Date:   Thu, 19 Jan 2023 21:08:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230119210842.5faf1e44@kernel.org>
In-Reply-To: <87pmb9u90j.fsf@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org>
        <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org>
        <87pmb9u90j.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 20:26:04 -0800 Rahul Rameshbabu wrote:
> One of my concerns with doing this is breaking userspace expectations.
> In linuxptp, there is a configuration setting "write_phase_mode" and an
> expectation that when adjphase is called, there will not be a fallback
> to adjtime. This because adjphase is used in situations where small fine
> tuning is explicitly needed, so the errors would indicate a logical or
> situational error.

I don't mean fallback - just do what you do in mlx5 directly in 
the core. The driver already does:

if delta < MAX
	use precise method
else
	use coarse method

> Quoting Vincent Cheng, the author of the adjphase functionality in the
> ptp core stack.
> 
> -----BEGIN QUOTE-----
>   adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
>   adjphase modifies the frequency to quickly nudge the 1 PPS to new location and also includes a HW filter to smooth out the adjustments and fine tune frequency.
> 
>   Continuous small offset adjustments using adjtime, likley see sudden shifts of the 1 PPS.  The 1 PPS probably disappears and re-appears.
>   Continuous small offset adjustments using adjphase, should see continuous 1 PPS.
> 
>   adjtime is good for large offset corrections
>   adjphase is good for small offset corrections to allow HW filter to control the frequency instead of relying on SW filter.

Hm, so are you saying that:

adjtime(delta):
	clock += delta

but:

adjfreq(delta):
	on clock tick & while delta > 0:
		clock += small_value
		delta -= small_value

because from looking at mlx5 driver code its unclear whether the
implementation does a precise but one shot adjustment or gradual
adjustments.
