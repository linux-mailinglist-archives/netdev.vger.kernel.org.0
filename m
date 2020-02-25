Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755B116B95F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBYF6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:58:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46894 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYF6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 00:58:35 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so5025411pll.13
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 21:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aL8HKc/o91pieXxtZUmutnJ9MzrPiOY52OcfTyzO3tQ=;
        b=aAGSYtEiWE7jghj1DaUabB+/pW4SPjW4fd/jB0FYcj+KI7+aOVcQcv+a5z3NnkKaLk
         SB1aD+h8X0FiF7+LWVu69ImZcMiDDFa08lMXu/B+nERklYrqzEZjvCWdj4ExajibthBS
         zGKiZGxhV9CA6pJDO+LG/CAr2jTmljg6LTQrhLgzmWK15W6GuHxUp/8P/1lz2plU6T9F
         IP6dHDGIG7tSb/jn3aolwSm1NuSeSLfJmeGP0oS/0YK1QaqvrQ4dl7J7J/o2c199WZip
         iw8ytwjnxxNr6ywgLY5QeZ5lmKIQkDNH7B1uuQZK1LivVRWdjAnsT15oQhmTnXOya8CY
         hZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aL8HKc/o91pieXxtZUmutnJ9MzrPiOY52OcfTyzO3tQ=;
        b=jHGHe/P8RWVi84A4aRQN6PBjTt68lZlL1nXW5QAAIMjtBq8CJLoJ/9Y9t56rSB71n/
         NA9rYiXfTIe26/hg3U8g10TJkO95JEUM34Cj/v2vfqjUJJkkeJfySIJFLhGYgRpYpiiQ
         +XgCL31cb4G3zjC27mAAmDAhFPl2ff7dZL8GSkHhn7KO7n7a26Ms4DMznNGGGr7TH0yb
         5XVONl8BYx8r/6oE2W1aWMsu4ySaWS8c+vebYpbPySLhzuH4vtjEKa061Qb52M33VSrb
         1/YErx0PCPoG3Di0DRDgRvTED5UM+wtEha9fi54kuw06uY4mftXXRsdsCG85siyNqHmY
         wr2A==
X-Gm-Message-State: APjAAAUBBmhB0cfnwoa0o2bX4LmbzOByibcto7h44IRL+o6yeUYi4YU8
        z6kp9T2/H1Re7my67G6RAng=
X-Google-Smtp-Source: APXvYqzj8ah2m+pb28FMF9JbCvbIf7kUma/2EtgcKJR8Lph1es1xJ8LDKtboycsj2HysUH/3Rf9L/g==
X-Received: by 2002:a17:902:b98d:: with SMTP id i13mr1088234pls.250.1582610313054;
        Mon, 24 Feb 2020 21:58:33 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id x6sm7158536pgb.70.2020.02.24.21.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 21:58:32 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com,
        willemb@google.com
Subject: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
Date:   Mon, 24 Feb 2020 21:58:06 -0800
Message-Id: <20200225055806.74881-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP receive zerocopy currently does not update the returned optlen for
getsockopt(). Thus, userspace cannot properly determine if all the
fields are set in the passed-in struct. This patch sets the optlen
before return, in keeping with the expected operation of getsockopt().

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>

---
 net/ipv4/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 600deb39f17de..fb9894d3d30e9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4148,8 +4148,12 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 zerocopy_rcv_inq:
 		zc.inq = tcp_inq_hint(sk);
 zerocopy_rcv_out:
-		if (!err && copy_to_user(optval, &zc, len))
-			err = -EFAULT;
+		if (!err) {
+			if (put_user(len, optlen))
+				return -EFAULT;
+			if (copy_to_user(optval, &zc, len))
+				return -EFAULT;
+		}
 		return err;
 	}
 #endif
-- 
2.25.0.265.gbab2e86ba0-goog

