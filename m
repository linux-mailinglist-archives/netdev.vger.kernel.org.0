Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343F44D0F43
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 06:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245254AbiCHFqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 00:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiCHFqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 00:46:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE613BBD1;
        Mon,  7 Mar 2022 21:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A73B61574;
        Tue,  8 Mar 2022 05:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF1C340EB;
        Tue,  8 Mar 2022 05:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646718352;
        bh=Y8xpjnCaZqjpKAi6LH7psa4XoBGA667VBgBc+PH2nLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mx31lcmtoMKA2ZBo/RU8iqV+gJN1S6CXEHizj1ptrPAsEWcD+SctSZK3N7b9x3/xe
         POuXp8Eo72XT3OIykVrom6BbZ/Zyi1xNzV/1520yN5alcXPInUABF3+4+ACw493ewC
         FhvPmRDtFyVK33kDjnnZYz9kzl1apHU00BOLGcYPnqRAAJQODDFz20RzCOrUBLG3Ko
         ja/APFTJXnAt5dXeh77V/T4/kymHSNvIf6mJ9DIrMF1cu497Qta9bBxA3ED945YaGt
         Hy2K3PjUVGkxDXPvNdC9blAwRS/Wk1LtRxI/mI09nmGNt+JzECmMIr0KYoxllvS6hv
         hJj8s8lfkj0dg==
Date:   Mon, 7 Mar 2022 21:45:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Roi Dayan <roid@nvidia.com>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
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

On Tue, 8 Mar 2022 01:04:00 +0100 Ilya Maximets wrote:
> > Thanks for the explanation, we can apply a revert if that'd help your
> > CI / ongoing development but sounds like the fix really is in user
> > space. Expecting netlink attribute lists not to grow is not fair.  
> 
> I don't think it was intentional, just a careless mistake.  Unfortunately,
> all OVS binaries built during the last 5 years rely on that unwanted
> expectation (re-build will also not help as they are using a copy of the
> uAPI header and the clash will be there anyway).  If we want to keep them
> working, kernel uAPI has to be carefully updated with current userspace-only
> attributes before we add any new ones.  That is not great, but I don't see
> any other option right now that doesn't require code changes in userspace.
> 
> I'd say that we need to revert the current patch and re-introduce it
> later when the uAPI problem is sorted out.  This way we will avoid blocking
> the net-next testing and will also avoid problems in case the uAPI changes
> are not ready at the moment of the new kernel release.
> 
> What do you think?

Let me add some people I associate with genetlink work in my head
(fairly or not) to keep me fair here.

It's highly unacceptable for user space to straight up rewrite kernel
uAPI types but if it already happened the only fix is something like:

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 9d1710f20505..ab6755621e02 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -351,11 +351,16 @@ enum ovs_key_attr {
        OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
        OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
        OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
-       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
 
 #ifdef __KERNEL__
        OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
 #endif
+       /* User space decided to squat on types 30 and 31 */
+       OVS_KEY_ATTR_IPV6_EXTHDRS = 32, /* struct ovs_key_ipv6_exthdr */
+       /* WARNING: <scary warning to avoid the problem coming back> */
+
        __OVS_KEY_ATTR_MAX
 };


right?

> > Since ovs uses genetlink you should be able to dump the policy from 
> > the kernel and at least validate that it doesn't overlap.  
> 
> That is interesting.  Indeed, this functionality can be used to detect
> problems or to define userspace-only attributes in runtime based on the
> kernel reply.  Thanks for the pointer!
