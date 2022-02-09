Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8143A4AEC0A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240831AbiBIIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbiBIIT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:19:56 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3888C05CB85
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:20:00 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 200so1035428qki.2
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 00:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXXsTLbqQsfurYNa2/nCRcydix2xehGGYSxX54I0elE=;
        b=j/OwUWTc9AaNmdnhrADamQj29YnwGmw0BC/zVLA6zuiqHc68kjvlZPM1DVFVzTlnAi
         hi7xqTkzMYBMbY0I2ZANuKQ3O7Hdq59LFMnVMZF8KR3I14f97Gdf+uEGAXP9DpO6+5mC
         i0oQfrbeXy0okdZYzHiSXZ29iBUUeJBN6Uj99nqjFYvNW2ZvWC3Mdy44XTqj3VsduZOa
         R5nmPKUCfW9V+uBONxVNRSZPF/OwcfyxJfxewXjEm1hFsPLkUT6vU0I8ctiBliB0hQ/V
         q3i95cyVu/8yodl8s/Rdnmp61dFTrEJKQldwTWVGEt+qUYmM3ns1euVYiOdEuSvKCIw0
         09aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXXsTLbqQsfurYNa2/nCRcydix2xehGGYSxX54I0elE=;
        b=fzcprgqH9HDkKoxU+6gU+Sk/avzV7oeBXo0yhVI90nd+gM7BV5rTLWIo4n7UqcV75+
         fNjTQNgpijOOWROdjO3taYfToA8Lf1Tur3RISuq31CiXnj21mCMtsbQ8vUw9SE/OuB8S
         QMGQoY8Ktr0UBIAyNzDhzm0/4pKPpnVxiN2zomoCV8snBBchmiYwtxCrj2dZYfHBG9qo
         xzQhIXIFASWpmOL9OxUqrJcyglRhT3cvWxCnLEyIgpeFkG45XvqeEgNke0N1OUxyAaDl
         4Z5XfLbplO7yME0BJAzI+JjQTEVMX/pqQJjxBuLXOs5Qpn7trAT8PgS0bv/+9fXNMsrO
         KATQ==
X-Gm-Message-State: AOAM530IorugyHbH5VHT83jpma/Dg8DaNTeIW9pbMfD2nclQ02UxADyT
        cIYY3T4BA7akdVX1PXEMtgL5wB6lCByF0A==
X-Google-Smtp-Source: ABdhPJyxUOaE1hZO7g/0GyImXH4KDRZRZqKFMpnDSP0RpLmtTpaAOXBMq1hU61cOUSANb6jooAtUsw==
X-Received: by 2002:a05:620a:854:: with SMTP id u20mr465157qku.716.1644394799753;
        Wed, 09 Feb 2022 00:19:59 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x18sm8837717qta.57.2022.02.09.00.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:19:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
Date:   Wed,  9 Feb 2022 03:19:56 -0500
Message-Id: <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1644394642.git.lucien.xin@gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuang Li reported an QinQ issue by simply doing:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name dummy0.1 type vlan id 1
  # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
  # rmmod 8021q

 unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1

When rmmods 8021q, all vlan devs are deleted from their real_dev's vlan grp
and added into list_kill by unregister_vlan_dev(). dummy0.1 is unregistered
before dummy0.1.2, as it's using for_each_netdev() in __rtnl_kill_links().

When unregisters dummy0.1, dummy0.1.2 is not unregistered in the event of
NETDEV_UNREGISTER, as it's been deleted from dummy0.1's vlan grp. However,
due to dummy0.1.2 still holding dummy0.1, dummy0.1 will keep waiting in
netdev_wait_allrefs(), while dummy0.1.2 will never get unregistered and
release dummy0.1, as it delays dev_put until calling dev->priv_destructor,
vlan_dev_free().

This issue was introduced by Commit 563bcbae3ba2 ("net: vlan: fix a UAF in
vlan_dev_real_dev()"), and this patch is to fix it by moving dev_put() into
vlan_dev_uninit(), which is called after NETDEV_UNREGISTER event but before
netdev_wait_allrefs().

Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/8021q/vlan_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5d23e75572a..d1902828a18a 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -638,7 +638,12 @@ void vlan_dev_free_egress_priority(const struct net_device *dev)
 
 static void vlan_dev_uninit(struct net_device *dev)
 {
+	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+
 	vlan_dev_free_egress_priority(dev);
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
@@ -851,9 +856,6 @@ static void vlan_dev_free(struct net_device *dev)
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 void vlan_setup(struct net_device *dev)
-- 
2.27.0

