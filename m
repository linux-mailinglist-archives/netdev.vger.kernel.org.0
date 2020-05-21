Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4031DD927
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgEUVLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbgEUVLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:00 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD842C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e2so10496214eje.13
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0s/Er0BpZNr3kmWpzh0ZD+YrPYRB0SL5OAK3lR0aHY=;
        b=lwZP0zxwUYuJOCQ5z6sKMEG2uGAlk1aEceuipwcfEkfXk8jBUhItXbGLO8l4ZGhinP
         ABU/6aHiXWKvQimgHzRs290Hl+eC/IGKwU/liZ9vf5Nw1+lw6LOoys0w2w7i6zGYSkwz
         3qmaOpOTwxnRkGzgGL2Px4MZnzv9ZSg/MzY8u3ZghWVoNKqpyahrv3GOZRiuxGXWyRFb
         3V2gWqfuCBnYj3RY9IOi9VYZBgA+mpXZp1OnDq/SVyWvdsuQBOwAnx8T1b57ps0grQVz
         z6M00EHIlVNhS8DD/d5FAyuwdP8dHw2GO42ei9e99wnedjnJZ7JrIEuFgi0lFgGvaf4W
         U74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0s/Er0BpZNr3kmWpzh0ZD+YrPYRB0SL5OAK3lR0aHY=;
        b=Lw/tz7C/SDpU50Vd9iujmTLPeCmB2vQsE7l+VaXFhmuY4uLEMjL0eKKIwqjazJ880L
         HEsgcoE4LqPGrm6h9qYoX6ZNeIqba8GdbcIEs+fynPhtlSHoxOKC9Ma0Kb9p1qMDMQ9I
         sGz6NNzvloZ8b3Tz5deEx3PPmGXggp82l80EJ81iko4aY65ONDl3h5PW/C/5D4rCBGOo
         DqeRKxVtTbM0p02/hKDPQ8V700SXIOvXjSLbDKgCuzWYmDHoOKIn/6ihy/SRpuywMxxS
         KNz/bLb+Wgv0mYiE4lVonOggkn192ERR+wZliwQzq/41POVEx0gr8Qr+3mCRYerfzKRp
         1V6g==
X-Gm-Message-State: AOAM531SeFgWlda4BZii6cEjfSasiyNPlXjlVeGGwgQdm//6tiSdSHq+
        XwN1NbajB4wlYqdSlNg4QPc=
X-Google-Smtp-Source: ABdhPJxKDaaRncieSb0EpEsR79D/rnNni533eP97uVxozQLX4Bf7WI59Ng+BhUWsk1FoUnjtHe/YCQ==
X-Received: by 2002:a17:906:2c03:: with SMTP id e3mr5273586ejh.206.1590095458522;
        Thu, 21 May 2020 14:10:58 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 06/13] net: core: dev_addr_lists: export some raw __hw_addr helpers
Date:   Fri, 22 May 2020 00:10:29 +0300
Message-Id: <20200521211036.668624-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA switches need to keep the list of addresses which are filtered
towards the CPU port. One DSA switch can have 1 CPU port and many
front-panel (user) ports, each user port having its own MAC address
(they can potentially be all the same MAC address). Filtering towards
the CPU port means adding a FDB address for each user port MAC address
that sends that address to the CPU. There is no net_device associated
with the CPU port. So the DSA switches need to keep their own reference
counting of MAC addresses for which a FDB entry is installed or removed
on the CPU port. Permit that by exporting the raw helpers instead of
operating on a struct net_device.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |  7 +++++++
 net/core/dev_addr_lists.c | 17 ++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2d11b93f3af4..239efd209c33 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4307,6 +4307,13 @@ void __hw_addr_unsync_dev(struct netdev_hw_addr_list *list,
 			  int (*unsync)(struct net_device *,
 					const unsigned char *));
 void __hw_addr_init(struct netdev_hw_addr_list *list);
+void __hw_addr_flush(struct netdev_hw_addr_list *list);
+int __hw_addr_add(struct netdev_hw_addr_list *list,
+		  const unsigned char *addr, int addr_len,
+		  unsigned char addr_type);
+int __hw_addr_del(struct netdev_hw_addr_list *list,
+		  const unsigned char *addr, int addr_len,
+		  unsigned char addr_type);
 
 /* Functions used for device addresses handling */
 int dev_addr_add(struct net_device *dev, const unsigned char *addr,
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 90eaa99b19e5..e307ae7d2a44 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -77,13 +77,14 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 				   sync);
 }
 
-static int __hw_addr_add(struct netdev_hw_addr_list *list,
-			 const unsigned char *addr, int addr_len,
-			 unsigned char addr_type)
+int __hw_addr_add(struct netdev_hw_addr_list *list,
+		  const unsigned char *addr, int addr_len,
+		  unsigned char addr_type)
 {
 	return __hw_addr_add_ex(list, addr, addr_len, addr_type, false, false,
 				0);
 }
+EXPORT_SYMBOL(__hw_addr_add);
 
 static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 			       struct netdev_hw_addr *ha, bool global,
@@ -123,12 +124,13 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 	return -ENOENT;
 }
 
-static int __hw_addr_del(struct netdev_hw_addr_list *list,
-			 const unsigned char *addr, int addr_len,
-			 unsigned char addr_type)
+int __hw_addr_del(struct netdev_hw_addr_list *list,
+		  const unsigned char *addr, int addr_len,
+		  unsigned char addr_type)
 {
 	return __hw_addr_del_ex(list, addr, addr_len, addr_type, false, false);
 }
+EXPORT_SYMBOL(__hw_addr_del);
 
 static int __hw_addr_sync_one(struct netdev_hw_addr_list *to_list,
 			       struct netdev_hw_addr *ha,
@@ -403,7 +405,7 @@ void __hw_addr_unsync_dev(struct netdev_hw_addr_list *list,
 }
 EXPORT_SYMBOL(__hw_addr_unsync_dev);
 
-static void __hw_addr_flush(struct netdev_hw_addr_list *list)
+void __hw_addr_flush(struct netdev_hw_addr_list *list)
 {
 	struct netdev_hw_addr *ha, *tmp;
 
@@ -413,6 +415,7 @@ static void __hw_addr_flush(struct netdev_hw_addr_list *list)
 	}
 	list->count = 0;
 }
+EXPORT_SYMBOL(__hw_addr_flush);
 
 void __hw_addr_init(struct netdev_hw_addr_list *list)
 {
-- 
2.25.1

