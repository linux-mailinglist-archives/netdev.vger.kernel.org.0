Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2570142742
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgATJ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:29:26 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38819 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJ30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:29:26 -0500
Received: by mail-pj1-f66.google.com with SMTP id l35so6900836pje.3;
        Mon, 20 Jan 2020 01:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sH9LEkgfmGifYi4XLAbxzQIiktpMa8GeYyvOnqKR3Bc=;
        b=Z22z8WDPRAJTVSKpwx+SiW14Dp1AyvGi9myR+Rol7435elpTB/qNLsd588uVNlmmHG
         hl9MACKu5jYqjVrYDsfk1yXmjT2yJCQoUjwQvijFUSCBEnxpqlf6XB0SOGdqj27iOEJq
         9gfnX/NdtHx4+hSOT6t6buMUXIsUHRhGlGbcgfT0Wt4GBZl+j1WVU6HXUqXTsojjZgkd
         2XKcobHWeIs4ThTF85LIAnm9Ar+5j9Pk0sD5seyDMy6jjb3SWITU2+PXoh88qa056vhz
         xIs6pdQXPs/BKiD5QoQP4y/LJSgNLLRpbbfyLYqzpHx2mTvaexkycd3GGRgmEyAuKY1r
         pptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sH9LEkgfmGifYi4XLAbxzQIiktpMa8GeYyvOnqKR3Bc=;
        b=XvZ/2kIQZfjoM899sBa2+MzroS6cF2Jfb+5YR4kavciueZROBXjrfzk6HwBAXpEUFK
         j2HeWApNZyfk551hBLkG9QqTGBtl+hnyPdxhWgx581PDQpM1JDMb5mSTPjSUMTfs26iO
         lK6qhnTbcuhKuZzpIF9EmBd9tS8Xk0ILAX+YM7DVH/wmLdWbTCQORxuhKDDJYjAmra/3
         ihBMh4ms51ulyhR4f+UnBxg1AwbcNorjcqRwmxul2PisJC9kiWHwBy4nCtnezU9+s1xR
         bazodEFka4w0VKMTb9C4Es4UYBrbgTxzYpS7paVDtDOAdAg4Ost3Vz/OieTv03NW4IgS
         cfNw==
X-Gm-Message-State: APjAAAX2JnVm81MLCqWrKJcGmRWZAKsVgYbMn3gnYjpiOEKu08dwWLc9
        4LiK5VUWEAMtV3LzxzKVq4Gi2s7S/ps=
X-Google-Smtp-Source: APXvYqyiFoDknMSkjq34ylWg77dBmDVa48tU+6JTgMdR0Q9M/SNH+jeR/VJj9p6hVBecdHh77q9UzA==
X-Received: by 2002:a17:902:6906:: with SMTP id j6mr13857856plk.117.1579512565449;
        Mon, 20 Jan 2020 01:29:25 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id g2sm38107147pgn.59.2020.01.20.01.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 01:29:25 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next] xsk, net: make sock_def_readable() have external linkage
Date:   Mon, 20 Jan 2020 10:29:17 +0100
Message-Id: <20200120092917.13949-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

XDP sockets use the default implementation of struct sock's
sk_data_ready callback, which is sock_def_readable(). This function is
called in the XDP socket fast-path, and involves a retpoline. By
letting sock_def_readable() have external linkage, and being called
directly, the retpoline can be avoided.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 2 +-
 net/xdp/xsk.c      | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8dff68b4c316..0891c55f1e82 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2612,4 +2612,6 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 	return false;
 }
 
+void sock_def_readable(struct sock *sk);
+
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 8459ad579f73..a4c8fac781ff 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2786,7 +2786,7 @@ static void sock_def_error_report(struct sock *sk)
 	rcu_read_unlock();
 }
 
-static void sock_def_readable(struct sock *sk)
+void sock_def_readable(struct sock *sk)
 {
 	struct socket_wq *wq;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 02ada7ab8c6e..df600487a68d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -217,7 +217,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 static void xsk_flush(struct xdp_sock *xs)
 {
 	xskq_prod_submit(xs->rx);
-	xs->sk.sk_data_ready(&xs->sk);
+	sock_def_readable(&xs->sk);
 }
 
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
-- 
2.20.1

