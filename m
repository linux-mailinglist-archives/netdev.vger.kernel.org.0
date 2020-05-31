Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF561E95B2
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgEaEsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbgEaEsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:48:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20680C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so2905404plv.9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xRuCKtmAU98/1FoM979BFTI0yYozTBzpHXxwBey2HNA=;
        b=KyCfLMCEctjuPZxTcAZubFGrdfCRDtqs1NlFaKp2q/O82BOw1v5G3SryqWvsJ73m7B
         hJA6Yk7IDkbC+PzhsOlEU6ZWyNE6f4evx+JcpxCQcV5AjAhjkLApw/3qSIuIPGocEOuu
         zgSnNHJx2oUHWsb9dRDupL0fj6/27HcQHWSmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xRuCKtmAU98/1FoM979BFTI0yYozTBzpHXxwBey2HNA=;
        b=UjYb0Qx+zvQ74y7zXBcDIgeF7Ru03wk/qmnF27DsjAvU8aoCf8SxBVmR83R5EMdGmT
         8alvTT74WImTnscH5v6kDAWqqdrkWrK8oiFoAPNkCsYcVGDtLRktwmkb7+f6lpOl7Ddb
         mmcKZ3UKPXH6kVeHLEnOYW7OcKeauWqsfk8561mb0E/uFwK7TFLCI4in1cK7a/6XuBEa
         aqKkuKIoE0XAB4+M2dMgiUwxi0u2dVRbI56TS1tR9PZoRVyyTKO5bvZeo+B+RXm8mjOn
         uy9SGhNec+Z82EopK1qRzO0Z9gcHA4GAk825ms3xzm78SzJHA//qKUnKFnZFG+Eo1TtK
         5VhQ==
X-Gm-Message-State: AOAM5314A6I4Ey/hJBDJ0rvRBg5nm5Ka5ITeJrnsgENqIAHXDVo8yFt7
        I+Hrx/gg5IcCFdqjM6N74yJfhA==
X-Google-Smtp-Source: ABdhPJwtvjMYtdawKe44vWu0BsFreRF/FCJJst8PPETK+5vWa1J9AWV2O/xRAxh23wbbEghq3rSF2w==
X-Received: by 2002:a17:90a:ca94:: with SMTP id y20mr16207843pjt.97.1590900529654;
        Sat, 30 May 2020 21:48:49 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id m2sm3584312pjk.52.2020.05.30.21.48.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 May 2020 21:48:49 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 3/3] vxlan: fix dereference of nexthop group in nexthop update path
Date:   Sat, 30 May 2020 21:48:41 -0700
Message-Id: <1590900521-14647-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

fix dereference of nexthop group in fdb nexthop group
update validation path.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Reported-by: Ido Schimmel <idosch@idosch.org>
Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 39bc10a..ea7af03 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -881,13 +881,13 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 			goto err_inval;
 		}
 
-		if (!nh->is_group || !nh->nh_grp->mpath) {
+		nhg = rtnl_dereference(nh->nh_grp);
+		if (!nh->is_group || !nhg->mpath) {
 			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
 			goto err_inval;
 		}
 
 		/* check nexthop group family */
-		nhg = rtnl_dereference(nh->nh_grp);
 		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
 		case AF_INET:
 			if (!nhg->has_v4) {
-- 
2.1.4

