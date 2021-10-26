Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4400843B316
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhJZNWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhJZNWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:22:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7188C061745;
        Tue, 26 Oct 2021 06:19:42 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so5640875plc.2;
        Tue, 26 Oct 2021 06:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VzCWxXxK9TdDs8vtpTG3m2qg1k4LCb22yH40yBeN194=;
        b=iAIwAL+itZzmAG/PxuRn0efFaRUSfd9e5rOMTCoNN+4qLc3H0Q8iuLh9nKBHDgU+G+
         qmBMdI2B3hQPMWAHa31SY4Az56+T/RGNR4ppy2ui6VjIf50HqnrAECVvqWLlQSV5X9nP
         Gtw347BTcEdbDJjo0n+oma0GF/rohUVqQLQx3O2ppEM1/5rT4oUfyLyxYZr12yj6E3dS
         MIxRGgU3IHdaSBtD3tQONEy1sRT259J1bTHlzLjw+9GqL3v0dmGb+Y+40GsTdF/r6XQK
         P/H1sAzssiePrQc4PZY39vmdgVj8aIDoYhI7a38mG5POc1aWPhCySI1FiHNba5/XDq+P
         nHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VzCWxXxK9TdDs8vtpTG3m2qg1k4LCb22yH40yBeN194=;
        b=Wj+GMCdKO4yVjdJP+0+5HAHA0ErmS72Q5D6bZzZ21FD7ThUfmgK0c06I4ZEXYgXQe7
         xGBKfa+dqHELDAtR61pSDcfk4N+/rJhxobMd0Xk4wWGd7UKEHAm6dVRxpeB2p2wfurkn
         nL7oV1Gko+0ahtBpCh6KIGochqvxcXUA51+7TfirOyXN6vmHAzKrN0yNR9AoXo2ubn92
         6MXig6NjOT+loi1rHeq7601EX874HUzhD7kCU6wT7ZpMX/bBkmdG0dJGdoVWCY46XUcZ
         /7h/F0NrPF/HoPATbiXJ6X0Q50pDTQiNpmqpOH4s7J4pwl9D3rKCE+aFQPpcfcfXzCu0
         Sb+g==
X-Gm-Message-State: AOAM531MYxpX/wojk+uxJU3cO/W7c9jzdTWOwY1+71bnYMuoCkXpbedr
        UX9Fp023/dOhGCLvvElPRyQ=
X-Google-Smtp-Source: ABdhPJxUNeYPuoYMIofoYzM3+5yUuwUhxMCQsVBUyKHvPYld780i9L/QH4Wj30RO0PsH0iTP2G+8+g==
X-Received: by 2002:a17:902:b40a:b0:13d:cbcd:2e64 with SMTP id x10-20020a170902b40a00b0013dcbcd2e64mr22527791plr.18.1635254382283;
        Tue, 26 Oct 2021 06:19:42 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.202])
        by smtp.gmail.com with ESMTPSA id d17sm9501560pfv.204.2021.10.26.06.19.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Oct 2021 06:19:41 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, alobakin@pm.me,
        jonathan.lemon@gmail.com, willemb@google.com, pabeni@redhat.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <xingwanli@kuaishou.com>
Subject: [PATCH net] net: gro: set the last skb->next to NULL when it get merged
Date:   Tue, 26 Oct 2021 21:18:59 +0800
Message-Id: <20211026131859.59114-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Setting the @next of the last skb to NULL to prevent the panic in future
when someone does something to the last of the gro list but its @next is
invalid.

For example, without the fix (commit: ece23711dd95), a panic could happen
with the clsact loaded when skb is redirected and then validated in
validate_xmit_skb_list() which could access the error addr of the @next
of the last skb. Thus, "general protection fault" would appear after that.

Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2170bea..7b248f1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		skb_shinfo(p)->frag_list = skb;
 	else
 		NAPI_GRO_CB(p)->last->next = skb;
+	skb->next = NULL;
 	NAPI_GRO_CB(p)->last = skb;
 	__skb_header_release(skb);
 	lp = p;
-- 
1.8.3.1

