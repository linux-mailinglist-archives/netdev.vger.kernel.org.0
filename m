Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A6582FFF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfHFKsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:48:05 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35192 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfHFKsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 06:48:04 -0400
Received: by mail-pf1-f175.google.com with SMTP id u14so41316390pfn.2;
        Tue, 06 Aug 2019 03:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tSv0N+buuXcfO2cMmMhlzp2LfygH9vWetg+buoM6+PE=;
        b=M4HUVcHj3lA270e1ADCiKHblHxlb+KfeMaLEsCpeMYzREBWo/h6X/pOFR3Yw8RA5R+
         +RMnaNsaT2MqnLIDPPJlR6op/GcNKibUh1j4zCBtJjGPUhV9kPSqqzhR9HK5+Gdplx2v
         4xUFFzMEEC3LKQNEuF00f6UbLeqxSBhX1N+hEDgiirGXJqxjpUZG7g5pn5iiCSHwdL76
         XQGhdevZ7T6zfjHIECxwTo/oCXQMCmAmZQ0VdswzO2kYIiIAnZK3KqWjAIQ5URfxJHBl
         OHF84giOeCoadHjuoicuc927ncNvap6ANjahQPbvtHAxM7cJMN9OYbjk6PC2DGogcqx8
         sfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tSv0N+buuXcfO2cMmMhlzp2LfygH9vWetg+buoM6+PE=;
        b=udHzXEL5AAQLOIP5hqEC1G7Gnd49hJKFiYQVjpTUdw1B6XuG8NzY1Cwo6xeEOCxVfY
         sDnBumAULsu0N13+cq3gBNc5ynZWetVGhqMGAmCiLT99qqGFzK1UA8sH9bCuyVL/MjMm
         GKnOvArkbHJnpEKH4FkXKRKwnh2IK/2Z5IAw4gSGX3yuWb6jp/Ckxh8Na2JkKhr4SPR6
         XFiZpMISOXw8RsO/qsXaDt09OsdvLfLYiGzbQAyFFqXOCXbCffp7nDJR/M2t+zsCfobO
         RVx5QnF7UCU/meFG+lAGfCZFteWyYIiBjhsV/GuNSeQugorxaDcChErfiCqEUFCXDpS4
         JFrg==
X-Gm-Message-State: APjAAAWYkpRbHp41nobfFtvCR0T1khwXr00hellTeM+RPPGmdjHjVTOw
        N+z0qehswm/jHBIxQv55BXLTEo3IOjS4Hw==
X-Google-Smtp-Source: APXvYqzjn12vozHs0fboLhCynVya4jjSWy7VPGJi4K0jd3nYUa/1Jg07U9WJB9Et0BNhCKglVhUt/g==
X-Received: by 2002:aa7:8a99:: with SMTP id a25mr3007540pfc.127.1565088483835;
        Tue, 06 Aug 2019 03:48:03 -0700 (PDT)
Received: from SC-GAME.lan ([2408:8256:3084:b0:885f:efd1:c65b:ab81])
        by smtp.gmail.com with ESMTPSA id v63sm89417888pfv.174.2019.08.06.03.47.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 03:48:02 -0700 (PDT)
From:   Chen Minqiang <ptpt52@gmail.com>
Cc:     davem@davemloft.net, Chen Minqiang <ptpt52@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipv4: reset mac head before call ip_tunnel_rcv()
Date:   Tue,  6 Aug 2019 18:47:31 +0800
Message-Id: <20190806104731.30603-1-ptpt52@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Chen Minqiang <ptpt52@gmail.com>
---
 net/ipv4/ipip.c | 1 +
 net/ipv6/sit.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 43adfc1641ba..ba2b5fc8910f 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -242,6 +242,7 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			if (!tun_dst)
 				return 0;
 		}
+		skb_reset_mac_header(skb);
 		return ip_tunnel_rcv(tunnel, skb, tpi, tun_dst, log_ecn_error);
 	}
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 80610899a323..44a9674d06a6 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -739,6 +739,7 @@ static int sit_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			tpi = &ipip_tpi;
 		if (iptunnel_pull_header(skb, 0, tpi->proto, false))
 			goto drop;
+		skb_reset_mac_header(skb);
 		return ip_tunnel_rcv(tunnel, skb, tpi, NULL, log_ecn_error);
 	}
 
-- 
2.17.1

