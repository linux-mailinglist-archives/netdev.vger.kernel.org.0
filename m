Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B8C462D4E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbhK3HNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbhK3HNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:13:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A95C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:09:47 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id g18so19669264pfk.5
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTJ8euAmz1y4tT9vlyLs629A2hrTumt6sjmZ397/sBU=;
        b=KQgkmCnS2XTa2yDgS+gODmbk/3dYMEO+B7ueTe2jTGhj7+7xoYkimnbNH2RnMQackL
         V2sQn4gEUOoxcI2FccgpSJS3JtN/j8jguwlpgskV1ZqlMMdqDnskHpsh6636h7tz/k5w
         rIx8zNxNXRNFFTeHsaUG045WgU4ncs7gYUrC7uoJS/OQDBtBbpUPoZ+34jiFOGb9nZdG
         zAe4xhO+rhp9bTEIv094s2dLTQMkuDVqdQSPbA5llt8l8paDU5025z8a78t8xFPGdbfk
         NpaV7hEmKJkTjKIF6IJYBgBcpy51SGpEfOtEaoZKLN+i/y+etH8tjyto67nIm7UAIVZ1
         SWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTJ8euAmz1y4tT9vlyLs629A2hrTumt6sjmZ397/sBU=;
        b=LUlTgBm0XT5kifTcIB6USbYp9vjmHS5vDxeZQxFalwgFPgI3vVGeCmr4ZuxEsa/5RD
         QFX/gmkjT9Rt3ONa6O/29kZcsbda93WPX8Dj51n3FtgSsl+kLV35PgPZDvUtG6S4M1Ti
         pkM59yUM9xH+HG0lvhDEah3qZkZKEyT+/nDoC2IFMXfuSBaJXu3KM+Cj76FzsOFCcMU3
         GcJbdQMcfdRslSFRW/19SHE31rmrb9Ia0hj2b6xPBEIZ8yGGdvicOEtrX/UW/1Axj7E/
         7DMA5VzHmXJWx5vwghVzawA63TddDPW9l44vifkGYiwInLRjMxnEOgL5ef1P3M9I2PBa
         5qcA==
X-Gm-Message-State: AOAM533NoJ0YnJrmbJCXQjDC6OjSnpK5OEhk17yWYu/Ty2g87WxsA+nU
        ns6J9Il9hfRmuj910dhP9uKkha96rPo=
X-Google-Smtp-Source: ABdhPJzQEIx7vxRPGwWgjSbrMoW8GOY05ZOUV6g1d0MpXAtH0vqBkGpec1HABhKxSxTW5f7WBzRWZw==
X-Received: by 2002:a05:6a00:a23:b0:4a4:e9f5:d890 with SMTP id p35-20020a056a000a2300b004a4e9f5d890mr44709246pfh.82.1638256186823;
        Mon, 29 Nov 2021 23:09:46 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e14sm21651360pfv.18.2021.11.29.23.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:09:46 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
Date:   Tue, 30 Nov 2021 15:09:32 +0800
Message-Id: <20211130070932.1634476-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have VLAN PTP support(via get_ts_info) on kernel, and bond support(by
getting active interface via netlink message) on userspace tool linuxptp.
But there are always some users who want to use PTP with VLAN over bond,
which is not able to do with the current implementation.

This patch passed get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
with bond mode active-backup/tlb/alb. With this users could get kernel native
bond or VLAN over bond PTP support.

Test with ptp4l and it works with VLAN over bond after this patch:
]# ptp4l -m -i bond0.23
ptp4l[53377.141]: selected /dev/ptp4 as PTP clock
ptp4l[53377.142]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[53384.127]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
ptp4l[53384.127]: selected local clock e41d2d.fffe.123db0 as best master
ptp4l[53384.127]: port 1: assuming the grand master role

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 55 +++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cf73eacdda91..1fc7249abf6d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -71,6 +71,7 @@
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/if_bonding.h>
+#include <linux/phy.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
 #include <net/route.h>
@@ -4091,7 +4092,10 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct mii_ioctl_data *mii = NULL;
-	int res;
+	const struct net_device_ops *ops;
+	struct net_device *real_dev;
+	struct ifreq ifrr;
+	int res = 0;
 
 	netdev_dbg(bond_dev, "bond_eth_ioctl: cmd=%d\n", cmd);
 
@@ -4117,7 +4121,24 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 				mii->val_out = BMSR_LSTATUS;
 		}
 
-		return 0;
+		break;
+	case SIOCSHWTSTAMP:
+	case SIOCGHWTSTAMP:
+		rcu_read_lock();
+		real_dev = bond_option_active_slave_get_rcu(bond);
+		rcu_read_unlock();
+		if (real_dev) {
+			strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
+			ifrr.ifr_ifru = ifr->ifr_ifru;
+
+			ops = real_dev->netdev_ops;
+			if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
+				res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
+
+			if (!res)
+				ifr->ifr_ifru = ifrr.ifr_ifru;
+		}
+		break;
 	default:
 		res = -EOPNOTSUPP;
 	}
@@ -5319,10 +5340,40 @@ static void bond_ethtool_get_drvinfo(struct net_device *bond_dev,
 		 BOND_ABI_VERSION);
 }
 
+static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
+				    struct ethtool_ts_info *info)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	const struct ethtool_ops *ops;
+	struct net_device *real_dev;
+	struct phy_device *phydev;
+
+	rcu_read_lock();
+	real_dev = bond_option_active_slave_get_rcu(bond);
+	rcu_read_unlock();
+	if (real_dev) {
+		ops = real_dev->ethtool_ops;
+		phydev = real_dev->phydev;
+
+		if (phy_has_tsinfo(phydev)) {
+			return phy_ts_info(phydev, info);
+		} else if (ops->get_ts_info) {
+			return ops->get_ts_info(real_dev, info);
+		}
+	}
+
+	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
+	info->phc_index = -1;
+
+	return 0;
+}
+
 static const struct ethtool_ops bond_ethtool_ops = {
 	.get_drvinfo		= bond_ethtool_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= bond_ethtool_get_link_ksettings,
+	.get_ts_info		= bond_ethtool_get_ts_info,
 };
 
 static const struct net_device_ops bond_netdev_ops = {
-- 
2.31.1

