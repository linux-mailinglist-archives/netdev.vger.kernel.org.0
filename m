Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB7229CC4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGVQHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgGVQHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:07:23 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3208C0619DC;
        Wed, 22 Jul 2020 09:07:23 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x69so2508101qkb.1;
        Wed, 22 Jul 2020 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inXRPYgND6+0WE39IDvE6wldzJTBYfDxX/wQ/vOfPn0=;
        b=a8k1mfHuBtctSv/v34AEQtJKDDMJsmzgQiLNEMGt4v2xwXaP9+GEfP4S+dVZi9N5cm
         StZ5VmZHe2C9KFpm5eofHmXUSvhi240cLFMIKR7UoqZ+KwFyYOXEZdIAbWrh7WAmVu4o
         7OcBxIEmwji96oE6vzBnqIvyyolTXj+IlHB/WVPIq0FWjRTz4zKz9GVi7/uWcYDDWFeu
         OqcdP+yyS4UEjao+xsT+J2XbAySKFfuFsUPmlbi8SM84zy/p3CExBuMfJQ6sk2CPMnnJ
         cKxPqrDOJnOgIQyJ2xBQ9c6B2wlAss8VNk//84EIuIgbdRYnnERBUNuz5E6J9LoAwTOu
         bSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inXRPYgND6+0WE39IDvE6wldzJTBYfDxX/wQ/vOfPn0=;
        b=UK412WiPGhcjb9w0Hfdi6XiKbWrQF7dfnC30EAAxmN7PZIQ3M9oSNB3r4hRDq3s4/L
         QTSDxHX3RWLEAc0a/eOwjYDn7iCdRLo0LEv65lCKWJXno0jX7aVH/439IxNuuD0pfrFq
         polnLqLlIBaX86JawcnxE6p2KRAnROYlWEPXeWKQJHP/FTEOkIu3lHxxhInbTw6+rJW2
         0PCesmYsax1uXdIfyGsqHl9+joMLzRFYVDaxKthsKkqYA3+GQhvZp+HG6cO8dRvZB5Fp
         9g33QFqGEB0aYWasLBcJGoVgS6kUuRkgne0fpnStWuMTTT2e2he7R8EZuybxGJDFS4NG
         xUGw==
X-Gm-Message-State: AOAM5326rxDnpKxnVUpmQ2zlX5zyPI3bJ/j17/5R4ufBNuJz+P2XjAHF
        gtQYpEzlixq4gpvldTDQDuAXowU3nw==
X-Google-Smtp-Source: ABdhPJx8zadp5hybrNbT1YGP6AF/F1kHC13kJf+YtmdUCtFIfFdTeqlM39WpgDmRgaDFzLlCZ3LU0A==
X-Received: by 2002:a37:8302:: with SMTP id f2mr644452qkd.271.1595434041414;
        Wed, 22 Jul 2020 09:07:21 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id f54sm76376qte.76.2020.07.22.09.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 09:07:20 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] AX.25: Prevent out-of-bounds read in ax25_sendmsg()
Date:   Wed, 22 Jul 2020 12:05:12 -0400
Message-Id: <20200722160512.370802-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checks on `addr_len` and `usax->sax25_ndigis` are insufficient.
ax25_sendmsg() can go out of bounds when `usax->sax25_ndigis` equals to 7
or 8. Fix it.

It is safe to remove `usax->sax25_ndigis > AX25_MAX_DIGIS`, since
`addr_len` is guaranteed to be less than or equal to
`sizeof(struct full_sockaddr_ax25)`

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/ax25/af_ax25.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index ef5bf116157a..0862fe49d434 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1509,7 +1509,8 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)usax;
 
 			/* Valid number of digipeaters ? */
-			if (usax->sax25_ndigis < 1 || usax->sax25_ndigis > AX25_MAX_DIGIS) {
+			if (usax->sax25_ndigis < 1 || addr_len < sizeof(struct sockaddr_ax25) +
+			    sizeof(ax25_address) * usax->sax25_ndigis) {
 				err = -EINVAL;
 				goto out;
 			}
-- 
2.25.1

