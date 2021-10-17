Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757A74309E7
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbhJQO7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbhJQO7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 10:59:15 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F138C06161C;
        Sun, 17 Oct 2021 07:57:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w19so59842998edd.2;
        Sun, 17 Oct 2021 07:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lipIEZ+n1vyEC0IkcC3jv40a0eLLrhXH63M7mDRpB6I=;
        b=b3y2ExnKRIhg3hWAu0BtPQ1jjAhR/NruRmRFVYikj/gt1KLT8rs7S9UDXRfiarECQP
         GdTw13HwDIked9Jkb/IyQkjVjXQt2tsnwMtbvN+uP0aNtKIPxFIZoy0rrnTztE5/kf/g
         7U2bx0O2TIpxzGUJuIZ7igRaHoxlXnR9J2gIWXMqmv0OmMj6Tpe0HoZQwsTJ55v2cV+p
         grrDis6i1FLjSTPfZ7Anme+/7NaWIK6aIYzArML0Vxwk3Dylx8m1D37WfyPtN5Z8KjVK
         qPcMMW320e9iqci+naN7/VbWZCZHUwzS2MXZ3aidmW43mrbqi2Bja6jb9vuK3SibgDBh
         em/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lipIEZ+n1vyEC0IkcC3jv40a0eLLrhXH63M7mDRpB6I=;
        b=EwxQ2zsFtEs/chniUGx0yXG14RVbHq/2imcQ0L79fbdwQbs20QkrTnvyTQ/aLFC9LN
         6UxDs7n9/GIl2XzVQLoMQyc4WVQHlwo94d0hcyl885+qg8cFC+NSNysuZHJ9GrN/moD+
         brZcJQ/FZSqv9PDvTOg+endFaR+j3P3rA0JP5bWZr6IfJdmtqjkH9RYZkbRMezjToZEZ
         pRTLzUg03noXNZF+7jKRm+8pEVI0yl147B7asL3YYLs1s7lQ/eCUCjZHhgHA+I3llLxY
         Fuiq9okDqMt+hX6HY3ckTSUdVhVVUp4pyqyvEfSoU756IzSNTOfwZhLF/Ui4OxE0p3QA
         AmhA==
X-Gm-Message-State: AOAM530erI6yazDD3iQ/1eeS3yT0gO8FADXN95zQNGqWlieU+dPX1xBF
        0lEMRF162FaexTB0BmfxzBzzFUMjSE0=
X-Google-Smtp-Source: ABdhPJxZYAvtGkH3LNE4woix254XGGQJfwLPHR88ASAjEjKjlZHmG9ghBeUYfki3ZKnPRsMtnYEScg==
X-Received: by 2002:a17:906:e2cf:: with SMTP id gr15mr22006992ejb.468.1634482624484;
        Sun, 17 Oct 2021 07:57:04 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o15sm7631100ejj.10.2021.10.17.07.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:57:04 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RESEND PATCH 2/2] net: dsa: qca8k: fix delay applied to wrong cpu in parse_port_config
Date:   Sun, 17 Oct 2021 16:56:46 +0200
Message-Id: <20211017145646.56-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211017145646.56-1-ansuelsmth@gmail.com>
References: <20211017145646.56-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix delay settings applied to wrong cpu in parse_port_config. The delay
values is set to the wrong index as the cpu_port_index is incremented
too early. Start the cpu_port_index to -1 so the correct value is
applied to address also the case with invalid phy mode and not available
port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ba0411d4c5ae..ee51186720d2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -976,7 +976,7 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
-	int port, cpu_port_index = 0, ret;
+	int port, cpu_port_index = -1, ret;
 	struct device_node *port_dn;
 	phy_interface_t mode;
 	struct dsa_port *dp;
-- 
2.32.0

