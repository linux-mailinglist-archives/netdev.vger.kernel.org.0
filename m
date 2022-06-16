Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAAB54E0C4
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376762AbiFPM2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376754AbiFPM2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 08:28:08 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C623828738
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 05:28:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so784032wms.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 05:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0cu62nrUvdfGJboFdMMwjmxMkokxoiG+y4zJVLN5uZM=;
        b=esXSjQvHQPRtHog/Jna3WAOWNqXM0koH45TlZBMBD7KqvUPuTg8wz7mBNZM5Ivf4QK
         MQ2oT7todp1ukwN2q5zOS7qA5be+aUI3LpYYd9mckNux1jKAAPDl31d7fwt8bTnQcjlA
         mzqqqbBnGkJC1friNmhkXKiPDrSt05apYfnWGPpSGZpZ5vD4VS40RbZ1EC/2mjIEFAb8
         GNvwTSQKUV2yQLtydw8QGkui8sSo4sYDKi94zW6HkFV9nlgYmYQfI+iyYaU2pLhX5yJZ
         fN7RLb3M1bMAhGgExJEPLSdmGRzqhbP5eVAbgU6Aq+Lx9hrmqLoQmyw0oJzNrdTbKc6A
         Wduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0cu62nrUvdfGJboFdMMwjmxMkokxoiG+y4zJVLN5uZM=;
        b=omHNfUnYfkBVSv5jeJbSHcyeRmeSBhPySRH3HPU/4vCcmU/5TuiEgqB61Pg+SXiP5V
         McnKvlCaTT95YYTtBSClTGBKhSH9Em2Dr11dAXqiqhhzXf552bG5ZgXS8rjiGCGfWBVS
         H2jKYAfRDgrLCw7mafik8MLgzc+zMtMcPCUEGrVouw3fg344jlbNZAbQPZsGR3yiiNvM
         dZcOyyD9gCjQZILsWZqp6IvZR488MMl1jC4wOZeqMfJiZRePfgTPcVGAIoRWf0FaoN2M
         /zAWMyWGZ22fEo21QSKbw+YNmJP1dKMAyyBh3JLjHdiu5uvDqB970rhrqj4fOItj7rgP
         m+OQ==
X-Gm-Message-State: AJIora/l4hjkyQAYq830qvSXiceYb/h75lYpM3g1o3I/FnyXbR8CRlle
        y4iwZnMsY3russETqNjVGDc=
X-Google-Smtp-Source: AGRyM1t2reannhgp3bDtujOBOVx053g+Mk9lLFJE3IxWBUDnDmg8tRWuUnLzNuAwa8szSy6d6Ng0pw==
X-Received: by 2002:a05:600c:3655:b0:39c:6745:ec53 with SMTP id y21-20020a05600c365500b0039c6745ec53mr4627541wmq.186.1655382481104;
        Thu, 16 Jun 2022 05:28:01 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600011c300b002102b16b9a4sm1688839wrx.110.2022.06.16.05.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:28:00 -0700 (PDT)
Date:   Thu, 16 Jun 2022 14:26:29 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, brouer@redhat.com, imagedong@tencent.com,
        vasily.averin@linux.dev, talalahmad@google.com,
        luiz.von.dentz@intel.com, jk@codeconstruct.com.au,
        netdev@vger.kernel.org
Subject: [PATCH] net: helper function for skb_shift
Message-ID: <20220616122617.GA2237@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the len fields manipulation in the skbs to a helper function.
There is a comment specifically requesting this. This improves the
readability of skb_shift.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/core/skbuff.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..8a0a941915e8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3508,6 +3508,19 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
 }
 
 /**
+ * skb_shift_len - Update length fields of skbs when shifting.
+ */
+static inline void skb_shift_len(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
+{
+	skb->len -= shiftlen;
+	skb->data_len -= shiftlen;
+	skb->truesize -= shiftlen;
+	tgt->len += shiftlen;
+	tgt->data_len += shiftlen;
+	tgt->truesize += shiftlen;
+}
+
+/**
  * skb_shift - Shifts paged data partially from skb to another
  * @tgt: buffer into which tail data gets added
  * @skb: buffer from which the paged data comes from
@@ -3634,14 +3647,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	tgt->ip_summed = CHECKSUM_PARTIAL;
 	skb->ip_summed = CHECKSUM_PARTIAL;
 
-	/* Yak, is it really working this way? Some helper please? */
-	skb->len -= shiftlen;
-	skb->data_len -= shiftlen;
-	skb->truesize -= shiftlen;
-	tgt->len += shiftlen;
-	tgt->data_len += shiftlen;
-	tgt->truesize += shiftlen;
-
+	skb_shift_len(tgt, skb, shiftlen);
 	return shiftlen;
 }
 
-- 
2.36.1

