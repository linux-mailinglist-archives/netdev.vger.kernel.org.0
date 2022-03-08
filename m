Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A24D2263
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 21:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbiCHUSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 15:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiCHUSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 15:18:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D4396A7;
        Tue,  8 Mar 2022 12:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A518617B3;
        Tue,  8 Mar 2022 20:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C19C340EB;
        Tue,  8 Mar 2022 20:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646770628;
        bh=o3Z0MKvYI7Rhy2kh/78Ads7YnfDBAWgnxKSelNwL7uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FN0I+BlkkIjkXdzN2btr6G9p9Ta0fZOw0YBVk7cdiY5lAAjxUAKlDkid8Vlm/noK9
         H/XUNvZrSGK7w5Di1Uo2jNzEOXogrrKQaOunB03UHwaJa27FvuYr880BNZxeNNd3vp
         aqqRhsV7OEVfoP0m1HIh4XO7S7U269odRS+YGipp9Ij0H/g36Z7GEHIjJSkhfkt8YX
         HupaYalCZb54v9IxMLmCLCqjduqytjOtBdPEXaXVcnlHUgibkS0J3DDfn6eLhq6pgL
         nB7VCQQX2qrjB80nHS0fbmU+AI6DUHm/NIp7gHmG9Pn4IO7sCzdg+GeFJlnA9wIKy9
         Fsl3OwEoNqpUQ==
Date:   Tue, 8 Mar 2022 12:17:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Roi Dayan <roid@nvidia.com>,
        Johannes Berg <johannes@sipsolutions.net>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220308121706.5e406e67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1eca594f-ec8c-b54a-92f3-e561fa049015@ovn.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
        <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
        <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
        <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
        <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
        <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
        <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
        <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
        <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
        <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
        <c9f43e92-8a32-cf0e-78d7-1ab36950021c@nvidia.com>
        <1eca594f-ec8c-b54a-92f3-e561fa049015@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Mar 2022 19:25:31 +0100 Ilya Maximets wrote:
> > since its rc7 we end up with kernel and ovs broken with each other.
> > can we revert the kernel patches anyway and introduce them again later
> > when ovs userspace is also updated?  
> 
> I don't think this patch is part of 5-17-rc7.  AFAICT, it's a candidate
> for 5.18, so we should still have a bit of time.  Am I missing something?

You are correct, it's going to hit Linus's tree during the 5.18 merge
window. It seems we're close enough to a resolution to focus on a fix
instead.
