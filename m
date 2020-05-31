Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5701E95C7
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 07:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgEaFRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 01:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEaFRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 01:17:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133AAC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:17:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 185so1972290pgb.10
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 22:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xRuCKtmAU98/1FoM979BFTI0yYozTBzpHXxwBey2HNA=;
        b=WuCnRGdoNPe44NoH4xa968aPJCc3VqhIaVE0jfmuFe/l3fosuxw+ZMYRXlb9mILjmh
         5t47ydHuiJcW76B8BznNuPerU7QQUeLvRIEHfhQIMYzznboGLdkOE09OFzzKWrygdDan
         UEsA8jQ4evHZaTvryEJogN8g4CQXT99zRgAtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xRuCKtmAU98/1FoM979BFTI0yYozTBzpHXxwBey2HNA=;
        b=pkSVbYpG+mCi3DjRM/Qca31llT3rkfDwcXzLTmzor1ZrOFKJHh/FZNZ7zeXBdPAriu
         a2b4jET8l0C2PxPEDCV3d6CWcjBhH+89MUom4dIkxim+WUalsWPNc8MmAocaZ3jky+J3
         +2F/3Cu1GlFiXTtUKkPrXT7gU6BxAbuR3K/DrC+02nrlGtplFHZE7lOnNSlauZghRXmo
         GoMHYTeyZpOVNC6nFU2VHaNhxYt1BUV1LWQf0VLpKpNs/+HSAI+9w/V827WVfIAncbSf
         +njN21vQO8qchVNnl4iKToAQUnYcX5xHfRinzxEJR6iL6iXJr5VCpzhZPl9kRpl4tvm2
         LWxw==
X-Gm-Message-State: AOAM532Osa+Ag3cyCPyXUeDJ/ym22ap92R5WBGbVOH9iI2ESZ15gR3St
        JkdDfLX6LSJ775DQ3b/wnKthhA==
X-Google-Smtp-Source: ABdhPJyyOBzoqaS/j7oGsorOoJ4YNltIjdO1CxMxXTgjvyxmCkWFS8R/x/Q0vyBKH/rY/oqVmUrj2Q==
X-Received: by 2002:a62:e305:: with SMTP id g5mr15835370pfh.144.1590902256513;
        Sat, 30 May 2020 22:17:36 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id x191sm11395292pfd.37.2020.05.30.22.17.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 May 2020 22:17:35 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next] vxlan: fix dereference of nexthop group in nexthop update path
Date:   Sat, 30 May 2020 22:17:20 -0700
Message-Id: <1590902240-10290-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
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

