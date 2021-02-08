Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414983140D9
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhBHUr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:47:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7066 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbhBHUog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a27a0000>; Mon, 08 Feb 2021 12:43:38 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:38 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:35 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 05/13] nexthop: Add data structures for resilient group notifications
Date:   Mon, 8 Feb 2021 21:42:48 +0100
Message-ID: <adb5a7fe9aa1f091baabe6c81f86abb443fa84f0.1612815058.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817018; bh=qtdT2nIMDDwxK5YrygxeAjyzGw0lh5TPQWUNialy2Ho=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=GeD/sjNqFFX7+6EpFoGKksJbbcnHg2TmKYRH7RsNg76TBb3TABQwzltoyze/+MKfJ
         onLr+fo9hWytKaMa8BqyarJk+eEOv1OWuIpIk5AffzN9YqpTTaRY+YdbEZ81dPTQ7p
         EExXTzRyhg9Casa6SCl3b6DZaJpISby7wbMEYs75CgWVUwQbwGtOiOoOGEWT7AucRW
         D8oz/4VGZ6g4zJaoU+wKExdj7CGqRGW5SRLMIqeK+HbBqAcHBJBXulH4E/D32YOkVe
         aYE9qCOwURJxZB+w1rGPw1AzxcB6X0MIQwOAii53aw3B2MeO4ItaQdmn209Edey34e
         nmbXhVyoCuqBQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add data structures that will be used for in-kernel notifications about
addition / deletion of a resilient nexthop group and about changes to a
hash bucket within a resilient group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/net/nexthop.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index f748431218d9..97138357755e 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -154,11 +154,15 @@ struct nexthop {
 enum nexthop_event_type {
 	NEXTHOP_EVENT_DEL,
 	NEXTHOP_EVENT_REPLACE,
+	NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE,
+	NEXTHOP_EVENT_BUCKET_REPLACE,
 };
=20
 enum nh_notifier_info_type {
 	NH_NOTIFIER_INFO_TYPE_SINGLE,
 	NH_NOTIFIER_INFO_TYPE_GRP,
+	NH_NOTIFIER_INFO_TYPE_RES_TABLE,
+	NH_NOTIFIER_INFO_TYPE_RES_BUCKET,
 };
=20
 struct nh_notifier_single_info {
@@ -185,6 +189,19 @@ struct nh_notifier_grp_info {
 	struct nh_notifier_grp_entry_info nh_entries[];
 };
=20
+struct nh_notifier_res_bucket_info {
+	u32 bucket_index;
+	unsigned int idle_timer_ms;
+	bool force;
+	struct nh_notifier_single_info old_nh;
+	struct nh_notifier_single_info new_nh;
+};
+
+struct nh_notifier_res_table_info {
+	u32 num_nh_buckets;
+	struct nh_notifier_single_info nhs[];
+};
+
 struct nh_notifier_info {
 	struct net *net;
 	struct netlink_ext_ack *extack;
@@ -193,6 +210,8 @@ struct nh_notifier_info {
 	union {
 		struct nh_notifier_single_info *nh;
 		struct nh_notifier_grp_info *nh_grp;
+		struct nh_notifier_res_table_info *nh_res_table;
+		struct nh_notifier_res_bucket_info *nh_res_bucket;
 	};
 };
=20
--=20
2.26.2

