Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F2E596ECA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiHQMwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiHQMwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:52:15 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2210B8B9A4
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:52:14 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oOIUk-00GCp5-NQ;
        Wed, 17 Aug 2022 14:51:13 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org
Subject: [PATCH net-next 0/1] openvswitch: allow specifying ifindex of new interfaces
Date:   Wed, 17 Aug 2022 15:49:08 +0300
Message-Id: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

CRIU currently do not support checkpoint/restore of OVS configurations, but
there was several requests for it. For example,
https://github.com/lxc/lxc/issues/2909

The main problem is ifindexes of newly created interfaces. We realy need to
preserve them after restore. Current openvswitch API does not allow to
specify ifindex. Most of the time we can just create an interface via
generic netlink requests and plug it into ovs but datapaths (generally any
OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
do not support selecting ifindex.

This patch allows to do so.
For new datapaths I decided to use dp_infindex in header as infindex
because it control ifindex for other requests too.
For internal vports I reused OVS_VPORT_ATTR_IFINDEX.

The only concern I have is that previously dp_ifindex was not used for
OVS_DP_VMD_NEW requests and some software may not set it to zero. However
we have been running this patch at Virtuozzo for 2 years and have not
encountered this problem. Not sure if it is worth to add new
ovs_datapath_attr instead.


As a broader solution, another generic approach is possible: modify
__dev_change_net_namespace() to allow changing ifindexes within the same
netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
sure that all its users are ready for ifindex change.
This will be indeed better for CRIU so we won't need to change every SDN
module to be able to checkpoint/restore it. And probably avoid some bloat.
What do you think of this?

Andrey Zhadchenko (1):
  openvswitch: allow specifying ifindex of new interfaces

 include/uapi/linux/openvswitch.h     |  4 ++++
 net/openvswitch/datapath.c           | 16 ++++++++++++++--
 net/openvswitch/vport-internal_dev.c |  1 +
 net/openvswitch/vport.h              |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

-- 
2.31.1

