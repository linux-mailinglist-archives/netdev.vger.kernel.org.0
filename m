Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D642D0BA8
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgLGIVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgLGIVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 03:21:14 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601FDC0613D0;
        Mon,  7 Dec 2020 00:20:28 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so8272357pge.6;
        Mon, 07 Dec 2020 00:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7loJejYCZUiegYYfnZHF1zns7qEuuJti+0V+ypDNatk=;
        b=qiNx+8BiKnA64HSAl6dDGA0EzBv7cjOSUUdA/SF2qwTDtkBSz276uVUjf4j73FQbxT
         36zXWEs+JOMebWDAsu6zfsTQ9NyCF5yFngPKk426FnHnm+IRPIJU2zstGsogqDVTfmss
         79RAJVR9QAGQly1rCsd5SOvgRQezoTG595V0dWVHFqDWIJZaL6Za3gznaNVLTgDbF4/V
         UDN08SVJByUTsF/PimNRG5V0G0BKB7Z5zjBcCtZ2r/fZn/U4q1kIZ/Kdca5JCdaKBmAi
         +WZk/lQvra1COO0q+SBwwK3ZAvlYUpfJY5I/ZcTngqFdlJ25qi6qTzaASeVoSVfxnXjt
         RguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7loJejYCZUiegYYfnZHF1zns7qEuuJti+0V+ypDNatk=;
        b=a7dCikJyTBDZa7tDrrID+xF+Fw84eJhJ4N5YmQs43iazNIfp57mcrovAOFmjDwrHLt
         dCu/NDCB59CTWrWEXunFjvfcx6UgHmWeWmmtVe3klyUeHM7TNpSwvu1QxE/TL3huqZp3
         uuFhIi787DTGTS7YUODBSlF+Il/fwAsqWfx2Vekxo42Ibo0ytEclGL9oMrEmdDSbz5mn
         Kgz/z6jpzsFFrDycdOT39QZWl6S24pFy1bA1aJU0PVtuAM+ko8qirEmE24DabgEXUwde
         c7wUmevB4qHjFFeFclkQoBS2N7z3Lvn+oaU02XbJGNG7UlSbO53mJSQvzXWEd7excgzw
         tuLA==
X-Gm-Message-State: AOAM533aMJV0iNGcSQdJF9OpBfZRx7UdPmXv4Loy+GkTGlvh6eadOEdl
        N464rwfUJoFPxWRz0aQr4frN2cwJcr2AZQ2k
X-Google-Smtp-Source: ABdhPJz9Ff4GvMEQMz32yUO0DTmI1UWRZUmuGqe+dQBoV1af5faE3ty3mxUENOoQUuxwdFBcHl4VXQ==
X-Received: by 2002:a63:5712:: with SMTP id l18mr17488343pgb.79.1607329227940;
        Mon, 07 Dec 2020 00:20:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id j9sm12971560pfa.58.2020.12.07.00.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 00:20:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH bpf-next] xsk: Validate socket state in xsk_recvmsg, prior touching socket members
Date:   Mon,  7 Dec 2020 09:20:08 +0100
Message-Id: <20201207082008.132263-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In AF_XDP the socket state needs to be checked, prior touching the
members of the socket. This was not the case for the recvmsg
implementation. Fix that by moving the xsk_is_bound() call.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 45a86681844e ("xsk: Add support for recvmsg()")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 56c46e5f57bc..e28c6825e089 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -554,12 +554,12 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
 	if (unlikely(!xs->rx))
 		return -ENOBUFS;
-	if (unlikely(!xsk_is_bound(xs)))
-		return -ENXIO;
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 

base-commit: 34da87213d3ddd26643aa83deff7ffc6463da0fc
-- 
2.27.0

