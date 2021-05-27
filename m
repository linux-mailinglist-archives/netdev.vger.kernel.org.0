Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C085392425
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhE0BNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbhE0BNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:45 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF347C061760;
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e15so1518284plh.1;
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=k3X0lHH497gYWDV0e+6sSKNrtoS5++p6XlWfcpr+6fF0+CAwrgDKc3TPWyQQjW2AQB
         vjwsmheyOjYTxE5rHz0sw+moMJnIK2nAhGpeSdNOBUaFwmQE7dpS1XAZXX8jUI6AK3xc
         tJYMLfRIwwECBbxFOAUMlXQ5CV+1X9Fp88FhgOjC8eqFz1S6cNjlapQPNV0JFaKh1Hz5
         IWcyrb4/2VzVzGNvcSt8Dkl3NGitSY6KL10P4KLUbJiQbE2pdSedK6vGw82+J/F5EzLX
         bDVTMVkN5iTt8txCUMDQ/iocJbDFVGiFikKrJEns86sB3ceLZmqszrFzOq5vkjQ5j6Zu
         XI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=ER1FD6LcPFz7NHol6fDEBk5ztsYfoCREOH5aNQxyTwGSoSxOinfotm5YBH9QgcXLSc
         QOA7hXr4Nw6nyVmVLg/DILv2FcdGPiKUuedn9DVZ+NemGQTmHfUEjQq+nzgAv7XTvJv6
         kPqTfMkSIu3tHaiZjdWoAV1mv9PgTIBA+ENjm8VtUEDXbZ/GFxWf6muIhYMs0Hx22poL
         llNKdoyrZjye7y5BzjDnQ7wfJEYUouW+Z3jlvXC6HE9JFbp5R9fYREMjNJ8rA3S5Oi6N
         G7UfaUTDnsWNXQME5lnu6jk68jp7DaB0o0GTpfJmKW1Ajy/hUtdYDzepxpR/XWkcYwFA
         1x1Q==
X-Gm-Message-State: AOAM532LUuFxPTOt1NcBj3nfyfBLp2rDTJtKIMLXMbP6smtaugAMOWJ7
        BXvRSzaHbih3WRGwbixDbE9j4IGG2ShIlw==
X-Google-Smtp-Source: ABdhPJwXkb/ZXaI5sM13aSy3fvwscGQdtQKfA+7RYcOpX9RN8r9NjXvirX+c3J+y9KosaR0jLnASIQ==
X-Received: by 2002:a17:90a:d258:: with SMTP id o24mr6635398pjw.221.1622077932425;
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 3/8] udp: fix a memory leak in udp_read_sock()
Date:   Wed, 26 May 2021 18:11:50 -0700
Message-Id: <20210527011155.10097-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_verdict_recv() clones the skb and uses the clone
afterward, so udp_read_sock() should free the skb after using
it, regardless of error or not.

This fixes a real kmemleak.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..e31d67fd5183 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
+			kfree_skb(skb);
 			break;
 		} else if (used <= skb->len) {
 			copied += used;
 		}
 
+		kfree_skb(skb);
 		if (!desc->count)
 			break;
 	}
-- 
2.25.1

