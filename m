Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11F42165A3
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgGGEzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:55:15 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7514 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgGGEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 00:55:15 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 052944174E;
        Tue,  7 Jul 2020 12:55:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: [PATCH net-next v2 0/3] make nf_ct_frag/6_gather elide the skb CB clear
Date:   Tue,  7 Jul 2020 12:55:08 +0800
Message-Id: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVOTU1CQkJNTEhDT0hIQ1lXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDoVEgMuDTo6KR0kGg0vOhxWVlVKT0pCKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NFE6CQw4MT5MEk0qQyEMAg8D
        MRUKFDZVSlVKTkJPS0JMTEpJQktLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTEs3Bg++
X-HM-Tid: 0a7327a0bba52086kuqy052944174e
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

v2: resue some ip_defrag function in patch1

wenxu (3):
  net: ip_fragment: Add ip_defrag_ignore_cb support
  netfilter: nf_conntrack_reasm: make nf_ct_frag6_gather elide the CB
    clear
  net/sched: act_ct: fix clobber qdisc_skb_cb in defrag

 include/linux/netfilter_ipv6.h              |  9 ++---
 include/net/ip.h                            |  2 ++
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  3 +-
 net/bridge/netfilter/nf_conntrack_bridge.c  |  7 ++--
 net/ipv4/ip_fragment.c                      | 55 ++++++++++++++++++++++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c     | 19 ++++++----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  3 +-
 net/openvswitch/conntrack.c                 |  8 ++---
 net/sched/act_ct.c                          |  8 ++---
 9 files changed, 77 insertions(+), 37 deletions(-)

-- 
1.8.3.1

