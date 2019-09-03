Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B669A70DF
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfICQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:45:27 -0400
Received: from correo.us.es ([193.147.175.20]:35554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbfICQp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 12:45:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E445DDA85C
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 18:45:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3883B8001
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 18:45:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BAACCB7FF6; Tue,  3 Sep 2019 18:45:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D87ED2B1E;
        Tue,  3 Sep 2019 18:45:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Sep 2019 18:45:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 455874265A5A;
        Tue,  3 Sep 2019 18:45:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com
Subject: [PATCH net-next,v2 0/4] flow_offload: update mangle action representation
Date:   Tue,  3 Sep 2019 18:45:09 +0200
Message-Id: <20190903164513.15462-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the mangle action representation:

Patch 1) Undo bitwise NOT operation on the mangle mask (coming from tc
         pedit userspace).

Patch 2) mangle value &= mask from the front-end side.

Patch 3) adjust offset, length and coalesce consecutive pedit keys into
         one single action.

Patch 4) add support for payload mangling for netfilter.

After this patchset:

* Offset to payload does not need to be on the 32-bits boundaries anymore.
  This patchset adds front-end code to adjust the offset and length coming
  from the tc pedit representation, so drivers get an exact header field
  offset and length.

* This new front-end code coalesces consecutive pedit actions into one
  single action, so drivers can mangle IPv6 and ethernet address fields
  in one go, instead once for each 32-bit word.

On the driver side, diffstat -t shows that drivers code to deal with
payload mangling gets simplified:

        INSERTED,DELETED,MODIFIED,FILENAME
        46,116,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c (-70 LOC)
        12,28,0,drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h (-16 LOC)
        30,60,0,drivers/net/ethernet/mellanox/mlx5/core/en_tc.c (-30 LOC)
        89,111,0,drivers/net/ethernet/netronome/nfp/flower/action.c (-17 LOC)

While, on the front-end side the balance is the following:

	123,22,0,net/sched/cls_api.c (+101 LOC)

Changes since v1:

* Fix missing flow_action->num_entries adjustment from tc_setup_flow_action()
  reported by Vlad Buslov.
* Action entry ID in netfilter payload mangling action was not properly set.
* Fix incorrect p_exact[] assignment logic in nfp_fl_set_helper().

Please, apply.

Pablo Neira Ayuso (4):
  net: flow_offload: flip mangle action mask
  net: flow_offload: bitwise AND on mangle action value field
  net: flow_offload: mangle action at byte level
  netfilter: nft_payload: packet mangling offload support

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 163 +++++-----------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  40 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  90 +++------
 drivers/net/ethernet/netronome/nfp/flower/action.c | 204 ++++++++++-----------
 include/net/flow_offload.h                         |   7 +-
 net/netfilter/nft_payload.c                        |  73 ++++++++
 net/sched/cls_api.c                                | 144 ++++++++++++---
 7 files changed, 382 insertions(+), 339 deletions(-)

-- 
2.11.0

