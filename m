Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD991D705C
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 07:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgERF2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 01:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERF2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 01:28:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D72C061A0C;
        Sun, 17 May 2020 22:28:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g11so3765551plp.1;
        Sun, 17 May 2020 22:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WBVBIzp2b7Pg1EPe8d8y6PumURqXzl8cvQXQg0AQNAA=;
        b=hj4YsfGYUb2YNgN2rYV/J1a6AVHr2yrndux2dSdQ3RTe+fM27+8IuY9ZsoSVS/+VDm
         LYZm3dti8aaUt085/HPWSnE3Qe44JtqkpAjH819QZUU2vwW5ptsjI0ReocF+a5vkc/kN
         GNq12gLNiOltbgqIDevqFJnXWZzOSNxGvDYlxtTgLB587i+eL9z4yDq7/If8tEx5eLrA
         tiRpCaCmlctzEo31p/c+bb++kSNtePaqJIaGVhlQgCQURE/Qpwx9QWeDIyvm011P6pyY
         uEePHDtdrlPCdbebkGvGIS0Y/wK9ZmHkUBzDBV+OWHN2jJC+YdMIeTLwiy/iXJWzPtwt
         jooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WBVBIzp2b7Pg1EPe8d8y6PumURqXzl8cvQXQg0AQNAA=;
        b=rx+kXlP3RwMbXnPrIZoAvJbFoEaoR9QXKy8Gj+A1tkky1uRXZ2r3vbmONywVypcB3A
         NAj5VNWnxLsGr49CTSpMzQti7w+3j5p4usET+6t1K2CgJEnsAW/bqUYvo2dV6dt9OfP0
         ny40GN/ijW77cjUH+iZcjqrMQGHW1K4o/gNgmM4WtCZCb8DFHhbY2DiAb+PADr4avWqI
         0V09ggLPf+eiObtpYGBbezezq3ClnmeAzTZu6P4JE5mHHmIx2on7Red7646Qn0l+Xt+U
         P6XKoPlZsEYFDB+1Xq75ZXqheS49valstDxtJ2ML5LurKNcxStIhRIO9jwMiIHck8kuP
         J8Rg==
X-Gm-Message-State: AOAM5335SoMfYy851Ecdm9n0DrWAujw/9xYXbVPwLkMzYjasIm6FNyyA
        zmQfERvBQP4EREg5tlkXP8o9rmF6LoU=
X-Google-Smtp-Source: ABdhPJxmuetqrkkLnesTvgOybSfcegJ2cC2tdvVo0nHqY6DkBKjxLhQVEr05YSe+jrZzRgNA0btnew==
X-Received: by 2002:a17:902:930c:: with SMTP id bc12mr14855642plb.255.1589779701248;
        Sun, 17 May 2020 22:28:21 -0700 (PDT)
Received: from DESKTOP-9405E5V.localdomain (h128-22-148-223.ablenetvps.ne.jp. [128.22.148.223])
        by smtp.gmail.com with ESMTPSA id d124sm7572835pfa.98.2020.05.17.22.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 22:28:20 -0700 (PDT)
From:   Huang Qijun <dknightjun@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ap420073@gmail.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        dknightjun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vlan: fix the bug that cannot create vlan4095
Date:   Mon, 18 May 2020 13:27:55 +0800
Message-Id: <20200518052755.27467-1-dknightjun@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the 8021q standard, the VLAN id range is 1 to 4095.
But in the register_vlan_device function, the range is 1 to 4094,
because ">= VLAN_VID_MASK" is used to determine whether the id
is illegal. This will prevent the creation of the vlan4095 interface:
    $ vconfig add sit0 4095
    vconfig: ioctl error for add: Numerical result out of range

To fix this error, this patch uses ">= VLAN_N_VID" instead to
determine if the id is illegal.

Signed-off-by: Huang Qijun <dknightjun@gmail.com>
---
 net/8021q/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index d4bcfd8f95bf..5de7861ddf64 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -219,7 +219,7 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 	char name[IFNAMSIZ];
 	int err;
 
-	if (vlan_id >= VLAN_VID_MASK)
+	if (vlan_id >= VLAN_N_VID)
 		return -ERANGE;
 
 	err = vlan_check_real_dev(real_dev, htons(ETH_P_8021Q), vlan_id,
-- 
2.17.1

