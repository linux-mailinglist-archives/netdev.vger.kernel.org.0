Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213861E95B1
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgEaEst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgEaEss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:48:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF339C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 5so3464598pjd.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o8WJEqNLglZhvsvbBJ2lgOdM1rKEo7a9ra+XWVTpbFk=;
        b=KmhflUlIzi09zRl4NC4AZd2rOHSE4QSjThJIai9AUJybSPGyLqW47VEw0soPI+jwTX
         ZdJUc4ivmz+qCVwQuoVoR/4CFl4OQU6aZvpbKLzUGuM1YitcJiUxd7KsSd6Suns7u70D
         8W0bQ2KssQVl1LM1FKnthwjRqw2BVfI6OpTxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o8WJEqNLglZhvsvbBJ2lgOdM1rKEo7a9ra+XWVTpbFk=;
        b=bNWygWUJF5h74nm+Lm3A3bPuaSkThOymLTiuxxGR97cdY0QU9Q1HnisX18uCRIe/XQ
         ssnaZAo/3dzCdm3x14V0XmPiND/zBRwa1BJQ2aV78acmgsSP04h6rTh2pncoFlTFuyuO
         OG38gAWu6s9sn4XwlTmW/MVDpELAABGO3eke4skbJ+uU4Hu4AraX6+E+WmSYwD6KFBDF
         LlU96NqvRl1DfT/3tJ2FDkuBpC9Wj5Zq82chyQ1EPH/11Xd1xrrLXIFiNhhrWHGu4PbV
         EgK9exaMqYRFxCDk6/huDZfqz3/SscPyJKVCBLEVsaUG1+3DCsr7G3p7QUDO/rh6oqpT
         C6SA==
X-Gm-Message-State: AOAM5331c5oYhzpDT+KNTieOAUB3hUzNFeBjVI7Eu8aHGArIfMROvpCo
        0YJ+WVbiVQszmxx6xhSb/u76mqfRX10=
X-Google-Smtp-Source: ABdhPJxj6Kxp4j88sufd5NrE3G9kxtz1fQgMxakF2itN+6T52kw73AzAbWIrjFUzgxnFBy8K3QXOwA==
X-Received: by 2002:a17:90a:e30e:: with SMTP id x14mr16672253pjy.235.1590900527443;
        Sat, 30 May 2020 21:48:47 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id m2sm3584312pjk.52.2020.05.30.21.48.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 May 2020 21:48:46 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 1/3] vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
Date:   Sat, 30 May 2020 21:48:39 -0700
Message-Id: <1590900521-14647-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

NDA_NH_ID represents a remote ip or a group of remote ips.
It allows use of nexthop groups in lieu of a remote ip or a
list of remote ips supported by the fdb api.

Current code ignores the other remote ip attrs when NDA_NH_ID is
specified. In the spirit of strict checking, This commit adds a
check to explicitly return an error on incorrect usage.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a0015cd..fe606c6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1196,6 +1196,10 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	struct net *net = dev_net(vxlan->dev);
 	int err;
 
+	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
+	    tb[NDA_PORT]))
+		return -EINVAL;
+
 	if (tb[NDA_DST]) {
 		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
 		if (err)
-- 
2.1.4

