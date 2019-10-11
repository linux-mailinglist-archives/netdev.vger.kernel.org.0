Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE16D4240
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfJKOGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:06:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33347 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbfJKOGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:06:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id d22so4538936pls.0
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5h+mm5b4p4hFAu72NQVMEV1XO70kNtCw7rgNvqIUP0k=;
        b=NG8DKB8x9sU1H1Lw0+HKzEl28Kkt7xEQkk/CoZ3xqTBarv2sR/+tt9rRJu1/1SLmPm
         Squ7sgtdwzTn/HyI2kTrS9wU6RrUeLk0fld9MDHW57b2TN3PbfHwB0fCl+FnaOhl81HU
         ONZ3AktdMaJNtBazgDrFyE1NK72Yk+bahH5pNTc0MlQz1Ggj7a5sY6uNOB6o173iDRj0
         wxPYniSVPH7x16jO3YefeRo8G/zIaFReVy984ZM1PsyXcBdlpnRoWgiWaK1tBbF8IeAH
         d6xJE72cyhKnn/JpNfiMTvMcn27QVkENOSNWAW40BaPSLEsfiTSiSFf3qMaVrRMaXPoy
         EzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5h+mm5b4p4hFAu72NQVMEV1XO70kNtCw7rgNvqIUP0k=;
        b=nxuYbMvGgzPMWg72b9yUBgiWkKtgIzjwRUoAy1PcdhA54o77zkfZI1p49rq7rJQ2zm
         J0EH+CmgzsCmbmTrfZ69oaXH2GZuphBqNSghcIkXGzr/DoijU3jS6spTWPbcL0scE3O1
         CsmWbeXQymtEwg22ZFhXoMtThUjkS3M70ZqYzrqy7Z9/5NtgNCDsE2jy8lIOHOJbsISz
         IpPTWVG4IDCkkDx6OvUJYTZZLL676d5Ptc50C4xJfOVCijGAyTSK0B18KY+jz33RaqF8
         zTSmI2b+U5oQyII/6hqGWQzz9sDNAR/GiW09+8mNzTSpqESejBLBQfkrZM5VbBX5hoFt
         THDg==
X-Gm-Message-State: APjAAAVZCIpNMovaLn/56peZ7m9SJAvqAU1YM6BvEff3uev6WAIdLEeb
        ONWcqDCnoRbuwAb2iRYqy8k=
X-Google-Smtp-Source: APXvYqxTvrl7XI01KCj9dwb+AZJcpTR03XXmdXoUz/KXypbnT1OxhfpptDwbDJx570IZnh53ZkCc+g==
X-Received: by 2002:a17:902:bc48:: with SMTP id t8mr14858034plz.255.1570802768878;
        Fri, 11 Oct 2019 07:06:08 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.06.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:06:08 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net-next v3 09/10] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Fri, 11 Oct 2019 22:00:46 +0800
Message-Id: <1570802447-8019-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Unlocking of a not locked mutex is not allowed.
Other kernel thread may be in critical section while
we unlock it because of setting user_feature fail.

Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain index")
Cc: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9fea7e1..aeb76e4 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1657,6 +1657,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
+		ovs_unlock();
 		goto err_destroy_meters;
 	}
 
@@ -1673,7 +1674,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 err_destroy_meters:
-	ovs_unlock();
 	ovs_meters_exit(dp);
 err_destroy_ports_array:
 	kfree(dp->ports);
-- 
1.8.3.1

