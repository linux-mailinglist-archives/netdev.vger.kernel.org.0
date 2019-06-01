Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86F31B45
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfFAKho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:37:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40601 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfFAKho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:37:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so3265655wre.7
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 03:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cY/42OI+Ii/fXIKG3ZaWQxf1THJBYMkiloGgXUlIGeA=;
        b=qhNJiWJQop+Shlf3bU1TjveN4PNsBAtBbfrztDKGkpt1ic7ApgBFeGYxU95bS6PQdD
         SupPD3quh+pkdR92QNMPfRUtHIFeRmqTt4ZiD1Qr6PdF6/IDZvZM6wwHQ5tdZQKaFKX3
         fEw0qZAjzFvOX8votkUcLdLGpa1u5cKtFB1AVackvBGPhlHu5s20n3rS2WTlcaYMd6hc
         WB6dhDDe6rN50Dfzn9FBJxHIFG7PQ4geu8cfcPglTegbaNAErlt/+Gfr8UA0YRqxsXb2
         pXNhhQA8BmDi7rrZ3jA0yxazrC/TnvvNyzzgrsHPUDhDPY/YjSxkI9Tch2qTTaSmjWAz
         7fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cY/42OI+Ii/fXIKG3ZaWQxf1THJBYMkiloGgXUlIGeA=;
        b=VHu9I/q27xZhVxUt/bWWsyIxWecdSXTW4fGqrmMCOuzIhTaHxjqQtxCD00sVL7PBxI
         fn8vfEWIVJaqcsH1HtMvqftMR2nL7KcgMSj/01DrWdY8IQ+suCLp+sZn/Y4QMzt5cAaN
         xldGHIY33UxkhtasjM1ey7hSNOdvZxhFOg2Jt/Vawtu5yo8nQOqrQjZxF5KGhj5LtSSh
         MmoJqiG9WHFzgYOEwxTihDjQoXW9g7Kpt2lVs5A7zqhmp79nuckGLdGTejswhywQsJpG
         CnXZ9aNmwtUuaGT0qIW+7AsZbcnwTKaxu92H9X8KARa3PghJQbAdp4NOXBb85kFqPCaD
         +lCA==
X-Gm-Message-State: APjAAAUlNI0uLJYS9ovl1f4Jw/QPGEsvcki10hHNOPfAY74lyiFB/Ia3
        Btoke91Y3+cl3u2JKCG/tpg=
X-Google-Smtp-Source: APXvYqyvysfwRlkX9dcrORDHmdIAKcpngdVI/q1GB2K0pe7S1rk5vOyDm+lhsLtTRyPCsaINe8Mx9g==
X-Received: by 2002:adf:f00d:: with SMTP id j13mr9902741wro.178.1559385462483;
        Sat, 01 Jun 2019 03:37:42 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id h90sm26273063wrh.15.2019.06.01.03.37.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 03:37:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: dsa: sja1105: Force a negative value for enum sja1105_speed_t
Date:   Sat,  1 Jun 2019 13:37:34 +0300
Message-Id: <20190601103735.27506-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190601103735.27506-1-olteanv@gmail.com>
References: <20190601103735.27506-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in sja1105_adjust_port_config relies on the fact that an
invalid link speed is detected by sja1105_get_speed_cfg and returned as
-EINVAL.  However storing this into an enum that only has positive
members will cast it into an unsigned value, and it will miss the
negative check.

So make the -EINVAL value part of the enum, so that it is stored as a
signed number and passes the negative check.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      | 1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 1e6d0f33a663..15df37ec63bf 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -160,6 +160,7 @@ typedef enum {
 	SJA1105_SPEED_100MBPS	= 2,
 	SJA1105_SPEED_1000MBPS	= 1,
 	SJA1105_SPEED_AUTO	= 0,
+	SJA1105_SPEED_INVALID	= -EINVAL,
 } sja1105_speed_t;
 
 int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b89d979ba213..12b1af52d84b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -719,7 +719,7 @@ static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
 	for (i = SJA1105_SPEED_AUTO; i <= SJA1105_SPEED_1000MBPS; i++)
 		if (sja1105_speed[i] == speed_mbps)
 			return i;
-	return -EINVAL;
+	return SJA1105_SPEED_INVALID;
 }
 
 /* Set link speed and enable/disable traffic I/O in the MAC configuration
-- 
2.17.1

