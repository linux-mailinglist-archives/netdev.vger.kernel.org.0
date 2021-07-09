Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622453C287F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhGIRiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 13:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGIRiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 13:38:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C203C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 10:35:39 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 21so9361003pfp.3
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 10:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S5SiMg/tRntXHdAPZChqgmTx740vzNob6DQjOConvmY=;
        b=upBCHglZFRpPq9QIg419DsVIJx1QsWcKYeAZPeZQPizft4AcfxU8YErnmN5DMJzW8w
         eVEEzGZrtx3jEkfZ9CkWcxe7myFyLxlObQMGrRSjqb9RfXBjmnhBjpULYILF50LqClQz
         rO6qysE8AOFhYddDIpmVovE5RuBz5VtDvV8muTwq8Xi0p0X7sbKHzJpAL+cuYXclzwYp
         Pj8cg3Wh3JPSmPxxfw6fxZuWJVKYpJ+EPIYIhTn5JvP6RVHVT0L4gd1nIvcx0soLaMxM
         9juCBJQCgl2I2j9VILUzHyp5jDdau9cHCdoflaf7PXvaN2AezAlQrafsMstfpEjkHZy5
         1DqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S5SiMg/tRntXHdAPZChqgmTx740vzNob6DQjOConvmY=;
        b=X6NayzjZDd80noKWGWKUs4eOqDSKk4Xy6eGI1z688wlflTTEVtL9t5sGNvC7MUJowa
         ACUmYkzMy9uGQlCj17ggMR3OjcCko4OTI0g+hqrevZPSmOW7rM5msq0GLjMNhrxqdxNS
         L77AkUXE6fMq782H8x9vhXA2S4ydSGvzp78fQZcU6M7sJfcG9XZbXSt4RyFxY24A3W7D
         kn48JAmJam3n5lRns8mEKiXnUETOnm7OdqT3j+5CM5Q4wu+TW+9+neni96y+a6ittrRE
         TzVTaFJXmU16X71zex9YJgvMxIobejabZzuEVlEdRhHvedJA7YHT5e0sE1EXf+YUcLTW
         Lt0A==
X-Gm-Message-State: AOAM530GC+CBipISCabpnEO9r5HFolitqjk323/tOpSYaKb6BWSvtG0K
        XiBjYJi7hujx2guH2coZfEM=
X-Google-Smtp-Source: ABdhPJzFZgSIJVnO9bmD6oCtdehOpplke0I0sAY0GmnyWeGFkX1maiFtGBG96IamryreUy2/NWSKtA==
X-Received: by 2002:a65:6217:: with SMTP id d23mr1446363pgv.105.1625852138436;
        Fri, 09 Jul 2021 10:35:38 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id c20sm7256168pfd.64.2021.07.09.10.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 10:35:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, tgraf@suug.ch, roopa@cumulusnetworks.com,
        jbenc@redhat.com
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: validate lwtstate->data before returning from skb_tunnel_info()
Date:   Fri,  9 Jul 2021 17:35:18 +0000
Message-Id: <20210709173518.24696-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_tunnel_info() returns pointer of lwtstate->data as ip_tunnel_info
type without validation. lwtstate->data can have various types such as
mpls_iptunnel_encap, etc and these are not compatible.
So skb_tunnel_info() should validate before returning that pointer.

Splat looks like:
BUG: KASAN: slab-out-of-bounds in vxlan_get_route+0x418/0x4b0 [vxlan]
Read of size 2 at addr ffff888106ec2698 by task ping/811

CPU: 1 PID: 811 Comm: ping Not tainted 5.13.0+ #1195
Call Trace:
 dump_stack_lvl+0x56/0x7b
 print_address_description.constprop.8.cold.13+0x13/0x2ee
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 kasan_report.cold.14+0x83/0xdf
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 vxlan_get_route+0x418/0x4b0 [vxlan]
 [ ... ]
 vxlan_xmit_one+0x148b/0x32b0 [vxlan]
 [ ... ]
 vxlan_xmit+0x25c5/0x4780 [vxlan]
 [ ... ]
 dev_hard_start_xmit+0x1ae/0x6e0
 __dev_queue_xmit+0x1f39/0x31a0
 [ ... ]
 neigh_xmit+0x2f9/0x940
 mpls_xmit+0x911/0x1600 [mpls_iptunnel]
 lwtunnel_xmit+0x18f/0x450
 ip_finish_output2+0x867/0x2040
 [ ... ]

Fixes: 61adedf3e3f1 ("route: move lwtunnel state to dst_entry")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/dst_metadata.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 56cb3c38569a..14efa0ded75d 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -45,7 +45,9 @@ skb_tunnel_info(const struct sk_buff *skb)
 		return &md_dst->u.tun_info;
 
 	dst = skb_dst(skb);
-	if (dst && dst->lwtstate)
+	if (dst && dst->lwtstate &&
+	    (dst->lwtstate->type == LWTUNNEL_ENCAP_IP ||
+	     dst->lwtstate->type == LWTUNNEL_ENCAP_IP6))
 		return lwt_tun_info(dst->lwtstate);
 
 	return NULL;
-- 
2.17.1

