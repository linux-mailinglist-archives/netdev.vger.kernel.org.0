Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C3322A4F2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbgGWB4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387467AbgGWB4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:56:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF196C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:56:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d1so1845379plr.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvlX3oCvtXl/uIJhPuyxAQXS2n6fLGPZfLSsBnafpek=;
        b=RWZFVftUlw7J0v8bM8lU803dbubywTicCpGtcTu0w4Z4eNQ+Jq6ft5mNxPtNuHfyYc
         2BemAFrgj8e2xEod3MZN61Rs1BlObChN0ME5apz9+YbFAyxAwEJcX0EMZhyRbWjJydjx
         fnMz7S2lD7octXPMNYpkDmvnKgYQCi0r4fOpEcZ5VakuIqfh3WthvvA/aG/Ofa4IVNj7
         v6xVOhjBA2VHK3I7dzSwdx74VFLe13D7XIWjAB2mMrbCmtXZAFIlov2Zj7WpnzQbkn+l
         pOVinMEb0kzGr+Z8xOMj0PZw9E7x0Sna/mWmFGgB5CYYalXIJc9WO5TIxMvx7BrQx8iM
         7HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvlX3oCvtXl/uIJhPuyxAQXS2n6fLGPZfLSsBnafpek=;
        b=Fd9+wiF0HKEQJONdFY/rrPCUhhUG1LuiKcxP2pGU3q6t0nq7mady77eX0L1/ySk4eR
         3M5uagrMmw3Q4K550r/XdRWLOZbN1eCSMOqxOH0d6CHD5PJ7FnpVa0C6xJUfMmAKD4Di
         K+zWw+vmprvtAkUpNNdUvC6b75prDp4lXB+KnjwP/QIP3aHGnQyl1lpMPVr+gtT6U6xv
         mfTWDopuzZKlUddlFTxv3ch1CvisMFXfRnEbv8Ms5vH0zdsA/UFEarBiZ1pe9fdaZxOL
         UQ+SwqXVCe++LtRgpXvZNK/Luj9y/EttlkOc2072vq2vAZaPL1+YtipePWDCbEkXtkmt
         /Ggw==
X-Gm-Message-State: AOAM5304hMr1CieiBoLuDIiWal9fKjDJvjAOK13gQY76oag/lZie09ed
        99RzE9PJymLNy2D5ynFapXfZ8U0k30I=
X-Google-Smtp-Source: ABdhPJxkdcBkxBPHyCjFzjoeHZ0RjFtoRLrcxYl0VyoNYUki+sDJtBmjbZRmDqYClyc3H5pR3Dtqyw==
X-Received: by 2002:a17:902:d68d:: with SMTP id v13mr2037344ply.10.1595469394215;
        Wed, 22 Jul 2020 18:56:34 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::2e])
        by smtp.gmail.com with ESMTPSA id j17sm882824pgn.87.2020.07.22.18.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 18:56:33 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [Patch net] geneve: fix an uninitialized value in geneve_changelink()
Date:   Wed, 22 Jul 2020 18:56:25 -0700
Message-Id: <20200723015625.19255-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

geneve_nl2info() sets 'df' conditionally, so we have to
initialize it by copying the value from existing geneve
device in geneve_changelink().

Fixes: 56c09de347e4 ("geneve: allow changing DF behavior after creation")
Reported-by: syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com
Cc: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4661ef865807..dec52b763d50 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1615,11 +1615,11 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct netlink_ext_ack *extack)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
+	enum ifla_geneve_df df = geneve->df;
 	struct geneve_sock *gs4, *gs6;
 	struct ip_tunnel_info info;
 	bool metadata;
 	bool use_udp6_rx_checksums;
-	enum ifla_geneve_df df;
 	bool ttl_inherit;
 	int err;
 
-- 
2.27.0

