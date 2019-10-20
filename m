Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C678DDC01
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfJTDUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:14 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35460 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJTDUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:13 -0400
Received: by mail-qk1-f193.google.com with SMTP id w2so9092016qkf.2;
        Sat, 19 Oct 2019 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CiT2dyKUrcwtWGvVFerk87hVzYZwm5syikYM9sOb9t0=;
        b=F2h3RDnEjOnrqUfQJed+Z4lmLtNKd17c4J8aOX45O4CSjL25JrkKsnRK3xRWYfTCuF
         wPqJStCIAd9qv2S/T9MNYXAOY4WN6MDiWQUeHugH3LQZEDkqkUCxSBD93f/8aGj9vnQL
         0r9rvu09GB8SWqIcCLEsmp8a3MW3sXehazt1wRH2SdZCRvkVmZrsB2zCZOsHw01qBIOi
         9N0AEvr1CQSEWipQBiDnP0EHVNyUt7awoodyh/N1ARlISMXC692rmT/pKueiKaPompmt
         yDWmzZh/zEWFbUvpSQkKgmMGdFgeRb+9dCjVv5OYjvl9htKWSw3TR8jNdLx++gXRtQpj
         Wh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CiT2dyKUrcwtWGvVFerk87hVzYZwm5syikYM9sOb9t0=;
        b=dvilZ0dNjiA/i4CzDKDyhle4hIcV6A0rJAW/i0s29VRk1e7B4Rjx0bxqpWktWpfVUX
         /hogvahrvXEx+TYa4uNkl4HOY2u/DrvFk8UFo97SXJJkTakKvVsbLy1VFTji0EgmzeVX
         TXvrSCYqMvjZhQELAvvNG0qboZSbEvDDqOF0OGqzc6f+aNGJKmeU+UpotYstVD3Xgb6p
         mQhPwI3kvCT2qDWdHp1lz5jxhr+rFSDqu6BWJnJySUipiAP3lHv79AcQINuYFHimLHmj
         CTt94sPMVkPJtA5nv3b6TE+87m+KK8QD8RxedZJ0Gg1OK7JM8PFChPzbFEam051QHZKD
         OeaA==
X-Gm-Message-State: APjAAAUgCpmWOg4w6ZiQkvTKIgNqwWffdXsp5r2OyHP3tdd2UEWfYe0/
        5go55NsNYKm/H4xKPyM/tvs=
X-Google-Smtp-Source: APXvYqwZ3D9xGCOlXfdqlAfAXqtvbpqnaxqrqo2cXXFSJhUWQUEOS/ho3GGIUbLDWwCFXcxjsMk1NA==
X-Received: by 2002:a05:620a:2f8:: with SMTP id a24mr14361754qko.21.1571541611506;
        Sat, 19 Oct 2019 20:20:11 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q25sm4903825qtr.25.2019.10.19.20.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:10 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 03/16] net: dsa: use ports list in dsa_to_port
Date:   Sat, 19 Oct 2019 23:19:28 -0400
Message-Id: <20191020031941.3805884-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of accessing the dsa_switch array
of ports in the dsa_to_port helper.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6ff6dfcdc61d..938de9518c61 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -285,7 +285,14 @@ struct dsa_switch {
 
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 {
-	return &ds->ports[p];
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds == ds && dp->index == p)
+			return dp;
+
+	return NULL;
 }
 
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
-- 
2.23.0

