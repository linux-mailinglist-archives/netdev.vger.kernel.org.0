Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2683CB977
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbhGPPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhGPPNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:13:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99B1C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 08:10:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v1so13377891edt.6
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 08:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=j+t8yjXII30Lt5iuh2lD0XOM6VDJ4rSKKotoaLtBVTE=;
        b=NmDmnwcigBAfFv56us2Q+6YtSLjpj6UYibPqgeIuYjH5YsAKTzcVzxvxie//jW2fkB
         ryMbNSUCQwRHd/ksYIiJz94shvaH1FeuSUa0FLIIGkzBUIfPhYgZqr1re2atI6fBBzBC
         V89ZKqHWdAymaZN2LKw0/r7sjKEP/TytMbEOAgCO1yfglr+Nfr07+cqiwzoIgJnu72BS
         vECDmf09mCDZJBKPynjI4WgQSVKPMDrlEaHafCXbyGD0w93D0A2Z5cLlXIT3IMHnmddn
         KSNe18ShxszJF8jWNqDO8KgPPK5weeZqQOfSmzaxj+BOU0o6qhHaL/Vod6RgafzjUtfa
         2soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=j+t8yjXII30Lt5iuh2lD0XOM6VDJ4rSKKotoaLtBVTE=;
        b=BCYVeybhR2nc37uBTZKLAOzfWuttm8fe2dniVshy3IMuDrVtrkomcvTTXDzetjRPYB
         N09j2aqoL5tAKqhDvudArbzWWzJuCFnovawK94IdacvkXGpXsV1Sfe6ronK8YQcFhDB1
         oGdGXwrTtbeyxU3iqGyhrpImpfSSGe1q+TZBRSSsyT3RhGgUCJkuucz2hmBxY3uWwhIc
         SnE182de78p9ugQxo/82ETchAEdruB/nUwidh980DaRWZcV8Vop55BdHW2O5mhcOxJAt
         ZL3waNrm5XYP1auvOJqjrbzDb6ByAo0d8wV2UYRRrCMeyXbSj4h3BQc++ufHvJWZIrr0
         hMnw==
X-Gm-Message-State: AOAM5301lD/L99XQxwcuCiYaoG1csnf/Q+BRg3MneXw8ofp7bHzXVN5F
        RDUo7VfIfIugUl1cuuGCOlk03q2Xij/70Kz9W0e8VJkZ3cpQhQ==
X-Google-Smtp-Source: ABdhPJzwEFlQSCfOnqZQjgnHRsC9jJMnrVMgMSWUk+GirmJVIRTIcdU3SZO7RuF8fdeH5O24DPKTPJwe5Da6qXPI1dE=
X-Received: by 2002:aa7:d809:: with SMTP id v9mr15538411edq.146.1626448214193;
 Fri, 16 Jul 2021 08:10:14 -0700 (PDT)
MIME-Version: 1.0
From:   Ilya Dmitrichenko <errordeveloper@gmail.com>
Date:   Fri, 16 Jul 2021 16:10:03 +0100
Message-ID: <CAPhDKbFwGzpjR_f=jz4JAq6GUDMd+2oZPwGVy7ru1XrUJVtXQA@mail.gmail.com>
Subject: [PATCH] ip/tunnel: always print all known attributes
To:     netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
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
index 9299236c..7db7e62f 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -243,7 +243,6 @@ static int geneve_parse_opt(struct link_util *lu,
int argc, char **argv,

 static void geneve_print_opt(struct link_util *lu, FILE *f, struct
rtattr *tb[])
 {
- __u32 vni;
  __u8 ttl = 0;
  __u8 tos = 0;

@@ -252,15 +251,12 @@ static void geneve_print_opt(struct link_util
*lu, FILE *f, struct rtattr *tb[])

  if (tb[IFLA_GENEVE_COLLECT_METADATA]) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

- if (!tb[IFLA_GENEVE_ID] ||
-    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) < sizeof(__u32))
- return;
-
- vni = rta_getattr_u32(tb[IFLA_GENEVE_ID]);
- print_uint(PRINT_ANY, "id", "id %u ", vni);
+ if (tb[IFLA_GENEVE_ID] &&
+    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) >= sizeof(__u32)) {
+        print_uint(PRINT_ANY, "id", "id %u ",
rta_getattr_u32(tb[IFLA_GENEVE_ID]));
+        }

  if (tb[IFLA_GENEVE_REMOTE]) {
  __be32 addr = rta_getattr_u32(tb[IFLA_GENEVE_REMOTE]);
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index bae9d994..8578fc9d 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -408,7 +408,6 @@ static int vxlan_parse_opt(struct link_util *lu,
int argc, char **argv,

 static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
- __u32 vni;
  __u8 ttl = 0;
  __u8 tos = 0;
  __u32 maxaddr;
@@ -419,15 +418,12 @@ static void vxlan_print_opt(struct link_util
*lu, FILE *f, struct rtattr *tb[])
  if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
     rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

- if (!tb[IFLA_VXLAN_ID] ||
-    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) < sizeof(__u32))
- return;
-
- vni = rta_getattr_u32(tb[IFLA_VXLAN_ID]);
- print_uint(PRINT_ANY, "id", "id %u ", vni);
+ if (tb[IFLA_VXLAN_ID] &&
+    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
+ print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_VXLAN_ID]));
+        }

  if (tb[IFLA_VXLAN_GROUP]) {
  __be32 addr = rta_getattr_u32(tb[IFLA_VXLAN_GROUP]);
diff --git a/ip/link_gre.c b/ip/link_gre.c
index 6d4a8be8..f462a227 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -442,7 +442,6 @@ static void gre_print_opt(struct link_util *lu,
FILE *f, struct rtattr *tb[])

  if (tb[IFLA_GRE_COLLECT_METADATA]) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

  tnl_print_endpoint("remote", tb[IFLA_GRE_REMOTE], AF_INET);
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index f33598af..232d9bde 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -461,7 +461,6 @@ static void gre_print_opt(struct link_util *lu,
FILE *f, struct rtattr *tb[])

  if (tb[IFLA_GRE_COLLECT_METADATA]) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

  if (tb[IFLA_GRE_FLAGS])
diff --git a/ip/link_ip6tnl.c b/ip/link_ip6tnl.c
index c7b49b02..2fcc13ef 100644
--- a/ip/link_ip6tnl.c
+++ b/ip/link_ip6tnl.c
@@ -344,7 +344,6 @@ static void ip6tunnel_print_opt(struct link_util
*lu, FILE *f, struct rtattr *tb

  if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

  if (tb[IFLA_IPTUN_FLAGS])
diff --git a/ip/link_iptnl.c b/ip/link_iptnl.c
index 636cdb2c..b25855ba 100644
--- a/ip/link_iptnl.c
+++ b/ip/link_iptnl.c
@@ -368,7 +368,6 @@ static void iptunnel_print_opt(struct link_util
*lu, FILE *f, struct rtattr *tb[

  if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
  print_bool(PRINT_ANY, "external", "external ", true);
- return;
  }

  if (tb[IFLA_IPTUN_PROTO]) {
