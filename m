Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E22866CEF4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbjAPShx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbjAPSh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:37:28 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B409305EF
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:27:37 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so70052104ejc.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=epMBQLj40t9dX5gwuafuYFxhG3Xn5KXEsQO4j44ipXI=;
        b=R5X6w/zlZI7qhH9qVpVOYzlPdW7+MnPHfYghx7lbrIpprKgXeoY8cbyRAzrYvPCWbc
         lvAinn6SEKWcFqIUjiUAUlOjh4uCRQHRE0QcOshQvaWR+809QGoCgesS70EnzpkXT3kK
         LcCgzhqIbql9NnsTPF3AADxUdOc7ypyp/bdTNWuz8w+Qil4uRe/mxv2mfm3EnTuYS05Y
         75WilG3dA/7IAg/AzPgdfR5UswYUo65/gVNE8i9xeJ6RrSRYczJayx9YZdHjPiY1Ilk+
         qXn0D0/mg3f2pw62pLy+0JEtBDYf1AozEw3is5fDp0aKAiUu0txQatA20N9Zg5p9j/vM
         p0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=epMBQLj40t9dX5gwuafuYFxhG3Xn5KXEsQO4j44ipXI=;
        b=XXsc5xs4LWoqtwhg0GytS5ei/fftbB+XWun0tufBFxKF4ZgyW1tZWecWXVh2gIWfQ3
         ytY0lLdpyNoYI8p/k6/uNjiRTJMszcibcN3f1rOFR0DhmJme1lptjfY2OrdNrtG1L1VK
         +yd5dgHPrcR1abVlFbLzMXcI9mHMxoOdzP/S6snaFMO7uMbBboWQkPM5oVmMOgDUymtO
         pb5iTiYp641cCM0n5dHiDditpG52t1LiA7e2ibtUJldxpEmAfbf/7ZSyiC1qBcRD7XGD
         WNGyN7qYazkC/MPZCU/wJFWJ1JpxIDzzUCZgqq6oID0rdh0dKLzT13xkR//yBONeCP1g
         npyA==
X-Gm-Message-State: AFqh2kpL5nYn7UQSWbQwxNCJXmxjwc+ycLbabVMpVmgzvAMcvrNfxxmI
        NSEezmu622NN5QddPO8c+XPGdeDcLfk=
X-Google-Smtp-Source: AMrXdXsQdu7OK779t7VyfL+NVlhWBJpma82X/aQKWwmXrOinEWRSkuc53dl4l3i6CKiBiT4kuAqQVw==
X-Received: by 2002:a17:906:1993:b0:870:5ed6:74a0 with SMTP id g19-20020a170906199300b008705ed674a0mr5421392ejd.73.1673893656054;
        Mon, 16 Jan 2023 10:27:36 -0800 (PST)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:9996:8a14:61c5:7cf5])
        by smtp.gmail.com with ESMTPSA id wb9-20020a170907d50900b0087045ae5935sm1745761ejc.1.2023.01.16.10.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 10:27:35 -0800 (PST)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net-next] net: ftmac100: handle netdev flags IFF_PROMISC and IFF_ALLMULTI
Date:   Mon, 16 Jan 2023 21:27:16 +0300
Message-Id: <20230116182716.302246-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdev->flags has IFF_PROMISC or IFF_ALLMULTI, set the
corresponding bits in the MAC Control Register (MACCR).

This change is based on code from the ftgmac100 driver, see
ftgmac100_start_hw() in ftgmac100.c

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 6c8c78018ce6..139fe66f8bcd 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -182,6 +182,12 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
 	if (netdev->mtu > ETH_DATA_LEN)
 		maccr |= FTMAC100_MACCR_RX_FTL;
 
+	/* Add other bits as needed */
+	if (netdev->flags & IFF_PROMISC)
+		maccr |= FTMAC100_MACCR_RCV_ALL;
+	if (netdev->flags & IFF_ALLMULTI)
+		maccr |= FTMAC100_MACCR_RX_MULTIPKT;
+
 	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
 	return 0;
 }
-- 
2.34.1

