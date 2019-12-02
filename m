Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F73A10EF93
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfLBSyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:54:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44948 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfLBSyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:54:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so421553wrm.11
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=DQJ1grk3fubDUDRNIt4KhApuKumbTnZSajmxJ9nBjaFEFM6B58uU2dOog+9u5eBG6n
         E8+NBcrHwayofy0fSgbIfVGUfA4mm+SFogkgbrPJDLSVgAFPddW3P8NgvbWrK6x6WF1E
         Xuhf2NPJoZ2pQcJfT1VTkKtp3fJLjfyLg/TiPPyJpTs8VD7Yrnwxz3ivGxqmLswZ3+/9
         WrBTDjAs+Z+c9A5wLAZmg0hvWkZpHKtCLidQnATwSA42ELCzQxp1HLUvvcuJNxTSb/En
         qi7LcMjeBtQhBqXFbONdafq6gpFVVzzwDYgkx6fxIV+idaNOfq7FzoGwVwZVPggK/tit
         OA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=dIcfe4WIf9YhK5NMloZt+35+dZSWk26ix1ZKPrqgRPz3DgrF+nCWWMy1esuaSwrqw6
         iDSYhFLR916rfrQ3Bh1G+ojqxCxO2xrNFMVR7r3fKvBJh4z26/E07FbfvVCrxDpONpCA
         w3HKbLrebl+snMDww6f1d8YptqtR7w3ASrm050Nmkfr9P2t8zfpnUUKyE03pxydIbF8Q
         ZHw4huCIzEDKLcu0B/5kvruK/E/aXl3aK7GYTmfJ3vorNd/ZGhXq+zSWlq+DKoHXTkfi
         g13dY33hrQ27pPs8ohwZPmJr49MbyDgqc299HiNwUi58by1U0/oLsh5AJmt5J4TsD0ve
         k9/A==
X-Gm-Message-State: APjAAAVsTAGbJNbeOoE3UFJz0Mt9KYtLvy3SND9jT38hNNt2j5N586BE
        wTe8kBylpirwLoreIGzp9MMFFw==
X-Google-Smtp-Source: APXvYqx1ZGRENX56qCtXtMhoJ7rYkDTJZ6IjBtbYyorxB3w5aIoh6cn+ggq5mollvDJybTecVRH4jg==
X-Received: by 2002:adf:d848:: with SMTP id k8mr458638wrl.328.1575312887566;
        Mon, 02 Dec 2019 10:54:47 -0800 (PST)
Received: from localhost.localdomain ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id c72sm376580wmd.11.2019.12.02.10.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:54:47 -0800 (PST)
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, fw@strlen.de, rocco.folino@tanaza.com,
        Marco Oliverio <marco.oliverio@tanaza.com>
Subject: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Mon,  2 Dec 2019 19:54:30 +0100
Message-Id: <20191202185430.31367-1-marco.oliverio@tanaza.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bridge packets that are forwarded have skb->dst == NULL and get
dropped by the check introduced by
b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
return true when dst is refcounted).

To fix this we check skb_dst() before skb_dst_force(), so we don't
drop skb packet with dst == NULL. This holds also for skb at the
PRE_ROUTING hook so we remove the second check.

Fixes: b60a773 ("net: make skb_dst_forcereturn true when dst is refcounted")

Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
Signed-off-by: Rocco Folino <rocco.folino@tanaza.com>
---
 net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a2b58de82600..f8f52ff99cfb 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -189,7 +189,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
+	if (skb_dst(skb) && !skb_dst_force(skb)) {
 		status = -ENETDOWN;
 		goto err;
 	}
-- 
2.24.0

