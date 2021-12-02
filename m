Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5743C465CA9
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355184AbhLBDZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355178AbhLBDZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:45 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AECC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:19 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s37so15975531pga.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qij13/EDGcPoDif2lcrCVzSIcywYR2YPGYnVdiAWmgA=;
        b=CYF8LDLykIVHm4LmTf9aZ8S69jprDNkKGB8uasOEKut2MrPsdjL8luWmintH4k6N4C
         3vmNQsKSrQPnAHmNQFdwu+qG35+FzypGNlcq9tfS20716GgE3dcTAYG6r5eXWznOsMFz
         UxSbXf0axEuyfWkmsJWYJZL39hx+ZPIrKgOGlM1uii1w1+6AtAa84BhOcgtjeU/SAGgE
         Bb+DutoibTahdLNVx/Dud4ZCQk+4bnoS/TZrz+mf0EGUZ17QjXdCwkCM3kq46lxKXeN1
         iJDTKFNkroJDnblroWgyeNoJibL07vh2PkUSHRAsOnB+U/OECYmBTCRQUfXu6PfIp+KM
         apmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qij13/EDGcPoDif2lcrCVzSIcywYR2YPGYnVdiAWmgA=;
        b=WeoB3A0dSTQHGm1z+RXqfgn20mej2YeX0xaKO5+S4y2IFRswODpVSN9ylKjgXCZ0fZ
         jSJ9VZd9aO/ccDdp8QjQU+hGO4DDc5op0welzJI2KqqicsZBhbzyysSkVBj9/dY29VAd
         yXk87znmmfCx0gpgABQv0aV+lOtVCtqaE1HojvH4JoaqN28Pb/NQYxkyIW3nD4SOEhGn
         rKgcnkdEHc+jU7Hg2ffZAd6hfdLbhVS6ebjw+6+ryTIGD0FOz4brf5NJSDmPQr+kL56Q
         O+utqP0Lzpg2FADMIHvzdIbwTvXGHDBJs4gkdShX4XnNNNM3WR5JqF15fMduajF1zIPa
         hfyw==
X-Gm-Message-State: AOAM530lDRBDG3XonQR7Mpau4HQJvPgYLa8MXtnWBfV/Wx4MNp1Hs2SR
        zfmWiKy/ZI+aw13Oa0DP3NM=
X-Google-Smtp-Source: ABdhPJzqG6orxJGGbvefjjxllddIm9fxm3xc9tieZcmApNECJRPIg8vvYnrSLbbl2GMlSFKGalvg+A==
X-Received: by 2002:a62:15d0:0:b0:4a0:2dd5:ee4e with SMTP id 199-20020a6215d0000000b004a02dd5ee4emr10488587pfv.14.1638415339117;
        Wed, 01 Dec 2021 19:22:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/19] net: add net device refcount tracker to ethtool_phys_id()
Date:   Wed,  1 Dec 2021 19:21:26 -0800
Message-Id: <20211202032139.3156411-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helper might hold a netdev reference for a long time,
lets add reference tracking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ethtool/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index fa8aa5ec19ba1cfff611a159c5b8bcd02f74c5ca..9a113d89352123acf56ec598c191bb75985c6be5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1989,6 +1989,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	struct ethtool_value id;
 	static bool busy;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	netdevice_tracker dev_tracker;
 	int rc;
 
 	if (!ops->set_phys_id)
@@ -2008,7 +2009,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	 * removal of the device.
 	 */
 	busy = true;
-	dev_hold(dev);
+	dev_hold_track(dev, &dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 
 	if (rc == 0) {
@@ -2032,7 +2033,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	}
 
 	rtnl_lock();
-	dev_put(dev);
+	dev_put_track(dev, &dev_tracker);
 	busy = false;
 
 	(void) ops->set_phys_id(dev, ETHTOOL_ID_INACTIVE);
-- 
2.34.0.rc2.393.gf8c9666880-goog

