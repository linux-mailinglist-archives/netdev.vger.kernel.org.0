Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E3C280C59
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbgJBCm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbgJBCmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:42:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6D6C0613D0;
        Thu,  1 Oct 2020 19:42:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q4so173272pjh.5;
        Thu, 01 Oct 2020 19:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pNIFCfbxn/994O6tOncE60q/cKfHn8CJSzrbaSDB3Bc=;
        b=ZIAxAI3LB542ee7hXFPsZjEdnq9/UH8jbb3Stpq8hN1b/FBaLPqG+SIsRK0wtRCS53
         Tz56f9PKsbKDcZQokW3WzR8jm6PcdRT5LPMhSPf2IFYv7u0XmGP0Ms/b5tpgrKx4aSUZ
         ds7nRnT8Pk8zrErOCMbJ989MkywmIIVipUxVYqp6FJCkiKF0+QaEk1C/sxhR1v+Oysf7
         7z6Uq444AzF71+PM/YbsopVzY4cjdNwi5dQcBSsVMDdTHy0ZLz97jhhP1K2RoG3AWrL0
         Db3YpVJYMU2fvoGPCYaALZFIxr8gnXMAPGuUfPXuCOF5Wpm185jLl6X/FZEaXtHKVYEJ
         K/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNIFCfbxn/994O6tOncE60q/cKfHn8CJSzrbaSDB3Bc=;
        b=R3QLZI1AGlTuf0IraZGCtwJbnxlqORVKwTjoo5fG+vXiTC9QKvEHUW2vajB4/GD12U
         x3RkUeXaGnL+0gZ5GCqYuSVvEoV4perRK7w8mDlCEtC8bu2iUezGgG53id85pIZQ8ubq
         Fj4uxfVDsqFNLZJ/BjnRwlwgtfspogOXRE50lRLJvjc/heLIBDkcARVTmAa1unP5xC4Z
         hxmG4vrdpQECyzZzQclpQ/SmNrYDoCi6W7vL6O5Bm8V0HK4kmrAkgVUkQR2NRpQxc2br
         OJ1Fo1t1tmblpi7h/gRcls3dRCc+JKRE/eIoRjTk/swsUEhC+TVw2yMAoNqgGEGhfqRz
         5m/w==
X-Gm-Message-State: AOAM533RUgvCEILulpBx+QGn19lQrGve3DFqEHi0sAJx9O6DKd6yeShY
        99jME0YrdqUFBFFC8YjN58IAtENXSY16nw==
X-Google-Smtp-Source: ABdhPJzKhXnK0vZ8esfwylqznfrHKgFVR3MRH2VN/JYz+WcFROH/2z0GjS2o1YoyQl145HarX3XgMg==
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr344996pjb.130.1601606567011;
        Thu, 01 Oct 2020 19:42:47 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm150185pjb.48.2020.10.01.19.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 19:42:46 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: [PATCH net-next 4/4] net: dsa: Utilize __vlan_find_dev_deep_rcu()
Date:   Thu,  1 Oct 2020 19:42:15 -0700
Message-Id: <20201002024215.660240-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002024215.660240-1-f.fainelli@gmail.com>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we are guaranteed that dsa_untag_bridge_pvid() is called after
eth_type_trans() we can utilize __vlan_find_dev_deep_rcu() which will
take care of finding an 802.1Q upper on top of a bridge master.

A common use case, prior to 12a1526d067 ("net: dsa: untag the bridge
pvid from rx skbs") was to configure a bridge 802.1Q upper like this:

ip link add name br0 type bridge vlan_filtering 0
ip link add link br0 name br0.1 type vlan id 1

in order to pop the default_pvid VLAN tag.

With this change we restore that behavior while still allowing the DSA
receive path to automatically pop the VLAN tag.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa_priv.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d6ce8c2a2590..12998bf04e55 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -204,7 +204,6 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	struct net_device *br = dp->bridge_dev;
 	struct net_device *dev = skb->dev;
 	struct net_device *upper_dev;
-	struct list_head *iter;
 	u16 vid, pvid, proto;
 	int err;
 
@@ -246,13 +245,9 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	 * supports because vlan_filtering is 0. In that case, we should
 	 * definitely keep the tag, to make sure it keeps working.
 	 */
-	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
-		if (!is_vlan_dev(upper_dev))
-			continue;
-
-		if (vid == vlan_dev_vlan_id(upper_dev))
-			return skb;
-	}
+	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
+	if (upper_dev)
+		return skb;
 
 	__vlan_hwaccel_clear_tag(skb);
 
-- 
2.25.1

