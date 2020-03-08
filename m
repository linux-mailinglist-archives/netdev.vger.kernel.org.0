Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E4917D3F3
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 14:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCHNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 09:47:33 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36880 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCHNrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 09:47:33 -0400
Received: by mail-pj1-f66.google.com with SMTP id ca13so1019276pjb.2
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 06:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cNVD2N0obEwSlOAC8sFMMehN28ZU8w7EF74gN92j0Ig=;
        b=MV8bCU+0782yvkstkKB2NdP0T6w2laiK85Jzy9ZudSAdFcCx4NCVA7RO1sCVnRg7v+
         COHhyf0UGP0MsmzYzqDj9HKilcZCbw/6RVr1f1jCNE4Yn1iJSc3GNQx30Vni9DRySn6s
         6Bj4YjgFHRc5Z6iGRLwdU3s/+TW7lr3SM9Mxn5DzzL3byPvrPxZUX0GHbs5KobrDjy7J
         pwzVIQRyLVNRMKD1H/DggX0xpivKbZe28ZJMQT9d60lAQWlgYz8eG/CjpglZdsIA9w1C
         mbOxDae14RiVZxaeob/Fs8mKvA8HS/6dSRElDsd/F1AIvOqiK9GRKvHmmz6o99f5e9ss
         0AzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cNVD2N0obEwSlOAC8sFMMehN28ZU8w7EF74gN92j0Ig=;
        b=gIKOSYRRMJ6I8JtY35CSU9uzNCCCG0bpDjhQBlmAToRsyoiAiQXIgCnvmI0z8N5bti
         GladDUfeKx67+deSp92mI6oUM0gALd3j+jGWfQGZ2bvm829y+8wfRIr6UwE6ZUdo34gk
         4ZhHuiiOcmm3t2/KFpKjOWFswoMxkVYFga+BoJYkTWSUCfxAS/H+hvxNVTUg0044Z4cX
         OnJokMBMrY39C4zhe7gDhf36Dc7eQFVU0VYNc0TESegoN0WqHUGP/8RjN3p23qis4A2K
         goZJhiZwKXKMEzG4Fw3eIc63SsPL4vvpmDPkguSi2ab64n4gTfjWnvHugEhJj4Xpb5RR
         t7Uw==
X-Gm-Message-State: ANhLgQ02ouTEXDgYzz8Y1SDI9o8B0oAqFtUK0zHW4dJDvfdlNy4vPks4
        jjN+WBjSk5g+nWzIjygy85g=
X-Google-Smtp-Source: ADFU+vtWe70P/1VGzrN1LHkMGtd4Vj2g+kmYREjAWdXFcVOPPWLpHGSpE63fKI6Uv3GbgOHpJ9GVMg==
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr14341354pjq.143.1583675251316;
        Sun, 08 Mar 2020 06:47:31 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id md20sm1661910pjb.15.2020.03.08.06.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 06:47:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: rmnet: set NETIF_F_LLTX flag
Date:   Sun,  8 Mar 2020 13:47:06 +0000
Message-Id: <20200308134706.18727-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rmnet_vnd_setup(), which is the callback of ->ndo_start_xmit() is
allowed to call concurrently because it uses RCU protected data.
So, it doesn't need tx lock.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d7c52e398e4a..d58b51d277f1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -212,6 +212,8 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->needs_free_netdev = true;
 	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
 
+	rmnet_dev->features |= NETIF_F_LLTX;
+
 	/* This perm addr will be used as interface identifier by IPv6 */
 	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
 	eth_random_addr(rmnet_dev->perm_addr);
-- 
2.17.1

