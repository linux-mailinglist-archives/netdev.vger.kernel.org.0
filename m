Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D418055D
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgCJRrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:47:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42726 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbgCJRrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:47:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id v11so16999160wrm.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XC8IKQ74vPv+UfMSye3u7t/54ed4ZAgOtHUPCB0KwJI=;
        b=zIJySxHvPp+R2UTCXnHsTySARcEwLDoOm3+7DSZAUoGamSnvk4Z4m/33Y22UZhZvPi
         HRjm7o/EH8TQJqeSEacRldso2oXzc0+fB9bwfzz2X23lp9AsuVD2eG/y8ojk15LjQWKQ
         hd+gxzQvdId2G79HdN+YP70IurA1njyIw1/oQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XC8IKQ74vPv+UfMSye3u7t/54ed4ZAgOtHUPCB0KwJI=;
        b=JQu0aSEBeoJFQo8ATf2z3E9QXs0eg6hfR0kMUDDMwSQZgEDNvKq1PQjLI87xv1sdTf
         Uzb+TLr1qcVf6SjT2WjcGmsuHBiB1bsO9xmJ43RJuJYV32pJyzJdp4+bV/h9urRQG1OY
         7R7q8hUyxH9Lp2mo/5aLQPJez1vQIofHP981fhnGfzd4WWK9s6UzFAK2WUKebce7/4Og
         rlTnJLnnT3lFsgPMezZB/K9mRzbpn2ng/UAWNijpZiiQ30scq2gjBKqbUKCS6unTxzRb
         MgjR+88ns9Ln5JCV70K7ZyOB1ezgYA96b78hoJKTuA+c0Df98yle4vYTXxO3vs9AtzDl
         QM6g==
X-Gm-Message-State: ANhLgQ3vUxOaA3aaIAPkuR1x70krVb04erkhBQLrdbkqBF/09rtXFb3d
        +UpIL1ho2+L3Wjtnkb7EKJaLqQ==
X-Google-Smtp-Source: ADFU+vsjj2OPEOgFyNbWcbNMGg6PA4mx+5cRmNV6PwJWCtb3+fuf9br0wM59YIl8VXByekmeR/p31w==
X-Received: by 2002:adf:a3c9:: with SMTP id m9mr26515647wrb.349.1583862456912;
        Tue, 10 Mar 2020 10:47:36 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:9494:775c:e7b6:e690])
        by smtp.gmail.com with ESMTPSA id k4sm9118691wrx.27.2020.03.10.10.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:47:34 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] bpf: sockmap, sockhash: return file descriptors from privileged lookup
Date:   Tue, 10 Mar 2020 17:47:10 +0000
Message-Id: <20200310174711.7490-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310174711.7490-1-lmb@cloudflare.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow callers with CAP_NET_ADMIN to retrieve file descriptors from a
sockmap and sockhash. O_CLOEXEC is enforced on all fds.

Without this, it's difficult to resize or otherwise rebuild existing
sockmap or sockhashes.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/core/sock_map.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 03e04426cd21..3228936aa31e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -347,12 +347,31 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
 static int __sock_map_copy_value(struct bpf_map *map, struct sock *sk,
 				 void *value)
 {
+	struct file *file;
+	int fd;
+
 	switch (map->value_size) {
 	case sizeof(u64):
 		sock_gen_cookie(sk);
 		*(u64 *)value = atomic64_read(&sk->sk_cookie);
 		return 0;
 
+	case sizeof(u32):
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
+		fd = get_unused_fd_flags(O_CLOEXEC);
+		if (unlikely(fd < 0))
+			return fd;
+
+		read_lock_bh(&sk->sk_callback_lock);
+		file = get_file(sk->sk_socket->file);
+		read_unlock_bh(&sk->sk_callback_lock);
+
+		fd_install(fd, file);
+		*(u32 *)value = fd;
+		return 0;
+
 	default:
 		return -ENOSPC;
 	}
-- 
2.20.1

