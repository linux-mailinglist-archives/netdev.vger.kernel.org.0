Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5195975A8
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiHQSTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiHQSTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:19:32 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4614C616
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:19:31 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 0063D40005;
        Wed, 17 Aug 2022 18:19:26 +0000 (UTC)
Message-ID: <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
Date:   Wed, 17 Aug 2022 20:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Cc:     dev@openvswitch.org, brauner@kernel.org, edumazet@google.com,
        avagin@google.com, alexander.mikhalitsyn@virtuozzo.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        ptikhomirov@virtuozzo.com, i.maximets@ovn.org,
        Aaron Conole <aconole@redhat.com>
Content-Language: en-US
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next 0/1] openvswitch: allow specifying
 ifindex of new interfaces
In-Reply-To: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/22 14:49, Andrey Zhadchenko via dev wrote:
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

Hmm.  Assuming you restored network interfaces by re-creating them
on a target system, but I'm curious how do you restore the upcall PID?
Are you somehow re-creating the netlink socket with the same PID?
If that will not be done, no traffic will be able to flow through OVS
anyway until you remove/re-add the port in userspace or re-start OVS.
Or am I missing something?

Best regards, Ilya Maximets.

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

