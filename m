Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86683CC675
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 23:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhGQVW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 17:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhGQVWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 17:22:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFCDC061762;
        Sat, 17 Jul 2021 14:19:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y3so3054573plp.4;
        Sat, 17 Jul 2021 14:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+jXk6zmzrnQw9ffNBdfJ4IIggoXjoJjxUf/3qpD11FM=;
        b=lZ85RRvWdiHLyZk/FTQPaej51raHhcDmst4zXVGHvqnjVYQgc8vt7VIo690pECsRrU
         dV9/vOZIQDw7N6jv+2rkihMIvw+IAQqAi0NNMgaHPceCQaeKf9pPjf9uF3FX6n0NM9Xt
         8mGuOUkuwfj8u0pwa/fiVmj5y/P7xWMFscDDyIZY1IGVWPK8Fa1TnVCS2trozV3obFFq
         Fa2m8o9sfsfUdrzpCqYk49qef8mEEBCpZj4uaSgyc+ToW3lJIaQQZ616fZxJ8a1Q1r02
         C2RvuWdwZcY471QgYUI+Nc0+7ncAZQHocCnu820dHvdgC8jvT7CMp3s9l4/FWMbfV8Dy
         s4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+jXk6zmzrnQw9ffNBdfJ4IIggoXjoJjxUf/3qpD11FM=;
        b=tIp6z7NI9sZLZ+q3tvomqTfCjyycr81lTjryI7A76/97fWMQrG4YJZOOcZJkmUn3rZ
         SEKguDGvANpTbFqgc1QiGFSqin9BllBGQ1jUn3Nsf3oo8HudTg+om2cLBKu9QBvKGuc7
         of3C8bp65CVaq4U5oI4QL7j1At8PxurKLcg5DEBvEQ9mz11N/HP5BBlCPaeB/aghOIoU
         /QZDu32d1lY9p/C5p8c0kmAg0KHzpr8w6Axg2Xf8gpG8oX3UPNBYNbH2Gd0vN7N6ylpH
         fGPX2X8/6pfXUSls1EX6Q1yymeIhR8ZmvxKPaLSEAbqux7lTpQTxJPz3Q9kRq2wQIfLJ
         UcJA==
X-Gm-Message-State: AOAM531qj54RYbx+fOMPbVRs2dTNccUSkPbLxBYdskaaoUJ7N2uTr36W
        3Occ0Yi/koOA2wX3NdUs4UYwV6cqo4sEeg==
X-Google-Smtp-Source: ABdhPJw2f+RKa6yzFAdWcS4kVb5/z5KVsmktXp51J66U015t3yUd2SCv4YaEC1tDb3CwQ6xkNo4qCg==
X-Received: by 2002:a17:902:cec7:b029:12a:ece5:6abf with SMTP id d7-20020a170902cec7b029012aece56abfmr13150666plg.50.1626556766666;
        Sat, 17 Jul 2021 14:19:26 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w123sm14396460pfb.109.2021.07.17.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 14:19:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: trim optlen when it's a huge value in sctp_setsockopt
Date:   Sat, 17 Jul 2021 17:19:19 -0400
Message-Id: <0871af1e816f5239aaf546fcbc24af31aeec780f.1626556759.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit ca84bd058dae ("sctp: copy the optval from user space in
sctp_setsockopt"), it does memory allocation in sctp_setsockopt with
the optlen, and it would fail the allocation and return error if the
optlen from user space is a huge value.

This breaks some sockopts, like SCTP_HMAC_IDENT, SCTP_RESET_STREAMS and
SCTP_AUTH_KEY, as when processing these sockopts before, optlen would
be trimmed to a biggest value it needs when optlen is a huge value,
instead of failing the allocation and returning error.

This patch is to fix the allocation failure when it's a huge optlen from
user space by trimming it to the biggest size sctp sockopt may need when
necessary, and this biggest size is from sctp_setsockopt_reset_streams()
for SCTP_RESET_STREAMS, which is bigger than those for SCTP_HMAC_IDENT
and SCTP_AUTH_KEY.

Fixes: ca84bd058dae ("sctp: copy the optval from user space in sctp_setsockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e64e01f61b11..6b937bfd4751 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4577,6 +4577,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	if (optlen > 0) {
+		/* Trim it to the biggest size sctp sockopt may need if necessary */
+		optlen = min_t(unsigned int, optlen,
+			       PAGE_ALIGN(USHRT_MAX +
+					  sizeof(__u16) * sizeof(struct sctp_reset_streams)));
 		kopt = memdup_sockptr(optval, optlen);
 		if (IS_ERR(kopt))
 			return PTR_ERR(kopt);
-- 
2.27.0

