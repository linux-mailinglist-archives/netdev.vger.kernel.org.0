Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2A267683
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgIKX0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgIKX0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:26:21 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FBBC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:26:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o8so15792530ejb.10
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hQBI1fMuU3dlgonskq6rOt2L1hM6mqPMtoblrqaS+I=;
        b=KW480HP999jLPF70vElITy92/FIST6ek4RLOBYiPYt7yOWEje59Y2i4ySIVNGm3sHs
         E/cvZNwu1q4pMdHff1efEOn+SOXuiZ/F+yCebSaC4YS0EV4940BMFq4xPGtvKMOBnMpE
         4N812q+Ux/kz4M5oLYs8L3AeiSFLV8uvZ7d572BjU0q6QIrl4PuCzxz1PPvlTmrOX4ny
         HTbuqG0Npmk5ZjelvieOUk7CfxYGwdCm3EKF0l8JwDoi3pZgyGVs0E4ju4OLXN9L3BkW
         g5GB9oVFoUwtMdQoW7X8jhaMSrI8Beggu6efT+O1F7hyctB5WFhIp0iqY0XYLgndsmhq
         zltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7hQBI1fMuU3dlgonskq6rOt2L1hM6mqPMtoblrqaS+I=;
        b=RvD16zWBLhWaTZL/hMwDfuvfdOvzIV0YDELGFEPELRz+7uBOIDvp1P9Nl+v8GQJZ3p
         UGi9ZtNdUAQGKH0WrtsMap1DJ2bQ3jb/IlGSgtNHQVOrspjtPLCO4P/Xx9/yq/FUm23c
         I1ve3LHVxF93wtYDn8UgTm1vHaDq42xDw9w1vmde4cR8gfQFqU2ZPT9EKQUSyOJq/uTm
         ofc1cTnoC+oSlal/FwVKaz1URtnN88+BwbeLjLGAJ3SjBIQ6KGse0SrDsUz1gpi2kn7u
         1zeeDP8y4Z9w6ICT0qaYZ/DEinVpqdt/XV+zkuLlAmtwnxCAW6sSucJJLzTP8tRMk8rp
         HOlQ==
X-Gm-Message-State: AOAM5304ZyZ2F8KPe1/MhQCFqbfSl/HZS6Z3JnLYAwx2FlBslfnk4eTF
        SzPssmomV5e5YyJKwzaKZLY=
X-Google-Smtp-Source: ABdhPJxiuUMXceLAPHcVR4tKaN0QGeHO5lSZ4cYLyHvp1a1cyzEH2EyOBZAd4+SfeIv6Gm/8FoPV9w==
X-Received: by 2002:a17:906:c0ce:: with SMTP id bn14mr4381543ejb.422.1599866776008;
        Fri, 11 Sep 2020 16:26:16 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id r16sm2962580edc.57.2020.09.11.16.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 16:26:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        willemdebruijn.kernel@gmail.com, edumazet@google.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] __netif_receive_skb_core: don't untag vlan from skb on DSA master
Date:   Sat, 12 Sep 2020 02:26:07 +0300
Message-Id: <20200911232607.2879466-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A DSA master interface has upper network devices, each representing an
Ethernet switch port attached to it. Demultiplexing the source ports and
setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
packet_type handler. Catch-all because DSA vendors have various header
implementations, which can be placed anywhere in the frame: before the
DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
handler acts like an rx_handler more than anything.

It is unlikely for the DSA master interface to have any other upper than
the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
is very likely that the DSA master will have no 8021q upper. So
__netif_receive_skb_core() will try to untag the VLAN, despite the fact
that the DSA switch interface might have an 8021q upper. So the skb will
never reach that.

So far, this hasn't been a problem because most of the possible
placements of the DSA switch header mentioned in the first paragraph
will displace the VLAN header when the DSA master receives the frame, so
__netif_receive_skb_core() will not actually execute any VLAN-specific
code for it. This only becomes a problem when the DSA switch header does
not displace the VLAN header (for example with a tail tag).

What the patch does is it bypasses the untagging of the skb when there
is a DSA switch attached to this net device. So, DSA is the only
packet_type handler which requires seeing the VLAN header. Once skb->dev
will be changed, __netif_receive_skb_core() will be invoked again and
untagging, or delivery to an 8021q upper, will happen in the RX of the
DSA switch interface itself.

*see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
network devices". This is actually the reason why I prefer keeping DSA
as a packet_type handler of ETH_P_XDSA rather than converting to an
rx_handler. Currently the rx_handler code doesn't support chaining, and
this is a problem because a DSA master might be bridged.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 152ad3b578de..952541ce1d9d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -98,6 +98,7 @@
 #include <net/busy_poll.h>
 #include <linux/rtnetlink.h>
 #include <linux/stat.h>
+#include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/pkt_sched.h>
@@ -5192,7 +5193,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		}
 	}
 
-	if (unlikely(skb_vlan_tag_present(skb))) {
+	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
-- 
2.25.1

