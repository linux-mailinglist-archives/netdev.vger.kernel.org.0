Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DD5158FE
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfEGFcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfEGFcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:32:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092DB206A3;
        Tue,  7 May 2019 05:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207170;
        bh=u2VF2JXohGzCVS0YQxbe4icbtKNKWHD2I4phXbF95dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMgGs+98nOX168na4RT7587e3c4UYXjKtOi+5REn6PeLlz2AeiKiDE4V+bBmDwu3l
         tHxkG82/sHgGvkVINotwQvetmzBRy2mAPVm4dWOonLj/d8zoULq7RieVakLMvju5me
         GbKJzeDeAW2tQD4yKEP26Q4Q0qfcneeEC/s5xpLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 11/99] mac80211: fix unaligned access in mesh table hash function
Date:   Tue,  7 May 2019 01:31:05 -0400
Message-Id: <20190507053235.29900-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 40586e3fc400c00c11151804dcdc93f8c831c808 ]

The pointer to the last four bytes of the address is not guaranteed to be
aligned, so we need to use __get_unaligned_cpu32 here

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 88a6d5e18ccc..ac1f5db52994 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -23,7 +23,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl, struct mesh_path *mpath);
 static u32 mesh_table_hash(const void *addr, u32 len, u32 seed)
 {
 	/* Use last four bytes of hw addr as hash index */
-	return jhash_1word(*(u32 *)(addr+2), seed);
+	return jhash_1word(__get_unaligned_cpu32((u8 *)addr + 2), seed);
 }
 
 static const struct rhashtable_params mesh_rht_params = {
-- 
2.20.1

