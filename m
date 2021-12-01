Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2344643BC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbhLAAGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345469AbhLAAGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55378C061574;
        Tue, 30 Nov 2021 16:03:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gt5so16566955pjb.1;
        Tue, 30 Nov 2021 16:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S+gYhKATM2bim21uFOrroBI8HZEroT+8tPo6qbiW+LY=;
        b=PmMcJRCFH8spCidjlHD5YAV9NszIi5yNzt9voRx1ByX2MFHp9yUoePC1A2G8bFvknf
         +FoxjTO2sVJIWnEtrXOZuzxt7/c0IlRmK9gLH0tNN5AcGkOvHPHC7kPOEUcmIe1L34gA
         Tpx1DZcdwb9CDyzVoSEq+WVzU/iH3Y2yS+wDXHTFEc5N0Ff8P6CE7ZwS54G1Vge7sJCS
         qpTviPddXgPxOLELvDZACO6hPzWL7MpCgYlezaXVSawXozZ2nX2JpXIs/zt4g1/4GYNQ
         V3VTYT5N8SqQqf/Q3BJQdbghj2gPR3wlPovvczsPPvckJ7PAP+www6JBvbbzYOv50cAv
         iSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+gYhKATM2bim21uFOrroBI8HZEroT+8tPo6qbiW+LY=;
        b=r3X5srT8wisjlgRaNFOWbMN9OOAzNp0khSHOkgX5cCgKFbDDpMmapi2nUM3WVwwM91
         8P+UfEZCiUIFpdyEeZSZUVZdJVC7IMv5ff3QLLK92gyzDxWw0838oegwWYSeRrLyJU15
         MDnEtnJ6U3iDW4tBwA6oHqUbjTRujJnxn8OVWXkdU0AVvpFZfmGndpr0PZ2MtGVXg8DP
         qiJjQjrV4YTsat9BUs3rewFu125yEgfpIYNMx8N6lefEaXACy/wLjLQUYkUviYmZuaWj
         SEesD3EZ/HeT10yyc7vLBGPcvfxrpd2R00mpgnDammcTooY4O21Rl3sdc2Mg4s8+leQt
         71tQ==
X-Gm-Message-State: AOAM533MRRtj6Jydly1B27o92t5i8FPmqC1NS99j0uDhfp9Fca/Xiwem
        LO+O/iTvQeLrvJGAexhVDxc=
X-Google-Smtp-Source: ABdhPJzIYnpsAslAJM7BG+WuPsB0d8gCQV4AZtJWi2gaUG0XTYf7Sz03wD+wyzgNypSBXvFQJ3NT3A==
X-Received: by 2002:a17:903:32c2:b0:141:eed4:ec0a with SMTP id i2-20020a17090332c200b00141eed4ec0amr3129467plr.74.1638316979742;
        Tue, 30 Nov 2021 16:02:59 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:02:59 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 01/15] skbuff: introduce skb_pull_data
Date:   Tue, 30 Nov 2021 16:02:01 -0800
Message-Id: <20211201000215.1134831-2-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

Like skb_pull but returns the original data pointer before pulling the
data after performing a check against sbk->len.

This allows to change code that does "struct foo *p = (void *)skb->data;"
which is hard to audit and error prone, to:

        p = skb_pull_data(skb, sizeof(*p));
        if (!p)
                return;

Which is both safer and cleaner.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eba256af64a5..877dda38684a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2373,6 +2373,8 @@ static inline void *skb_pull_inline(struct sk_buff *skb, unsigned int len)
 	return unlikely(len > skb->len) ? NULL : __skb_pull(skb, len);
 }
 
+void *skb_pull_data(struct sk_buff *skb, size_t len);
+
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
 static inline void *__pskb_pull(struct sk_buff *skb, unsigned int len)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a33247fdb8f5..0b19833ffbce 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2023,6 +2023,29 @@ void *skb_pull(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(skb_pull);
 
+/**
+ *	skb_pull_data - remove data from the start of a buffer returning its
+ *	original position.
+ *	@skb: buffer to use
+ *	@len: amount of data to remove
+ *
+ *	This function removes data from the start of a buffer, returning
+ *	the memory to the headroom. A pointer to the original data in the buffer
+ *	is returned after checking if there is enough data to pull. Once the
+ *	data has been pulled future pushes will overwrite the old data.
+ */
+void *skb_pull_data(struct sk_buff *skb, size_t len)
+{
+	void *data = skb->data;
+
+	if (skb->len < len)
+		return NULL;
+
+	skb_pull(skb, len);
+
+	return data;
+}
+
 /**
  *	skb_trim - remove end from a buffer
  *	@skb: buffer to alter
-- 
2.33.1

