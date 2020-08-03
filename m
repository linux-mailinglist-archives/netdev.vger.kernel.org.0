Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6346723A058
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgHCHdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:33:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43517 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725831AbgHCHdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:33:20 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 3 Aug 2020 10:33:13 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0737XCK0012882;
        Mon, 3 Aug 2020 10:33:12 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH net v2 0/2] netfilter: conntrack: Fix CT offload timeout on heavily loaded systems
Date:   Mon,  3 Aug 2020 10:33:03 +0300
Message-Id: <20200803073305.702079-1-roid@mellanox.com>
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
Second commit is to use it from flow_offload_add().

Roi Dayan (2):
  netfilter: conntrack: Move nf_ct_offload_timeout to header file
  netfilter: flowtable: Set offload timeout when adding flow

 include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
 net/netfilter/nf_conntrack_core.c    | 12 ------------
 net/netfilter/nf_flow_table_core.c   |  2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.8.4

