Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58E2280C57
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbgJBCmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387604AbgJBCmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:42:44 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F6C0613D0;
        Thu,  1 Oct 2020 19:42:43 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o25so536584pgm.0;
        Thu, 01 Oct 2020 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vhJrTuKe7PDz10GtNZQbkYGDQuGZYuoM+kYSrehJVgg=;
        b=snQHdcK2Lj0GYmkGAMK+uTYrfZPPy/CkOc4CDSftneJIFxmF/+ZJC/pLeIPJk4N0wm
         jTtIYJ38X33KJLvA6yr/Vut3N2E8Qq5MdgK4qsyKSvGpY6jwAxh/3lXICP1Tjc0OgZUD
         yY0PdElkMYfdrBAZiGZNh6KL8h6NXZyIC6DI8vHKXDsdI5Hae7mzE5QvaesltPflNPmb
         vBT73gdfmh4xl1g9VfRapcGsUU7Ttytvb38iy53Y0yNvLQiwMBsillsyVoa/7JQIVvaF
         JidnH7q5TM+nJlLhuQL+eiXwxMt6R+D4P5lKc0pkgg9Jc9RmHJgCU+y12yJII+bEx879
         yabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vhJrTuKe7PDz10GtNZQbkYGDQuGZYuoM+kYSrehJVgg=;
        b=uQ6ulqffxTaJaA3hJ4n3to7SZyELjo4aUKOM1bUpSYqGuwnt72ZvrlZ1cRdlz1DUrS
         lq16AT0//BuUISUm2FCrUcDWvNFf71OK6h8CAUJn9igq53Y4MJ+4fgtCJ0Pp7ZUGDv6l
         W95H76oJDCSJHXxKMeQTW96+OoXO3ONX1uOJT0ruhfxyE+yGRTuZlJCVzzbwGwZfjP64
         p+Wpgfi2tls7Ja0y3Yqt2N2JpUV9WQeemqdikkxwAR3yylcqGYV11DW9jAP60BtC0pqK
         tGIEtT+c72wWt2FEI47zraXnlQfKjrE299AtNb6Wv5osPzdlHs75kebqvVuLnRS6VLfe
         39Bw==
X-Gm-Message-State: AOAM5331xHI6CPSCBkBDnDxvP0jmuKMuhlCXuYSgbH8gHT+RuZ2dczZL
        bgLZC2khDkVsIHncapn8oJXV/gofULSUig==
X-Google-Smtp-Source: ABdhPJwSVJkhy6QDj4UfhIyYeyf97BTCqf224vB3pU5Fu8758ZvLqreNoLtNHtqCh1L2ZUm2XKPqoA==
X-Received: by 2002:a62:2985:0:b029:142:2501:3969 with SMTP id p127-20020a6229850000b029014225013969mr139245pfp.46.1601606562137;
        Thu, 01 Oct 2020 19:42:42 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm150185pjb.48.2020.10.01.19.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 19:42:41 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: [PATCH net-next 3/4] net: dsa: Obtain VLAN protocol from skb->protocol
Date:   Thu,  1 Oct 2020 19:42:14 -0700
Message-Id: <20201002024215.660240-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002024215.660240-1-f.fainelli@gmail.com>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that dsa_untag_bridge_pvid() is called after eth_type_trans() we are
guaranteed that skb->protocol will be set to a correct value, thus
allowing us to avoid calling vlan_eth_hdr().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0348dbab4131..d6ce8c2a2590 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -201,7 +201,6 @@ dsa_slave_to_master(const struct net_device *dev)
 static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 	struct net_device *br = dp->bridge_dev;
 	struct net_device *dev = skb->dev;
 	struct net_device *upper_dev;
@@ -217,7 +216,7 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 		return skb;
 
 	/* Move VLAN tag from data to hwaccel */
-	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto == htons(proto)) {
+	if (!skb_vlan_tag_present(skb) && skb->protocol == htons(proto)) {
 		skb = skb_vlan_untag(skb);
 		if (!skb)
 			return NULL;
-- 
2.25.1

