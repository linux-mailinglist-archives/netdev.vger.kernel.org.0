Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6F46AFC9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhLGBej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhLGBe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856E7C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:30:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so707170pja.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDYVPuIEkV8eN9s9kPcAAJsWE+y2Z23XnE5mUhQWdCg=;
        b=aGu30ek36ZJ/yIxOnYnKDbkLpvh5PZbKwBwS6TDJGLwlXuTwrDAPNmKOJ3IQj8t+HG
         fj4B4HFY2Pr5Ik+gHX2kGNkJtLpXHW/oDe7LR1sSA8pGaByiogEwQk3IV/Nr3DT6p+H0
         FhLQ7FNJwbxij1MUvBWpfVr8T1oMuYyCJJu1+rRMDlDLmUwWOWb+MfwaRYk73t2tFpG+
         9xLN5GZ3u/PtT2vdc+6Amc7zYIjKJRuZtYehc63vBMG+cdsvpTgxAQsdjM6hR9wsCRbP
         4G2Z5SOTPwUeBryTwJJCrGe2tyvI31z96vMU0lRftPX9lj6/Tk/oRzBku0bsjzI00A2Z
         zm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDYVPuIEkV8eN9s9kPcAAJsWE+y2Z23XnE5mUhQWdCg=;
        b=Ov2BfVzP02Jg5yk0VBOQ3myTmCDzuSaYKdyqTyOzQl3nmHIJJ6ymGXMde1dcQrCXUD
         id74LHzwlwTcQQ57RplTW0fy5jpS1qHPOtMCtNAyD3LxYizzoZANKYRQz+i5gLxRlLYW
         T33CQF8tMeCQV8/TXjVxHVmqN3L2vJKKxC3mrBTlPwKf05yU+g5/LhVsq3wDxg4EaglI
         nWt5sMnrfQUqo5hFjZmR2B2Va62ZAF43jEEv1Z7qyLDDeacXAy5hw7shvgV3YK/dNT5H
         G9s14IlP1zjYCvD+GXAwCKK1ITud4fP1cwgvPqG64SiXDBqkd4o3guibVH1yKLh3EA61
         hs+g==
X-Gm-Message-State: AOAM531OVmVwhh4v1R+gtHy8BiQvy3fz3yvwWAj2ZMF5I4nxtJEzKXKq
        4jbjdjw8j6aQma/P5+z+o1Q=
X-Google-Smtp-Source: ABdhPJxKpEnBSq/f8dTgySs/4UdxCNxslqsOGnADuGBoi309ysvKKjk8jOTyISu89/1Q4cilk24OwQ==
X-Received: by 2002:a17:90a:f2c2:: with SMTP id gt2mr2814596pjb.178.1638840659093;
        Mon, 06 Dec 2021 17:30:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:30:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/13] vlan: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:28 -0800
Message-Id: <20211207013039.1868645-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/if_vlan.h | 3 +++
 net/8021q/vlan_dev.c    | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 41a518336673b496faf7ce0ea2a65068fe6814f2..8420fe5049272bbfa108df794bb351f7d87f7a5c 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -162,6 +162,7 @@ struct netpoll;
  *	@vlan_id: VLAN identifier
  *	@flags: device flags
  *	@real_dev: underlying netdevice
+ *	@dev_tracker: refcount tracker for @real_dev reference
  *	@real_dev_addr: address of underlying netdevice
  *	@dent: proc dir entry
  *	@vlan_pcpu_stats: ptr to percpu rx stats
@@ -177,6 +178,8 @@ struct vlan_dev_priv {
 	u16					flags;
 
 	struct net_device			*real_dev;
+	netdevice_tracker			dev_tracker;
+
 	unsigned char				real_dev_addr[ETH_ALEN];
 
 	struct proc_dir_entry			*dent;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 866556e041b729af5ebd5184fa3a90374fc3c244..26d031a43cc1a70aa94a5f3efe895efacb612cad 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -616,7 +616,7 @@ static int vlan_dev_init(struct net_device *dev)
 		return -ENOMEM;
 
 	/* Get vlan's reference to real_dev */
-	dev_hold(real_dev);
+	dev_hold_track(real_dev, &vlan->dev_tracker, GFP_KERNEL);
 
 	return 0;
 }
@@ -848,7 +848,7 @@ static void vlan_dev_free(struct net_device *dev)
 	vlan->vlan_pcpu_stats = NULL;
 
 	/* Get rid of the vlan's reference to real_dev */
-	dev_put(vlan->real_dev);
+	dev_put_track(vlan->real_dev, &vlan->dev_tracker);
 }
 
 void vlan_setup(struct net_device *dev)
-- 
2.34.1.400.ga245620fadb-goog

