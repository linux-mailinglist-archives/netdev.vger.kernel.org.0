Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4424D1CFF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbiCHQSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348208AbiCHQSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:18:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA361013;
        Tue,  8 Mar 2022 08:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A90B616F2;
        Tue,  8 Mar 2022 16:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B684C340EB;
        Tue,  8 Mar 2022 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646756253;
        bh=RHG7+NaypXs6njZprF1L4oaPoKIzbTsRnRQHdaHpdxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=opNzORxJtVFIfnE3Xb8qL/GahhvtR6BV7v2P/YREv0EXAf1ECKOmeOZWQfLD3lp7o
         aGXdHZKjFuXiCft6gzKTjHYHzXExEKAL28DfiljubBaxZp75fWfq4d+sRsKZYqQ4gh
         HRkss7pg/g9x9viCFjQgt0wN6WR96ic9XJHidu6LCHxQkEH/e88oaDGF4jLz3BoxP8
         UlrOSqkDxey26M56j/wXiU4Fw6+/E7X6LevZT+JEnQaec+yrg+Mw0jcvdbrEHWwvf0
         BIQihrPGi2FSTMp/SQUHsaOEFN1fnS752uXP1HajU6tzBn+1GZo+JNFidiS9aPNCu2
         GaILL66Ipgc1g==
Date:   Tue, 8 Mar 2022 08:17:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Roi Dayan <roid@nvidia.com>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220308081731.3588b495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
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

On Tue, 8 Mar 2022 15:12:45 +0100 Ilya Maximets wrote:
> >> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> >> index 9d1710f20505..ab6755621e02 100644
> >> --- a/include/uapi/linux/openvswitch.h
> >> +++ b/include/uapi/linux/openvswitch.h
> >> @@ -351,11 +351,16 @@ enum ovs_key_attr {
> >>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> >>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> >>         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> >> -       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> >>  
> >>  #ifdef __KERNEL__
> >>         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> >>  #endif
> >> +       /* User space decided to squat on types 30 and 31 */
> >> +       OVS_KEY_ATTR_IPV6_EXTHDRS = 32, /* struct ovs_key_ipv6_exthdr */
> >> +       /* WARNING: <scary warning to avoid the problem coming back> */  
> 
> Yes, that is something that I had in mind too.  The only thing that makes
> me uncomfortable is OVS_KEY_ATTR_TUNNEL_INFO = 30 here.  Even though it
> doesn't make a lot of difference, I'd better keep the kernel-only attributes
> at the end of the enumeration.  Is there a better way to handle kernel-only
> attribute?

My thought was to leave the kernel/userspace only types "behind" to
avoid perpetuating the same constructs.

Johannes's point about userspace to userspace messages makes the whole
thing a little less of an aberration.

Is there a reason for the types to be hidden under __KERNEL__? 
Or someone did that in a misguided attempt to save space in attr arrays
when parsing?

> Also, the OVS_KEY_ATTR_ND_EXTENSIONS (31) attribute used to store IPv6 Neighbor
> Discovery extensions is currently implemented only for userspace, but nothing
> actually prevents us having the kernel implementation.  So, we need a way to
> make it usable by the kernel in the future.

The "= 32" leaves the earlier attr types as reserved so nothing
prevents us from defining them later. But..

> > It might be nicer to actually document here in what's at least supposed
> > to be the canonical documentation of the API what those types were used
> > for.  
> 
> I agree with that.

Should we add the user space types to the kernel header and remove the
ifdef __KERNEL__ around TUNNEL_INFO, then?
