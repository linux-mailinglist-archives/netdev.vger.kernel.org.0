Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C5923AFDB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHCV4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgHCV4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 17:56:10 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F29C06174A;
        Mon,  3 Aug 2020 14:56:10 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id h7so36631752qkk.7;
        Mon, 03 Aug 2020 14:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bJNY2GB8OkKmcGCaNAJSseuUbRBXSJYrDDnkmcwiQfc=;
        b=nD4wYT2WIc2tj9H/jyl8+DoslLgGToJrc2t4eV9i5JrbXO0T95qqB1MPxMGuSj2lyq
         RpZ1UGYajTTkQ5P+CgYElEXe5oM+WgOHsxTS/OH7gy8ISe0vXPSOXXVm9CgcjhxA9Sfb
         MEkE+vMguvFPvGFonFLZL9RofezVHVYRdnGu0644asVPZKILP9Zs3xOcxEGu9orX9ooz
         n4nsN2RPy8TJIzZdseSiecjuWCUujo/on2mMizbU8OGeJHpClICj/+qom77/oPlT6zxL
         1W8BBFZe3Lo60yrjdsbEE4oZSXyveHMw7qGCMBa9JRLuTlksV1znawOW7aAOd/RcZXC0
         065Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bJNY2GB8OkKmcGCaNAJSseuUbRBXSJYrDDnkmcwiQfc=;
        b=PU3Zt/Z5QeDEgKsDPMhyHYC7TCVlfWwgB0i3tT26Eq+voveZwx3SvMQL40Lws98Frd
         lqKnnGwvKRo4e0xskQwoyLWgSFPLJUt3DH8sX8HfGZ/v8aIGIUAa8JIn28udrYN/HYMn
         J/OX58PF3tDPb6UbmivbKcueyKvqcR3IA6dFBXfYMezxcZ7Ldr9HMqCirtHXYmQuXzFr
         Qt7oKUi5yI3aVAs37Jpu0bF0PQt3YpsiMvg2DNgwy/Nmy/ucMM7q+NgzdpcHGNWYDbE8
         LiPmJbWuxsazsU+hMsbfj9r2XI2wG6TkKIB2AfCOZaP3gB6C+SCEubwDI7xbh3385Zhq
         bDbw==
X-Gm-Message-State: AOAM530veG8gH/UxGfjbDe7teAQ0fjsjh/0Dn+wDLinNjX6NYCAEXVL0
        /Sir6lXbhPFjqjqnE5SSnoKhWP4=
X-Google-Smtp-Source: ABdhPJyjHekKIs/WKgNZM3UHQbuPZU0LBOPLHZ+lUtZsoC/le44kqsTcV/iSi8cYur0EwGVG6yCtXg==
X-Received: by 2002:a37:a45:: with SMTP id 66mr18731744qkk.435.1596491769093;
        Mon, 03 Aug 2020 14:56:09 -0700 (PDT)
Received: from localhost.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id m17sm24629779qkn.45.2020.08.03.14.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:56:08 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian
Date:   Mon,  3 Aug 2020 14:20:01 -0400
Message-Id: <20200803182001.9243-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On big-endian machine, the returned register data when the exthdr is
present is not being compared correctly because little-endian is
assumed. The function nft_cmp_fast_mask(), called by nft_cmp_fast_eval()
and nft_cmp_fast_init(), calls cpu_to_le32().

The following dump also shows that little endian is assumed:

$ nft --debug=netlink add rule ip recordroute forward ip option rr exists counter
ip
  [ exthdr load ipv4 1b @ 7 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x01000000 ]
  [ counter pkts 0 bytes 0 ]

Lastly, debug print in nft_cmp_fast_init() and nft_cmp_fast_eval() when
RR option exists in the packet shows that the comparison fails because
the assumption:

nft_cmp_fast_init:189 priv->sreg=4 desc.len=8 mask=0xff000000 data.data[0]=0x10003e0
nft_cmp_fast_eval:57 regs->data[priv->sreg=4]=0x1 mask=0xff000000 priv->data=0x1000000

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 07782836fad6..50e4935585e3 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -44,7 +44,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		*dest = cpu_to_le32(err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
@@ -141,7 +141,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 
 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		*dest = cpu_to_le32(err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
-- 
2.25.1

