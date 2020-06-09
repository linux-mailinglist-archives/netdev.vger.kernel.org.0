Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF91F4A15
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 01:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgFIX1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 19:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgFIX1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 19:27:30 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE74206A4;
        Tue,  9 Jun 2020 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591745249;
        bh=W5b9xaweRRU8wG7moJ1hgDrhv8aPDYSP/hKyzuDXx6k=;
        h=From:To:Cc:Subject:Date:From;
        b=YjBjrGeHLL2w6z3Lr3fsim9c07YGqzhLAlz6bVQCrI677bEJ9rdkRFZHNxcvpcZca
         gAuxuMLW7TKFx18m2S+5J6MCiU+wR3344vBhvJ2bUSvg67+J+Khhe+cX6T2tPZbJfK
         /nDUkgxNcQG3WQEsMqt5dOPogITHTdaWFeFlepXs=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net] vxlan: Remove access to nexthop group struct
Date:   Tue,  9 Jun 2020 17:27:28 -0600
Message-Id: <20200609232728.26621-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan driver should be using helpers to access nexthop struct
internals. Remove open check if whether nexthop is multipath in
favor of the existing nexthop_is_multipath helper. Add a new
helper, nexthop_has_v4, to cover the need to check has_v4 in
a group.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 drivers/net/vxlan.c   |  8 +++-----
 include/net/nexthop.h | 11 +++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5bb448ae6c9c..0c6086879ab7 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -857,7 +857,6 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 			       u32 nhid, struct netlink_ext_ack *extack)
 {
 	struct nexthop *old_nh = rtnl_dereference(fdb->nh);
-	struct nh_group *nhg;
 	struct nexthop *nh;
 	int err = -EINVAL;
 
@@ -881,8 +880,7 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 			goto err_inval;
 		}
 
-		nhg = rtnl_dereference(nh->nh_grp);
-		if (!nh->is_group || !nhg->mpath) {
+		if (!nexthop_is_multipath(nh)) {
 			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
 			goto err_inval;
 		}
@@ -890,14 +888,14 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 		/* check nexthop group family */
 		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
 		case AF_INET:
-			if (!nhg->has_v4) {
+			if (!nexthop_has_v4(nh)) {
 				err = -EAFNOSUPPORT;
 				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
 				goto err_inval;
 			}
 			break;
 		case AF_INET6:
-			if (nhg->has_v4) {
+			if (nexthop_has_v4(nh)) {
 				err = -EAFNOSUPPORT;
 				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
 				goto err_inval;
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index c28bed98d211..f452fc6ad742 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -137,6 +137,17 @@ static inline bool nexthop_cmp(const struct nexthop *nh1,
 	return nh1 == nh2;
 }
 
+static inline bool nexthop_has_v4(const struct nexthop *nh)
+{
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		return nh_grp->has_v4;
+	}
+	return false;
+}
+
 static inline bool nexthop_is_multipath(const struct nexthop *nh)
 {
 	if (nh->is_group) {
-- 
2.17.1

