Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847612EBB90
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAFJKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbhAFJKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:10:15 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF0AC06134D
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 01:09:35 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x20so4909984lfe.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 01:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WXb8ZbXP3cgf2Fgkbx8Pw1yOIWIB+RyqLEJVZ8Z4lLk=;
        b=YH26p+llWbMpPx65LLEgAZSsNMgyxAadr7BxxTCZsHJysAAM7cPe81cw1JeKnD4gLg
         rqr/H0OBfNKP/23BsgLeaHM2DLdxx43dB9L6GcfhdZKY2qYtpc1nLmzfv8Iia8ZyfY3a
         NxacykOBa7moG7nUI6Hn7x0RVZ2Vxz/HbeoA6o8uJgKll9B525L6EvweBzpHD2/onxmD
         7BMYttC7UON8pu3rzyNbgsqN+L4OUprS8vGMZMN/nqZdrFfroNyNhB0J0moUSbfNnmip
         sDVW0OuErGIuyV36m7tL9nGO58XgnOWObyj0JghJ8H/GhJSb5F1GCb4y4lsSpGz4cY6X
         YdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WXb8ZbXP3cgf2Fgkbx8Pw1yOIWIB+RyqLEJVZ8Z4lLk=;
        b=dgc7Q3ia+gUGQiGo53Ma752K5c3ixj6AbeCwEyfrpI73VKznIzQ2pK6N7KsbiHXm+B
         YLlj1199Kb015yDJAIPwkAj6WlmBDFhbXSrs8ve8/KaimfmtHvtyZXaeVq73bLbXOF0X
         1wCjsf2uPuDWhj7YTbjlbjm3U4z1TgQoLXPxOfG/uPA7Bmu89yogoLEBK1bgrY1SMHxB
         QBYk9B2JFtpaLacSm1KGi5oWz7voa9Be/T4OUpzW+fCcoFNwRLzDmsfVo6ZPeuFApDq8
         p/ln2jWBI2ZmArCDKP3bNtT9fMXHiqZz+iGYvYwf0sqFPClFJJ6TFE5ucV3ZglIRwTpa
         oxlw==
X-Gm-Message-State: AOAM530kD7D53jgOCqPwVH937Y6eDbBfgBeFeKpfr53efZPdvd7jLQBC
        sUlKUd0ASUyCmaRazLVlHCtk/IjoSYs1VQ==
X-Google-Smtp-Source: ABdhPJw0F0w5yIsIF02ScYBJMua0rt9nhNGD2v7UavFZcbJGH596yZORLolVkmv6X9FzAmNXKxliKA==
X-Received: by 2002:a2e:a407:: with SMTP id p7mr1651300ljn.78.1609924173796;
        Wed, 06 Jan 2021 01:09:33 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id r201sm222335lff.268.2021.01.06.01.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:09:33 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH next] net: dsa: print error on invalid port index
Date:   Wed,  6 Jan 2021 10:09:15 +0100
Message-Id: <20210106090915.21439-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Looking for an -EINVAL all over the dsa code could take hours for
inexperienced DSA users.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 net/dsa/dsa2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 183003e45762..01f21b0b379a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -783,6 +783,8 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 			goto out_put_node;
 
 		if (reg >= ds->num_ports) {
+			dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%zu)\n",
+				port, reg, ds->num_ports);
 			err = -EINVAL;
 			goto out_put_node;
 		}
-- 
2.26.2

