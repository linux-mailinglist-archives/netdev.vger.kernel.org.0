Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA02AE8ED
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKKG2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:28:31 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:54113 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgKKG22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 01:28:28 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id D24B55C18BA;
        Wed, 11 Nov 2020 14:28:20 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v8 net-next 0/3] net/sched: fix over mtu packet of defrag in
Date:   Wed, 11 Nov 2020 14:28:17 +0800
Message-Id: <1605076100-21782-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQkhCTkgfQ0NMQh0eVkpNS05LTE1KS0tCT0tVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NU06Qgw*Iz03TThPTEI3Ki0Q
        TVYKCwhVSlVKTUtOS0xNSktKS0JNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDQ003Bg++
X-HM-Tid: 0a75b5fda7272087kuqyd24b55c18ba
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently kernel tc subsystem can do conntrack in act_ct. But when several
fragment packets go through the act_ct, function tcf_ct_handle_fragments
will defrag the packets to a big one. But the last action will redirect
mirred to a device which maybe lead the reassembly big packet over the mtu
of target device.

The first patch fix miss init the qdisc_skb_cb->mru
The send one refactor the hanle of xmit in act_mirred and prepare for the
third one
The last one add implict packet fragment support to fix the over mtu for
defrag in act_ct.

wenxu (3):
  net/sched: fix miss init the mru in qdisc_skb_cb
  net/sched: act_mirred: refactor the handle of xmit
  net/sched: act_frag: add implict packet fragment support.

 include/net/act_api.h     |  16 +++++
 include/net/sch_generic.h |   5 --
 net/core/dev.c            |   2 +
 net/sched/Kconfig         |  13 ++++
 net/sched/Makefile        |   1 +
 net/sched/act_api.c       |  47 +++++++++++++
 net/sched/act_ct.c        |   7 ++
 net/sched/act_frag.c      | 164 ++++++++++++++++++++++++++++++++++++++++++++++
 net/sched/act_mirred.c    |  21 ++++--
 9 files changed, 265 insertions(+), 11 deletions(-)
 create mode 100644 net/sched/act_frag.c

-- 
1.8.3.1

