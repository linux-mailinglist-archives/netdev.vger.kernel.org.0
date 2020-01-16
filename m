Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945FB13F263
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436811AbgAPSe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:34:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36895 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436742AbgAPSez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:34:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so4892699wmf.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8lMD/+RVNhiPm3KuKcZhVdeHUIqREzXrLBn65oHgTW4=;
        b=O6FeASvtNUpFtbOfQwpOc1qiGT9cM3prSvmWPVLn3zwB//z0eTjRO+txibow2ju2ff
         GbqP0f9PenDMATgDcj0DWFFXtLMHyh9tOyTDQmfg+GeswFsvvUlXnxV4YRPGZEuFAA2Z
         2g2EYEARwNlnvcfazQ2nGPng9F87FBXz1p/uKCHq6MWOcJ8SJmf2YdlnTS+C0MtbEnW7
         y0lmfyaYBKj7vw8vTHVa5vgqrKHmU9U0dXy6GCOKmQUQfMQa/4xtqmpYtrWSkAkyLKoi
         o3SPaiynR2qZvOkVoh+JdZCQZ6BzgH6H+RAgMu5dJIV963mter8UYhb6vmAO3bKwsIOo
         n+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8lMD/+RVNhiPm3KuKcZhVdeHUIqREzXrLBn65oHgTW4=;
        b=ULCMAfyFkLcOjL06bigkUqnKk2WYe9KKzCz2vtf5h1tXZVzKS2iEdIzP1YrrreR1eN
         O10MZeQ6yyZu/vovtXwWSHkflMXzXoxg9ureIcMkTpcOnhaOn+0vJR67bQE4neGIYnnw
         7UYNYxlZT3J0CWkDKJO1uN87WT0v7xE6jDewRKeih/D275A3ElCgFrXtu3ErPx/GTtf+
         BoagJIV6Jw67Qb4d+Y1Pn0dQzfiWswSeKA4cnbADQuYHz4oehh/ceBZwPSYqjr/1FR4s
         ZdeDN8r9+Qwq5DR7SXD4/Ef+FCZ+R8RgcqZnZaTXxU146EGMoHyz8hjpQ1S7Dh0zmGUE
         O+vA==
X-Gm-Message-State: APjAAAXFfSALqXMJHpi1RahMvUo+OSj6Q7bSxDOF46KI38KHeboDBDgr
        52SuI3ky77sPSYGkimFQpgY=
X-Google-Smtp-Source: APXvYqybXvIAXAx7vngVI26GoQWy2yBGMoET5JCx+5rTfK+cW5oX+z18AiPkzb8XMpPH0sZoYDfDdw==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr330756wml.173.1579199693905;
        Thu, 16 Jan 2020 10:34:53 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e18sm29970433wrw.70.2020.01.16.10.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:34:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: felix: Don't error out on disabled ports with no phy-mode
Date:   Thu, 16 Jan 2020 20:34:49 +0200
Message-Id: <20200116183449.3582-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The felix_parse_ports_node function was tested only on device trees
where all ports were enabled. Fix this check so that the driver
continues to probe only with the ports where status is not "disabled",
as expected.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index feccb6201660..d6ee089dbfe1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -328,6 +328,9 @@ static int felix_parse_ports_node(struct felix *felix,
 		u32 port;
 		int err;
 
+		if (!of_device_is_available(child))
+			continue;
+
 		/* Get switch port number from DT */
 		if (of_property_read_u32(child, "reg", &port) < 0) {
 			dev_err(dev, "Port number not defined in device tree "
-- 
2.17.1

