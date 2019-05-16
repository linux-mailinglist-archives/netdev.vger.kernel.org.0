Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8A2105F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfEPVyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:54:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43416 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbfEPVy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:54:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so2521403pfa.10
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 14:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1E3N0zT9A+r2im6QpOgDPD+XgR8M/OLuBEDLlf3Z7+c=;
        b=gHkbTo/dzg62EsHuFOEqzE4zD0Awx6QMgcAVIz/QDckgP8FbVYM+OnrKQVNxdWE0gX
         QKCSUSA/5MtU2Sh8txLOvLtyG4AbSahniQnaAFLf/nYHtbFzkha6QBUUHIwqdaAQ4Kgk
         1deRntqeIqPhsdF+aTx7HcXFte1XoPJz3t73ctR67DoLXakKCZLv/0Fvy4UTaf48V38i
         Qg4zypj/7GDSaP8zDKz2rHdFXDEB4hsddy7VtJ1Yu/ZTEN49nhygcMkJCpvXO+L2Z5pw
         tCDFBuEKrBZaZMCL2KnVBs5qRKvhGlpGEP/Pss70wox83tzVtngnivANiEWDIb2Bt53s
         z9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1E3N0zT9A+r2im6QpOgDPD+XgR8M/OLuBEDLlf3Z7+c=;
        b=C12u8w6fjGcQ+AyIZ4iLkE/YYpuKcPrDJb0OHWboBx4iveEtT50eoLyj+ofk3cGV/p
         Xfc0v7zTjN1DbkmGBAFHQtHNrQ8XNs5Exd4eBzrYZkpW9Qg61jfIk2zMn+M/0Ql0Q0va
         g1EA3VnFN9Zh4fcstFQ3Zp1iy4fec0gdV1/sTbmphHpray2JBCcu0R/2qWokVauhLche
         QfbuZYJwwnL5YG+YB8oytBrNZo23LHywllK25Rb52Ixj8oB0t4dH9slYQ18dt0Lalfyq
         N6boAsCsj9mqfSVGXvgjhFFlMWu1GX3k7Uxczf5dswHBPeTLHlN4PTKeEc2QAdjSfDZN
         Sdrw==
X-Gm-Message-State: APjAAAXWmzX3daLCWsdfMH7IJ5vgicP4Z3K4alEyBhFezpagLcyTnKlC
        5ee6t4z28fLLwxbJHdMn+NlBHQ2R974=
X-Google-Smtp-Source: APXvYqyFTs+tyVssS57cMOZTZJEMcnxAqM0IxUaMpyARtuJ/MrI3oWy5+iENt2ct906kPow0o/zKJw==
X-Received: by 2002:a62:528b:: with SMTP id g133mr56806059pfb.246.1558043668893;
        Thu, 16 May 2019 14:54:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d15sm19842506pfm.186.2019.05.16.14.54.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 14:54:28 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net 2/3] net: core: generic XDP support for stacked device
Date:   Thu, 16 May 2019 14:54:22 -0700
Message-Id: <20190516215423.14185-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516215423.14185-1-sthemmin@microsoft.com>
References: <20190516215423.14185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device is not called.  In these
cases, the rx handler changes skb->dev to its own in the receive
handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
do_xdp_generic if necessary before starting another round.

Review of all the places RX_HANDLER_ANOTHER is returned
show that the current devices do correctly change skb->dev.

There was an older patch that got abandoned that did the
same thing, this is just a rewrite.

Suggested-by: Jason Wang <jasowang@redhat.com>
Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 net/core/dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 108ac8137b9b..9165fd3c9e90 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
+			if (static_branch_unlikely(&generic_xdp_needed_key)) {
+				struct bpf_prog *xdp_prog;
+
+				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
+				ret = do_xdp_generic(xdp_prog, skb);
+				if (ret != XDP_PASS) {
+					ret = NET_RX_SUCCESS;
+					goto out;
+				}
+			}
 			goto another_round;
 		case RX_HANDLER_EXACT:
 			deliver_exact = true;
-- 
2.20.1

