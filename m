Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BCF410C3B
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhISPpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 11:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhISPpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 11:45:30 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BB9C061757;
        Sun, 19 Sep 2021 08:44:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id 194so9147913qkj.11;
        Sun, 19 Sep 2021 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDkakuhEl/Dan5KAuhVlwRPEvRkbpGxHTjJ5gNV/EIk=;
        b=WVeaQ9SrUmuZi0cz8l2Sq/poppYj+QuHxhOuKQXs67o20rWjkzR/ki56QVKdliuUKT
         hCEWO7y3AmTgt9our3tVgZrxgmutzSam9XQ+4VuwGKE6CkKc6Q28F7Bfd03i5R7Gpr47
         XSNpIqhIoVgNc2zCyYmtjV6B/9ouGlG1unCUypji9x5ZmaBrPBDHD1nDrku9yYxEVZlE
         cQfHBnZhvamFFgnr4iQmicx3yfmX/NMb4L1X7DTdBIHRXtsOgpkt4YFFZXXpUpOO0dnK
         nGbsTtLts2AkRWooJ6cwjigp+z6/SfysKNpeCoHvuHe5NV8oPwdPCJSwJPSP7/4+xSxW
         U42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDkakuhEl/Dan5KAuhVlwRPEvRkbpGxHTjJ5gNV/EIk=;
        b=AG2LNCZB9O9eOnoWU3MjHEOcN2P0ZCPqCmJQ3dBYq8EfTSqJ/c8Exr1DGE8ra7oKfl
         VqtoG35QSM25ORIkfZPMeA+3fsMa10UmV0d91/76EBvXk/ByNDGRrsPxjm0bT5Tf7FPo
         FThTrQ5jCX0Ohj+OFObo5MmPldnKEsHDn3xRK9FIuH/I6HpviH9Lc/4r8QqET2diTeMR
         nZgMXkzA6M15uCg974ChqJ0e/8ynTotavgJzfDhjNP269b4Kz346rwRHeIR1XtUBw7jc
         BjGy72yU1lteeXIZrQRmSvPPiOw1bsB00L/1Bjj5y1rqqfAbur1r4LJuYfkqFkZIvxCy
         +WZA==
X-Gm-Message-State: AOAM531O0ZyPfrjD2yLi7uf+20X97MvBTbi/Chuz6Wx4h8jcequXhbIG
        CE7KhAS13YBaFXYO+oJ50IWZYFmC8YDCgA==
X-Google-Smtp-Source: ABdhPJwFOaJ1dD3KlhVVHe2LD/Lu3ChbAnuIgPKC8VCKqyEwsmv1k4YQYtrBi/2iqVcEbEVelG+RJw==
X-Received: by 2002:a37:e17:: with SMTP id 23mr18365389qko.301.1632066244022;
        Sun, 19 Sep 2021 08:44:04 -0700 (PDT)
Received: from luigi.stachecki.net (pool-96-246-29-33.nycmny.fios.verizon.net. [96.246.29.33])
        by smtp.gmail.com with ESMTPSA id bl36sm8849057qkb.37.2021.09.19.08.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 08:44:03 -0700 (PDT)
From:   "Tyler J. Stachecki" <stachecki.tyler@gmail.com>
Cc:     fankaixi.li@bytedance.com, stachecki.tyler@gmail.com,
        xiexiaohui.xxh@bytedance.com, cong.wang@bytedance.com,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ovs: Only clear tstamp when changing namespaces
Date:   Sun, 19 Sep 2021 11:43:37 -0400
Message-Id: <20210919154337.9243-1-stachecki.tyler@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of "ovs: clear skb->tstamp in forwarding path", the
tstamp is now being cleared unconditionally to fix fq qdisc
operation with ovs vports.

While this is mostly correct and fixes forwarding for that
use case, a slight adjustment is necessary to ensure that
the tstamp is cleared *only when the forwarding is across
namespaces*.

Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
---
 net/openvswitch/vport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index cf2ce5812489..c2d32a5c3697 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,7 +507,8 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
-	skb->tstamp = 0;
+	if (dev_net(skb->dev))
+		skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
-- 
2.20.1

