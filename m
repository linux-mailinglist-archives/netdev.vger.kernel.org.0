Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319E6619F50
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiKDRzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKDRy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:54:56 -0400
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A8E31F8A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:54:55 -0700 (PDT)
Received: from pps.filterd (m0286614.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A4HstfW000928
        for <netdev@vger.kernel.org>; Fri, 4 Nov 2022 10:54:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=ppemail; bh=cDmOKcPj6U9lA8G0PnzuOvCtXbcRU92OPOA8AkWynSI=;
 b=Gat4UQDpGwydop6PK7/brzsRD2WehWrJKEl0y41BiXpNoeBvO9dp1q/jJRLgsu6e0feE
 dDXGyaDFtOHj+8Ch+qIdbPtrNguNqGcltdk1ecYw35h2t4mBXquPeEPIwTA5QVUZbnBY
 Lz8TCjwHGEtFBZmgzmmFnbaDqEEUdlNRgjMu6PMpmkoQAoRW0twBIRhmipdEBsJVBQGL
 55S82fW+Q38IxMXhUjALuSjZQNVSZVXhMMjdrjZFeY0zCQlAqrtJsC2/4d9QmBiLBnj2
 4ndVDpid6zxAmPfM7esT9WwFW5fWwmdJj0v0nYzFraVZKlbuz8wv1P4GOy5n4ImoW5Gn 4A== 
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kmpksr6pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:54:55 -0700
Received: by mail-pl1-f199.google.com with SMTP id b18-20020a170903229200b00186e357f3b9so4027162plh.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cDmOKcPj6U9lA8G0PnzuOvCtXbcRU92OPOA8AkWynSI=;
        b=aMrx2+Kv3RQHcHzAANGS8zruVPElv/uWZS1795Tjhfbf5I5gJoVvANwq5pctH357Hp
         OOuK3aXcauKygH3nxcodM8LPjxgidcpu6TJjC11N3N+SJpABWVYxNjl8VtBWrb0PFwPf
         bK7SdoUQvMye1xI8fjcG2SbZd1qPSOj6wPz2cXtCdM/7ixZboGh+qoVT+C6Mwozr+w5I
         5TBvjhbKVBQGMmtHi2F6FItzAIeqM1WLjM7RGlGDZ3jxwURO7AIStTLrhaIN872nyaA1
         KWil/PapPTKvFjQjZlyyzoLkkX5r1j4BkMA+71THtTzQ50JsjERHEt2ZlM2p6tu7cLoP
         X7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cDmOKcPj6U9lA8G0PnzuOvCtXbcRU92OPOA8AkWynSI=;
        b=k4Gn09cOmHkUkFWp2X6k4RaPf2rhyNPbkN7t9J22XRPEb/4gxO/q+0gpViyMVGsQhZ
         8h+UD2Y4IObgQjP19NjDh7UIACYMS8x3/5s8Pbmz23g3nDfQb3BrKdpFEQR6/UQdosI3
         FNtUufLOJhL/zocOraVnS8amUsFepkeCNZ1cUu1J7Td2TjLfzTPa1aDSPLp+hzdU+mo0
         vtxKMfKEtIzOTtZB4WRVUJ8VcMOn4lWBIyIW8orhnXdq4E8ms3PTn3KT00wuFFE/lrXO
         LcCEUbLXM9Y/8ZwvMdRfiy8S8WnKE+0zVrc5cSkXSV5jjsRGPf+Av9Q/HKKHlDqwdM4x
         XO1A==
X-Gm-Message-State: ACrzQf0UTLYm4dr9zKyvjkfKmbuyT/9tPm0x6um/fLYJbEodlqmaqQ3j
        /3G1nly9b+5PvbCuOLZcCFcfJ2StTMlpvzGph7pJgpbCiWDgyAxhH8bSKLoJ+YqQfYktG6pr0hb
        F2i+KiDOyLwbwW7g=
X-Received: by 2002:a17:902:c2c4:b0:187:640:205c with SMTP id c4-20020a170902c2c400b001870640205cmr35182662pla.11.1667584487295;
        Fri, 04 Nov 2022 10:54:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7cea80X9+ppRTJHno74AreljRO/eYUblEOqETO59QjxbcVjz7DwzH0eTwrDORwq5sx8i2lYA==
X-Received: by 2002:a17:902:c2c4:b0:187:640:205c with SMTP id c4-20020a170902c2c400b001870640205cmr35182630pla.11.1667584486950;
        Fri, 04 Nov 2022 10:54:46 -0700 (PDT)
Received: from 4VPLMR2-DT.corp.robot.car ([199.73.125.241])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78e89000000b005633a06ad67sm3011913pfr.64.2022.11.04.10.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:54:46 -0700 (PDT)
From:   Andy Ren <andy.ren@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, dsahern@gmail.com,
        sthemmin@microsoft.com, idosch@idosch.org,
        sridhar.samudrala@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev,
        Andy Ren <andy.ren@getcruise.com>
Subject: [PATCH net-next v2] net/core: Allow live renaming when an interface is up
Date:   Fri,  4 Nov 2022 10:54:34 -0700
Message-Id: <20221104175434.458177-1-andy.ren@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Qb3Tm-Y0A2HZmM8qI5qXXU0FPafmDFHD
X-Proofpoint-ORIG-GUID: Qb3Tm-Y0A2HZmM8qI5qXXU0FPafmDFHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_11,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=817 spamscore=0
 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should allow a network interface to be renamed when the interface
is up.

Live renaming was added as a failover in the past, and there has been no
arising issues of the user space breaking. Furthermore, it seems that this
flag was added because in the past, IOCTL was used for renaming, which
would not notify the user space. Nowadays, it appears that the user
space receives notifications regardless of the state of the network
device (e.g. rtnetlink_event()). The listeners for NETDEV_CHANGENAME
also do not strictly ensure that the netdev is up or not.

Hence, we should remove the live renaming flag and checks due
to the aforementioned reasons.

The changes are as the following:
- Remove IFF_LIVE_RENAME_OK flag declarations
- Remove check in dev_change_name that checks whether device is up and
if IFF_LIVE_RENAME_OK is set by the network device's priv_flags
- Remove references of IFF_LIVE_RENAME_OK in the failover module

Changes from v1->v2
- Added placeholder comment in place of removed IFF_LIVE_RENAME_OK flag
- Added extra logging hints to indicate whether a network interface was
renamed while UP

Signed-off-by: Andy Ren <andy.ren@getcruise.com>
---
 include/linux/netdevice.h |  4 +---
 net/core/dev.c            | 19 ++-----------------
 net/core/failover.c       |  6 +++---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d45713a06568..4be87b89e481 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1650,7 +1650,6 @@ struct net_device_ops {
  * @IFF_FAILOVER: device is a failover master device
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
- * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
  * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
  *	skb_headlen(skb) == 0 (data starts from frag0)
  * @IFF_CHANGE_PROTO_DOWN: device supports setting carrier via IFLA_PROTO_DOWN
@@ -1686,7 +1685,7 @@ enum netdev_priv_flags {
 	IFF_FAILOVER			= 1<<27,
 	IFF_FAILOVER_SLAVE		= 1<<28,
 	IFF_L3MDEV_RX_HANDLER		= 1<<29,
-	IFF_LIVE_RENAME_OK		= 1<<30,
+	/* was IFF_LIVE_RENAME_OK */
 	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
 	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
 };
@@ -1721,7 +1720,6 @@ enum netdev_priv_flags {
 #define IFF_FAILOVER			IFF_FAILOVER
 #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
-#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
 #define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
 
 /* Specifies the type of the struct net_device::ml_priv pointer */
diff --git a/net/core/dev.c b/net/core/dev.c
index 3bacee3bee78..707de6b841d0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1163,22 +1163,6 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	net = dev_net(dev);
 
-	/* Some auto-enslaved devices e.g. failover slaves are
-	 * special, as userspace might rename the device after
-	 * the interface had been brought up and running since
-	 * the point kernel initiated auto-enslavement. Allow
-	 * live name change even when these slave devices are
-	 * up and running.
-	 *
-	 * Typically, users of these auto-enslaving devices
-	 * don't actually care about slave name change, as
-	 * they are supposed to operate on master interface
-	 * directly.
-	 */
-	if (dev->flags & IFF_UP &&
-	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
-		return -EBUSY;
-
 	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
@@ -1195,7 +1179,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	}
 
 	if (oldname[0] && !strchr(oldname, '%'))
-		netdev_info(dev, "renamed from %s\n", oldname);
+		netdev_info(dev, "renamed from %s%s\n", oldname,
+			    dev->flags & IFF_UP ? " (while UP)" : "");
 
 	old_assign_type = dev->name_assign_type;
 	dev->name_assign_type = NET_NAME_RENAMED;
diff --git a/net/core/failover.c b/net/core/failover.c
index 864d2d83eff4..655411c4ca51 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -80,14 +80,14 @@ static int failover_slave_register(struct net_device *slave_dev)
 		goto err_upper_link;
 	}
 
-	slave_dev->priv_flags |= (IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags |= IFF_FAILOVER_SLAVE;
 
 	if (fops && fops->slave_register &&
 	    !fops->slave_register(slave_dev, failover_dev))
 		return NOTIFY_OK;
 
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
 err_upper_link:
 	netdev_rx_handler_unregister(slave_dev);
 done:
@@ -121,7 +121,7 @@ int failover_slave_unregister(struct net_device *slave_dev)
 
 	netdev_rx_handler_unregister(slave_dev);
 	netdev_upper_dev_unlink(slave_dev, failover_dev);
-	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
+	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
 
 	if (fops && fops->slave_unregister &&
 	    !fops->slave_unregister(slave_dev, failover_dev))
-- 
2.38.1

