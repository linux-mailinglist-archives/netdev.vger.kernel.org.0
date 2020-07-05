Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C6D214D1C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGEO2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:28:45 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54035 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgGEO2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:28:45 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7A79541114;
        Sun,  5 Jul 2020 22:28:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     davem@davemloft.net, pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 0/3] make nf_ct_frag/6_gather elide the skb CB clear
Date:   Sun,  5 Jul 2020 22:28:29 +0800
Message-Id: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VKSUNCQkJMSktLQ0hLSllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDkzPVACKU8MPR0CGCM3OhxWVlVCTEpCKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBQ6ATo6Mj5JOE1MATg0LTop
        NAEKCy5VSlVKTkJIQk5CSEpOSUJPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTEo3Bg++
X-HM-Tid: 0a731f60f06c2086kuqy7a79541114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_ct_frag_gather and Make nf_ct_frag6_gather elide the CB clear 
when packets are defragmented by connection tracking. This can make
each subsystem such as br_netfilter, openvswitch, act_ct do defrag
without restore the CB. 
This also avoid serious crashes and problems in  ct subsystem.
Because Some packet schedulers store pointers in the qdisc CB private
area and parallel accesses to the SKB.

This series following up
http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/

patch1: add nf_ct_frag_gather elide the CB clear
patch2: make nf_ct_frag6_gather elide the CB clear
patch3: fix clobber qdisc_skb_cb in act_ct with defrag

wenxu (3):
  netfilter: nf_defrag_ipv4: Add nf_ct_frag_gather support
  netfilter: nf_conntrack_reasm: make nf_ct_frag6_gather elide the CB
    clear
  net/sched: act_ct: fix clobber qdisc_skb_cb in defrag

 include/linux/netfilter_ipv6.h              |   9 +-
 include/net/netfilter/ipv4/nf_defrag_ipv4.h |   2 +
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |   3 +-
 net/bridge/netfilter/nf_conntrack_bridge.c  |   7 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c         | 314 ++++++++++++++++++++++++++++
 net/ipv6/netfilter/nf_conntrack_reasm.c     |  19 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |   3 +-
 net/openvswitch/conntrack.c                 |   8 +-
 net/sched/act_ct.c                          |  12 +-
 9 files changed, 350 insertions(+), 27 deletions(-)

-- 
1.8.3.1

