Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B310198590
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgC3Uks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36825 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgC3Ukr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so322463wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bl0yu2j4T+LH6lKOM5xoWi5HPF7bOq1CzLFkv/S3kcI=;
        b=U0Yxdpos0iSRNJLHt+4crgex7qmMuBuOV9IGuugJrlXEWr1WW2OND9nH46veyawvgq
         Fb3ljVH8saxAPIATTlayEHJ2l9y215pPJOBFZ6DkVNr3OcnfpbUAHVSIfmaTjrGugISK
         qltenYX5AKt1aYWgHBewedLqiYUFoYY781cn6rAYL5a16XQt7RL4PwH30Sv8pu9OLgl5
         8KVSwVtCMSNKzYsMcVFv/ZOQPFxwGE9LuakvZxCBLVjh3n0oqNrqIcoOQ/8CiSLhStMB
         8QxViOy+pa6icy/rYoYlRq0ktezKQsG1ada7bza9DxOnvUBXTu0EF7oOoqsQcUIS99jv
         Uhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bl0yu2j4T+LH6lKOM5xoWi5HPF7bOq1CzLFkv/S3kcI=;
        b=WWAnKkapJGB6WXyTety7MxCoEDVnjzc8rOxf0RivrShI/SoGhQIuC8kwPqdkZPuACM
         6ln5saFLaG53rKDHrPdji7/kAn7J8m4Ky7GgBvnhSLLtHIBKHntTLPIm95CBJEJT9mPp
         B3VNuzEBLATNpamQ4ecDOnjDTZUes07pxBwQxXeSkzlvu/dKlwSDE19LrAo2xlcJeZ3C
         gzpXh9n/bA8QFovRkzIC+trDQu1yPMO/h13dmzNSTZn3+1fCH5/bEu8C7u5iUSbiFQtF
         oRP8vvxao5CpCK//DWlly4XLf9KMc+ELwKQiu+wjISBxbq5FiheFzapJQ6K0Nvpds2dl
         X8jg==
X-Gm-Message-State: ANhLgQ3nnAnV8W3DcAQCb/8rHNDfGnwj9z7IR2Qc7XiU/9M/K68R9h4F
        YC4vdpXBMM6tV45Ao0RaAIRpCeiW
X-Google-Smtp-Source: ADFU+vtrrVGiFoRhxkxQX2Sa67KF0gubkUZVvVNJAPJgxTnSA3uJShMhIBqzCBP3MCL40jsyE4O/DQ==
X-Received: by 2002:a7b:c004:: with SMTP id c4mr1068627wmb.108.1585600844727;
        Mon, 30 Mar 2020 13:40:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 2/9] net: dsa: b53: Restore VLAN entries upon (re)configuration
Date:   Mon, 30 Mar 2020 13:40:25 -0700
Message-Id: <20200330204032.26313-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first time b53_configure_vlan() is called we have not configured any
VLAN entries yet, since that happens later when interfaces get brought
up. When b53_configure_vlan() is called again from suspend/resume we
need to restore all VLAN entries though.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 39ae4ed87d1d..5cb678e8b9cd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -681,7 +681,9 @@ int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan vl = { 0 };
+	struct b53_vlan *v;
 	int i, def_vid;
+	u16 vid;
 
 	def_vid = b53_default_pvid(dev);
 
@@ -699,6 +701,19 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
 
+	/* Upon initial call we have not set-up any VLANs, but upon
+	 * system resume, we need to restore all VLAN entries.
+	 */
+	for (vid = def_vid; vid < dev->num_vlans; vid++) {
+		v = &dev->vlans[vid];
+
+		if (!v->members)
+			continue;
+
+		b53_set_vlan_entry(dev, vid, v);
+		b53_fast_age_vlan(dev, vid);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_configure_vlan);
-- 
2.17.1

