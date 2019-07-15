Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48B769D0F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbfGOUti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:38 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40949 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:38 -0400
Received: by mail-ot1-f68.google.com with SMTP id y20so2595937otk.7;
        Mon, 15 Jul 2019 13:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZHj7FzG6KKRySBDBc7TLYiAyMZ+JKkfDT3AI7gRaHYQ=;
        b=Mt//Z6ojehdLRVZBQxlCutK6O9L5omSoMegkQTdhEZP6Q7s04Y4PvQAXrgrc3BCawd
         hGJMZAakxhxLUJhPoHp/lTI4GECdjUZIEObeTU5MJruCYURri6QNjWphmKgNmgU5ZzQA
         VFyyhfirSahfcBVF8LzNx3kY+8GJb4qgbaMt42u5Jp8/FJCOB+JKC0y3DAzBlsK9/r7E
         jDqGBxru+pQr3RFu7faSR95PA51KraZhDVPrc7/lvaOFE1y5izXUpcIIRsl3OFx5Rfi0
         CXipNfseLMejqrLdmgKXnr7RPuIEqCeHhMTmzKxbHVmQVi1/U8XlmOB6mzgagzCMoCns
         fOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZHj7FzG6KKRySBDBc7TLYiAyMZ+JKkfDT3AI7gRaHYQ=;
        b=mWihltdDWo4xYboR/JI7V0ppjTKGTgMfVeFkSI0UPxGpwPFHJnm3bJTIq+rGfoW5c/
         TzKY64TNXhdLiaF0WHL/MA798rrUe+6uN4vcJkncA3SUdyh82D6EMqqh8x6K6PY+X0tl
         FA0KU76VyEnHVsyvNs/PHRTxWCFh9AYgi28WRaGOeCwvyp3jJf54C01XTIF0bUo8L8/+
         bmPFntIuMk1FJAer6XzjIcL9t6WlnO7bYqfO3745IlFGxuIJ8TNoPYqbFByJtaRMd7eB
         uBW/hrVgSNSrsE7qQe4mYFjOumuMH+i5hX3nkFtoyLZfkis3qvY9/urv8w8Vx40g1VmL
         CsaA==
X-Gm-Message-State: APjAAAUXsw9At+DwyL24jj24NDGT4qy1Gv45kKX+0P7GuStHiTnO2aoy
        BWjn5wFVqruygavvGKPXwvA=
X-Google-Smtp-Source: APXvYqygiZIHfhM2/ndiQzWwnORwOI00rpzymuG4yHtWBM8FxSllf08V/erRJpNnB8kaGf3ElvX0ow==
X-Received: by 2002:a9d:7e6:: with SMTP id 93mr22157851oto.143.1563223777358;
        Mon, 15 Jul 2019 13:49:37 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id d22sm6381356oig.38.2019.07.15.13.49.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:36 -0700 (PDT)
Subject: [bpf PATCH v3 5/8] bpf: sockmap, sock_map_delete needs to use xchg
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:35 -0700
Message-ID: <156322377575.18678.9230942769643387694.stgit@john-XPS-13-9370>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
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

