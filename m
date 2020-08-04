Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5347823C302
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 03:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgHEBUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 21:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgHEBUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 21:20:21 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF663C06174A;
        Tue,  4 Aug 2020 18:20:20 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l64so33499836qkb.8;
        Tue, 04 Aug 2020 18:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0GIrQ8itFhpZvTb41Thq1WjSb67rtxrKB3Dhx4CAxA=;
        b=jWW/SUs+JMYPMrE29BOBZ/90sk76mm5HdxR53NnmuPi59a9/BgcQmEuozCdwo9CJNi
         okg0lfO9/djlvgLYOX9rpeF8lZ/+TQbBYf7DDO38Zbcwm555ovR2/ctuzbMFNhJvJmFx
         mRTW3E0U55Lv+nh6jNfarWsu+TAblzCxvgoHoj3OF3+0SLPEqpI2z2SR9/XjJ+WSbf2N
         o8MKE/EOYx3NUDlCJDsiDj1hfllmz1vmFoNYa0voIuGQ/LWXN1ALReBjz2UGhZoe7him
         Zik/TOYIoNNT5kLD1tqMpgeFQvSFtuI5SqDwkETBj96K4gogNiT2sNPOiZJ7Cm9vbjyE
         ZZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0GIrQ8itFhpZvTb41Thq1WjSb67rtxrKB3Dhx4CAxA=;
        b=b8Z6nuUfWf+7gdPSmkfx+ODuyquQ0JTR/y2dIo3F0avemYI0jRh0NSYOcsssFTJ46D
         yQ7WKT18CrKPFcpA9XbAoDBckP2hqe//P+NKFf3+oEuIZj8Ii/b/E1KxYnVXTw8EuCZE
         bbCjpj5e44w31te6CQlEL/yq1BD7W4Hpb5y3OJjIFrZVpujQK5WOSUHGHwChA4qsA2Yx
         KX5ZH3nD8BNvBDtxJTi3S+ZyW+wkGHu8t5j4lFTyt3jzl/pSrzk7SVtf+eDFxI/Vnwaa
         5jhDFYRF1uVKYhh7ePXaNKOhARVbsoizWaQVQ0O47M0vhgzVdz50AEKJAhLtFDV7WQHg
         ujIw==
X-Gm-Message-State: AOAM531cN1bXHDSC41Ua2pAjbBa7m4WA2cM+GVHu+e2Pzl1/kG6Mb5Rz
        +VWeDFqyCfdzZWsQaDLlig4SAQw=
X-Google-Smtp-Source: ABdhPJz5+svKzjxbguGfY1yf7b2aWwIs983WfjMIFeIXJqzSSeUHsvqvlB+Iv7TgK+nCGsAbpxg+eQ==
X-Received: by 2002:a37:9701:: with SMTP id z1mr1005337qkd.61.1596590419872;
        Tue, 04 Aug 2020 18:20:19 -0700 (PDT)
Received: from localhost.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id z72sm431148qka.107.2020.08.04.18.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 18:20:19 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf,v2] netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian
Date:   Tue,  4 Aug 2020 17:44:09 -0400
Message-Id: <20200804214409.105658-1-ssuryaextr@gmail.com>
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

v2: use nft_reg_store8() instead (Florian Westphal). Also to avoid the
    warnings reported by kernel test robot.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 07782836fad6..3c48cdc8935d 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -44,7 +44,7 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
@@ -141,7 +141,7 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 
 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		*dest = (err >= 0);
+		nft_reg_store8(dest, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
-- 
2.25.1

