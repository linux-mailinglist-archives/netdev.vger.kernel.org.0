Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB098DE8E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHNUQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:16:22 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36204 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfHNUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:16:21 -0400
Received: by mail-yb1-f196.google.com with SMTP id m9so154812ybm.3;
        Wed, 14 Aug 2019 13:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bydRDezFxispb0Cykq5AhesYrm10kP1GKiJAz6zvvSA=;
        b=D3DGiTJNLVanBb0fQFEIpO31zawDlOLiNzP7MC1G2m92H+YwxRvMg0AmynenYR+rM9
         7w/Tm0tAVI7ls/it6nktQVrRaGQM0pHZp7/eatvyHtxYKmOHRqifJNgD6exfchJ063NG
         ugxP0KhcFB3Dft1zCKEkO+l5V5fGu9Sg6fsKDqmhJEpOsQEra4Fc48l6nTf/pjbkVCSo
         M5yK94dRYajo/CBlpdASWAAiQcsdarANcq0TJo+XavA6VmFz+C3fvoPn1CR75GTSGPkE
         tM/jhlNaSLy1wdgIVjAGr2jVHRkw12JFwfx0xhlmowJp1UEKDbLWDcKSzhi66gz7/fqD
         LBVg==
X-Gm-Message-State: APjAAAVpHLTTRiz2MAEdYMMB8ejCpCoOtN36bIpb31z6QxImVbn/R7bU
        OHmmGdjiXXQh5rPVqK5Pvok=
X-Google-Smtp-Source: APXvYqzvpnkK5P8IlJ2ICnlWRFiTmCjkGo1S6wKs0/CmrsNS7ffFDu82Xn1qM6sxPse3VXVRNjhS9A==
X-Received: by 2002:a25:818d:: with SMTP id p13mr1118668ybk.322.1565813780968;
        Wed, 14 Aug 2019 13:16:20 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id a130sm193818ywe.27.2019.08.14.13.16.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 13:16:19 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hyperv@vger.kernel.org (open list:Hyper-V CORE AND DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] hv_netvsc: Fix a memory leak bug
Date:   Wed, 14 Aug 2019 15:16:11 -0500
Message-Id: <1565813771-8967-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rndis_filter_device_add(), 'rndis_device' is allocated through kzalloc()
by invoking get_rndis_device(). In the following execution, if an error
occurs, the execution will go to the 'err_dev_remv' label. However, the
allocated 'rndis_device' is not deallocated, leading to a memory leak bug.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/hyperv/rndis_filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 317dbe9..ed35085 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1420,6 +1420,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 
 err_dev_remv:
 	rndis_filter_device_remove(dev, net_device);
+	kfree(rndis_device);
 	return ERR_PTR(ret);
 }
 
-- 
2.7.4

