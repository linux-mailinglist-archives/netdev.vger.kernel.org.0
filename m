Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A725A23D4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245347AbiHZJML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245744AbiHZJMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:12:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45318D6BAB
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29B7B82FDE
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EB8C43140;
        Fri, 26 Aug 2022 09:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661505115;
        bh=9Hc/ZVlkUQ0mJW0yEFzahKoYD3UoFK4+z1GFwrpL49k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cs8GHn6AayJTPqmAovaH6bVh4SJ25tY1xKOrTdOs1qSwKN+aGMCRYO6wXV2AmgBJz
         RpqI/TkjcSBoTE33daCiYy7LBroapuL2DWd0ZweUWMyrlqso7DynGDmGzotI4pEs7M
         oreuoGaqlDGIK2AYjLuIYFgPDpanYuk/At/pWZlgcQotq6JjqT9syHWe94mAh9ToaH
         f9WImR9MAHPfvq+USS7su+hp30m0rCmZq0bgAO/YEqWBEFkvgblkRoigrEtTBOyqt+
         0LgMVNhsVb/2097Eak1QF4gzOpKB6CsMSQx5RMdNcGr8uTlhVi7nRwEPr8QNpbaSqW
         lWaJBsj/4Z6tw==
Date:   Fri, 26 Aug 2022 11:11:47 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: Re: [PATCH net-next v3 0/2] openvswitch: allow specifying ifindex of
 new interfaces
Message-ID: <20220826091147.eechwvoa6eckhuq4@wittgenstein>
References: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 05:04:48AM +0300, Andrey Zhadchenko wrote:
> Hi!
> 
> CRIU currently do not support checkpoint/restore of OVS configurations, but
> there was several requests for it. For example,
> https://github.com/lxc/lxc/issues/2909
> 
> The main problem is ifindexes of newly created interfaces. We realy need to
> preserve them after restore. Current openvswitch API does not allow to
> specify ifindex. Most of the time we can just create an interface via
> generic netlink requests and plug it into ovs but datapaths (generally any
> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
> do not support selecting ifindex.
> 
> This patch allows to do so.
> For new datapaths I decided to use dp_infindex in header as infindex
> because it control ifindex for other requests too.
> For internal vports I reused OVS_VPORT_ATTR_IFINDEX.
> 
> The only concern I have is that previously dp_ifindex was not used for
> OVS_DP_VMD_NEW requests and some software may not set it to zero. However
> we have been running this patch at Virtuozzo for 2 years and have not
> encountered this problem. Not sure if it is worth to add new
> ovs_datapath_attr instead.
> 
> v2:
> Added two more patches.
> 
> Add OVS_DP_ATTR_PER_CPU_PIDS to dumps as suggested by Ilya Maximets.
> Without it we won't be able to checkpoint/restore new openvswitch
> configurations which use OVS_DP_F_DISPATCH_UPCALL_PER_CPU flag.
> 
> Found and fixed memory leak on datapath creation error path.
> 
> v3:
> Sent memleak fix separately to net.
> Improved patches according to the reviews:
>  - Added new OVS_DP_ATTR_IFINDEX instead of using ovs_header->dp_ifindex
>  - Pre-allocated bigger reply message for upcall pids
>  - Some small fixes

Seems good,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
