Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4339F8E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfFHMHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:07:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44343 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfFHMFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id b17so4639142wrq.11;
        Sat, 08 Jun 2019 05:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tz6R2sXMeNxZli7dtBvWFgZ8AOaycafMMuboOgKjF7E=;
        b=lCPzgLcLlpHr0hVU43xIKvjIEcQ+gOiHroQwSt0AgbkSVD7Aif8x7a8wtLXP4DQAiw
         UTVkl/IlExAF1FDNLRoD3hSigih0Oe1qtQ8+EeAbL9q9al1u/oUrp+ETTWLa6b2sCAYD
         7Zrl7VmFQAj3x3qOfh7ZilrL6SEY2PDNdlEuUah921bA06A0cVmufsT1mrELNyYqhBfA
         yAzyWTrkIwwkhtr8Yw8exHg0VSkByMdamwkJ5vRsID6bu01tzLSj1U9iLWIX+eO1x0Re
         Cpii1sS0SYszMuRuUuSEAMoHHS53DgG4x0anTfKicFuuxZmXbnXPW8ubbMvnxA+nlOed
         XoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Tz6R2sXMeNxZli7dtBvWFgZ8AOaycafMMuboOgKjF7E=;
        b=TCtl8ceoUgaTtV9REoPpCeanJQDtEDGm8YJjpWhQRO0b7OvbeTBSyoVtAQ41TwAtlQ
         t5vPKGmZWF2LmiwHjbVxIAj/xKp+BvXT2s0gSO/IIZcHENwi06poY3Oj6iDMgF9TEPEp
         onwYOrp/Unngm0lNm1SpmccjR+f7gBmbn4QRUOZuk/rNIJj2QRFuSR6tcLhCnfwLSVHc
         v5sWJFAvTIPpASdmS84F7tAiWPqq417eOeF8BmW+EVfC+bJHfOpF4Di2lbUNN+m7xbfm
         9KyUK/7bxQM0TbH07JiK3DO36+kIHV6P5Aa7AEfcMn7V5hFiRtCzf1jBmdutAajm9c4w
         iKBg==
X-Gm-Message-State: APjAAAUhhsOa44Ae5rM8ZRB6AIiyjcsQRpalQc0IC622Q6CbWuczCdTk
        /4DL0shQBBe5mZqC1VkdGjg=
X-Google-Smtp-Source: APXvYqzwx6vMSnLWw1L8rkUoFf6RObW4IGmGAKyB3j2LtcswJyfXwaMAxhMFXpqpaSeCj+pXMeZHyw==
X-Received: by 2002:adf:c654:: with SMTP id u20mr11648634wrg.271.1559995539786;
        Sat, 08 Jun 2019 05:05:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 05/17] net: dsa: sja1105: Reverse TPID and TPID2
Date:   Sat,  8 Jun 2019 15:04:31 +0300
Message-Id: <20190608120443.21889-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From reading the P/Q/R/S user manual, it appears that TPID is used by
the switch for detecting S-tags and TPID2 for C-tags.  Their meaning is
not clear from the E/T manual.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:

None.

Changes in v3:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8ee63f2e6529..ecb54b828593 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1421,8 +1421,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	if (enabled) {
 		/* Enable VLAN filtering. */
-		tpid  = ETH_P_8021Q;
-		tpid2 = ETH_P_8021AD;
+		tpid  = ETH_P_8021AD;
+		tpid2 = ETH_P_8021Q;
 	} else {
 		/* Disable VLAN filtering. */
 		tpid  = ETH_P_SJA1105;
@@ -1431,7 +1431,9 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
+	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid = tpid;
+	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
 
 	rc = sja1105_static_config_reload(priv);
-- 
2.17.1

