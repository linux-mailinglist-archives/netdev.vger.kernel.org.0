Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303B612E460
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgABJYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:24:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36819 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgABJYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:24:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so21627915pgc.3
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 01:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2IH9WStj1rdeyfsfmC5g7DkdrKHSQ98yL1eZh7F0lzc=;
        b=s4KwDGUAS24xZdNjn1mIuuoHXEeYB+s9+aLkXKJl87vYe1qxwJpjUchVYu/uwVQIGu
         katOy+oR860Lh1WxWjP/f0LfeHKtpUXwiSlaVr3QWVA/mP5TXTOMBuXaoA2p6sP5Nl1k
         XFfWia0Z1uRiNbHcQFe5Lv095iZaJcfYt+GUF1ZJtXdC3/QM7tRxED9Jhw7KEs5fAb3R
         FYojcqf6ez0rrSlqy9zg7SdEEZGESUnuYEJMpohLqxERPPTe89Y54XH2w80paEu2Eu0v
         WcSHjonvUOgv52nQCEbYblhHU96oRzcRU9yDVEJuAeAOq37omFx85JODyjhsW2yuCTL3
         SQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2IH9WStj1rdeyfsfmC5g7DkdrKHSQ98yL1eZh7F0lzc=;
        b=IhGayMUMD8P4DoOPVcAuu0IgR67dSjjKHCxc5VVRvFFTqa6MQMga+sExPCm+8VHGs7
         7HAoiUPMFPkdsxpfZF6nxPf1cM4B7BYUGJW+I015i1/ah6ydtuFxiBYuc2SBIzGdCqPX
         Fx1/POZj+HluZYKd/HYj0cuHPYjxD8npinr1RTbu5MBK5ET7I0Ey/XIpF/XKvuRu8Vv7
         5un+K5x9Ui9n+MJjwR86/gUYekNPTHpvN87Cl0q7sRZYW5RS/KTNqhPf2hcWbhk2luyK
         dlm9bM+PCo/MA9RD21cfzPMQfEhbJ5/pvoAvQCV2sDQADINLqn0TdUsF62xKSAATrzQc
         tARw==
X-Gm-Message-State: APjAAAUAAgr64iw2fO03MAKhgworXHqg8awK7AhSQsm09ZbF1avGs3Aj
        Inr3KZZZQ6yjwT4K2+Vuq3Nxv/2afeg=
X-Google-Smtp-Source: APXvYqwVbpne9kZ2OZk6b9rje5IyP7Ib5RPFqSoEviFXKMsf85kcCBP+1WiFkOu0vUpDGW+6H1bNbQ==
X-Received: by 2002:a63:1f21:: with SMTP id f33mr89504101pgf.91.1577957042049;
        Thu, 02 Jan 2020 01:24:02 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t63sm63481267pfb.70.2020.01.02.01.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 01:24:01 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] vxlan: fix tos value before xmit
Date:   Thu,  2 Jan 2020 17:23:45 +0800
Message-Id: <20200102092345.19748-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before ip_tunnel_ecn_encap() and udp_tunnel_xmit_skb() we should filter
tos value by RT_TOS() instead of using config tos directly.

vxlan_get_route() would filter the tos to fl4.flowi4_tos but we didn't
return it back, as geneve_get_v4_rt() did. So we have to use RT_TOS()
directly in function ip_tunnel_ecn_encap().

Fixes: 206aaafcd279 ("VXLAN: Use IP Tunnels tunnel ENC encap API")
Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3ec6b506033d..1c5159dcc720 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2541,7 +2541,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2581,7 +2581,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.19.2

