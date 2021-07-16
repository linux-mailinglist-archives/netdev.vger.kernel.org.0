Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098173CB9FD
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhGPPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhGPPjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:39:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654CDC06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 08:36:49 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l17-20020a05600c1d11b029021f84fcaf75so8466198wms.1
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 08:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ephksBXSo5qzPSd+KRDEmChwHQ09muLiTFSo5rhHT2I=;
        b=a5RyLuYOXT2ipjhcM2qhd1YPIf512GsjhS3GQEuXxKCI3V8/wjEkaCos/YRMiNaEtO
         1d2+axjPX1Z1+UMWMBw9lwdfM23o2q/sWGhNKU4LJzlV2iTInyR7J2o1Ju4tx689cOHl
         pzKsEGNpvj7xfoFnBtqVcnSaa+9CjhK2b0mFKjSK+9JZv0bNd8d2KoM14qPclImLpyIW
         AnEi5Os50RSkot+JbvUGSH0xSZIiZy6pWedM634Aj/wA/h23Pc5fAbmT4qsh6dMPOLy/
         yhTVIH+EqmA65g8XwukTCNJH3THmNcB87thJQS2iFSZIQt5/9Ub96ZZWro6Nnq9pxgTl
         1Rug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ephksBXSo5qzPSd+KRDEmChwHQ09muLiTFSo5rhHT2I=;
        b=b8aIUFy7V90bOvQOlXcoDOYdPaQtGB3M7l9zAPstTK9YG0jA165mNRJzFagpoRRJYm
         2RQ6uAQn/V+4FHG3BZTd4+wuW5fdfn7BbcOhe4d1cE0KcDpMaTZInBbqs1Ia2JkbVwmz
         9sQccLBGS5cB1k7PXghca90Yy683rbmcHED2iVZ7WNLScKVMIB6spMWvOdFjuYkuThXp
         G/wsI0Lyl5hty7rrqTUFQJjftagPXE7eHmJvMCemvX14QN4X2wK+39UEU/OH+vsaTiPU
         ZBDL0YG0LijrZ2L8uQaMZIR8xYrvhbmN+MInnwf+3SaiWFsmo9kCACw7hWYmTbaY4bMi
         X6sw==
X-Gm-Message-State: AOAM5305EcF5tEBDtLuN8LZtZS8dY2/NFcofFkXTtsnPf947/CGFpBdj
        2eM30T/yQ/Oq6zgAKl4DGQILOHra3vY6jg==
X-Google-Smtp-Source: ABdhPJycJDkct1fxcXdUK8Cd2tcBoMbQvJCOlf51PcnqlXCuZ2iAvhfvLlCiDfxcGQhbxNJ44bPe7A==
X-Received: by 2002:a1c:f717:: with SMTP id v23mr17272012wmh.32.1626449807710;
        Fri, 16 Jul 2021 08:36:47 -0700 (PDT)
Received: from localhost.localdomain ([51.52.208.25])
        by smtp.gmail.com with ESMTPSA id m32sm11099513wms.23.2021.07.16.08.36.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jul 2021 08:36:47 -0700 (PDT)
From:   Ilya Dmitrichenko <errordeveloper@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Dmitrichenko <errordeveloper@gmail.com>
Subject: [PATCH iproute2] ip/tunnel: always print all known attributes
Date:   Fri, 16 Jul 2021 16:35:57 +0100
Message-Id: <20210716153557.10192-1-errordeveloper@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Presently, if a Geneve or VXLAN interface was created with 'external',
it's not possible for a user to determine e.g. the value of 'dstport'
after creation. This change fixes that by avoiding early returns.

This change partly reverts 00ff4b8e31af ("ip/tunnel: Be consistent when
printing tunnel collect metadata").

Signed-off-by: Ilya Dmitrichenko <errordeveloper@gmail.com>
---
 ip/iplink_geneve.c | 12 ++++--------
 ip/iplink_vxlan.c  | 12 ++++--------
 ip/link_gre.c      |  1 -
 ip/link_gre6.c     |  1 -
 ip/link_ip6tnl.c   |  1 -
 ip/link_iptnl.c    |  1 -
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index 9299236c..eb296367 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -243,7 +243,6 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
-	__u32 vni;
 	__u8 ttl = 0;
 	__u8 tos = 0;
 
@@ -252,15 +251,12 @@ static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GENEVE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
-	if (!tb[IFLA_GENEVE_ID] ||
-	    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) < sizeof(__u32))
-		return;
-
-	vni = rta_getattr_u32(tb[IFLA_GENEVE_ID]);
-	print_uint(PRINT_ANY, "id", "id %u ", vni);
+	if (tb[IFLA_GENEVE_ID] &&
+	    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) >= sizeof(__u32)) {
+		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_GENEVE_ID]));
+        }
 
 	if (tb[IFLA_GENEVE_REMOTE]) {
 		__be32 addr = rta_getattr_u32(tb[IFLA_GENEVE_REMOTE]);
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index bae9d994..8578fc9d 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -408,7 +408,6 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
-	__u32 vni;
 	__u8 ttl = 0;
 	__u8 tos = 0;
 	__u32 maxaddr;
@@ -419,15 +418,12 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
 	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
-	if (!tb[IFLA_VXLAN_ID] ||
-	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) < sizeof(__u32))
-		return;
-
-	vni = rta_getattr_u32(tb[IFLA_VXLAN_ID]);
-	print_uint(PRINT_ANY, "id", "id %u ", vni);
+	if (tb[IFLA_VXLAN_ID] &&
+	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
+		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_VXLAN_ID]));
+        }
 
 	if (tb[IFLA_VXLAN_GROUP]) {
 		__be32 addr = rta_getattr_u32(tb[IFLA_VXLAN_GROUP]);
diff --git a/ip/link_gre.c b/ip/link_gre.c
index 6d4a8be8..f462a227 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -442,7 +442,6 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GRE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	tnl_print_endpoint("remote", tb[IFLA_GRE_REMOTE], AF_INET);
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index f33598af..232d9bde 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -461,7 +461,6 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GRE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_GRE_FLAGS])
diff --git a/ip/link_ip6tnl.c b/ip/link_ip6tnl.c
index c7b49b02..2fcc13ef 100644
--- a/ip/link_ip6tnl.c
+++ b/ip/link_ip6tnl.c
@@ -344,7 +344,6 @@ static void ip6tunnel_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb
 
 	if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_IPTUN_FLAGS])
diff --git a/ip/link_iptnl.c b/ip/link_iptnl.c
index 636cdb2c..b25855ba 100644
--- a/ip/link_iptnl.c
+++ b/ip/link_iptnl.c
@@ -368,7 +368,6 @@ static void iptunnel_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[
 
 	if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_IPTUN_PROTO]) {
-- 
2.29.2

