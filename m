Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A501D9189
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391467AbfJPMut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42996 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405261AbfJPMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id f14so9130289pgi.9
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jwtkQFquC2mlodekae2bu8dLbM884QLNSQaXHG1zPZ0=;
        b=UPw+uzFytviho1tnE4WmG+WBafo32SJxY9ZFiwBdgpiTakzUoZZOIISpAPJnvLT/7X
         H24PnAWZYT+RVFIpXefQ2NKYF1sjo0FeWuZphmIqP+fAdDO3G1dvlXl3+41PTfs9g3TR
         KSupN6v+T9UhaOZb2cjtYHU0xNcVgD3HJ2mbgy6xbhQxd+GCLrk0iw9D66QMlW3atXGK
         3wf/XB3OxkVCiYCFDyl8pbibAlLINUPLqgt5ZKqOmth76I+K5Twga01DGZgqL/VixRrz
         njeu5xURcDg9XFxBpE32ixMdBlFm83795Ejb63IOrUj28zpXdlQ579899ycngEsqXjAI
         Ffcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jwtkQFquC2mlodekae2bu8dLbM884QLNSQaXHG1zPZ0=;
        b=P3RmwigWCdR2dnJZCvdcSk1vYH/7Cg/lMM8FMrTDHs/MjYhlpQwYTjkAfGOJtFT/Xh
         htU9V9IODN4WnBEecnTuGdlZ+Pq4kqKsCUiuuM3PGlNrG/Zh6XdJOPpB4KDaNPRjxRt1
         Vu/LbDefc3zxHc7e/HqbTFqvvZuIqiNmO91WedXDjL8vHizgVg6/S2qZTHIe6anWPiu6
         gjEouJ4pblQiDSTIhOrVXtRq0FqtTqjkBeqIEbRKSP7SDTkqrjSsv0CJtsMGn56i/iIH
         PAzHsLbM2K4unHatdkKrSaec4PWYzuV7FnamWP2v+f9lepyp83tCyssPi+tA1MC6XF7M
         6xqw==
X-Gm-Message-State: APjAAAVW05Xm/fGTflmsI1K85se4A+gb+3ks4kFFFFwJXCg6RjdE5Wv1
        auCYdWQutme+6r8kCNpUDNc=
X-Google-Smtp-Source: APXvYqwz75XUUl97HRXGgt1GVHvivlpp+M2yuWsLRQJkUhD5JQxOFkefjrF/9s3ie2CpEpgbJIp6oQ==
X-Received: by 2002:a63:10d:: with SMTP id 13mr45122384pgb.173.1571230246648;
        Wed, 16 Oct 2019 05:50:46 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:46 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 07/10] net: openvswitch: add likely in flow_lookup
Date:   Tue, 15 Oct 2019 18:30:37 +0800
Message-Id: <1571135440-24313-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The most case *index < ma->max, and flow-mask is not NULL.
We add un/likely for performance.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 3e3d345..5df5182 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -518,7 +518,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->max)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
@@ -533,7 +533,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 			continue;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
-		if (!mask)
+		if (unlikely(!mask))
 			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-- 
1.8.3.1

