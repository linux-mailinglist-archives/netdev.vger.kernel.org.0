Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B951B2610
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgDUMbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728285AbgDUMbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:31:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D96C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t14so16213508wrw.12
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xZC3BFNH/qr3fk9rKXm7H0W1TkJOjRPVGTkQO2n53O0=;
        b=G5ubOw9YZRb7ZXVxzp897iXop8bkyduCUF/Ufq9S9a07pIGYtZYYfvyQzLuvMft3CZ
         rxK9DTCDTcRBAcmK8eB2RT/yML4TLvttC7zKkfUZXlnuZ9YF6FZyCDD/FfWWM6uZZKiE
         nYOHVoCc39OnixOofn2kA6vIMRpYRkI294ZqBO3Bu1RipX8gVdHaLkYDsxN4nNbJikWF
         z4TAQRI1SMUtbCfI+jwoeukM9z9eMvkUFbrDG2zeb017sDX2nN9lL2KztxlLtkMI3zck
         n2E2Et2XJSSRn69EsnlbbIKodmCTs/clxnhWp7S1oHUtcHtZmVlPKFvZIVSvLS/OsrQG
         I5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xZC3BFNH/qr3fk9rKXm7H0W1TkJOjRPVGTkQO2n53O0=;
        b=iUgoMLiCXg2lwCnIZY1FB2mnR+IR3iIOTjo6Lx/qb0b2lvLNEIYYrujdoJsaN1vf5Y
         AZ2uHvPWkPRPJvi2vc4ZAVKWFi8h5m582ueESYV6hOOExVCLniAI5T7M0EVKirYq2kf8
         52+NX05yddoj+J9VW8ILFA0c1cSILxL0VnqeVeeHcemyAv7T2nl20ZVywS0qWT+PSYyT
         sLcovo/x5DE5ti5n/+mzoELY8hvDznrJxZDDHE9hKRvMQObXm1LiBbg5Sqj5Ovp9iGwR
         327TvZZLuT1v38Bti2wrDrzPI3Y/IiKnZGNW4OZkYVMrIAwAQwLUbvj5rdHsQ+voc2/P
         czvA==
X-Gm-Message-State: AGi0Pub0AlDRp6YjhB0W/LC7mKJ497AzZgclefv3ByUHhLNiA6sqXNhg
        MVvQzegm4bnMYbxOW7d+6Fo=
X-Google-Smtp-Source: APiQypLcyuzuFsJxMJ7Xvs4BjVW3k6EbExSNy0pGN+7ARqNfqxWirNrIqQg//7iRMZ96xt1rIW1JpA==
X-Received: by 2002:a5d:4042:: with SMTP id w2mr22357432wrp.195.1587472278449;
        Tue, 21 Apr 2020 05:31:18 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id q8sm3256009wmg.22.2020.04.21.05.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:31:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, o.rempel@pengutronix.de
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: don't fail to probe if we couldn't set the MTU
Date:   Tue, 21 Apr 2020 15:31:10 +0300
Message-Id: <20200421123110.13733-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421123110.13733-1-olteanv@gmail.com>
References: <20200421123110.13733-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no reason to fail the probing of the switch if the MTU couldn't
be configured correctly (either the switch port itself, or the host
port) for whatever reason. MTU-sized traffic probably won't work, sure,
but we can still probably limp on and support some form of communication
anyway, which the users would probably appreciate more.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3776a6f6d312..34071d9bab3f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1773,11 +1773,9 @@ int dsa_slave_create(struct dsa_port *port)
 	rtnl_lock();
 	ret = dsa_slave_change_mtu(slave_dev, mtu);
 	rtnl_unlock();
-	if (ret && ret != -EOPNOTSUPP) {
+	if (ret)
 		dev_err(ds->dev, "error %d setting MTU on port %d\n",
 			ret, port->index);
-		goto out_free;
-	}
 
 	netif_carrier_off(slave_dev);
 
-- 
2.17.1

