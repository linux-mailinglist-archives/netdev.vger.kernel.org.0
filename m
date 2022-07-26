Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884265808F4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 03:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiGZBNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 21:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiGZBNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 21:13:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4A6286E7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 147E8B81160
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 01:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC46C341C6;
        Tue, 26 Jul 2022 01:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658798012;
        bh=rwpCRmP7FfLKLIsfpfQlfHQsczKVhxJ31+8+/Y4OiW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bivC1TR5fKkKNXT9T5DsXO8eBs8NHmlUSvBIqpPpWRlv2g/OOt1vSoT9vNo5kJIKP
         BMQ4saoaeG+rhm/bNc2hw4y2x10x4K68Yeghb3Co3RbU/9WMRld7WGqTCVQymE8bZ1
         LlXtWXWkHO9EX1KqcMhkg9JWXeaT7NbXuIahcQfGJU2qKVhCYzr1ac0DcZnaskfsM3
         RsavsVFo1zOT2UjBs8zmfBXKD9ATT2mIbExJfwH4b/0rN0+zh2Lv0tj7JFwxz9E6q4
         PDsdvQ2iwy/VoYhCCJ7Z9L8xvohf8jNdzUWEJt2PH2qm0RUvEcOt5KvjTkZMHGoNaC
         k97U9Iyr014fA==
Date:   Mon, 25 Jul 2022 18:13:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220725181331.2603bd26@kernel.org>
In-Reply-To: <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 20:46:01 +0000 Keller, Jacob E wrote:
> There are two problems, and only one of them is solved by strict
> validation right now:
> 
> 1) Does the kernel know this attribute?
> 
> This is the question of whether the kernel is new enough to have the
> attribute, i.e. does the DEVLINK_ATTR_DRY_RUN even exist in the
> kernel's uapi yet.
> 
> This is straight forward, and usually good enough for most
> attributes. This is what is solved by not setting
> GENL_DONT_VALIDATE_STRICT.
> 
> However, consider what happens once we add  DEVLINK_ATTR_DRY_RUN and
> support it in flash update, in version X. This leads us to the next
> problem.
> 
> 2) does the *command* recognize and support DEVLINK_ATTR_DRY_RUN
> 
> Since the kernel in this example already supports
> DEVLINK_ATTR_DRY_RUN, it will be recognized and the current setup the
> policy for attributes is the same for every command. Thus the kernel
> will accept DEVLINK_ATTR_DRY_RUN for any command, strict or not.
> 
> But if the command itself doesn't honor DEVLINK_ATTR_DRY_RUN, it will
> once again be silently ignored.
> 
> We currently use the same policy and the same attribute list for
> every command, so we already silently ignore unexpected attributes,
> even in strict validation, at least as far as I can tell when
> analyzing the code. You could try to send an attribute for the wrong
> command. Obviously existing iproute2 user space doesn't' do this..
> but nothing stops it.
> 
> For some attributes, its not a problem. I.e. all flash update
> attributes are only used for DEVLINK_CMD_FLASH_UPDATE, and passing
> them to another command is meaningless and will likely stay
> meaningless forever. Obviously I think we would prefer if the kernel
> rejected the input anyways, but its at least not that surprising and
> a smaller problem.
> 
> But for something generic like DRY_RUN, this is problematic because
> we might want to add support for dry run in the future for other
> commands. I didn't really analyze every existing command today to see
> which ones make sense. We could minimize this problem for now by
> checking DRY_RUN for every command that might want to support it in
> the future...

Hm, yes. Don't invest too much effort into rendering per-cmd policies
right now, tho. I've started working on putting the parsing policies 
in YAML last Friday. This way we can auto-gen the policy for the kernel
and user space can auto-gen the parser/nl TLV writer. Long story short
we can kill two birds with one stone if you hold off until I have the
format ironed out. For now maybe just fork the policies into two - 
with and without dry run attr. We'll improve the granularity later 
when doing the YAML conversion.
