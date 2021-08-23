Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1433F44DC
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 08:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhHWGU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 02:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhHWGUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 02:20:25 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F786C061575;
        Sun, 22 Aug 2021 23:19:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u15so9489709plg.13;
        Sun, 22 Aug 2021 23:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ZeKKxsi+JTCjIObZ4eE1fvYuLFReuH5GCzKzRZkgdE=;
        b=UCLzYMyaq7Rrmnp8ZFnPp4omrv77mq+4A6TSSxWbqeZmgcMawouGrIXO7wQEGX4ndh
         PYKaWptz3y5dYVq9LZjG7cqYZhlKesoDrBTXeVAHAlctv2iHKr1OPNQOOoqinC5hWa9x
         JV56yWZEL5kcLSl3Y9cNT872JEpREwb9UGmuHtZhNFyEXBQa4QZ4Xz/3Ms79Da8IgVcH
         e83V4rEDO67aDK3PMsP3dPDTrtC6D0B1IOk61uYp1euwsX2rXIwHoVRvewY6bDVWYW2i
         97DlNEAOs76P6GTtvaaHpyT73waBlhphm7jkMXPg/4v1swexZIXlhQ5bCnFwV6Bhuz+A
         PMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ZeKKxsi+JTCjIObZ4eE1fvYuLFReuH5GCzKzRZkgdE=;
        b=aco7RvL5I8bojrZ/gJB7VTkwzSCChsS5G5DbXrm1MTGKAI+bSQanBQID3Ej2+5m7rQ
         aMfjGr3VylwXx+w7dRyfP6DdHugmvjr7uBSaT/Bab1TSGhAUm2s3cZ4cL00IwrTcOcSO
         1V3KCgqMPRv3XSYmeT8iMm87IzKsuSbEDo3FWCZFixnvDUDkYA5OwHU6yRY18Z0iNY7R
         Gy4lCVl3n1vVpCKmlPHcpBe6N6S9illYcTGowFEjsF+dxNCRpK/vtUXim4CrTdeZw1iz
         f3fiVTdljbDiCzwnfihmn6LvJRHPpCQlVh0Fmtv/5IlSL6I/EJx8GvTSdsCcJLWOx6pU
         PL3w==
X-Gm-Message-State: AOAM530Msepoz/7lRFyUKEFM8fgNdNxwkRKqZy4PXMGYXj2kI3yPaVDi
        Ebov4M6Xyi82w2vlh2/UPb4=
X-Google-Smtp-Source: ABdhPJw1tycfU8q3I7bG+LeG8Jkrs1BieOAdB8wva7RxHhdPGryWtEvwwDegHVxrcH9xXWjEa6cwfg==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr18231339pjj.165.1629699583082;
        Sun, 22 Aug 2021 23:19:43 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id l12sm17273425pgc.41.2021.08.22.23.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 23:19:42 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: bridge: replace __vlan_hwaccel_put_tag with skb_vlan_push
Date:   Mon, 23 Aug 2021 15:19:38 +0900
Message-Id: <20210823061938.28240-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_handle_ingress_vlan_tunnel() is called in br_handle_frame() and
goto drop when br_handle_ingress_vlan_tunnel() return non-zero.

But, br_handle_ingress_vlan_tunnel() always return 0. So, the goto
routine is currently meaningless.

However, paired function br_handle_egress_vlan_tunnel() call
skb_vlan_pop(). So, change br_handle_ingress_vlan_tunnel() to call
skb_vlan_push() instead of __vlan_hwaccel_put_tag(). And return
the return value of skb_vlan_push().

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/bridge/br_vlan_tunnel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 01017448ebde..7b5a33dc9d4d 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -179,9 +179,7 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 
 	skb_dst_drop(skb);
 
-	__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan->vid);
-
-	return 0;
+	return skb_vlan_push(skb, p->br->vlan_proto, vlan->vid);
 }
 
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
-- 
2.26.2

