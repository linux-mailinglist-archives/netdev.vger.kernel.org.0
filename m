Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672BC3B99ED
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhGBAOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhGBAOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:14:20 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8EC061762;
        Thu,  1 Jul 2021 17:11:49 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k16so9650894ios.10;
        Thu, 01 Jul 2021 17:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SiO6sM+XvfiysPkLpQDRfRvm5Fce6TSrKOnYNqubSNc=;
        b=HnAhX5T9DHn2AetAynjXwUeQyoAVoefGCIEIUKsghuwufX3E6U+iuirgoFEhdiqyh3
         9vjBrhFpwU795oZzHrY7GrdtWhaflf70YF8Ohzol6Hbkvtq0oqkYglO/WJgYD4fFKyPN
         w13uaOv52B7y7FPiAaFY9J5VrUzUEvl5wqYd2aQ966sIq8T/QNFjBR0XZKm0U7X8f5iX
         WK3GMss5tkvN954bW9HJLZmhrYWSxfEAEloLcZDP+jCLO4HstqQ2rLn2gc/36IaLEQf+
         kC+kAiRLf+gmbNhuYWE8XaBBpGT/BRuHjFXlcnogqx7wyv+5kFDlcpzQv+JKov1QBf58
         yEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SiO6sM+XvfiysPkLpQDRfRvm5Fce6TSrKOnYNqubSNc=;
        b=MOkx/lcCRnH+/74y3Q+vUv0s7D6xp1TZnWFrMjXEZv2ALg7U443+vNcS+v4RNWcvG6
         D71dQKOrb7jf1BSXW1HCrNM8qsWL2R8VVoAxXzGW0QdiLrYKgIw3VVRKnEV32U2QlbZK
         kO/KBs8aR/4g65ENjx8qXWff4YlZrPxn2lqy2TlxSan9x7Hz6aQs7U1yGkpqUfXea8wD
         J6JIz6OHunJ8apnWNhhR7zeY8PN+UaXjpkTeIHsA5Sb2v5s/z+oBwcLwOn7t33PLnsiR
         bOkUdLzOR3cQpVkCKT+eFJnrMXntXC78rLeASfv1rZRGXXK8lZcXeao42PpyRDIjZIrD
         /hbg==
X-Gm-Message-State: AOAM53283bqxJez9FYSlA/2Dysd9u/WA3cj5cTtWck7x/lCb1Yp7is5q
        +Ux8yYj2OPgU/WOsUXKM1wA=
X-Google-Smtp-Source: ABdhPJxbuImpLy8fRkcJqnFJWjmponTKI4guhH90PnxD4QIJh625euNgLNhLjxpPYSYiWL5uEwfVXw==
X-Received: by 2002:a05:6638:e8f:: with SMTP id p15mr1632084jas.69.1625184708815;
        Thu, 01 Jul 2021 17:11:48 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c23sm704010ioz.42.2021.07.01.17.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 17:11:48 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH v2 bpf 1/2] bpf, sockmap: fix potential msg memory leak
Date:   Thu,  1 Jul 2021 17:11:22 -0700
Message-Id: <20210702001123.728035-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210702001123.728035-1-john.fastabend@gmail.com>
References: <20210702001123.728035-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_linearize is needed and fails we could leak a msg on the error
handling. To fix ensure we kfree the msg block before returning error.
Found during code review.

Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9b6160a191f8..22603289c2b2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -505,8 +505,10 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	 * drop the skb. We need to linearize the skb so that the mapping
 	 * in skb_to_sgvec can not error.
 	 */
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		kfree(msg);
 		return -EAGAIN;
+	}
 	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
-- 
2.25.1

