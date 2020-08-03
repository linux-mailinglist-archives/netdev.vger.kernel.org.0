Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38F823A094
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgHCICp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHCICo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:02:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6780C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 01:02:43 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ep8so1635565pjb.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 01:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDpBvbyHoZnWo1Mi0A0SayAq++pz41CsV9IZlDr/PRY=;
        b=cZBgth8zXXI/TK8UKYrTpzUjeduZVYn10XHx72Kv5JoE+W4M56/Cg/5r4C0dsw4ZdA
         KABjm3zKF1KJulM2Ih+FOGTYFHn+NG2bB56WKwry70qydOgSh9tKiLefz/xL3Nz89rvd
         R8hfJa71YKNGw4JU/jGrnYAQ3wxPR7JbRRiHSpuqeub40+SiwfSPPFY4VFrUyRWMZ+J/
         2VXENVwWxJ+2y0ALcN/NfE0WZJdBetLm12wkVdi8QdBbbB3Xr9Rov68HI7IBlKo/hVSc
         TiYV6isVK1/tf4CdD1jdVVq9fuDcqupk1uzySRYT0ekc8KiC3CEJjoF1eB7GORvicsFn
         RJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDpBvbyHoZnWo1Mi0A0SayAq++pz41CsV9IZlDr/PRY=;
        b=YXSD5jjPacYULSqpuZ1yx9DXxFaESQplZwKdd59TnX66JI1d3yVppEjSdhBsqcU6Q3
         gaHXrvp7xA7J9dPgO0vXlNB9kDQxRwqBirxvanVRlFnRS3QmW6xKHGJBzkVV0o5m/Som
         pd+j+kg4hBjCze2k4YKsdV9lphhv2MzXxUP1i+1miGzGhi/vUgV8VtcrpRL4kpWVMNlK
         pWr0EN+lj/++u3qhA0kmJtayA9LJYHjReybhtxJP2jMUpx5TuAmcjmnyf8I0o4RYv6P0
         o6HCPiVBsjENfv4xRaC7bI/202wQlfxiHVbAJ4YpX27yARgK83Zl4VOPx851+xMWsrT5
         7s9Q==
X-Gm-Message-State: AOAM533voJN/zxXkYFM30JlN+uzTytenKwQUcLUJNo1tDxj0IfyidTgq
        UxOPdi2e/OKdcfWtINwnmwDM5pgKjid0OA==
X-Google-Smtp-Source: ABdhPJyxLL8TB00Eu2TnHAAFPlWZCA4//T5NmgqBGJtslBM01E7XzjvYbdZ5VIR7Mv7u3EDe2zhaqA==
X-Received: by 2002:a17:902:b594:: with SMTP id a20mr6047959pls.339.1596441763019;
        Mon, 03 Aug 2020 01:02:43 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm18651674pfg.113.2020.08.03.01.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 01:02:42 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 2/2] vxlan: fix getting tos value from DSCP field
Date:   Mon,  3 Aug 2020 16:02:17 +0800
Message-Id: <20200803080217.391850-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200803080217.391850-1-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 71130f29979c ("vxlan: fix tos value before xmit") we strict
the vxlan tos value before xmit. But as IP tos field has been obsoleted
by RFC2474, and updated by RFC3168 later. We should use new DSCP field,
or we will lost the first 3 bits value when xmit.

Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 77658425db8a..fe051ed0f6db 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2722,7 +2722,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2762,7 +2762,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.25.4

