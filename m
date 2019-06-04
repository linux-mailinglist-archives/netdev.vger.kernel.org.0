Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D991134E6C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfFDRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45364 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbfFDRIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so1917705wre.12;
        Tue, 04 Jun 2019 10:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vuvZzizp1G0cVCZViE7O7i65Bt526Td+PC5RJmQRqkQ=;
        b=Bg/LpytX7B47GPGFTPty7Uy7c+wUDG2IyFYwOH0pnjqszdhEmtQPwMCAJ/ityjQJcG
         XnKTkGW2P0MA+ildUrvqoi3IpFuWUMSd+35Oyxy48PxW6NwxHFg8/UyHuBlmT4+aYgnR
         Z6k2pN9Qb/LG6HQqyFRunD5UIh7lNZlU5uKq25qE2yvVvCuR2PM54SQrbcaPRwvPFbx8
         1vNrN96T26jmIwK5rFpV9+yAYcTfb9NDuMKmZaJw9W2GilE+OzFyNFcxUtivnCX2O7OL
         HNCc6dIopvhuniFoEaqtDTQZZGNR/CKWhet4dAiIr7G+eCDebVPxh91MauKuglJfVod8
         EjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vuvZzizp1G0cVCZViE7O7i65Bt526Td+PC5RJmQRqkQ=;
        b=ivZIvMYQuPIXmHss1KyR86ntX9aKP7ulDgfu3qIW3al6wz1/oz4E61UM6hqy9lmilZ
         i2OlW14zDHoWS36mO01dy5WINLeOqHhISmQRxNwmiyvBaUXasljYOcfqZnK2+HMxb8mz
         WglkgTU4aRkH2XihjdnsRiiiKgs+X0GrgChOmQGehGvIg6w0RcAZUOfsq77blfAkKP6c
         JHCaVOp3TInRpdpbqhqqWUJV55gcGYRuiCZ15/L+s7pTcRP2s3MegROHcljgl1qZRCfX
         6/NIHBLI4wi+FmYin0sQ2iflNNs3n0RZ/MB0zDF1hL4lraomgpUC2vAenGYmhrqMrNGy
         +amw==
X-Gm-Message-State: APjAAAWa14knNH98D+1dOzow2mjuH4hPyhDXhuBVyIIgkqSChpKAs+yV
        6pp4VUA+sbia9V9VPOZZiJU=
X-Google-Smtp-Source: APXvYqwkm6qK86qSGIcBn+OCuG9ltQsON8KuBofrkExsQlmLyTp7h4tCj9Gd8HDYLEhWeJkHQsGs7w==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr5820557wrt.290.1559668085584;
        Tue, 04 Jun 2019 10:08:05 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 02/17] net: dsa: Add teardown callback for drivers
Date:   Tue,  4 Jun 2019 20:07:41 +0300
Message-Id: <20190604170756.14338-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is helpful for e.g. draining per-driver (not per-port) tagger
queues.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

Moved after dsa_switch_unregister_notifier, which is symmetrical to
where the setup callback is.

Changes in v2:

Patch is new.

 include/net/dsa.h | 1 +
 net/dsa/dsa2.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a7f36219904f..4033e0677be4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -361,6 +361,7 @@ struct dsa_switch_ops {
 						  int port);
 
 	int	(*setup)(struct dsa_switch *ds);
+	void	(*teardown)(struct dsa_switch *ds);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b70befe8a3c8..d98e0e8ee8aa 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -412,6 +412,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 
 	dsa_switch_unregister_notifier(ds);
 
+	if (ds->ops->teardown)
+		ds->ops->teardown(ds);
+
 	if (ds->devlink) {
 		devlink_unregister(ds->devlink);
 		devlink_free(ds->devlink);
-- 
2.17.1

