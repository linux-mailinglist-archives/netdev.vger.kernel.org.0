Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95590306FE3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 08:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhA1HmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 02:42:14 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49486 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231802AbhA1Hl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 02:41:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@nvidia.com)
        with SMTP; 28 Jan 2021 09:41:04 +0200
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10S7f4ED031551;
        Thu, 28 Jan 2021 09:41:04 +0200
From:   Roi Dayan <roid@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table dump
Date:   Thu, 28 Jan 2021 09:40:52 +0200
Message-Id: <20210128074052.777999-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, offloaded flows might be deleted when executing conntrack -L
or cat /proc/net/nf_conntrack while rules being offloaded.
Ct timeout is not maintained for offloaded flows as aging
of offloaded flows are managed by the flow table offload infrastructure.

Don't do garbage collection for offloaded flows when dumping the
entries.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 439379ca9ffa..87c85109946a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -276,7 +276,7 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 {
 	return nf_ct_is_expired(ct) && nf_ct_is_confirmed(ct) &&
-	       !nf_ct_is_dying(ct);
+	       !nf_ct_is_dying(ct) && !test_bit(IPS_OFFLOAD_BIT, &ct->status);
 }
 
 #define	NF_CT_DAY	(86400 * HZ)
-- 
2.26.2

