Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935D51BE39C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgD2QUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726871AbgD2QUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:20:02 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88D4C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:20:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x18so3280441wrq.2
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zSQUFcTA5EZEGaPUB16rfmy3e7ibN/rhh32ryX4vK0A=;
        b=XHexUZNEEoPLgiKSW3tiPQbAg+klMt2VeEbN69JwmzWCJG75SktlhyIrXnnKMcrWFb
         faPL6lRlvCoROh4BQDqXo4Fur++S1Aw0eMONGRp1z6cBtWKZygoOp8RZSMKdebTs9mFz
         bj777HQcJFKwiY61tb0pqDFa4QfAQUcn0bmPfZdpBejIcR7XZR2u5Unz2zxhH6Ru9I2O
         z6Vb6wCcl2rMWzyjdsT3RsuIUThGYnRsdIFXHhSlCQXc4ZxGAL63IzL+gHCvfUxGK1CU
         ASXC8FoDYmAjwIPj1x5vLiSZaNDhuv8IPHxONseP+/VS2w2jRvmQHtampEaK4fFqXcyx
         47sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zSQUFcTA5EZEGaPUB16rfmy3e7ibN/rhh32ryX4vK0A=;
        b=kNxJdYrn2W3+FsiLRPAMLUr6IAt1U52Av3eztO5oybu69p0FhYWFoSAkT/XCaSovxz
         vmXT78wmWiz/pjXG40DPB5bb7VxkaQVymJS7e1jJhOcw8JiSbSKKvjX8arGnSQ/9armJ
         fU9YeWiaNntmDuk2g+wMiz6EmcKTII/Y6WdxaOFNsu7kWOONuJUkqg56bTqwhZA8qpMp
         FREwyiZI0LpbAL+LcNMx4lJzFqJDBvuyTmFxqyrnq4My5HDbv5IwcESLJ3yvKOtDOSq3
         7zUOEy8JERVs1+CCGh185Z92bHCSkWyXJFd7EVULm7Mc8fykNmOzUbQ9kiz12kXGD/dK
         ABpQ==
X-Gm-Message-State: AGi0PuYztSDMZlGNX4x+atWxBVoMZ7WClNxqM3XHqUKCE+Q/ngyZbCCp
        K8KmO+U54Uh0vkxphnttP00=
X-Google-Smtp-Source: APiQypLnRMNWj+gSL1nJEaYPI0cQv/guQjjTgnbCwZ0+y9mH8/h91MOFUuEH32wYsuPb23Cxzhzccw==
X-Received: by 2002:a5d:4042:: with SMTP id w2mr37340690wrp.195.1588177200611;
        Wed, 29 Apr 2020 09:20:00 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r18sm28132609wrj.70.2020.04.29.09.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 09:20:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com
Subject: [PATCH net-next 3/4] net: dsa: introduce a dsa_switch_find function
Date:   Wed, 29 Apr 2020 19:19:51 +0300
Message-Id: <20200429161952.17769-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429161952.17769-1-olteanv@gmail.com>
References: <20200429161952.17769-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Somewhat similar to dsa_tree_find, dsa_switch_find returns a dsa_switch
structure pointer by searching for its tree index and switch index (the
parameters from dsa,member). To be used, for example, by drivers who
implement .crosschip_bridge_join and need a reference to the other
switch indicated to by the tree_index and sw_index arguments.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b2111924c7ef..8a337387565a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -671,6 +671,7 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
+struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9a271a58a41d..07e01b195975 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -24,6 +24,27 @@ LIST_HEAD(dsa_tree_list);
 static const struct devlink_ops dsa_devlink_ops = {
 };
 
+struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
+{
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		if (dst->index != tree_index)
+			continue;
+
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->ds->index != sw_index)
+				continue;
+
+			return dp->ds;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dsa_switch_find);
+
 static struct dsa_switch_tree *dsa_tree_find(int index)
 {
 	struct dsa_switch_tree *dst;
-- 
2.17.1

