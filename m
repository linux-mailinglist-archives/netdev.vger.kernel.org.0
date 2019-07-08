Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4686291E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391536AbfGHTOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:14:37 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42972 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfGHTOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:14:37 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so37757794ior.9;
        Mon, 08 Jul 2019 12:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZHj7FzG6KKRySBDBc7TLYiAyMZ+JKkfDT3AI7gRaHYQ=;
        b=Muvb234SOfI2dkAM481zW/DsSPQRjV4pTwlWdKOCxo5jtzZc3QbpcYfS3lp2DtzKgW
         SCbhZO1+ctHSXwhQhViRgjpaQI/ty0bOIzECsc2WID5Rjmz9MN1L+BIaxcmN56kT4Y5f
         pNYCofDHeCgphlpp0bqkZed3/tfi/YF8NhT10VFceJtcjGVOJkWpbENx/Xc+omeKbtY+
         HVSwnO9zTJIXwRg0lURkgt2vDRfVbWFN+79jXUHT8kp9AStjjCMQz39rLTuQUc6UsPCw
         4TGLePgDeSH9E6n/Vf051gWhU6C1S94m/Vt20lKlM81507FUsEs9bPUC0jrJ7h1xYcwg
         M9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZHj7FzG6KKRySBDBc7TLYiAyMZ+JKkfDT3AI7gRaHYQ=;
        b=MJ30eqmgJAsZ+4Ybo/CqPHU/wf/B0AeuLjYulbQQoDonL86aPSC09QqX3vVgJmHcDL
         6PiN1WLAJgGtf7Il8WJ+M1OgTF8+1zQYzYXMcYG8kMUxJwlTtaR76IIsU81tIB6/Cisr
         AxEIPbGhg8ebYPz44GCwRBphR7i3HLVz3VnJU2DOQC9LLPWpGtpOnQ/Y7U8h8oooCrNP
         fJwYMKtiwuOGSfEMDi6y/dig6Vu0uGV7OYNOgMo5yLnv8nlD6k4zzQY3Y7zfKk9Ls1G5
         I8qzjm5cDV27/eTHMnxgesmVoZWayoRVWg7VL+iVhCUbwcVdusOkPPb6Yo4s3oO5X+7/
         Alkw==
X-Gm-Message-State: APjAAAUZQtAj6ZAWrn72P5eoUIgCyIRo5F8g7y+LDRivrNrIrQwOrFOE
        lKsIEmRbOe3nBl9xIUBaaok=
X-Google-Smtp-Source: APXvYqz3ev/yMDnkXUqLxZeVICHbSM9FMfCk+G9X4V1kQN2o+fn+NB8T6b4Ay+2n7NDSloC2wr5flg==
X-Received: by 2002:a02:3f1d:: with SMTP id d29mr24516554jaa.116.1562613276243;
        Mon, 08 Jul 2019 12:14:36 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c17sm15350637ioo.82.2019.07.08.12.14.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:14:35 -0700 (PDT)
Subject: [bpf PATCH v2 3/6] bpf: sockmap, sock_map_delete needs to use xchg
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:14:23 +0000
Message-ID: <156261326334.31108.17728262375224434415.stgit@ubuntu3-kvm1>
In-Reply-To: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__sock_map_delete() may be called from a tcp event such as unhash or
close from the following trace,

  tcp_bpf_close()
    tcp_bpf_remove()
      sk_psock_unlink()
        sock_map_delete_from_link()
          __sock_map_delete()

In this case the sock lock is held but this only protects against
duplicate removals on the TCP side. If the map is free'd then we have
this trace,

  sock_map_free
    xchg()                  <- replaces map entry
    sock_map_unref()
      sk_psock_put()
        sock_map_del_link()

The __sock_map_delete() call however uses a read, test, null over the
map entry which can result in both paths trying to free the map
entry.

To fix use xchg in TCP paths as well so we avoid having two references
to the same map entry.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 52d4faeee18b..28702f2e9a4a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -276,16 +276,20 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 			     struct sock **psk)
 {
 	struct sock *sk;
+	int err = 0;
 
 	raw_spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
-		*psk = NULL;
+		sk = xchg(psk, NULL);
+
+	if (likely(sk))
+		sock_map_unref(sk, psk);
+	else
+		err = -EINVAL;
+
 	raw_spin_unlock_bh(&stab->lock);
-	if (unlikely(!sk))
-		return -EINVAL;
-	sock_map_unref(sk, psk);
-	return 0;
+	return err;
 }
 
 static void sock_map_delete_from_link(struct bpf_map *map, struct sock *sk,

