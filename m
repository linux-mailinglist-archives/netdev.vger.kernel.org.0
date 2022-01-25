Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5636D49AF49
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455935AbiAYJHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455317AbiAYJEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:04:07 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3CCC061347
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:24 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z7so11378735ljj.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dl66e2A4mF2Qyvn7/VEBHhQt84ZUbQKV7qGHfbulC4U=;
        b=Gsrzm15/kayF28SoC7sRkEvuny/rjuR0K2X1Z7cSFVnnayBUfiP4EzS1A2SOjEc6Hh
         C7NTMRcc88pn/KoPjs2YMzKWjRjxmLg0jXOGRjhWVct3Tl0qq1V+JEFL75IbM/JUmsAM
         tdrhqfsQXJCR4egAsQInQ8ZLP4VBZf3T+/bTepIzfgGapjSy+Jo9RjHYdxGOCkEOjvFf
         7GZXD2q/iwvTy3FaLt/ZtdI8FpA7ZZInUvR4qxCp0oTiIr2xfzOySbV8bMt607oC1SfJ
         7DsCIcTW0+tQfr3RglcbTYg/Mljf71FeLFk4M675o6azUTmUSWS9oipD0pox74oQEFRr
         JN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dl66e2A4mF2Qyvn7/VEBHhQt84ZUbQKV7qGHfbulC4U=;
        b=tk0Q4/C8tQ4BX2ZiHpnoolJakigQSlqamqCDHFXVHbdQSV13uomZCtIWiC2PSOAgw9
         xnNoiPbAhgiTe2Ck6jqgfThr2R8dBJl8zYU73kMiA6hQYINh0ASguG7gT1ru9XRIIy8r
         DhV+qOu1EuyrLyyHBShHdv/4vqqK6oX7n6yNEXg1Uds5OAtnWOyDOkmOr5xPRajmFCy2
         nmxLPhkczZh+VehLjCXQsZz2EBVBP9itU0KyFVMvtIOGLFvI1kLWviu9r7SiaiOcVBSp
         gGaQGKrrCWteAW31jJ5X0BgyWa33Owo3yv5OuWiOIBdn4Wxx/lfcuctHQngMBMwFWAgn
         gxGA==
X-Gm-Message-State: AOAM530vZUlGtOk+qyUDL4PVuI06Yd0occ/qpuY2+GdRYuxR8XG4d4Oc
        aGjjWRVB00aGsLUpI8sbE5NuxQ==
X-Google-Smtp-Source: ABdhPJzCfueNt7EGxpjgAvt/Euq5JGSCE+aooEIdd/EgvAx3MMRVq/2nZFYCCNX0MnqsmbFtQII1ig==
X-Received: by 2002:a05:651c:210c:: with SMTP id a12mr14427072ljq.285.1643100442603;
        Tue, 25 Jan 2022 00:47:22 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id q5sm1418944lfe.279.2022.01.25.00.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:47:22 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
Subject: [RFC PATCH 2/5] driver/net/tun: Added features for USO.
Date:   Tue, 25 Jan 2022 10:46:59 +0200
Message-Id: <20220125084702.3636253-3-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125084702.3636253-1-andrew@daynix.com>
References: <20220125084702.3636253-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for USO4 and USO6, also added code for new ioctl TUNGETSUPPORTEDOFFLOADS.
For now, to "enable" USO, it's required to set both USO4 and USO6 simultaneously.
USO enables NETIF_F_GSO_UDP_L4.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/tap.c | 18 ++++++++++++++++--
 drivers/net/tun.c | 15 ++++++++++++++-
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..82d742ba78b1 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -940,6 +940,10 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 			if (arg & TUN_F_TSO6)
 				feature_mask |= NETIF_F_TSO6;
 		}
+
+		/* TODO: for now USO4 and USO6 should work simultaneously */
+		if (arg & (TUN_F_USO4 | TUN_F_USO6) == (TUN_F_USO4 | TUN_F_USO6))
+			features |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -950,7 +954,8 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
+	    feature_mask & (TUN_F_USO4 | TUN_F_USO6) == (TUN_F_USO4 | TUN_F_USO6))
 		features |= RX_OFFLOADS;
 	else
 		features &= ~RX_OFFLOADS;
@@ -979,6 +984,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	unsigned short u;
 	int __user *sp = argp;
 	struct sockaddr sa;
+	unsigned int supported_offloads;
 	int s;
 	int ret;
 
@@ -1074,7 +1080,8 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	case TUNSETOFFLOAD:
 		/* let the user check for future flags */
 		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
-			    TUN_F_TSO_ECN | TUN_F_UFO))
+			    TUN_F_TSO_ECN | TUN_F_UFO |
+			    TUN_F_USO4 | TUN_F_USO6))
 			return -EINVAL;
 
 		rtnl_lock();
@@ -1082,6 +1089,13 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 		rtnl_unlock();
 		return ret;
 
+	case TUNGETSUPPORTEDOFFLOADS:
+		supported_offloads = TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
+						TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_USO4 | TUN_F_USO6;
+		if (copy_to_user(&arg, &supported_offloads, sizeof(supported_offloads)))
+			return -EFAULT;
+		return 0;
+
 	case SIOCGIFHWADDR:
 		rtnl_lock();
 		tap = tap_get_tap_dev(q);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..4f2105d1e6f1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -185,7 +185,7 @@ struct tun_struct {
 	struct net_device	*dev;
 	netdev_features_t	set_features;
 #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
-			  NETIF_F_TSO6)
+			  NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4)
 
 	int			align;
 	int			vnet_hdr_sz;
@@ -2821,6 +2821,12 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 		}
 
 		arg &= ~TUN_F_UFO;
+
+		/* TODO: for now USO4 and USO6 should work simultaneously */
+		if (arg & TUN_F_USO4 && arg & TUN_F_USO6) {
+			features |= NETIF_F_GSO_UDP_L4;
+			arg &= ~(TUN_F_USO4 | TUN_F_USO6);
+		}
 	}
 
 	/* This gives the user a way to test for new features in future by
@@ -2991,6 +2997,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	int sndbuf;
 	int vnet_hdr_sz;
 	int le;
+	unsigned int supported_offloads;
 	int ret;
 	bool do_notify = false;
 
@@ -3154,6 +3161,12 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	case TUNSETOFFLOAD:
 		ret = set_offload(tun, arg);
 		break;
+	case TUNGETSUPPORTEDOFFLOADS:
+		supported_offloads = TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
+				TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_USO4 | TUN_F_USO6;
+		if (copy_to_user(&arg, &supported_offloads, sizeof(supported_offloads)))
+			ret = -EFAULT;
+		break;
 
 	case TUNSETTXFILTER:
 		/* Can be set only for TAPs */
-- 
2.34.1

