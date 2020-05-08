Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC271CB1DF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgEHOeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726712AbgEHOeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:34:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1079AC05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:34:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h185so2308664ybg.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=tTqhwlA+QDmv8O8u/u6jCXv+euRfFSjdfEqdKaPZmO8=;
        b=chp2nPMZP3pMTC7Ea9CBcSNKwXCGum5kbeY82mciAnSCNNncmKc56CtcluzE49PDmK
         pcOrBYL8uZES87g8d1RIizv7JxaUnDh4XtuRxLVjQqBS+l2tGFhcdQEaeoRa37ffNWb7
         mb1aHchyiqCSViXG5f5yrO4AJfYZfoUNeyBIchyeiZYco3r9HLfHp6egXapWmWV/ozrs
         SdoK+kdri10gZ6IVVN+ahb2n3APzYtBF9bCkpPATzfNHkD1AQni6fur2ZnW/ECByLmpb
         ZsI0SMYvYJ7N5ZwrPuVOZaN6fvNcCoLru87VbRRqVq0DbwOCvhGQHVJdjNyIQgaOyPQq
         vO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=tTqhwlA+QDmv8O8u/u6jCXv+euRfFSjdfEqdKaPZmO8=;
        b=aW+2VcxsWa4ACnjGiQjqcE7kPccqupqkss4kQNIRcnrlccdJCOOMlUsBwwE81LAIis
         k1hH1i0rWp8GebSiiJ3dmpPnz93pqfqI7crHOWd8EQewmawzd+mcWYgZwQz5MY3cvuFQ
         MIkfcKN3yx9SCAxEYNbPFscMUpllHmqvZy1Smvc+FATsRJqtgzMtt2IYmMUKlkDNNgBq
         9A2Y9rdhhwc70H+AaAD1qp9uwzeBUiz08fbdaJd3hiLEL4Pcs03V6pgfaOTzpt+ZB7+U
         kCVUKXVHq0CD3mVp7dEDjVxTieFlseudrOrEX1N9P17D1/pf40jKuatbQEKzCds0hPpH
         0xtw==
X-Gm-Message-State: AGi0PuZHLnEkUD517DDAQyy9O7RNhRTOE7nHGTSDgz8YPWRtxcBPlrZL
        5pYpZmBiUUqixLvvjDDyIDHxqfVefs66SQ==
X-Google-Smtp-Source: APiQypKJ/hG7Bp0Vt8+nig1p9psLNoncHjeFapn1cwPolcdxB51rX8Uq2Bnrs4z7GwZcM0AK5fHlEYB9Lk0UNg==
X-Received: by 2002:a25:bcd2:: with SMTP id l18mr5617184ybm.477.1588948457104;
 Fri, 08 May 2020 07:34:17 -0700 (PDT)
Date:   Fri,  8 May 2020 07:34:14 -0700
Message-Id: <20200508143414.42022-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have to adjust ipv6 route gc_thresh/max_size depending
on number of cpus on a server, this makes very little sense.

If the kernels sets /proc/sys/net/ipv6/route/gc_thresh to 1024
and /proc/sys/net/ipv6/route/max_size to 4096, then we better
not track the percpu dst that our implementation uses.

Only routes not added (directly or indirectly) by the admin
should be tracked and limited.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Wei Wang <weiwan@google.com>
Cc: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa..4292653af533bb641ae8571fffe=
45b39327d0380 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1377,7 +1377,7 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const struc=
t fib6_result *res)
=20
 	rcu_read_lock();
 	dev =3D ip6_rt_get_dev_rcu(res);
-	pcpu_rt =3D ip6_dst_alloc(dev_net(dev), dev, flags);
+	pcpu_rt =3D ip6_dst_alloc(dev_net(dev), dev, flags | DST_NOCOUNT);
 	rcu_read_unlock();
 	if (!pcpu_rt) {
 		fib6_info_release(f6i);
--=20
2.26.2.645.ge9eca65c58-goog

