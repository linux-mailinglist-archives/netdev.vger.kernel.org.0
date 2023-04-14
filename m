Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0636E1AC3
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 05:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDND07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 23:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjDND04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 23:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4675D4C39;
        Thu, 13 Apr 2023 20:26:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D210D64374;
        Fri, 14 Apr 2023 03:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED9BC433D2;
        Fri, 14 Apr 2023 03:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681442793;
        bh=RJDVGjjLW9wPMhTKvMcwo53pRkCDc84UcdDQ5nCZb7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kcW0Yg5gftV7F1VwXH/O/XhGNYCdoOaZvAQCugKeQq9fFR1tC9wxVCNENX7Q8SSyt
         9o+t6FwIVbPuKG1lpmdQSCIdB6z3dHd1Ykp2trZIuyd3EZdQH2H8E3BaeIEdWoWz6Y
         o326BWbteJc+6v5tppbqPEDrZ/IK9UkJr8z6M6Ub7+FQmlx7Lb/6ZnD5ddz79HWK6p
         KVAByTxK/nzcUQDpks5/j5xU/Jvp9VEQB2AByRjDk913CXkEkbd2yMqVTcesOZhMyZ
         stKAA0TKtnULlhtMsZnPwojUDl9St6gB4My5tGpr2pd8fi2v2pjvyrzrzN8k17ygev
         jKvKZZSe2jEjw==
Date:   Thu, 13 Apr 2023 20:26:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230413202631.7e3bd713@kernel.org>
In-Reply-To: <ZDjCdpWcchQGNBs1@x130>
References: <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
        <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
        <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
        <20230410054605.GL182481@unreal>
        <20230413075421.044d7046@kernel.org>
        <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
        <ZDhwUYpMFvCRf1EC@x130>
        <20230413152150.4b54d6f4@kernel.org>
        <ZDiDbQL5ksMwaMeB@x130>
        <20230413155139.22d3b2f4@kernel.org>
        <ZDjCdpWcchQGNBs1@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 20:03:18 -0700 Saeed Mahameed wrote:
> On 13 Apr 15:51, Jakub Kicinski wrote:
> >On Thu, 13 Apr 2023 15:34:21 -0700 Saeed Mahameed wrote:  
> >> But this management connection function has the same architecture as other
> >> "Normal" mlx5 functions, from the driver pov. The same way mlx5
> >> doesn't care if the underlaying function is CX4/5/6 we don't care if it was
> >> a "management function".  
> >
> >Yes, and that's why every single IPU implementation thinks that it's
> >a great idea. Because it's easy to implement. But what is it for
> >architecturally? Running what is effectively FW commands over TCP?  
> 
> Where did you get this idea from? maybe we got the name wrong, 
> "management PF" is simply a minimalistic netdev PF to have eth connection
> with the on board BMC .. 
> 
> I agree that the name "management PF" sounds scary, but it is not a control
> function as you think, not at all. As the original commit message states:
> "loopback PF designed for communication with BMC".

Can you draw a small diagram with the bare metal guest, IPU, and BMC?
What's talking to what? And what packets are exchanged?

> >> But let's discuss what's wrong with it, and what are your thoughts ?
> >> the fact that it breaks a 6 years OLD FW, doesn't make it so horrible.  
> >
> >Right, the breakage is a separate topic.
> >
> >You say 6 years old but the part is EOL, right? The part is old and
> >stable, AFAIU the breakage stems from development work for parts which
> >are 3 or so generations newer.
> 
> Officially we test only 3 GA FWs back. The fact that mlx5 is a generic CX
> driver makes it really hard to test all the possible combinations, so we
> need to be strict with how back we want to officially support and test old
> generations.

Would you be able to pull the datapoints for what 3 GA FWs means 
in case of CX4? Release number and date when it was released?

I understand the challenge of backward compat with a multi-gen
driver. It's a trade off.

> >The question is who's supposed to be paying the price of mlx5 being
> >used for old and new parts? What is fair to expect from the user
> >when the FW Paul has presumably works just fine for him?
> >  
> Upgrade FW when possible, it is always easier than upgrading the kernel.
> Anyways this was a very rare FW/Arch bug, We should've exposed an
> explicit cap for this new type of PF when we had the chance, now it's too
> late since a proper fix will require FW and Driver upgrades and breaking
> the current solution we have over other OSes as well.
>
> Yes I can craft an if condition to explicitly check for chip id and FW
> version for this corner case, which has no precedence in mlx5, but I prefer
> to ask to upgrade FW first, and if that's an acceptable solution, I would
> like to keep the mlx5 clean and device agnostic as much as possible.

IMO you either need a fully fleshed out FW update story, with advanced
warnings for a few releases, distributing the FW via linux-firmware or
fwupdmgr or such.  Or deal with the corner cases in the driver :(

We can get Paul to update, sure, but if he noticed so quickly the
question remains how many people out in the wild will get affected 
and not know what the cause is?
