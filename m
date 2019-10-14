Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14B2D6B64
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfJNWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:00:48 -0400
Received: from correo.us.es ([193.147.175.20]:33250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730612AbfJNWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:00:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB5C51694AD
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:00:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADFCDB7FF2
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:00:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91306CA0F2; Tue, 15 Oct 2019 00:00:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 688D1DA72F;
        Tue, 15 Oct 2019 00:00:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:00:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0363C426CCBA;
        Tue, 15 Oct 2019 00:00:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v4 0/4] flow_offload: update mangle action representation
Date:   Tue, 15 Oct 2019 00:00:23 +0200
Message-Id: <20191014220027.7500-1-pablo@netfilter.org>
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
         one single action. Calculate header field based on the offset
	 and mask.

Patch 4) add support for payload mangling for netfilter.

After this patchset:

* Offset to payload does not need to be on the 32-bits boundaries anymore.
  This patchset adds front-end code to adjust the offset and length coming
  from the tc pedit representation, so drivers get an exact header field
  offset and length.

* This new front-end code coalesces consecutive pedit action composed of
  several keys into one single action, so drivers can mangle IPv6 and
  ethernet address fields in one go, instead of updating 32-bit word at
  a time.

As a result, driver codebase to deal with payload mangling gets simplified.

Changes since v4:

* Use header field definitions to calculate the header field from the
  u32 offset and the mask. This allows for mangling a few bytes of a
  multi-byte field, eg. offset=0 mask=0x00ff to mangle one single byte
  of a source port. --Edward Cree

Please, apply.

Pablo Neira Ayuso (4):
  net: flow_offload: bitwise AND on mangle action value field
  net: flow_offload: mangle action at byte level
  netfilter: nft_payload: packet mangling offload support
  net: flow_offload: add flow_rule_print()

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 163 ++++----------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  40 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  80 +++----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 212 +++++++-----------
 include/net/flow_offload.h                         |  10 +-
 net/core/flow_offload.c                            |  85 +++++++
 net/netfilter/nf_tables_offload.c                  |   6 +-
 net/netfilter/nft_payload.c                        |  73 +++++++
 net/sched/cls_api.c                                | 243 +++++++++++++++++++--
 net/sched/cls_flower.c                             |   4 +
 10 files changed, 566 insertions(+), 350 deletions(-)

-- 
2.11.0

