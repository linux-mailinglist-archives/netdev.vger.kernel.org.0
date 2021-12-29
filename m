Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE8D4810D9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhL2IKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 03:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbhL2IKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 03:10:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00FC061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:10:02 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so19320668pjp.0
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaI+DTc4QB8QYwvd/nhaa44rW5rN6eXyjF2LaEd8LPc=;
        b=MhJHAlXewc3Cl4L5xszxTU54tqzv9IuovEIOCYDFN3Vux5PKo+KHnVM9/6SN3kQv29
         LtVI8bXPmQ4GLPXiy2hH9fbRFPvf2mNAAwpAjqgYqLcJBiAsiL7JYYoFzx6WhLy/XAPk
         vSlUkxCqlb595spi2FCwyVSE5vOf3QHmmkRggvUYwNoSU3DSoUhErrc/XisU71TG3iA3
         uamb+fwCoyUmmgGLCMZda3utDWQk7K8ef99IcPSkQ3Nr66mauaA6unKP9NmTU4DLqFIf
         8cIBqHKaOC3x9tbb5xy9irhU0LRysFZJb1J5xRbrxK6R3Tl249qJrtCzMB00lmDtkNw0
         7f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaI+DTc4QB8QYwvd/nhaa44rW5rN6eXyjF2LaEd8LPc=;
        b=rfFnxThuQ2IKaaUyTr8mCPOeEbb0vUEfRGHXVg1eyJ+aG/ZfyiPrNF1ldk9PfMTXBN
         mBUbqCRB2rAdVgH6B1cSeLebuYe3W+YxZd0/DIutVRXIM1T5tndAcrNec8C3YXaqzuXW
         +tcZOH6jsvVlEMfdci1O8OjJ9+UadI2V3aT4Y8A51tzfkHGuNm+Cl9lIBwVQWmFS6U/n
         63en3tmupCYMuzW3pVUfA42MuMXn9Na58EcEQiC9He771euL3uz66T3/8qb3ajvEERiZ
         rweeMYlUt+lwMlig0uPuZhEiD6WeKVmNIr+d0MKGrWCJ0aK8/9Rl9LB4yOGWXNlkkone
         0EUw==
X-Gm-Message-State: AOAM5339KiuO8g4FIOPjIkdLubww8Jf80lrkh/y9EUR9cRYATx9CI4g8
        KgJ3ZPNJooSsti4aLq48U424jv8wwx0=
X-Google-Smtp-Source: ABdhPJy01WbmRlrb0ALMHgo1jfNpUWktFayzKsJlZxUfGssR8xp8TaH0hxc03cXlau3w1vuKcY8cRA==
X-Received: by 2002:a17:90b:4d86:: with SMTP id oj6mr30832699pjb.185.1640765402129;
        Wed, 29 Dec 2021 00:10:02 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2sm23996709pfe.93.2021.12.29.00.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 00:10:01 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 2/2] Bonding: return HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space
Date:   Wed, 29 Dec 2021 16:09:38 +0800
Message-Id: <20211229080938.231324-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211229080938.231324-1-liuhangbin@gmail.com>
References: <20211229080938.231324-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the userspace program is distributed in binary form (distro package),
there is no way to know on which kernel versions it will run.

Let's only check if the flag was set when do SIOCSHWTSTAMP. And return
hwtstamp_config with flag HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify
userspace whether the new feature is supported or not.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 085d61000845 ("Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 42 ++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b60e22f6394a..1bb8fa9fd3aa 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4124,28 +4124,38 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 
 		break;
 	case SIOCSHWTSTAMP:
-	case SIOCGHWTSTAMP:
 		if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 			return -EFAULT;
 
-		if (cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX) {
-			rcu_read_lock();
-			real_dev = bond_option_active_slave_get_rcu(bond);
-			rcu_read_unlock();
-			if (real_dev) {
-				strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
-				ifrr.ifr_ifru = ifr->ifr_ifru;
+		if (!(cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
+			return -EOPNOTSUPP;
 
-				ops = real_dev->netdev_ops;
-				if (netif_device_present(real_dev) && ops->ndo_eth_ioctl) {
-					res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
+		fallthrough;
+	case SIOCGHWTSTAMP:
+		rcu_read_lock();
+		real_dev = bond_option_active_slave_get_rcu(bond);
+		rcu_read_unlock();
+		if (!real_dev)
+			return -EOPNOTSUPP;
 
-					if (!res)
-						ifr->ifr_ifru = ifrr.ifr_ifru;
+		strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
+		ifrr.ifr_ifru = ifr->ifr_ifru;
 
-					return res;
-				}
-			}
+		ops = real_dev->netdev_ops;
+		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl) {
+			res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
+			if (res)
+				return res;
+
+			ifr->ifr_ifru = ifrr.ifr_ifru;
+			if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+				return -EFAULT;
+
+			/* Set the BOND_PHC_INDEX flag to notify user space */
+			cfg.flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;
+
+			return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ?
+				-EFAULT : 0;
 		}
 		fallthrough;
 	default:
-- 
2.31.1

