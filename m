Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472FD9520D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfHTAAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41160 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHTAAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so10430658wrr.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pIrJaC+48SpEcMoxrIYiUg3jV4y8anjJtvhQRRuXa6M=;
        b=jKRQtaEw9nuK3qTm+BWKM3N/2lYBhxg73xGS8UFzXWYs3qapSyPW0Q/wQ45D00WY2e
         sF2I8JwhfHfJwUamixSqDoN8XdJ0nGSzIIuOan4nqsNH61WkSlKY0fz6adKcEoV6JD72
         FuOHr8bAfRUrp6N8vG5LrZHUeQwYK5jcLax1yV0AHaoScm68YDiRYwE0ToLbFLFqdbGO
         SSe6h1SeIhfQSabZ3GbOBosXkCEGhouzqkBOuWlwqHsOJTjNaxtXu5/BonxYy/a1x+nz
         wGlGtcoM3vSdfj3xijyPE4lnY9o5zaPxZ29lQKM5h1Gp4t0bo+FqC5jE104ppAbrFYG3
         zLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pIrJaC+48SpEcMoxrIYiUg3jV4y8anjJtvhQRRuXa6M=;
        b=EiF/r0qc/bipWE0ObJhhozemkzb1SgzPYgnnuP0sbJ0WfkAMos7xnCRHWq4Q1eup7Q
         c5BxfGiAvALsUB/0JFgyx6jA3GaRFoizpfVah6jcRDSe6MtjgqM9vSW//aoje8yNGX0c
         Qn3+K3OIv8ijCZgmSUENvG61gS9ZrtCdjyEPjCZa+mVv6k+Xm+n4jsdaZLd2Z0U8Ew8Z
         JcWfIbrOPI1xfXiapL9ENyfq+OG3HWoU9tBw9hAWzRadSEuGY/GLQljdYHvXmhZVMYLL
         JgdQkIWDm046iZuyWBNidMUMOZjc+idgIyHCoTVwZVeqyvH6KyBdUwjqRINrfxicRkOS
         0cjQ==
X-Gm-Message-State: APjAAAVEGkzTZocnQs81rs+RofsPwbtLVjftIP/eV89vmw/yIsiXCWYD
        82wCdXwupklaBKs4bVFL/48=
X-Google-Smtp-Source: APXvYqxBq3WnaCAwBPpjVNFVaW7TpxnFyPojtwtLC6aIB0CJHQmkVSkHO7SLEBDH3cHbwR32uVckdw==
X-Received: by 2002:a5d:6911:: with SMTP id t17mr29718086wru.255.1566259210631;
        Mon, 19 Aug 2019 17:00:10 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream port as well
Date:   Tue, 20 Aug 2019 02:59:59 +0300
Message-Id: <20190820000002.9776-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
is littering a lot. After deleting a VLAN added on a DSA port, it still
remains installed in the hardware filter of the upstream port. Fix this.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/switch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 09d9286b27cc..84ab2336131e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -295,11 +295,20 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
 	const struct switchdev_obj_port_vlan *vlan = info->vlan;
+	int port;
 
 	if (!ds->ops->port_vlan_del)
 		return -EOPNOTSUPP;
 
+	/* Build a mask of VLAN members */
+	bitmap_zero(ds->bitmap, ds->num_ports);
 	if (ds->index == info->sw_index)
+		set_bit(info->port, ds->bitmap);
+	for (port = 0; port < ds->num_ports; port++)
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+			set_bit(port, ds->bitmap);
+
+	for_each_set_bit(port, ds->bitmap, ds->num_ports)
 		return ds->ops->port_vlan_del(ds, info->port, vlan);
 
 	return 0;
-- 
2.17.1

