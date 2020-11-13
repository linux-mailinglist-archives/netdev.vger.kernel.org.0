Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143B12B1E43
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgKMPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMPIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:08:19 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71617C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:19 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id j19so487439pgg.5
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IYRMHQo/0TotVSboDZgb2XPRzlLB7yUez+sJ4ytUiLI=;
        b=PeCyei/nipKyR7ADEKy6RlfNc9op6oxY5ODv7uYg8pTXLsbLWuc6qzn+L5MnRPXv8a
         QuObolzqqN4djmp7YM0GPhCeQRwIme5WVR6kkCZNAeQ0VAje9QXrY6xNwW9kZ1dPEvY7
         9tQF/HArGaz8efItznZDQXcRR42uE6Ek2uk5KwMf3CIT+IG85fOlTjKJGJct+BwwACUx
         xW6KQD7ORimU0YdOA0BQpMUuur88UU2YOrFu9hPNHb+LEtzcCGwjYrdjGF27741SR++J
         tLmC8DrUyA99WThw6/OQm6jzA5Y1l74k3uOjcB2ODrVvNaMvzj6F4X7sIP5OOVZP9Qup
         +78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IYRMHQo/0TotVSboDZgb2XPRzlLB7yUez+sJ4ytUiLI=;
        b=WPvZe75zfYBubQnuSBod4S7LiHJJkZh+yldR7A3up8HcOPdZo+KloN2b84KASWdoHB
         qc4MdfQpaHYT8Bhn17S4leGEAPbJmBmGXdTmm6Yi2Q19CMON2Q/CtfJNGi8IDua8fnBP
         Fi8quH5V3tyCUQy89iMF4v8jsHDapK+yT0fN0rq8oP5GLRQTibeWmRnx6U9XqE5zbv4c
         estHgNbji0YpGqPNrv53jSU5W15tlShazvGe6RUV4W+1Zm7BrrA9akUwGc1x3EK4tORx
         7uSE/CITh5lZuCxi8LqEsMaPFbSdlB7TlOyUx8S8ANtwT8loNKF85HXrExiVCh+zPBsD
         +NvA==
X-Gm-Message-State: AOAM531fS92DE9sEJCg95B4y062hfVGwNvgiy/6QyfiLHBsV93qc+epo
        /05TptuEQM5zODSDejpJReL1DKx1O/0=
X-Google-Smtp-Source: ABdhPJyZ1vflD+z7mPpc1KoesngD3NOKz6NNxzlQSGdmR3dmx1t6r5ddeV7UjFKZOG+sL+IRIQZp2w==
X-Received: by 2002:a17:90b:180f:: with SMTP id lw15mr3457995pjb.119.1605280099126;
        Fri, 13 Nov 2020 07:08:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id k17sm12043834pji.50.2020.11.13.07.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 07:08:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] tcp: avoid indirect call to tcp_stream_memory_free()
Date:   Fri, 13 Nov 2020 07:08:09 -0800
Message-Id: <20201113150809.3443527-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201113150809.3443527-1-eric.dumazet@gmail.com>
References: <20201113150809.3443527-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77d08e4b65e634e93040446486bdc2..1d29aeae74fdbbae3410def33ebc66758e034205 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -60,7 +60,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/poll.h>
 #include <linux/sockptr.h>
-
+#include <linux/indirect_call_wrapper.h>
 #include <linux/atomic.h>
 #include <linux/refcount.h>
 #include <net/dst.h>
@@ -1264,13 +1264,17 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 #define sk_refcnt_debug_release(sk) do { } while (0)
 #endif /* SOCK_REFCNT_DEBUG */
 
+INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
+
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
 	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
 		return false;
 
 	return sk->sk_prot->stream_memory_free ?
-		sk->sk_prot->stream_memory_free(sk, wake) : true;
+		INDIRECT_CALL_1(sk->sk_prot->stream_memory_free,
+			        tcp_stream_memory_free,
+				sk, wake) : true;
 }
 
 static inline bool sk_stream_memory_free(const struct sock *sk)
-- 
2.29.2.299.gdc1121823c-goog

