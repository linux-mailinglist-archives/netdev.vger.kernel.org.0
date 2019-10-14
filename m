Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE2D6B81
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbfJNWLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:11:01 -0400
Received: from correo.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730859AbfJNWLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:11:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B9FF1694A9
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A75FA7EE7
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:10:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0013FA7EC6; Tue, 15 Oct 2019 00:10:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90259B7FF2;
        Tue, 15 Oct 2019 00:10:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:10:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 366CD426CCBA;
        Tue, 15 Oct 2019 00:10:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [PATCH net-next,v5 0/4] flow_offload: update mangle action representation
Date:   Tue, 15 Oct 2019 00:10:47 +0200
Message-Id: <20191014221051.8084-1-pablo@netfilter.org>
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

Changes since v5:

* v4 patchset was missing the initial 1/4 patch to undo the bitwise NOT
  operation as the cover letter describes.

* Use header field definitions to calculate the header field from the
  u32 offset and the mask. This allows for mangling a few bytes of a
  multi-byte field, eg. offset=0 mask=0x00ff to mangle one single byte
  of a source port. --Edward Cree

Please, apply.

Pablo Neira Ayuso (4):
  net: flow_offload: flip mangle action mask
  net: flow_offload: bitwise AND on mangle action value field
  net: flow_offload: mangle action at byte level
  netfilter: nft_payload: packet mangling offload support

 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 163 ++++----------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  40 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  80 +++----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 212 +++++++-----------
 include/net/flow_offload.h                         |   7 +-
 net/netfilter/nft_payload.c                        |  73 +++++++
 net/sched/cls_api.c                                | 243 +++++++++++++++++++--
 7 files changed, 469 insertions(+), 349 deletions(-)

-- 
2.11.0

