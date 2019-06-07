Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06E0398F7
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfFGWiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731749AbfFGWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:19 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB952146F;
        Fri,  7 Jun 2019 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947099;
        bh=n8IBK3dCAN27MQYAkoLRDxbNXvETLAbr5HekssFqeRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHszTUxI4KZYnWs7soAfXacPosn+IvU07F3g3oNOMgiSrWaN7DUfQ4W6bh6eibw4y
         emheRzsPMJfbMFAM9uYUsPsVncpircp1wQhzPVY6g1LF08pp/TX5qB5SWcZRWH1uoO
         VqlaetRq18AM2mTyVhph5gnt9sVc7X3HPKIth/50=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 03/10] libnetlink: Add helper to add a group via setsockopt
Date:   Fri,  7 Jun 2019 15:38:09 -0700
Message-Id: <20190607223816.27512-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

groups > 31 have to be joined using the setsockopt. Since the nexthop
group is 32, add a helper to allow 'ip monitor' to listen for nexthop
messages.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/libnetlink.h | 3 ++-
 lib/libnetlink.c     | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 503b3ec11bb6..599b2c592f68 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -45,7 +45,8 @@ int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
 int rtnl_open_byproto(struct rtnl_handle *rth, unsigned int subscriptions,
 			     int protocol)
 	__attribute__((warn_unused_result));
-
+int rtnl_add_nl_group(struct rtnl_handle *rth, unsigned int group)
+	__attribute__((warn_unused_result));
 void rtnl_close(struct rtnl_handle *rth);
 void rtnl_set_strict_dump(struct rtnl_handle *rth);
 
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 6ae51a9dba14..eb85bbdf01ee 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -173,6 +173,12 @@ void rtnl_set_strict_dump(struct rtnl_handle *rth)
 	rth->flags |= RTNL_HANDLE_F_STRICT_CHK;
 }
 
+int rtnl_add_nl_group(struct rtnl_handle *rth, unsigned int group)
+{
+	return setsockopt(rth->fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
+			  &group, sizeof(group));
+}
+
 void rtnl_close(struct rtnl_handle *rth)
 {
 	if (rth->fd >= 0) {
-- 
2.11.0

