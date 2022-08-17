Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E40596F88
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiHQNLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbiHQNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8A526DB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D33612FE
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 13:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407A2C433C1;
        Wed, 17 Aug 2022 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660741790;
        bh=rszLf2pCTVl5ZsGmkASiTS5sIsLt0IfVi7IKCJzyEyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T+FVogiO9FZeD6LW9x0TWbITeThjmqr1OWN8FaWWpMykiZAKJsy6iJ6qKCzCCUgtW
         17OBMqbKFjZo5nKsrRG8E7ji2swGWJd5dIpXaJmt0flD0qeowd4UB5hPpfULgByfoT
         H/9CyEGtsA3X70Thas846t8/Ov9xbmoWKPh0z/PRCSGAnuNC9MeNujrPNeRqOhZ3QO
         tvRTnkeYAQXurLPHIJ0vHKutPIiZ92aiSG69A/p7hrmj7BwmNgkxPoDFApb4sdVTG8
         RYklXgAnDfLmzZXPclUjP208jroOVXrodCGvDvoe25keac41GWhUig3CCH4hgcjCb/
         KAW4WVdKwCiUQ==
Date:   Wed, 17 Aug 2022 15:09:45 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com
Subject: Re: [PATCH net-next 0/1] openvswitch: allow specifying ifindex of
 new interfaces
Message-ID: <20220817130945.szn6rmqubx5cs7ty@wittgenstein>
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:49:08PM +0300, Andrey Zhadchenko wrote:
> Hi!
> 
> CRIU currently do not support checkpoint/restore of OVS configurations, but
> there was several requests for it. For example,
> https://github.com/lxc/lxc/issues/2909

Ah right, I remember that. :)

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
> 
> As a broader solution, another generic approach is possible: modify
> __dev_change_net_namespace() to allow changing ifindexes within the same
> netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
> sure that all its users are ready for ifindex change.

I think that might become confusing. We already have issues - even with
the tracking infrastucture - to keep track of ifindex changes when a
network device is moved between network namespaces multiple times. So
I'd rather not make it possible to change the ifindex at will within the
same network namespace though I understand the appeal for CRIU.

> This will be indeed better for CRIU so we won't need to change every SDN
> module to be able to checkpoint/restore it. And probably avoid some bloat.
> What do you think of this?
> 
> Andrey Zhadchenko (1):
>   openvswitch: allow specifying ifindex of new interfaces
> 
>  include/uapi/linux/openvswitch.h     |  4 ++++
>  net/openvswitch/datapath.c           | 16 ++++++++++++++--
>  net/openvswitch/vport-internal_dev.c |  1 +
>  net/openvswitch/vport.h              |  2 ++
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> -- 
> 2.31.1
> 
