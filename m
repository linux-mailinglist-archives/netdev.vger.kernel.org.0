Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03F68C5F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbfGONvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730952AbfGONvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:51:15 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDD52086C;
        Mon, 15 Jul 2019 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198674;
        bh=ilvjH9Ml4srFA9CkBFZD0/rLV1KQFMEQowPN1l6GCaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hbvow764W+LP0FqsCYes0yMiFQVylspND4zHtunIwv5nQEMHWrA5+s5zvXRUZmvUM
         fIp7tVkCWhPQ6swOpE43VmelZru+Bgk91tfyE8gxyz0/irFHdwGStyxK+juJh82Jqb
         9gpBEV+vFf0MupvkHXKBesGpeF8+4t9R3Pxx3pYQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 080/249] netfilter: ipset: fix a missing check of nla_parse
Date:   Mon, 15 Jul 2019 09:44:05 -0400
Message-Id: <20190715134655.4076-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit f4f5748bfec94cf418e49bf05f0c81a1b9ebc950 ]

When nla_parse fails, we should not use the results (the first
argument). The fix checks if it fails, and if so, returns its error code
upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3cdf171cd468..16afa0df4004 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1541,10 +1541,14 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-				     nlh->nlmsg_len - min_len,
-				     ip_set_adt_policy, NULL);
+		ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+					   nlh->nlmsg_len - min_len,
+					   ip_set_adt_policy, NULL);
 
+		if (ret) {
+			nlmsg_free(skb2);
+			return ret;
+		}
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
 		*errline = lineno;
-- 
2.20.1

