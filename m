Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA69F2B73C8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgKRBd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:33:27 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:43560 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRBd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:33:26 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 511545C1B49;
        Wed, 18 Nov 2020 09:33:24 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/3] net/sched: fix over mtu packet of defrag in
Date:   Wed, 18 Nov 2020 09:33:19 +0800
Message-Id: <1605663203-14180-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGEgdSx5JSB8aHk4eVkpNS05NTUhJS09PTk5VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBg6MAw6NT06UT09DyooTQ4d
        ORwaCQtVSlVKTUtOTU1ISUtPTU5OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCSU43Bg++
X-HM-Tid: 0a75d8fc24202087kuqy511545c1b49
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

There are too much versions, this series repost restart with version v2.

wenxu (3):
  net/sched: fix miss init the mru in qdisc_skb_cb
  net/sched: act_mirred: refactor the handle of xmit
  net/sched: sch_frag: add generic packet fragment support.

 include/net/act_api.h     |   8 +++
 include/net/sch_generic.h |   5 +-
 net/core/dev.c            |   2 +
 net/sched/Makefile        |   2 +-
 net/sched/act_api.c       |  44 ++++++++++++++
 net/sched/act_ct.c        |   7 +++
 net/sched/act_mirred.c    |  21 +++++--
 net/sched/sch_frag.c      | 150 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 228 insertions(+), 11 deletions(-)
 create mode 100644 net/sched/sch_frag.c

-- 
1.8.3.1

