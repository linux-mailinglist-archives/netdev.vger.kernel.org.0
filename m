Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE76FF261
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfKPPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbfKPPqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABA620857;
        Sat, 16 Nov 2019 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919177;
        bh=KG7jFFleSrAXnKXJdxb/7eBupZkKjYHi6r78Y7FcSD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bbv51ljuPkk7PaiSEd1cr5M2cr8B4iDUFBpvaBP38ZEV/ncpFc1VryZDvh2eU9unT
         6eC+8tSeEpSqarDWHMP183dR41/SC249ZuuhCPDPs6/HIFKBD9YuXo8ym/lcwU6fvZ
         YN2sK0y0QeQ3Hk1r1ViP0L3t9RDIQ/CPU+33s1HI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH AUTOSEL 4.19 186/237] openvswitch: fix linking without CONFIG_NF_CONNTRACK_LABELS
Date:   Sat, 16 Nov 2019 10:40:21 -0500
Message-Id: <20191116154113.7417-186-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a277d516de5f498c91d91189717ef7e01102ad27 ]

When CONFIG_CC_OPTIMIZE_FOR_DEBUGGING is enabled, the compiler
fails to optimize out a dead code path, which leads to a link failure:

net/openvswitch/conntrack.o: In function `ovs_ct_set_labels':
conntrack.c:(.text+0x2e60): undefined reference to `nf_connlabels_replace'

In this configuration, we can take a shortcut, and completely
remove the contrack label code. This may also help the regular
optimization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 35ae64cbef33f..46aa1aa51db41 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1199,7 +1199,8 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 					 &info->labels.mask);
 		if (err)
 			return err;
-	} else if (labels_nonzero(&info->labels.mask)) {
+	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
+		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
 					&info->labels.mask);
 		if (err)
-- 
2.20.1

