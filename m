Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644C7193B71
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCZJDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:03:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38851 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZJDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:03:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so1802555pfo.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XBipA4SFKoUhJ/xuuCXQMNGazAldjBhMqrG7TlX9yFI=;
        b=tvpbgnDEyRf4b8r4S864SpOHup7smxaw1zQGJ2JxETC3FKM5ge29t7rEBhFHwNhJ87
         AgNwOPLq5R87Tqzuj3D6mGKPuRyf9QYo4QnQaUv5dDqSFAYJz/xHtxWB6nEXg0bDHdHn
         FKbaIWFxJ8jhHRPjjzIdPZCHhRawNZKltkvNBjCizwjtKbLbWFVAvANY78gqXEswjqb0
         ZJdk04INVSfwxSqxTJZ70tTh0xVi6ueu3Kr0STKJ96+LvA+XyhT25DdLF09flWAOmghw
         m+t9TJB68Rl+ppqZfhTmtpRwCcBFT/LtuTx8GbbT6MTEKkgFY1hcOF6CSfLarC/Y6OTq
         XmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XBipA4SFKoUhJ/xuuCXQMNGazAldjBhMqrG7TlX9yFI=;
        b=MdckblXN/15V1IgMJXnn1SOlZpB27zO5DTKUZoFCmuj5Xit7TQnEqWai7CtGm6a2P2
         PyIn9ZwxxDJKiNqn14uCz6jlmScihZLy/TCfXVcWu+n1U4X2clTdoIgFZXwZzpEj97Vy
         qdmPVPb+brht2VB8YJ49kLcJQeGB6mDr6TUlvVAUYF4iccXJPqQ98N9SMgOnqR6BbcJy
         kRxlv4+7600ZnD9TD0hWF8+UPCYBgscjlr5wVpNAW5Fizsgrjr/VAYN1YDBWxHJp/H2O
         Ba/A5N+XxETTz94ayJscLpR/gV35o4trh/y2tQY5ee/o0vAyVzQR8pkRQCb8a76kTCB2
         vgyw==
X-Gm-Message-State: ANhLgQ1h6E0FOKO7cx1LiYN77eTSva3W3YhGPfbV144X3IF114c4TqMD
        h7O3Xtf7fe+kDhBXC6mThCJVUUKt
X-Google-Smtp-Source: ADFU+vsRiS4AFbf+U7QnN9rMa9sJgvwp8VXnrR484RwDTAezlWPquLkfIfRcbhIiMOZmc0fYrhn2xg==
X-Received: by 2002:a62:30c3:: with SMTP id w186mr7804249pfw.245.1585213399792;
        Thu, 26 Mar 2020 02:03:19 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mn18sm1140280pjb.13.2020.03.26.02.03.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:03:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/3] xfrm: add prep for esp beet mode offload
Date:   Thu, 26 Mar 2020 17:02:31 +0800
Message-Id: <c50df9e6ddc7f5211b531160189da52bc900ad8e.1585213292.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <dc705b5bbeee366e76829d3c98c1b438a7dce232.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
 <0baafba3ed70c5e04d437faf83f2c40f57f52540.1585213292.git.lucien.xin@gmail.com>
 <dc705b5bbeee366e76829d3c98c1b438a7dce232.1585213292.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585213292.git.lucien.xin@gmail.com>
References: <cover.1585213292.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like __xfrm_transport/mode_tunnel_prep(), this patch is to add
__xfrm_mode_beet_prep() to fix the transport_header for gso
segments, and reset skb mac_len, and pull skb data to the
proto inside esp.

This patch also fixes a panic, reported by ltp:

  # modprobe esp4_offload
  # runltp -f net_stress.ipsec_tcp

  [ 2452.780511] kernel BUG at net/core/skbuff.c:109!
  [ 2452.799851] Call Trace:
  [ 2452.800298]  <IRQ>
  [ 2452.800705]  skb_push.cold.98+0x14/0x20
  [ 2452.801396]  esp_xmit+0x17b/0x270 [esp4_offload]
  [ 2452.802799]  validate_xmit_xfrm+0x22f/0x2e0
  [ 2452.804285]  __dev_queue_xmit+0x589/0x910
  [ 2452.806264]  __neigh_update+0x3d7/0xa50
  [ 2452.806958]  arp_process+0x259/0x810
  [ 2452.807589]  arp_rcv+0x18a/0x1c

It was caused by the skb going to esp_xmit with a wrong transport
header.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_device.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 50f567a..fa2a506 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -46,6 +46,25 @@ static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
 	pskb_pull(skb, skb->mac_len + x->props.header_len);
 }
 
+static void __xfrm_mode_beet_prep(struct xfrm_state *x, struct sk_buff *skb,
+				  unsigned int hsize)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	int phlen = 0;
+
+	if (xo->flags & XFRM_GSO_SEGMENT)
+		skb->transport_header = skb->network_header + hsize;
+
+	skb_reset_mac_len(skb);
+	if (x->sel.family != AF_INET6) {
+		phlen = IPV4_BEET_PHMAXLEN;
+		if (x->outer_mode.family == AF_INET6)
+			phlen += sizeof(struct ipv6hdr) - sizeof(struct iphdr);
+	}
+
+	pskb_pull(skb, skb->mac_len + hsize + (x->props.header_len - phlen));
+}
+
 /* Adjust pointers into the packet when IPsec is done at layer2 */
 static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 {
@@ -66,9 +85,16 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 			return __xfrm_transport_prep(x, skb,
 						     sizeof(struct ipv6hdr));
 		break;
+	case XFRM_MODE_BEET:
+		if (x->outer_mode.family == AF_INET)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct iphdr));
+		if (x->outer_mode.family == AF_INET6)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct ipv6hdr));
+		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
 	case XFRM_MODE_IN_TRIGGER:
-	case XFRM_MODE_BEET:
 		break;
 	}
 }
-- 
2.1.0

