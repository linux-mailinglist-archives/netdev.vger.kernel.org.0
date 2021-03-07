Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3232FFD3
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCGJNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhCGJNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 04:13:09 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D270BC06174A;
        Sun,  7 Mar 2021 01:13:09 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so1385482pjc.2;
        Sun, 07 Mar 2021 01:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9Aawe9QfXb0YxIR8Jzrfs58tlZMG5IqOctIXF8gQkLY=;
        b=UhggsXAldaEpBafQQQwFw14B6tumhWrHV43VeU8nYUccgd6lTUv4UrLEXD0mxpvYg0
         WJETcpeA1siImX1QC2lMAZ66NE30eUMlWU2Z6Dd3vFyCu6+aKJn/FC/VXfXHyd8F4NcF
         nNu7gZlfNHnIDQyonKFVJ573DfI15xS7F64dh2Y97k717XT6JRTBonF6n9dz2PG+ucty
         UU4/dO9GP2FqGMMqKNCCff6Iw6vlVVuRmBICkh1izEOfRNv3aYz0JjdZ4KFfevzjxm/Z
         KQQCLPSa8LFrPwcArGCfayTcp80+eL3j/oob2BNIWLvtGxkGG7ObNg4UObBFzC/TuCc6
         y5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9Aawe9QfXb0YxIR8Jzrfs58tlZMG5IqOctIXF8gQkLY=;
        b=ktAjLCy9xzu/IiKw1wnRNcojgCOnKbF9uHtbxjNxdNWnfp69mm9w6aqan1m4z8qP6H
         5g1+lPbJKJ9VeGJkzNNsvQCiRwcg30NMvFW0nCWK9Y+ba0F1O+H6ru/TgsEjGP3/NjQ6
         yMA1leUrxosCQowthPQp8uYt5P+cFct1V2cT4TXZs7agoq5Oe8hFoyiEP5sxkB9aB1Er
         DKVR9+fwgVtm0NhbWG7nRDxyRm2lOAmujeohJST7zjG2S2K8K+HReSBiX5G2E003GV72
         gBKkfm4P9V5Mj+ClYS97HkG6Lj4z+yBhLwCj4TwpwyrLGieiwRpBcaNqfiZBTpTjos07
         ssWA==
X-Gm-Message-State: AOAM531F0vyEjaj/5dTs398PlhnRKLKLfvA3gY3qNNAk7bwzyb9EJiWw
        k0ohzQRZNEXXnuJO6JWeGQqBGfD2mBvAt8Uf
X-Google-Smtp-Source: ABdhPJw6y5+sJnv51Z6d8vwll05AJl+ba8SkszCda/a9N/8fuHzZ8pEuMl57xak273MSyHvwnb2M+g==
X-Received: by 2002:a17:902:a40b:b029:e0:1096:7fb with SMTP id p11-20020a170902a40bb02900e0109607fbmr15909348plq.40.1615108389415;
        Sun, 07 Mar 2021 01:13:09 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id q15sm6850719pfk.181.2021.03.07.01.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 01:13:09 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     qiang.zhao@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wan: fix error return code of uhdlc_init()
Date:   Sun,  7 Mar 2021 01:12:56 -0800
Message-Id: <20210307091256.22897-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When priv->rx_skbuff or priv->tx_skbuff is NULL, no error return code of
uhdlc_init() is assigned.
To fix this bug, ret is assigned with -ENOMEM in these cases.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index dca97cd7c4e7..7eac6a3e1cde 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -204,14 +204,18 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 	priv->rx_skbuff = kcalloc(priv->rx_ring_size,
 				  sizeof(*priv->rx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->rx_skbuff)
+	if (!priv->rx_skbuff) {
+		ret = -ENOMEM;
 		goto free_ucc_pram;
+	}
 
 	priv->tx_skbuff = kcalloc(priv->tx_ring_size,
 				  sizeof(*priv->tx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->tx_skbuff)
+	if (!priv->tx_skbuff) {
+		ret = -ENOMEM;
 		goto free_rx_skbuff;
+	}
 
 	priv->skb_curtx = 0;
 	priv->skb_dirtytx = 0;
-- 
2.17.1

