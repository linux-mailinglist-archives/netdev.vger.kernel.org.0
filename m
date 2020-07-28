Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC17F230942
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgG1L6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:58:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36500 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728129AbgG1L6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 07:58:14 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 28 Jul 2020 14:58:09 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06SBw9Qr028102;
        Tue, 28 Jul 2020 14:58:09 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net 0/2] netfilter: conntrack: Fix CT offload timeout on heavily loaded systems
Date:   Tue, 28 Jul 2020 14:57:57 +0300
Message-Id: <20200728115759.426667-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On heavily loaded systems the GC can take time to go over all existing
conns and reset their timeout. At that time other calls like from
nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
expired. To fix this when we set the offload bit we should also reset
the timeout instead of counting on GC to finish first iteration over
all conns before the initial timeout.

First commit is to expose the function that updates the timeout.
Second commit is to use it from act_ct.

Roi Dayan (2):
  netfilter: conntrack: Move nf_ct_offload_timeout to header file
  net/sched: act_ct: Set offload timeout when setting the offload bit

 include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
 net/netfilter/nf_conntrack_core.c    | 12 ------------
 net/sched/act_ct.c                   |  2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.8.4

