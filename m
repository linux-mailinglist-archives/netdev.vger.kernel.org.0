Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300AC46CCA8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbhLHErI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhLHErH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:47:07 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E19BC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:43:36 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v23so1057324pjr.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 20:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJSFvb3zWMWtatao654Uabt7gJnMmnQ1lBC06QxW9Ho=;
        b=YugA28eT6/ryc/JORq2x6ZDscdw6/QPnYa63x4EtowMoo9XPSk0LrAagsesQ1yQwfI
         wJNimb8rc1CdjkSOpCaR3GtvWtPUQCcZ+Ob0L0yVxlTHcWVexg5exjCRKHrLvrQLYd4+
         RmT8khO7IPVCSmsQ7hFoOPd3sSGb5oxzNZ11eoNxrYkcCq3KHEPOWczEz8713B+C6k07
         aMSi6dWLCJKWUIDuhT6oqeTYTXQOFjCdX46VDtLc8rD6t6anuXvBRsUn47JbV27iHWT6
         KhQnWkgn4XBguq7b0Sxnf/CKu49T+E5ri9383VtbIEL7bLV+yx0JSt/eO36zIXZQeH02
         ZFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJSFvb3zWMWtatao654Uabt7gJnMmnQ1lBC06QxW9Ho=;
        b=MSucrcPdi1ryouB3Jnan7zjk26ZzSpJghNZrylz65sP868mXtLfsxIqvAkTKQ5ItQ1
         paNkkUccgYLxmMcZjqx4swgNh6iP2ITiAfR/Tw5iCuTirpPOIypfCKUGK2Vw8g4aYJRz
         Dw0PryztBRQ1HKdubnTA3wZivWDNcW8BlO5Vmf4gMjhXG+Yqhj9hzmt5M4WnlLhor9lE
         frPbuu5Nm6NZNq8kmkMh2q3hO7fI7oPg9p3ErZ+K97AgRkCbEcdWcPi/eg2Rk8ouG7IM
         807clxXM/vQRz6fnFMKx2LmTlUaXPCZRwpmBauVzV1J/JZ3NgL6aLZ+p4tqK6hUAb8J6
         aaWQ==
X-Gm-Message-State: AOAM530oUAilUOgqZY+Q+6KZiMP2xcfwNRkbV7YLX4R2tdnRtLuU7dlj
        J7X4AxZkHEC9PNHXjOC1uMJfKjOikDw=
X-Google-Smtp-Source: ABdhPJztKAU1z0giHk6W1b3tsA8bHleUgBF4ckL8ljp+GbnRkxvDi4nSxamt2V/mMREviqzBehSu7w==
X-Received: by 2002:a17:902:7003:b0:143:c009:89f9 with SMTP id y3-20020a170902700300b00143c00989f9mr58280067plk.11.1638938615763;
        Tue, 07 Dec 2021 20:43:35 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u12sm1491631pfk.71.2021.12.07.20.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 20:43:35 -0800 (PST)
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
Subject: [PATCH net-next 2/2] Bonding: force user to add HWTSTAMP_FLAGS_UNSTABLE_PHC when get/set HWTSTAMP
Date:   Wed,  8 Dec 2021 12:42:24 +0800
Message-Id: <20211208044224.1950323-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211208044224.1950323-1-liuhangbin@gmail.com>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is a failover, the PHC index of bond active interface will
change. This may break the user space program if the author didn't aware.

By setting this flag, the user should aware that the PHC index get/set
by syscall is not stable. And the user space is able to deal with it.
Without this flag, the kernel will reject the request forwarding to
bonding.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 94dd016ae538 ("bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0f39ad2af81c..196fec74944b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4094,6 +4094,7 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 	struct mii_ioctl_data *mii = NULL;
 	const struct net_device_ops *ops;
 	struct net_device *real_dev;
+	struct hwtstamp_config cfg;
 	struct ifreq ifrr;
 	int res = 0;
 
@@ -4124,21 +4125,29 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 		break;
 	case SIOCSHWTSTAMP:
 	case SIOCGHWTSTAMP:
-		rcu_read_lock();
-		real_dev = bond_option_active_slave_get_rcu(bond);
-		rcu_read_unlock();
-		if (real_dev) {
-			strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
-			ifrr.ifr_ifru = ifr->ifr_ifru;
+		if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+			return -EFAULT;
+
+		if (cfg.flags & HWTSTAMP_FLAGS_UNSTABLE_PHC) {
+			rcu_read_lock();
+			real_dev = bond_option_active_slave_get_rcu(bond);
+			rcu_read_unlock();
+			if (real_dev) {
+				strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
+				ifrr.ifr_ifru = ifr->ifr_ifru;
+
+				ops = real_dev->netdev_ops;
+				if (netif_device_present(real_dev) && ops->ndo_eth_ioctl) {
+					res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 
-			ops = real_dev->netdev_ops;
-			if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
-				res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
+					if (!res)
+						ifr->ifr_ifru = ifrr.ifr_ifru;
 
-			if (!res)
-				ifr->ifr_ifru = ifrr.ifr_ifru;
+					return res;
+				}
+			}
 		}
-		break;
+		fallthrough;
 	default:
 		res = -EOPNOTSUPP;
 	}
-- 
2.31.1

