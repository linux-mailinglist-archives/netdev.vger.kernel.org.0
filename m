Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D5D9C512
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfHYR0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:26:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37340 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfHYR0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:26:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id s14so12367329qkm.4
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8tZZoMYH0zUgp0pMuVpwmTGdcHjbhIRWQiiC8o6B+s=;
        b=H13DWAKNtRc4wcqOdNPEGUGp1gQclJPaIdum5WaGjZ8bV0uCA5YxOEfKPCegrh2YSe
         uLdP2YPEAHGcn++DVzEWMnmJ//zgQXjXMB2mHve3S8g6txO23adt/jBCwIyDSv0PFM4+
         A6aWgNk0KLJK1Af/ens/feSeEw2I5Iyg0E2Y/KoXemtEsI0hLaGZ1MeZ6U2JCQqr+wZZ
         wabqfPA/9Z0NZqRYWYb8YTsX0x++VHeT42a5rNhwNoMOGYC0tyxRom6WZkeUF8nPqlFf
         A9Bdtu46E5A+j0YONlQXQDgVVT3X2DhkwK/EBG7WXvRysnz5tN2owpP74GI7/xUgLbFJ
         T4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8tZZoMYH0zUgp0pMuVpwmTGdcHjbhIRWQiiC8o6B+s=;
        b=oFZGfsKCDOrLTGXHP2RBXEdWghJgQ/IZ62QNxGaMKLLJKd1C2JB+HeIo4MSrI88LKL
         dx5CD7LAnUVj/i7/CSlVtApZBzS3JWEteZA3ibZFWm5KIpK9PGDWw0jJJc1MKI6gm26s
         7SAchMcq/NEmcu+60+XJ5gZWDOLQWqDrPQX2dLIl/M1vl2wxMj5oX7BHojED9Q3g+5PV
         btpXFIu5VNu/3hlK6tmfE2IoH3hDlTbZEnMnNA8RXJkey8nxs7Ws+nSqoXtUck9exk2o
         VaZRcBw5gHrVdj4VMtnzy6eweSONhs35SPuZFIgZWTu/Mj0dpQVsgpzYpn3sEy3mVFoX
         dMbw==
X-Gm-Message-State: APjAAAVgwDN5ibRSHxQCT2lRwmQbIfkOa3RhE8uVuHMHpTo6EuE3vtpv
        g6dm+FCO5EzCD2LtVUyC2OoKKB/y
X-Google-Smtp-Source: APXvYqx8cM6+tP9qjD94DNBnQVGXKHm36sbSjbQfCHt+SHiGkPgzqjg6McqNORN9c7Dab1DO3GRsPA==
X-Received: by 2002:a05:620a:12ef:: with SMTP id f15mr13665859qkl.167.1566753964177;
        Sun, 25 Aug 2019 10:26:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id a21sm5110471qka.113.2019.08.25.10.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:26:03 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 6/6] net: dsa: clear VLAN PVID flag for CPU port
Date:   Sun, 25 Aug 2019 13:25:20 -0400
Message-Id: <20190825172520.22798-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bridge offloads a VLAN on a slave port, we also need to
program its dedicated CPU port as a member of the VLAN.

Drivers may handle the CPU port's membership as they want. For example,
Marvell as a special "Unmodified" mode to pass frames as is through
such ports.

Even though DSA expects the drivers to handle the CPU port membership,
it does not make sense to program user VLANs as PVID on the CPU port.
This patch clears this flag before programming the CPU port.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8267c156a51a..d84225125099 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -332,6 +332,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	/* We need the dedicated CPU port to be a member of the VLAN as well.
+	 * Even though drivers often handle CPU membership in special ways,
+	 * it doesn't make sense to program a PVID, so clear this flag.
+	 */
+	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
+
 	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
 	if (err)
 		return err;
-- 
2.23.0

