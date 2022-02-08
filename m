Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCABA4AD234
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348164AbiBHH3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiBHH3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:29:11 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AA9C03FECC;
        Mon,  7 Feb 2022 23:29:10 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id z35so355960pfw.2;
        Mon, 07 Feb 2022 23:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OHmI69f2zbi3ypl2upS6FscMcBrriYn6MPvaNo5sJGs=;
        b=MB+r1RvSi+Ci8DXYcxwfiaAtJlKYeCrCx7rIGAvunVNqQtMxuQNoypQRXuRf3j1gOJ
         ctWyutjhxjzUJ9HVEKUPMdSqGoq4Jj0OTQDDxBUjS8qX3RXvNyDqem+GlaRm1hCGHLD5
         J61AmQSnGo/HB+Ioo41Ew0zUAR4Rq3/MmHyDICOz+IvZ8h0EcM1RLP9Y4x1FcQGMSXuN
         nKeN8WoS6otvOlGZ2xDoDisnr8G1NkllUOU6bJRz1QZCl9jCHgEOP7mrTvxJ+a7aROC6
         /tqfxtq6QYVGy3BRO9OL8pObmc2G8/l3CVCbV6ma4+CEOHTDQcsSSFmFMlriMr8wK1M6
         nfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHmI69f2zbi3ypl2upS6FscMcBrriYn6MPvaNo5sJGs=;
        b=nwI5TvwkKiltEAt/By0XlS5hjVICTEGNLmx66fXTUxn23b2dTjiwckzLr9tN/RkFQX
         RmT9p9cdJxUF+mSKQhHg47pJ0mp4UN9eSlEmqcN4PK/qZgyQyMOeWckw7SncAzYykAir
         d034//2TXw64e49azv2L5ylbEi7PiIEZpjNoVA6xiTbV1va46+oT5sBMfDCF29mcUGdL
         tY6D7S77X9iRw8OzRycwkeZSi0AZIbg4N43jQ2oacmN31vnoMegwl84VJ8LFc+1gppoJ
         4IZVq4ZCoXkI4oK+5VwNS8Z7mdpGchE3CN6CoQod5Cp3/hVky8BON8JHeKtO1MzeUIr5
         w1yw==
X-Gm-Message-State: AOAM530CMnE+Z/ko2v2Tq/bX6otJOKQT8XkFm4fZ2nYEYpS03jhXt1+F
        LZkJn4PE20wnq5XS+zE+ans=
X-Google-Smtp-Source: ABdhPJzld/ICy+U12WKUrj0achNoAKH67ahuKuRe+IDCCTVUEj9QoSII2LtGo239S3BcKGqJhjJ4+w==
X-Received: by 2002:a63:475e:: with SMTP id w30mr2531541pgk.175.1644305350363;
        Mon, 07 Feb 2022 23:29:10 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id n37sm435675pgl.48.2022.02.07.23.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 23:29:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, idosch@idosch.org
Cc:     mingo@redhat.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, imagedong@tencent.com, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: skb: introduce SKB_DR_MAX_LEN
Date:   Tue,  8 Feb 2022 15:28:35 +0800
Message-Id: <20220208072836.3540192-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208072836.3540192-1-imagedong@tencent.com>
References: <20220208072836.3540192-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Introduce 'SKB_DR_MAX_LEN' to define the max length of drop reasons.
32 should be enough, as the current longest reason is
'UNICAST_IN_L2_MULTICAST'.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/trace/events/skb.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cfcfd26399f7..920adcd564bc 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,6 +9,11 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+/* max string length of drop reason. We use 'SKB_DR_' as the prefix to
+ * make it distinct from 'enum skb_drop_reason'
+ */
+#define SKB_DR_MAX_LEN	32
+
 #define TRACE_SKB_DROP_REASON					\
 	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
 	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
-- 
2.34.1

