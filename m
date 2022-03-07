Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22864D0B55
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243292AbiCGWrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243189AbiCGWrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:47:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB7A26D;
        Mon,  7 Mar 2022 14:46:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18591CE12A5;
        Mon,  7 Mar 2022 22:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B59C340F3;
        Mon,  7 Mar 2022 22:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646693178;
        bh=0H6XB46pWYh6xZnaTmcKQn0MM2/ClqZdvLNMr6BJqkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtMZcA53GaxsPpz3H1bwL5eT9rsN7fl5bs5guxs34W4ttTLsb+jDmo+ZCzsD5Q1Z+
         WfuFn2eezBXmbYeiq666HzAW6hjYzKtWgKnkg7VRs1XesXGSs3sf8XaJNc1QzMsJaA
         HUoviWFPuUcpK+vuOeLiaas261WV1lXfEazfMAN9sd6f/g9Qa/vJ+z3gGAbro+0uIv
         4CzZ7Xcc2/pzbBO75DpgDFn6QuMVQqjQCPdQFniPEKJN2UM3cWZXCmy3axAOUy0y/H
         Yq1N/OjS0TSjS5Hr7363ef484SvANz2cXBw6kkPRu9K9hgO/1Nv6JKlL6vraECSFFI
         miDt/c4FfP9bg==
Date:   Mon, 7 Mar 2022 14:46:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Roi Dayan <roid@nvidia.com>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
        <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
        <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
        <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
        <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
        <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
        <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
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

On Mon, 7 Mar 2022 23:14:13 +0100 Ilya Maximets wrote:
> The main problem is that userspace uses the modified copy of the uapi header
> which looks like this:
>   https://github.com/openvswitch/ovs/blob/f77dbc1eb2da2523625cd36922c6fccfcb3f3eb7/datapath/linux/compat/include/linux/openvswitch.h#L357
> 
> In short, the userspace view:
> 
>   enum ovs_key_attr {
>       <common attrs>
> 
>   #ifdef __KERNEL__
>       /* Only used within kernel data path. */
>   #endif
> 
>   #ifndef __KERNEL__
>       /* Only used within userspace data path. */
>   #endif
>       __OVS_KEY_ATTR_MAX
> };
> 
> And the kernel view:
> 
>   enum ovs_key_attr {
>       <common attrs>
> 
>   #ifdef __KERNEL__
>       /* Only used within kernel data path. */
>   #endif
> 
>       __OVS_KEY_ATTR_MAX
>   };
> 
> This happened before my time, but the commit where userspace made a wrong
> turn appears to be this one:
>   https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
> The attribute for userspace only was added to the common enum after the
> OVS_KEY_ATTR_TUNNEL_INFO.   I'm not sure how things didn't fall apart when
> OVS_KEY_ATTR_NSH was added later (no-one cared that NSH doesn't work, because
> OVS didn't support it yet?).
> 
> In general, any addition of a new attribute into that enumeration leads to
> inevitable clash between userpsace-only attributes and new kernel attributes.
> 
> After the kernel update, kernel provides new attributes to the userspace and
> userspace tries to parse them as one of the userspace-only attributes and
> fails.   In our current case userspace is trying to parse OVS_KEY_ATTR_IPV6_EXTHDR
> as userspace-only OVS_KEY_ATTR_PACKET_TYPE, because they have the same value in the
> enum, fails and discards the netlink message as malformed.  So, IPv6 is fully
> broken, because OVS_KEY_ATTR_IPV6_EXTHDR is supplied now with every IPv6 packet
> that goes to userspace.
> 
> We need to unify the view of 'enum ovs_key_attr' between userspace and kernel
> before we can add any new values to it.
> 
> One way to do that should be addition of both userspace-only attributes to the
> kernel header (and maybe exposing OVS_KEY_ATTR_TUNNEL_INFO too, just to keep
> it flat and avoid any possible problems in the future).  Any other suggestions
> are welcome.  But in any case this will require careful testing with existing
> OVS userspace to avoid any unexpected issues.
> 
> Moving forward, I think, userspace OVS should find a way to not have userpsace-only
> attributes, or have them as a separate enumeration.  But I'm not sure how to do
> that right now.  Or we'll have to add userspace-only attributes to the kernel
> uapi before using them.

Thanks for the explanation, we can apply a revert if that'd help your
CI / ongoing development but sounds like the fix really is in user
space. Expecting netlink attribute lists not to grow is not fair.

Since ovs uses genetlink you should be able to dump the policy from 
the kernel and at least validate that it doesn't overlap.
