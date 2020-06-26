Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C1520B828
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFZSYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZSYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:24:31 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E89C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:24:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d12so4575270ply.1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lNKYtQQz75XCkUzBHeQ9a6h7UWDHNcE1U551+U4a8Tg=;
        b=t9Xdv5Buga6pxM97gkpAUfjxjSiVSw74ytT+1xSfWS8oDmBFQpsQXOayyFKKoLAs41
         vcxfaK6WpHpjEfFkLc1Rj3KOwc4qHcV1iTeRnZIDsa4slSz+taqp1VCNlVYtdGGoiEBc
         a9fLu6bfVTil+J2RsNAnFV4/xGLOI42+7+nBof7jTHapkYoqWI9wawoXedeD87YQsTCd
         k1teNb6tldyWtckGUGhMOzpt9S1HTf81uyc2MtdwD2BBsYGxCvRP9x8PfWUAU0GjR/D9
         XBUXLctL6Dwg2b2rS1PHKKPec+FrxKraSkywEwRmQD8Ix8BNRspIRH1cOLQpCd03I5Lh
         9g3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lNKYtQQz75XCkUzBHeQ9a6h7UWDHNcE1U551+U4a8Tg=;
        b=bzC1t2cokTJGJl4uHkFRBxvLno7kbOkuLopRu7gsQccEfwR4D6Tlc0xXXAOj/xHR1E
         MaNOSL/1i7TLiXtDOyGuW2nhcubFvnpsSc5sU2KHoeCoXhE2+3B9y0xsDaytVNFrsPG3
         4iGiNgBhnhOjDoUIXHiedXGvNqwPQD20cikbLmlkMrwGittMWz3M+DbV2CQkijDnhO1Q
         ElRbVK6Tzrd6cNmpOPxfRmR9KViC8o2KNteV3Wq6WpUPWcWnnEF27POU4ayk0inHuAcj
         4bLy/GWOyISEHv88sCHvn2YXoCqv0W2j2W3oa1Rf9rdxz6tv9Q+tp1n6a02Sd+Sqqf9A
         uxtQ==
X-Gm-Message-State: AOAM531h6I0r8d5aSKnNs6VKghbIRbf/9eD6o5WoWgM5YLeRXSDLlvJj
        QL/CepC1Ql843YCKKnuZ483+2CRWZps=
X-Google-Smtp-Source: ABdhPJwzT1ExatIwamGj8JlzsraYIYMbgjhDKc99T5BESPUyHf0XL58AbUiZQA4mn6WDdH6W86Fy3Q==
X-Received: by 2002:a17:902:b496:: with SMTP id y22mr3679053plr.224.1593195870543;
        Fri, 26 Jun 2020 11:24:30 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2601:642:4780:87f0:b554:afd3:52c0:2f89])
        by smtp.gmail.com with ESMTPSA id t19sm3912016pgg.19.2020.06.26.11.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 11:24:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [Patch net] net: get rid of lockdep_set_class_and_subclass()
Date:   Fri, 26 Jun 2020 11:24:22 -0700
Message-Id: <20200626182422.9647-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lockdep_set_class_and_subclass() is meant to reduce
the _nested() annotations by assigning a default subclass.
For addr_list_lock, we have to compute the subclass at
run-time as the netdevice topology changes after creation.

So, we should just get rid of these
lockdep_set_class_and_subclass() and stick with our _nested()
annotations.

Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
Suggested-by: Taehee Yoo <ap420073@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/macsec.c  | 5 ++---
 drivers/net/macvlan.c | 5 ++---
 net/8021q/vlan_dev.c  | 9 ++++-----
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index e56547bfdac9..9159846b8b93 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4052,9 +4052,8 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 		return err;
 
 	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macsec_netdev_addr_lock_key,
-				       dev->lower_level);
+	lockdep_set_class(&dev->addr_list_lock,
+			  &macsec_netdev_addr_lock_key);
 
 	err = netdev_upper_dev_link(real_dev, dev, extack);
 	if (err < 0)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6a6cc9f75307..4942f6112e51 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -880,9 +880,8 @@ static struct lock_class_key macvlan_netdev_addr_lock_key;
 static void macvlan_set_lockdep_class(struct net_device *dev)
 {
 	netdev_lockdep_set_classes(dev);
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &macvlan_netdev_addr_lock_key,
-				       dev->lower_level);
+	lockdep_set_class(&dev->addr_list_lock,
+			  &macvlan_netdev_addr_lock_key);
 }
 
 static int macvlan_init(struct net_device *dev)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index c8d6a07e23c5..3dd7c972677b 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -503,11 +503,10 @@ static void vlan_dev_set_lockdep_one(struct net_device *dev,
 	lockdep_set_class(&txq->_xmit_lock, &vlan_netdev_xmit_lock_key);
 }
 
-static void vlan_dev_set_lockdep_class(struct net_device *dev, int subclass)
+static void vlan_dev_set_lockdep_class(struct net_device *dev)
 {
-	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-				       &vlan_netdev_addr_lock_key,
-				       subclass);
+	lockdep_set_class(&dev->addr_list_lock,
+			  &vlan_netdev_addr_lock_key);
 	netdev_for_each_tx_queue(dev, vlan_dev_set_lockdep_one, NULL);
 }
 
@@ -601,7 +600,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &vlan_type);
 
-	vlan_dev_set_lockdep_class(dev, dev->lower_level);
+	vlan_dev_set_lockdep_class(dev);
 
 	vlan->vlan_pcpu_stats = netdev_alloc_pcpu_stats(struct vlan_pcpu_stats);
 	if (!vlan->vlan_pcpu_stats)
-- 
2.27.0

