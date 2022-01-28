Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4416E49F4E9
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347186AbiA1II3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbiA1II2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:08:28 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C092C06173B;
        Fri, 28 Jan 2022 00:08:28 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id b4so305278qvf.0;
        Fri, 28 Jan 2022 00:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dUdMR4tvElt5mBvJJ0cqJizhQUejWTE0aS2LwZH55CA=;
        b=nfDGaJmSoY3l6qtGDWVlwd64W5N/3tV3yLE9028Px0ZqpEzJEUIKTKXgEtmYazP5Zw
         6NvL75F5QdSCXIpLrhsRsaTw5bqy3NUgEWZklIJxd9ab9yKICbQimA/jnHSqTjoRrWN2
         KFuxmP+7Kp8uyO+HjfPfoNSEvUIEA4ubocyBylmABlrszO8oDx32nx6DOi9S3OQbxfDF
         VNDXJxVGizC/K+LoSQ5NFUGsragZnX5chXvNickE7ez20DIszQhi50lF0ofg2khxZ2ya
         tI+OGnDcICID/opGIW/qFVa0nFqjIUuuDAxlXiSsKsvk4lFxTzVx73zNzag4xZRpj+sF
         0ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dUdMR4tvElt5mBvJJ0cqJizhQUejWTE0aS2LwZH55CA=;
        b=FDazPfCMkcHdRbDR1RDq/MSu2fl/4RMRnmYyZWBdY9zmc4DNlrUBf2MeuZ+pNcGER2
         jgrYeu1KMb7R9Y1Trd4EsMGk9oXg+tM8fYdnm1IKx01vZSZYX66qGOlEb58HuCXHY+iq
         thoPxz3c7pULzclj1EkRpwkGO5cav0vZETQ+JtEMsA8fc5HqrH9teisVvamsafE4r68M
         34+8cYMNavDm61RIJy+Si1j25PD2q304y01JbP7uE4OzoQHdxCldxbxL1IBdx66MKsUK
         llb4qLKyUCHxKEXOl/XdXpYYvbdMaqEXvYCWNqADPlmojpDr/Qq/VFxjcz/anOrA12hy
         cKKA==
X-Gm-Message-State: AOAM531O0DWBGmB/fwEauPmPZyCKc/XO7n45buUPyUq/mIvHTAG/xy6M
        P6gVGKIH650oJ6X19RcSdwo=
X-Google-Smtp-Source: ABdhPJzPjjZUaMNtuhBqEvMsApIAGW4WDkZ2E/yGdpB7oU/dn7HNHjHjuMC5QaQ73tNJUkama0wq2A==
X-Received: by 2002:a05:6214:4009:: with SMTP id kd9mr6589645qvb.53.1643357307878;
        Fri, 28 Jan 2022 00:08:27 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y5sm2682749qkj.28.2022.01.28.00.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 00:08:27 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/802: use struct_size over open coded arithmetic
Date:   Fri, 28 Jan 2022 08:05:41 +0000
Message-Id: <20220128080541.1211668-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct garp_attr {
	struct rb_node			node;
	enum garp_applicant_state	state;
	u8				type;
	u8				dlen;
	unsigned char			data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/802/garp.c | 2 +-
 net/802/mrp.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/802/garp.c b/net/802/garp.c
index f6012f8e59f0..746763a76f83 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -184,7 +184,7 @@ static struct garp_attr *garp_attr_create(struct garp_applicant *app,
 			return attr;
 		}
 	}
-	attr = kmalloc(sizeof(*attr) + len, GFP_ATOMIC);
+	attr = kmalloc(struct_size(*attr, data, len), GFP_ATOMIC);
 	if (!attr)
 		return attr;
 	attr->state = GARP_APPLICANT_VO;
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 35e04cc5390c..ce3f1b610a3f 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -273,7 +273,7 @@ static struct mrp_attr *mrp_attr_create(struct mrp_applicant *app,
 			return attr;
 		}
 	}
-	attr = kmalloc(sizeof(*attr) + len, GFP_ATOMIC);
+	attr = kmalloc(struct_size(*attr, value, len), GFP_ATOMIC);
 	if (!attr)
 		return attr;
 	attr->state = MRP_APPLICANT_VO;
-- 
2.25.1

