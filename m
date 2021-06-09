Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025403A0A14
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhFICge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhFICgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 22:36:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B752C061574;
        Tue,  8 Jun 2021 19:34:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h16so487836pjv.2;
        Tue, 08 Jun 2021 19:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=cUOirqNA+Jrq6bmd/rqs4xfQ5uYMyR0S/qTKzd8aK20=;
        b=GKtCJte0YIlQdpdHbTuG9Z2A3RgP1JkKNS4RX61jZGFAH6CCjQLOL+oIIEIBpH4DxZ
         D018h8p8GDFi+GSIFXa56UVqrKCHLg1CppytVe47x+ZLVhh5bQYRz1BfPBWqoek1Uf2t
         aE8k0rwItfYoVZSOaO/qk829YOHenQEpvjH8gGuqQ9aBFozW9Lp9VIhgn/mfGSPBWRDe
         X5LzlhUolWpSe5rDiWfC8/TZvxXuPREglA9LHauAN2MfOZrFa/i089eTwz4XLh5a6e+B
         xGNygV5sIiiMcUi7aQ5IoDNdyk24DBu0bSkgyCvEl1L1JuWQtUSHEabxmC7/cisecJP+
         yt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cUOirqNA+Jrq6bmd/rqs4xfQ5uYMyR0S/qTKzd8aK20=;
        b=YAc4Y/DofLPCW8tOmhPznYTOOEGdZy/5jH6hLVHHuKCJYotw+ka2unLYxrTFFOhcSq
         tBOqojXLFLPeitdbGLCuLKHrw9X9MZKPXT/5ARzQYZzFKTZfrc+19dcnGejYPNENcDIV
         f0taNbnEZfp/bBAp0DKw0PKOFkhypoWn60H1PcwAh5/AYWmad4iMoSxIfluEaYMq2z07
         wMZw4CvlRQZj2eg9cNG3dx9kgNw7bVAP0eKimZUEH0bnmeO4fg272kYxfxyajUBCBQx6
         RVlLXkCikGVDtEru8azXubmic9RqMSWLjf1AKdtizacBrfY2PVfxPql/bC5H7fkyjO4P
         wjGw==
X-Gm-Message-State: AOAM530pLX6r2hpIh5rCXILizbxt0UCia13SyuJNApIANPIf5wa2uVzG
        ASaaiAGU1uqAq9sdby+0ocI=
X-Google-Smtp-Source: ABdhPJyioCWPvHjA4n8/ff48v5qwBh9YBX035SZFg7jQ3DFfK07mWqXZ/UUgIx+JkvV5suow3aP0rQ==
X-Received: by 2002:a17:90b:3ecb:: with SMTP id rm11mr29001510pjb.95.1623206070595;
        Tue, 08 Jun 2021 19:34:30 -0700 (PDT)
Received: from raspberrypi ([125.141.84.155])
        by smtp.gmail.com with ESMTPSA id p36sm12542193pgm.74.2021.06.08.19.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:34:30 -0700 (PDT)
Date:   Wed, 9 Jun 2021 03:34:25 +0100
From:   Austin Kim <austindh.kim@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        andrew@lunn.ch, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        austin.kim@lge.com, austindh.kim@gmail.com
Subject: [PATCH] net: ethtool: clear heap allocations for ethtool function
Message-ID: <20210609023425.GA2024@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several ethtool functions leave heap uncleared (potentially) by
drivers. This will leave the unused portion of heap unchanged and
might copy the full contents back to userspace.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 net/ethtool/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3fa7a394eabf..baa5d10043cb 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1421,7 +1421,7 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 	if (eeprom.offset + eeprom.len > total_len)
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1486,7 +1486,7 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	if (eeprom.offset + eeprom.len > ops->get_eeprom_len(dev))
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1765,7 +1765,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 		return -EFAULT;
 
 	test.len = test_len;
-	data = kmalloc_array(test_len, sizeof(u64), GFP_USER);
+	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -2293,7 +2293,7 @@ static int ethtool_get_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	ret = ops->get_tunable(dev, &tuna, data);
@@ -2485,7 +2485,7 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_phy_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	if (phy_drv_tunable) {
-- 
2.20.1

