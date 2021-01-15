Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B842F75CC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbhAOJsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbhAOJsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:48:36 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73996C061794;
        Fri, 15 Jan 2021 01:48:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j13so4889337pjz.3;
        Fri, 15 Jan 2021 01:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=H00cl0DwIpRYCoMPIXu8DVIsewbITBDDpGhtqr9YNek=;
        b=XO/zfGZEJr9k+VTdbdqArp6UW0x4XwRZOzNdUzmnzYut+JOqdUTRQd/P1PUzSC0MjQ
         87Anc8RXHLixRPIF4kBT+6IRQwmN4gZ3Rnn/jTlDrVACTzviUx2f/idKp77QQyS4/krq
         uE87jsmdW862tpBiZLnv19AucYqaANgOAYnfwFklBSDJSCPZXHDhjuDU6evw9PgGh9su
         mKehb5aIqzSViTYoZnt/WfwKYFSldabQk29QqU+JQZ7J6wSli29HVeuQfjpyqaGdZbpV
         ex6UdrLz2o5BgxrYquwq19DrY8JDq9/aLv+qt74tZVZ+cUz+Cu5dEbQq64Hxdxrw4/7e
         knxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=H00cl0DwIpRYCoMPIXu8DVIsewbITBDDpGhtqr9YNek=;
        b=dlcgeSkZPDYE0WoClHA1owfVCnyhjpHKRPD+MTEuxhLNpSJhvKxR3fdy3zuy/gny7C
         2FYQXvawRPQvONqXdVtnz1pjFTvu4PMNpR8KzMT7bF+xpuiG3zDk9qvmP2btQeIX7nY0
         d9LLiR858Zwj5pqkeKpqBdExhRC599kDlI32Bc1tp+v+6hWXJQV9I+W9QIOCinuZSiWS
         OjxUmnfX7WjqfmZm6V2b9Un58eo0u9TlACSOmeJX756t+cE+1HRg46qVcmarv9Jiyxt8
         Gj54+jmpdLRH5eTu4tGDgFH565lWyCyUn0wOB2jE3FgklPlKjn+8ifD83/7TrehQI+Cd
         DbIg==
X-Gm-Message-State: AOAM531DVjIKHehTENlNiQdpr2y5Ftosub7JqECaUo5PGQrspEsb4W5R
        pan1bSsxpELFF9G3+dQOgWzgVD8UjvrVeQ==
X-Google-Smtp-Source: ABdhPJxyVKj6xHUESk8pS1eQwZ2HvhWM5+ABENP4P3ahved2z+7fqmu6E5sgVlGNum9KAEfhL8sq8A==
X-Received: by 2002:a17:90a:4096:: with SMTP id l22mr9516324pjg.114.1610704084854;
        Fri, 15 Jan 2021 01:48:04 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w90sm7561241pjw.10.2021.01.15.01.48.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:48:04 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 1/3] vxlan: add NETIF_F_FRAGLIST flag for dev features
Date:   Fri, 15 Jan 2021 17:47:45 +0800
Message-Id: <25be5f99a282231f29ba984596dbb462e8196171.1610704037.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some protocol HW GSO requires fraglist supported by the device, like
SCTP. Without NETIF_F_FRAGLIST set in the dev features of vxlan, it
would have to do SW GSO before the packets enter the driver, even
when the vxlan dev and lower dev (like veth) both have the feature
of NETIF_F_GSO_SCTP.

So this patch is to add it for vxlan.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/vxlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b936443..3929e43 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3283,12 +3283,13 @@ static void vxlan_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
 	dev->features	|= NETIF_F_LLTX;
-	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
 	dev->features   |= NETIF_F_RXCSUM;
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
 
 	dev->vlan_features = dev->features;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE;
-- 
2.1.0

