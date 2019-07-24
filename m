Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6161C74106
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfGXVr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:47:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34265 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXVr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:47:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so48555182wrm.1
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Vlda9c7KETvEGQsxjXjGpWIbBtg5qtO61aZYGqevnio=;
        b=GUXM3ArOvBVEWJdL6pgvL3DfV17PRDOW+oqx+fKU232DKRxvpHsrbpUC9GYeIN4q4a
         6IqWnEFJLqDz37tKpIzeradkLok928luTI7YUf9TYiS7GRIPenm+eaKvR/z721AWypZM
         BKBTn5DLhJIyBjC6P9BndFZ3itZ4G3jCMopUSORmIc5807FhSZXD1eYFEo9zQ+4AF49R
         W99QpxM5b6bHrhKhOQuqbfvYnMCYv83B7xaY75KA0QUbYg93Wd/kVhPVHDvYlVGYXpru
         SJFDziOrFrpJyIahkjRtXBBQOaHCKsH5iFiZ49Phgk/ZtM5ED4r0nkifwmc77YfI06SP
         OQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Vlda9c7KETvEGQsxjXjGpWIbBtg5qtO61aZYGqevnio=;
        b=hQ1YH1kiotAB57518do1/1HzNBHAJp8rjsZz68uq0a/sMXoZlTtLs/q8QI11Y679zW
         qCu8um2DVYbqA58SrHT/f8+u2yM/3rX/z5evTJa2l0aKT3sSft81rbdv5YwQhGNRtUom
         mHXYoNnRnZ2i5N2yccpY0WZzAH3XBdtzI5MxezBcR63eXhyaaZWM2mES0hU1d3UIGGLT
         11qx4E+k2Qb5YZxmsI+jzBgXQ6G+m4z+xsP2yqosd/niOVCm+jgCI/rbYeBORIN4suHJ
         FDmg/02w6ZbDae09cCbe2lXHQ62abUkWZQfbSR6EYcVeCH/gCSTpiRLeGEkP0nimYLyJ
         EeOw==
X-Gm-Message-State: APjAAAUXyQRI5AyySS4B47Fsz9Kc1kN2DpcfCHUWwdm3RXJ3GLSPN8wP
        F7Y1O81azCxMbRQX1WUmblH9KSvv
X-Google-Smtp-Source: APXvYqwdAXylPi+y1fktiKIscVlrf7xtrn0z7NJT3xblEStYYHHpC6ycU8IWHxNdKHIvCkVcrNFN6g==
X-Received: by 2002:a5d:4e45:: with SMTP id r5mr91570956wrt.206.1564004876880;
        Wed, 24 Jul 2019 14:47:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id z6sm41960104wrw.2.2019.07.24.14.47.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:47:56 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC net-next] net: use helper skb_ensure_writable in
 skb_checksum_help and skb_crc32c_csum_help
Message-ID: <d5791755-5b1e-6dc6-fa9d-da3bb0353847@gmail.com>
Date:   Wed, 24 Jul 2019 23:47:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding making the checksum writable we can use an
appropriate helper. skb_ensure_writable is a candidate, however we
might also use skb_header_unclone. Hints welcome.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b261..90516a800 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2939,12 +2939,9 @@ int skb_checksum_help(struct sk_buff *skb)
 	offset += skb->csum_offset;
 	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
 
-	if (skb_cloned(skb) &&
-	    !skb_clone_writable(skb, offset + sizeof(__sum16))) {
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		if (ret)
-			goto out;
-	}
+	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
+	if (ret)
+		goto out;
 
 	*(__sum16 *)(skb->data + offset) = csum_fold(csum) ?: CSUM_MANGLED_0;
 out_set_summed:
@@ -2979,12 +2976,11 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (skb_cloned(skb) &&
-	    !skb_clone_writable(skb, offset + sizeof(__le32))) {
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		if (ret)
-			goto out;
-	}
+
+	ret = skb_ensure_writable(skb, offset + sizeof(__le32));
+	if (ret)
+		goto out;
+
 	crc32c_csum = cpu_to_le32(~__skb_checksum(skb, start,
 						  skb->len - start, ~(__u32)0,
 						  crc32c_csum_stub));
-- 
2.22.0

