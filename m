Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6643555725
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfFYSYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:24:08 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35137 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfFYSYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:24:07 -0400
Received: by mail-ed1-f67.google.com with SMTP id w20so20904438edd.2;
        Tue, 25 Jun 2019 11:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Y1fHVNSsj21p520XEod8X+4E/GAo7E8+cJufOo/k1w=;
        b=AP7Npey8pgp8xTDS8RBgnpNc3lwjKMOEdzWsdMvDJg6RKV+vZEQkrIPtyw9Jbkf8Ny
         sINTNiPJg+5BYPSghjcRCEgWQVaWJQdD5k33So5JpXJFv9akoCT3IYJyy2QCD/kHO7VU
         uvJlShEma5aYlNWAgaN48K4HZfZ1m9WduuswxeKGq/EHVqcp5Bb7NPGHu4Oajb6zPIkd
         YpeQK5qX5IJIoQIwgk5tZyI6ZhGWTGzNSmWR9Fpm97VIem3HcNh+z7biTTCUN4A65lMz
         FT7VTukS2CDyHtshqdh4aKYOkT8HW31LYgEhP+/ml5IWmsEgboI5p7Gh8lbBkxNN88BT
         HIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Y1fHVNSsj21p520XEod8X+4E/GAo7E8+cJufOo/k1w=;
        b=c/PAC/ANemJVfRj5BTZeEHBCoTJRNcr+qo2r2xB0XEKgUTmYJXLfPA8ks0GjmjBnJa
         9SlPgajwgd1dBbW53H91t/AisMP2cC/mIkvxA7KzKtJ+8syejjAgcBH6Udu+WrQ0GQg+
         4THcfKGE8gda/2h/04rUifS7xPEz5ObeJrjq35NWZPbsIQ8yVX7udAd4ZGkvYPdNfu0z
         HVyH+lwXh2rOg+mCZ5qNyR37UTKSIT1j/2Z7rga2Ain6+j3ZYWEpLirz09oqMT+193ln
         JjtzPBbmt6AUFeY4xjZ7vLimkUlALfdhWBIJ73pve0JltN4kYZ5LG2PICSt+quejjZlK
         jURg==
X-Gm-Message-State: APjAAAXBnCZuA5MXnxKW0i6eaLLdQtMex8p8z4qScGCpb+BS9OcnpzEs
        MqKXH9vEzbzyRDoqKMm8be8=
X-Google-Smtp-Source: APXvYqyfiVnKBTDReM3U3HnitEqUtLIeUK93VVuj7LIWGKCfAfQB10fvnTBYlQALqQYcYOWHCBiv6w==
X-Received: by 2002:a50:b566:: with SMTP id z35mr140706976edd.129.1561487045655;
        Tue, 25 Jun 2019 11:24:05 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id y3sm4811521edr.27.2019.06.25.11.24.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 11:24:05 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] xsk: Properly terminate assignment in xskq_produce_flush_desc
Date:   Tue, 25 Jun 2019 11:23:52 -0700
Message-Id: <20190625182352.13918-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

In file included from net/xdp/xsk_queue.c:10:
net/xdp/xsk_queue.h:292:2: warning: expression result unused
[-Wunused-value]
        WRITE_ONCE(q->ring->producer, q->prod_tail);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
        __u.__val;                                      \
        ~~~ ^~~~~
1 warning generated.

The q->prod_tail assignment has a comma at the end, not a semi-colon.
Fix that so clang no longer warns and everything works as expected.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Link: https://github.com/ClangBuiltLinux/linux/issues/544
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/xdp/xsk_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 88b9ae24658d..cba4a640d5e8 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	q->prod_tail = q->prod_head,
+	q->prod_tail = q->prod_head;
 	WRITE_ONCE(q->ring->producer, q->prod_tail);
 }
 
-- 
2.22.0

