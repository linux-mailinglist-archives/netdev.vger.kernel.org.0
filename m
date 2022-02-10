Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9BB4B14B8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbiBJR5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiBJR5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:15 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C0325D7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:16 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n23so11637988pfo.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rIIGX3P8YWiAdhJvBY9NBTOCqxvy9xtRdDHIVkVhWGU=;
        b=DhB6TepfR6i4DI7ctCCzkjgl5EK2E1n0VP4xZE15qhGEtv3IAc2mcD/RQSBVfeJDks
         mtwKbeExfvo+sU/eZfa70KmCfJyR/zqBiYCv03o1Sv6Hm6/zvlrCBJLUyk8CkU6bG4C5
         nh1DpqBgfUpqkOScQ7eG3IingipimNNfmpLJ8o197B2HZqZRYWvgw7/46byHpg4z2Pe9
         AYW8Zy3FALXVmX1ejFTbMrRde6SpUynryjbX2D8swAnc48oqz91QbwoNykY92vFjc9RI
         PmjW5K/jm3bmOInV+N5+/6YlAp87GaqO5EfvF7nqNtLXaBqKF1TfaWpcIvACMxkVCEqv
         1Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rIIGX3P8YWiAdhJvBY9NBTOCqxvy9xtRdDHIVkVhWGU=;
        b=gIPFJ8YTaZcouFp2OY42TI9sUH1If82SbUiXDXW3meQVeqnFFzolHFjNimAtbo0sd3
         Uc7WpwDs8H/XbLWscD+iOjatPmRMz8RSTNUbWi6c11b/Xgd7XMXT5tbCyJyeR5NFr+rN
         zGYhI8QFeiPq3s9rdv+DpqvOsOAt38d4FQqA6cmcgHjzuc5D6NkpCDFF37pvHbh3pDXX
         en8tklBsnvvmoyfHTzJwJL2VLBCg0qroNPfk+D348oj+pzZ4eZh7Yqpz2OivgQczKBI0
         cLmCAdTVnHnlnL5hlIi0bAfzZ2YOAOOVhDZ7v0zskn3qkx6BaAqmWE8BCvq6cnSk0fhj
         vc0Q==
X-Gm-Message-State: AOAM533zU1Ir1r6mq9iXtFLuA7vq1BAdjmzHIS9TWoddymPKE2QDFiUF
        Z/Jvyq/cKTWZnIe+0aD38h8=
X-Google-Smtp-Source: ABdhPJw3wqGJgc4rqukK5rrk0hsN/tSJgKgw9AaalF84jEIT/dv+S1JD7nwWqX4BjllUNpFvB/mdvQ==
X-Received: by 2002:a05:6a00:22cb:: with SMTP id f11mr8554303pfj.75.1644515836448;
        Thu, 10 Feb 2022 09:57:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id t3sm26230634pfg.28.2022.02.10.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:57:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] scsi: iscsi: do not assume MAX_SKB_FRAGS is unsigned long
Date:   Thu, 10 Feb 2022 09:55:55 -0800
Message-Id: <20220210175557.1843151-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210175557.1843151-1-eric.dumazet@gmail.com>
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We want to add a CONFIG_MAX_SKB_FRAGS option in the future,
and this will change MAX_SKB_FRAGS to an int type.

cxgbi_sock_tx_queue_up() has one pr_err() using %lu to
print SKB_WR_LIST_SIZE.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/scsi/cxgbi/libcxgbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 3687b5c0cf905827aa4ba70fbc21d42c15e7b3f7..ccf7ea612e1281bd3a3deb9fe5246549e257cc0d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -382,7 +382,7 @@ static inline struct sk_buff *alloc_wr(int wrlen, int dlen, gfp_t gfp)
  * length of the gather list represented by an skb into the # of necessary WRs.
  * The extra two fragments are for iscsi bhs and payload padding.
  */
-#define SKB_WR_LIST_SIZE	 (MAX_SKB_FRAGS + 2)
+#define SKB_WR_LIST_SIZE	 ((unsigned long)MAX_SKB_FRAGS + 2)
 
 static inline void cxgbi_sock_reset_wr_list(struct cxgbi_sock *csk)
 {
-- 
2.35.1.265.g69c8d7142f-goog

