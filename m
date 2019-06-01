Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A92531B46
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfFAKhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:37:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39913 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAKhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:37:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so8107673wrt.6
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 03:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qC3cTC6iOsRLdr2pHn823m1pV0SUlxDOahYmCzMhqvA=;
        b=AOEnSqPo2I6hSQwt4xtvtrS/CQCvnZpJ1iMl+Vgyhprqt47s7fAfBsFYySyslm1UaZ
         nSHUOT7YeFwA+wWSxrIXPx+VTih1dQ44csSaU7SUhDcSOXsZKilnB3sKYEdUjF0RWenX
         3lhPSvsFKTJobMWFGk83lndTR+M8Oz/h+B4QaEvuCosDEpfQ5w6b9F8PZETUytsaFBtd
         G/lOVrjb49OKPdXIZsUwZcBOD9HuFSQaXfJ8cKCjhvQkvdto/CsacWMV5WU4CmomMfbX
         1nVUEAsjlPFX9IkaXgFn/9v2l+HIzTN9+mSV7UN8+t2nS0K27hk4dhFXyRb5X6FMpE62
         zJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qC3cTC6iOsRLdr2pHn823m1pV0SUlxDOahYmCzMhqvA=;
        b=IFnQA0EIi22SSgRUXVomdOi3t+UzcA5l+wJU23HGa8LvfBSl8r2UizxGV0in1ZxYXA
         0ZrgGeowl/wBQAEEk4/i+9S+jNX4X4IjPDhGeyltH2Yc02Xj+Vv/3wBWTHh+jkpTenZK
         MqJF4EAft1aLawfUKLpymafTd+ahuMJlZT7RnTwnAhDt2zX2HbXgwMBwMqqneEu7rbeO
         0RNGQy4SgVP5SpXf/wgnMyMa/TkCQKs4ESAsOedLdoxPMtUzEVLqGlFNmHJDerCGuC3n
         eLlpS1WbkmOuC0kqIC4D+zpP6YhK0Fbo6vxxd6CeSa9pE/x2CzMCn5bwMzyFNn1tIoSg
         a89g==
X-Gm-Message-State: APjAAAU74Zcm4zA9Zpa1qq2KGORCOT2vYR7SMnQndLZe1DCSjSJxs0e8
        Mr+xbtpLrXBjgF7YnIv7OFA=
X-Google-Smtp-Source: APXvYqw4b+OQTBBSxJb+8JDomo/JZzTBf3cBjcVjYVhjqk1ZctmikuMQ9Id/ojnEEnXyuABflm4DRw==
X-Received: by 2002:a5d:4f0d:: with SMTP id c13mr10054106wru.117.1559385463380;
        Sat, 01 Jun 2019 03:37:43 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id h90sm26273063wrh.15.2019.06.01.03.37.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 03:37:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/2] net: dsa: sja1105: Fix link speed not working at 100 Mbps and below
Date:   Sat,  1 Jun 2019 13:37:35 +0300
Message-Id: <20190601103735.27506-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190601103735.27506-1-olteanv@gmail.com>
References: <20190601103735.27506-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware values for link speed are held in the sja1105_speed_t enum.
However they do not increase in the order that sja1105_get_speed_cfg was
iterating over them (basically from SJA1105_SPEED_AUTO - 0 - to
SJA1105_SPEED_1000MBPS - 1 - skipping the other two).

Change the iteration from going through the enum values to going through
the sja1105_speed array, which makes sure that all elements are visited
regardless of underlying ordering.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 12b1af52d84b..c3eab40b0500 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -716,7 +716,7 @@ static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
 {
 	int i;
 
-	for (i = SJA1105_SPEED_AUTO; i <= SJA1105_SPEED_1000MBPS; i++)
+	for (i = 0; i < ARRAY_SIZE(sja1105_speed); i++)
 		if (sja1105_speed[i] == speed_mbps)
 			return i;
 	return SJA1105_SPEED_INVALID;
-- 
2.17.1

