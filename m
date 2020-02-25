Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB616F040
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgBYUjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:39:04 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33928 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgBYUjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 15:39:04 -0500
Received: by mail-pj1-f68.google.com with SMTP id f2so1368892pjq.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 12:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sQIbI7dBNLv69VANmscf3kTolWr8JxCUdMFG96rkYc=;
        b=nN7tdWIfojfI4nX3ebOyntvIy8OKYbZurdDqGQAyiHFxI46/v9P+hmaS0jgFBfcMct
         WJqdMxLE1ImzscclDZMarEfQ4xO4EoSIaDMbXxJcksfAbndg4mz09YDkIixPe8vf5Tf8
         8H1PTrd2IV3Ab8xP6+1qNdffBgqfWe8JF3JOqBtQDE3D/y02jjOuo8KqXSNM9RCe5+NG
         33shaNKZrUdwQVfbxnmB1Hf16hysNK90AY9zCMI7kT158G/P2k568mOcXyxprgNCQHUE
         jn0dNJ+wTsjmQN27uvVqq3yx5n5JsB9gQRaYSe+5Z8sYVxXYdtLrJnfE5/drHo+LsbSB
         zWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sQIbI7dBNLv69VANmscf3kTolWr8JxCUdMFG96rkYc=;
        b=oVZWYmrW1zYCaKYc3UzvenjttEquUh5SAcECkvhGjJjJ85dm1HYwPEbE+I/ZO3vHb9
         nGVyq3ezoYvudGkMhJ5OnIDPJ68BkgXv5tEk2zJCl/MBWeiab8c2pECzpuOhOHjBDMIX
         AMp4VUz6HM2xPtqEbu7+HGxV1ZraE1g2wfZCnz5V9yyRJKSKZxTgDXvQsbQx3/wJSoWE
         53pPqH5fCt6MVKlzcaq0sBP+fBShpiBXfaYopyBkCjUChPNGvgj7JHYFeDB+q+AWOiTX
         BI/E2ZZBMlttb5siIkrBfs+Ce04cAYW+bKEziXHHHV1eaKCNrXB/lo7h0W7TQWMgXRu4
         NkpA==
X-Gm-Message-State: APjAAAXR5lHTL2pb0vbFZ8OiV3J75KT5+ggNLg/BPUrvjksIGj8go1vi
        3q3dyOnT3obBf8ImyE/WyYU=
X-Google-Smtp-Source: APXvYqzYlrfnti+Ws8CI6bIVyArXSp4kEjzCyWXGniVa4VoiZExo0DN5xeFEe8EjLAcn83QcxOylhA==
X-Received: by 2002:a17:90a:9416:: with SMTP id r22mr995925pjo.2.1582663142772;
        Tue, 25 Feb 2020 12:39:02 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id e30sm9641pga.6.2020.02.25.12.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 12:39:02 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com,
        willemb@google.com
Subject: [PATCH v2 net-next] tcp-zerocopy: Update returned getsockopt() optlen.
Date:   Tue, 25 Feb 2020 12:38:54 -0800
Message-Id: <20200225203854.184524-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP receive zerocopy currently does not update the returned optlen for
getsockopt() if the user passed in a larger than expected value.
Thus, userspace cannot properly determine if all the fields are set in
the passed-in struct. This patch sets the optlen for this case before
returning, in keeping with the expected operation of getsockopt().

Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---
 net/ipv4/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 600deb39f17de..9644047262ece 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4124,8 +4124,11 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		if (len < offsetofend(struct tcp_zerocopy_receive, length))
 			return -EINVAL;
-		if (len > sizeof(zc))
+		if (len > sizeof(zc)) {
 			len = sizeof(zc);
+			if (put_user(len, optlen))
+				return -EFAULT;
+		}
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
 		lock_sock(sk);
-- 
2.25.0.265.gbab2e86ba0-goog

