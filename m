Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7AA652ED
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfGKIOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:14:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37061 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728090AbfGKIOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:14:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Jul 2019 11:14:31 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6B8EVkU026708;
        Thu, 11 Jul 2019 11:14:31 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc connection tracking
Date:   Thu, 11 Jul 2019 11:14:24 +0300
Message-Id: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series add connection tracking capabilities in tc.
It does so via a new tc action, called act_ct, and new tc flower classifier matching.
Act ct and relevant flower matches, are still under review in net-next mailing list.

Usage is as follows:
$ tc qdisc add dev ens1f0_0 ingress
$ tc qdisc add dev ens1f0_1 ingress

$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 0 proto ip \
  flower ip_proto tcp ct_state -trk \
  action ct zone 2 pipe \
  action goto chain 2
$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 2 proto ip \
  flower ct_state +trk+new \
  action ct zone 2 commit mark 0xbb nat src addr 5.5.5.7 pipe \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 2 proto ip \
  flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \
  action ct nat pipe \
  action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_1 ingress \
  prio 1 chain 0 proto ip \
  flower ip_proto tcp ct_state -trk \
  action ct zone 2 pipe \
  action goto chain 1
$ tc filter add dev ens1f0_1 ingress \
  prio 1 chain 1 proto ip \
  flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \
  action ct nat pipe \
  action mirred egress redirect dev ens1f0_0

Changelog:
V1->V2:
	Removed pkt_cls changes (as it was merged already)

Paul Blakey (3):
  tc: add NLA_F_NESTED flag to all actions options nested block
  tc: Introduce tc ct action
  tc: flower: Add matching on conntrack info

 include/uapi/linux/tc_act/tc_ct.h |  41 ++++
 man/man8/tc-flower.8              |  35 +++
 tc/Makefile                       |   1 +
 tc/f_flower.c                     | 276 ++++++++++++++++++++-
 tc/m_action.c                     |   3 +-
 tc/m_ct.c                         | 497 ++++++++++++++++++++++++++++++++++++++
 tc/tc_util.c                      |  44 ++++
 tc/tc_util.h                      |   4 +
 8 files changed, 899 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/tc_act/tc_ct.h
 create mode 100644 tc/m_ct.c

-- 
1.8.3.1

