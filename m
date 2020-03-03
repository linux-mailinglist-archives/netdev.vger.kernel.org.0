Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9709176E52
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgCCFFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgCCFFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:41 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79FC24671;
        Tue,  3 Mar 2020 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211941;
        bh=R1hgmaYxd6ATLBxvHWR5VPf0UtZ3CwshoA+vgr0suD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIEV3ZxkNgTNU2UlwVYrkZ9xRS5SlU21JshG9qbUZVd6EpjFq/0hcbH0N9GRurUzz
         gDp37ec1NXfox01jSZSZWsqbgp4VeJqjVM7//SIxTcyfzQWc0nFGtKH+yEZOBV313V
         l3sMlwh5r8rSEwn81Pz5faGce+TvrpdyPpzkibcA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Vesker <valex@mellanox.com>
Subject: [PATCH net 02/16] devlink: validate length of region addr/len
Date:   Mon,  2 Mar 2020 21:05:12 -0800
Message-Id: <20200303050526.4088735-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEVLINK_ATTR_REGION_CHUNK_ADDR and DEVLINK_ATTR_REGION_CHUNK_LEN
lack entries in the netlink policy. Corresponding nla_get_u64()s
may read beyond the end of the message.

Fixes: 4e54795a27f5 ("devlink: Add support for region snapshot read command")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jiri Pirko <jiri@mellanox.com>
CC: Alex Vesker <valex@mellanox.com>
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8e44dc5cde73..b831c5545d6a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5958,6 +5958,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_PARAM_VALUE_CMODE] = { .type = NLA_U8 },
 	[DEVLINK_ATTR_REGION_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_REGION_SNAPSHOT_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_CHUNK_ADDR] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_REGION_CHUNK_LEN] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
-- 
2.24.1

