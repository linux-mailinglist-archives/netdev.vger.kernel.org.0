Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C877B32503
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfFBVkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55493 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfFBVkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id 16so4802436wmg.5;
        Sun, 02 Jun 2019 14:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/kDFxYp4kGKHFwaNy0rA+lCd9it89LuKTDiTNBIqcE=;
        b=gk/xSJmNUrHLjRKCWLBJLTMn1i1lz/eUNktEHDASjqO5Ic6qwH/uXlzbQeydH3l0zG
         b8wE2B+gkubjYFmzGO/53R/1mzpLLsnDvFZhuZWhzQfZQ92KkUkqXdFMoIdISCoYHDhc
         vNPnREGeOI3f8a2GwcvayiQ8j+pVdlVQWqgkHtEI278p1wYt9mhcxnCPsyuW3oOGI9cm
         2lKFm5vQ5Y6aCUUJIkSZ2kNZWTn0LBX5rQDXOQw5VAkqsA9OGyaig0iA2pmzWfxahvRO
         tYfdaKZBSTDepGLdSBUY87SQijUIog38XjnspFeC5BGrLhYFhaIG5QCzk6VZIcbik+yN
         Edog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/kDFxYp4kGKHFwaNy0rA+lCd9it89LuKTDiTNBIqcE=;
        b=OH+Jqa8LuBSWu6BDPwcGGHZKDXAmKgdQQDhwFcD4T1YaPhgRCMUTYWfpLYgh5fLLas
         GiRhrOCUSowtzoX4yEVyBnwWqIMtacKWuE9YB+rz9WculJczsfXc8E584TIsDv4Tldl1
         qx7bQ06LaQw8QI7oJp1nclrkSZ8s/8kmHZXDtnF5GDOvJGZ3LF1BI2BC42OuCcXdjFE8
         ZRcEYnp4S+iq8ueeempXIdS69FuvCgPaU7Kk8jsaaYQDnqUL4o7JoPPIfLrv0myDRYmE
         qBvSTW9t8r8ekvtacVOynjh7YC5Oe2cNRiViY2c5Hn5LzgzQNXSgwCm/47AoI7oXZmEL
         RzaQ==
X-Gm-Message-State: APjAAAXT29Do6fVUvIVUISrFe8DbpcdEj0AIYJtaOx51xtokjxBZuUMN
        ahHjysb+kPW4YCNzBtegzsY=
X-Google-Smtp-Source: APXvYqyHqRFinzqUadLjZ5PNkpYD1rUrZiiq/Eb/nS3HEZ6AX1apuKyEe5KDT2fBJ5+E5LI0FkW77w==
X-Received: by 2002:a7b:c043:: with SMTP id u3mr11375036wmc.56.1559511634093;
        Sun, 02 Jun 2019 14:40:34 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 10/10] net: dsa: sja1105: Increase priority of CPU-trapped frames
Date:   Mon,  3 Jun 2019 00:39:26 +0300
Message-Id: <20190602213926.2290-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without noticing any particular issue, this patch ensures that
management traffic is treated with the maximum priority on RX by the
switch.  This is generally desirable, as the driver keeps a state
machine that waits for metadata follow-up frames as soon as a management
frame is received.  Increasing the priority helps expedite the reception
(and further reconstruction) of the RX timestamp to the driver after the
MAC has generated it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b7af9479ab5a..6307e1c461be 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -389,7 +389,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.mirr_ptacu = 0,
 		.switchid = priv->ds->index,
 		/* Priority queue for link-local frames trapped to CPU */
-		.hostprio = 0,
+		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
 		.incl_srcpt1 = false,
-- 
2.17.1

