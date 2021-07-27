Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280BB3D7747
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhG0NrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237118AbhG0Nqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FCDB61AD0;
        Tue, 27 Jul 2021 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393596;
        bh=cxtr45B6h+sQitZaG1aZlG8BuBgayEPGxhUUerg6o1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJIB50sU70CABNVqSgYD6YhDctHuiAYqiF3H4n/B3p5CHO8/eUIGKnyBUk40+3sbG
         +05ZWi8YLJsJXIqlxM46niDWS+lqiTTu4j99ovB3Ex9PQbiebqvXFKlhrMwt2OW6Ov
         gqf2Ra6LpkYpEMZq+N0Dul714O2JTgH/Yx5OuvcGq86L4R+I+pRAU2BVjXknM7bS+t
         CuP6zTIkURdJ26i4FkFd7lU3JYZUNnDw0lhXwAfNc3WiHCRWgiQmyjRSjxmHs/HH46
         RZcAFUvQ+y48iW7CwUN011Qx7ZCN7JOpkCHuVNF4oid7CPtD7ugr9gTri0hHUxIq83
         4GvLbzmZ9CMtQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jes Sorensen <jes@trained-monkey.org>, linux-hippi@sunsite.dk
Subject: [PATCH net-next v3 21/31] hippi: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:07 +0200
Message-Id: <20210727134517.1384504-22-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The rr_ioctl uses private ioctl commands that correctly pass
all data through ifr_data, which works fine in compat mode.

Change it to use ndo_siocdevprivate as a cleanup.

Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-hippi@sunsite.dk
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hippi/rrunner.c | 11 ++++++-----
 drivers/net/hippi/rrunner.h |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 22010384c4a3..7661dbb31162 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -63,7 +63,7 @@ static const char version[] =
 static const struct net_device_ops rr_netdev_ops = {
 	.ndo_open 		= rr_open,
 	.ndo_stop		= rr_close,
-	.ndo_do_ioctl		= rr_ioctl,
+	.ndo_siocdevprivate	= rr_siocdevprivate,
 	.ndo_start_xmit		= rr_start_xmit,
 	.ndo_set_mac_address	= hippi_mac_addr,
 };
@@ -1568,7 +1568,8 @@ static int rr_load_firmware(struct net_device *dev)
 }
 
 
-static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int rr_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			     void __user *data, int cmd)
 {
 	struct rr_private *rrpriv;
 	unsigned char *image, *oldimage;
@@ -1603,7 +1604,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			error = -EFAULT;
 			goto gf_out;
 		}
-		error = copy_to_user(rq->ifr_data, image, EEPROM_BYTES);
+		error = copy_to_user(data, image, EEPROM_BYTES);
 		if (error)
 			error = -EFAULT;
 	gf_out:
@@ -1615,7 +1616,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			return -EPERM;
 		}
 
-		image = memdup_user(rq->ifr_data, EEPROM_BYTES);
+		image = memdup_user(data, EEPROM_BYTES);
 		if (IS_ERR(image))
 			return PTR_ERR(image);
 
@@ -1658,7 +1659,7 @@ static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		return error;
 
 	case SIOCRRID:
-		return put_user(0x52523032, (int __user *)rq->ifr_data);
+		return put_user(0x52523032, (int __user *)data);
 	default:
 		return error;
 	}
diff --git a/drivers/net/hippi/rrunner.h b/drivers/net/hippi/rrunner.h
index 87533784604f..55377614e752 100644
--- a/drivers/net/hippi/rrunner.h
+++ b/drivers/net/hippi/rrunner.h
@@ -835,7 +835,8 @@ static int rr_open(struct net_device *dev);
 static netdev_tx_t rr_start_xmit(struct sk_buff *skb,
 				 struct net_device *dev);
 static int rr_close(struct net_device *dev);
-static int rr_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int rr_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			     void __user *data, int cmd);
 static unsigned int rr_read_eeprom(struct rr_private *rrpriv,
 				   unsigned long offset,
 				   unsigned char *buf,
-- 
2.29.2

