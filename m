Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2572A193C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgJaSL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:11:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BF4C0617A6;
        Sat, 31 Oct 2020 11:11:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ie6so403021pjb.0;
        Sat, 31 Oct 2020 11:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMBn+rYkg3m7MdrionOcBnXTX9dRZwUBNceirhydnOk=;
        b=hKvZamZTb25e33AB+8VwWxH330WIl0POFvf7Rfyx7DHPRUoZVZrNtNNkz6QKFc1Utm
         rwnFzczRZdxUfLKeXNuATbMg5sSjo3sbGwJEehw50CxxKbMmKHbO+jG2iAsrnNDSiyxx
         aQg97tq0GcvLAv7nd9Sg4ZVkosnMTxRY1ZCyDPOFC2f0MDwyBNhmestTTLNu80w50JWM
         i97p+zWBS4k51ZmNDttob0rdmBGxpiF+0iZjlIVsnF2SOfm6Mst81WGf0Tl+AblvlIvr
         l5GQ0nE0uac/hw9fjeFtXydTLW5ifIlb/vj91CynqjfLReQpWANKa8aUYzlYpTGC/4Mi
         zFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMBn+rYkg3m7MdrionOcBnXTX9dRZwUBNceirhydnOk=;
        b=YCNPGb5InR0zaly2hUcHPPBJ2jBbcw31sgT9W3pkxGII8VnXS+qRKmNX9hS6uSPYIT
         xnNRSSyF4fa/RMMsX/M51h+tGcjcN4OdbPDtRhqcHsCvGQSnUWwm4SAHrG9SBHTPQ83v
         iG7wXWg9Bq9CoQPkN71zelqbQzjtAB+Jfn1W27M+Sb708d7/fdUqXC+RxE9sZ88B5fTC
         te3pkrZEyB/zAxll8mifWNHMm1K6AMNx4rfuT75vEp06pSbhkNQ2zQnQNsBLWWBMzvJr
         QAZdytR1d46ef15YBtzOAB1ZWkbSYYtB7tmQYCn5yA6tKJoNbGfRPj1gcdtNHXa3iHqL
         UMlA==
X-Gm-Message-State: AOAM5324qdyEYZebIZ1H1/ckVN9Mm9rpp3C66+fL5Wcwz/BpBi2/GQpe
        wZ3Wif0Zko9NLtGNuXrwgf8=
X-Google-Smtp-Source: ABdhPJy7cxBykrG/vdL/UwPP80XqDpzuk/yzPsAkY6yIg2wVQ/CvrC6VM4FH2YL0EW9EXZTjEiSzdQ==
X-Received: by 2002:a17:902:7046:b029:d5:a5e3:4701 with SMTP id h6-20020a1709027046b02900d5a5e34701mr14157624plt.57.1604167918755;
        Sat, 31 Oct 2020 11:11:58 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:11:58 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 4/5] net: hdlc_fr: Improve the initial checks when we receive an skb
Date:   Sat, 31 Oct 2020 11:10:42 -0700
Message-Id: <20201031181043.805329-5-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.
Change the skb->len check from "<= 4" to "< 4".
At first we only need to ensure a 4-byte header is present. We indeed
normally need the 5th byte, too, but it'd be more logical and cleaner
to check its existence when we actually need it.

2.
Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
the second address byte is the final address byte. We only support the
case where the address length is 2 bytes.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index eb83116aa9df..98444f1d8cc3 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -882,7 +882,7 @@ static int fr_rx(struct sk_buff *skb)
 	struct pvc_device *pvc;
 	struct net_device *dev;
 
-	if (skb->len <= 4 || fh->ea1 || data[2] != FR_UI)
+	if (skb->len < 4 || fh->ea1 || !fh->ea2 || data[2] != FR_UI)
 		goto rx_error;
 
 	dlci = q922_to_dlci(skb->data);
-- 
2.27.0

