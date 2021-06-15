Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC523A7444
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhFOCsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhFOCsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:48:17 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA54C061574;
        Mon, 14 Jun 2021 19:46:13 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id g19so7806971qkk.2;
        Mon, 14 Jun 2021 19:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=TyvUdaj9mu/Y8GbmB/A7t1MkJtCWQoLM+uRbnlvtl3gMyN9GNAdWipqQbd5OVKbMG7
         zZhfDxTRtTiGUzxSO9WeC+khEg6MEiipckMc5J2EkoCngtfi4DTe46QPE4qNjeQJhOFg
         /h2AK7Z3O+XJtLbuVGbrY5aXkB43tV/Jb9D4nnQcftVgiKx8VyvlsUjsxkuZvk9gMdAK
         ntoRAAa+K/aoMWtOOEkLsVeL3l03Vl+x0mobo/LGay/id1IW4F3aXQUd6RSAuUtgpzIQ
         Rk8a2jrU37qJ7cX7IJUkpTeqfTn88Dnj1yfuLOX9y9lwPsPmsITMFAXv87miX77VWCEg
         1UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=Uf7O6paWpyLG2LxaJA5BMYE93QkDQY7s9ROl0Ia9pC/QzgbYVXK1OraeEjWy66WZB9
         QkAQvaEisRlIY3XYCL754aCyXgi3MNJjiiz2Bq4Va419y+whBsc0NhYiWnp0RGzccwed
         RDVhNBSl/ppwtsWddrH8Fuxa/0EIBTx3G0K9ujGfIUTSxA078DDLVZCVJVjeKWw9cr0a
         HURo28Py3nhhAC6YLoU73C9p2rKu7xPIXJuEt2oTykqWbuQhru6FO7v7TSzoRFsbMmt0
         ReD/BTQMDKpUX8OecyTrF319U8BvRQ/kHMaHnD9RDMxiXDO82ZZxSt5njlWvxz07DUZo
         AXLQ==
X-Gm-Message-State: AOAM5331IILs1nKbJT7kao8aFaWnB3+OtZK3RjdbXdvWr/mrLfxdywzy
        35JjTNX3tNu8hpgDJZzZnK4vibIvybLQHQ==
X-Google-Smtp-Source: ABdhPJxROlCDb5f3PnQDmV9B3n+h8p2HvhvOQerLQxiDh0rQ0hA+6AV6bfJSrAWvrK9zRwDXV3jquQ==
X-Received: by 2002:a37:89c5:: with SMTP id l188mr19739046qkd.27.1623723239038;
        Mon, 14 Jun 2021 19:13:59 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:13:58 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 3/8] udp: fix a memory leak in udp_read_sock()
Date:   Mon, 14 Jun 2021 19:13:37 -0700
Message-Id: <20210615021342.7416-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
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

