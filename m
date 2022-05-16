Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB09E527C7D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbiEPDqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbiEPDps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:45:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2068237E9;
        Sun, 15 May 2022 20:45:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m12so13280998plb.4;
        Sun, 15 May 2022 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NX5eVZhreG6Gb+/fM2DfcEq481HgwxLouGtxtS55WrY=;
        b=qgFC4yMpaIGyabHJFUtzPb3UyoLUeDZyn6i2iIL3usEjEGFeHwjmpp9UC/1QNdaEOW
         6Vy0ecshFbGkGEh4p/NQpsgXsO08C/+xOFA2O2vIRzIPc7X6XHT91pcluNJ7D7X+5erB
         aM/dp5sBeFwa2+UiXE68ijL6Fmc2vqWSCT1szerEgdxwk8ATme/wgE6a8NecQsZZNiR/
         Wv0C9sEIm6Q/m7Ty3Y8oefr2DJNf6h3/z8F0Srg2B1xtZdaESryDsKvOeuL8fOE2qFcw
         vfBgGwmLpDawXABfH536DdHDLXl9JrONdaR0sHA2IBeePeogvB52WMd58wewDOtV3ylY
         a8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NX5eVZhreG6Gb+/fM2DfcEq481HgwxLouGtxtS55WrY=;
        b=ZfvFI4+ETTeCvbVy+YiqgUx2uQq71hxtPCphUUw/XT5bM7le4nJCe487lsQP/TnrGs
         c4D1vQy6diuVXnwTJBy4zHjHmWrdEYkXG/MHBqioDUFw1waVsGU4CJB8HtA5JueZTzWZ
         6NPd1RFRXDvevCF189eLUfGjMMCIK16fVKVIUEppOs4xVzKYD2mB2t/ZLetOo1+FsEDj
         dv5J1OdoBX8Zq19eJxE/dIYhu7WpTsMDymky62Pv55Pl4ZUvvW+PflBNvlsbTFX7QWry
         lM7W+AmdrZ/ZEiQeaMZgUbxJTBgU3gtH5f6UGtyvz2dBpVatcngjalj5cxGqz+cueGuY
         kFeg==
X-Gm-Message-State: AOAM530emUO0FgZ78f0ZqPUeHBCCbU+RdhYQdRZT1oF3w4e+ISnD5BCD
        MSK7ogLTAokt6KnaeLk+Kjo=
X-Google-Smtp-Source: ABdhPJxlZsWVDuLERpc9vu0LyuzMPvD+kHrTH+zvb+VYIAK1mSpNIgb3ZZeQ1lbhKeDV9mnudkJpRQ==
X-Received: by 2002:a17:90a:5217:b0:1dc:9b82:272c with SMTP id v23-20020a17090a521700b001dc9b82272cmr28399234pjh.53.1652672747534;
        Sun, 15 May 2022 20:45:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:45:47 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/9] net: skb: introduce __skb_queue_purge_reason()
Date:   Mon, 16 May 2022 11:45:12 +0800
Message-Id: <20220516034519.184876-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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

Introduce __skb_queue_purge_reason() to empty a skb list with drop
reason and make __skb_queue_purge() an inline call to it.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dfc568844df2..e9659a63961a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3323,18 +3323,24 @@ static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 }
 
 /**
- *	__skb_queue_purge - empty a list
+ *	__skb_queue_purge_reason - empty a list with specific drop reason
  *	@list: list to empty
+ *	@reason: drop reason
  *
  *	Delete all buffers on an &sk_buff list. Each buffer is removed from
  *	the list and one reference dropped. This function does not take the
  *	list lock and the caller must hold the relevant locks to use it.
  */
-static inline void __skb_queue_purge(struct sk_buff_head *list)
+static inline void __skb_queue_purge_reason(struct sk_buff_head *list,
+					    enum skb_drop_reason reason)
 {
 	struct sk_buff *skb;
 	while ((skb = __skb_dequeue(list)) != NULL)
-		kfree_skb(skb);
+		kfree_skb_reason(skb, reason);
+}
+static inline void __skb_queue_purge(struct sk_buff_head *list)
+{
+	__skb_queue_purge_reason(list, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 void skb_queue_purge(struct sk_buff_head *list);
 
-- 
2.36.1

