Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08581A5403
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgDKXDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgDKXDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:03:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5062E215A4;
        Sat, 11 Apr 2020 23:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646232;
        bh=AteEPKEmTxb6IvEHpeF+RDvEo930PxsTukXeAY8tpqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8sqBX2PBOtlrEbDPkQHn4ko9WYNaxym7kDtgl1lC8Z+G+CsrmSksLWdu+tvs75rx
         GJr1q866ugQed3ylHK4Iict3C3a8x1tUFK6wY2MlH7BM9sIAhnsPuRn+02gMiwbhUP
         gBdlkqopJ/TUn5cxHBvyqud2ba0dkVZ6RNxaaGGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 003/149] netfilter: ctnetlink: be more strict when NF_CONNTRACK_MARK is not set
Date:   Sat, 11 Apr 2020 19:01:20 -0400
Message-Id: <20200411230347.22371-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Bellan <romain.bellan@wifirst.fr>

[ Upstream commit 7c6b4121627aeaa79536fbb900feafec740410d3 ]

When CONFIG_NF_CONNTRACK_MARK is not set, any CTA_MARK or CTA_MARK_MASK
in netlink message are not supported. We should return an error when one
of them is set, not both

Fixes: 9306425b70bf ("netfilter: ctnetlink: must check mark attributes vs NULL")
Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1c8f1f61718..7f5258ae1218a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -860,7 +860,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	struct ctnetlink_filter *filter;
 
 #ifndef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK])
+	if (cda[CTA_MARK] || cda[CTA_MARK_MASK])
 		return ERR_PTR(-EOPNOTSUPP);
 #endif
 
-- 
2.20.1

