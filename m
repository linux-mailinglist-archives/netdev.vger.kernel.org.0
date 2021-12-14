Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBFA47406D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhLNK0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhLNK0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 05:26:35 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4CC061574;
        Tue, 14 Dec 2021 02:26:35 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a9so31529710wrr.8;
        Tue, 14 Dec 2021 02:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/VGyRwF+8Rszd1IEhKwQkaBM8IPnn8NnVzK7EFHiQQI=;
        b=MeomFovZoLezTR1tSnbnhyVLZK6yJCzBDSmkj/nBgqbUvsOhoByun/xXnue5ZYdI58
         /nxkoa2ddfI7vFrfQWBbH4q9UDKBcbM68NlvitWX9Hvn82BCv9RXUe6El+nqswJpnaqg
         0DKESmsXneed8P59QD23eYdcNB3RCbXJG+UCq7IKXxrgD72eG/FWoKXaxnRCjLSGXFDd
         qw+sjvA+5PSiBTVEV2OmV0+KNvCo59GCGusfnCtgWe6Ta36FYfe6JDk4r1IW8OkACh4h
         E5h68MKdReHs2JA+waMB7QXuGj/sAbA6dd94A3Au2mOKVKPm6K95jyzJFQs6xsli3S4g
         L9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/VGyRwF+8Rszd1IEhKwQkaBM8IPnn8NnVzK7EFHiQQI=;
        b=pLz171+v4YgaadibSwgl0fdHzvgUpxtjXxQq7c0MY3mk79yb+AblPHqMapmeJiXJEA
         Ds82uPFzfZ9nev2ZpZvUm30fj2W7JZile9/RMJKbkSgdyqBfPGQ90Zzg2xHwNv6vgoQa
         JKPN4wfmXSOtafz0ZZcFl2QjvqPjJMU325nHvvr6LIm220/p5agd9T91dqnu8FdzYUJz
         akUTHhM4umbeGCbJm377UL+w/XYxsDwoOMo00u0Y/Of9BSKrlYGAQzCCajdGbtcKTG/V
         6hxtEbUF0dDFaAYKgmBuI62ghgg4H2Zi8IkrK3163PFNO75vBnbtkUIzpOXNtp1EL/Wp
         idJA==
X-Gm-Message-State: AOAM5312/i9jaMOSkE8EZ69xvmrvvDfUxpi8VjW6N3Te90Jw5HL7LZke
        Zu3sIMxeZLvufkhXLcbIG38=
X-Google-Smtp-Source: ABdhPJzxIiqQNLAmcsI/Rqq1kNp8fxUliullKf6oqWJW5fL1PEPSOyNsqm/JeFoDYsiP1KczCoKlUA==
X-Received: by 2002:adf:e482:: with SMTP id i2mr5107521wrm.284.1639477593618;
        Tue, 14 Dec 2021 02:26:33 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id f7sm1958737wmg.6.2021.12.14.02.26.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:26:33 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Keith Wiles <keith.wiles@intel.com>
Subject: [PATCH bpf] xsk: do not sleep in poll() when need_wakeup set
Date:   Tue, 14 Dec 2021 11:26:07 +0100
Message-Id: <20211214102607.7677-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Do not sleep in poll() when the need_wakeup flag is set. When this
flag is set, the application needs to explicitly wake up the driver
with a syscall (poll, recvmsg, sendmsg, etc.) to guarantee that Rx
and/or Tx processing will be processed promptly. But the current code
in poll(), sleeps first then wakes up the driver. This means that no
driver processing will occur (baring any interrupts) until the timeout
has expired.

Fix this by checking the need_wakeup flag first and if set, wake the
driver and return to the application. Only if need_wakeup is not set
should the process sleep if there is a timeout set in the poll() call.

Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Reported-by: Keith Wiles <keith.wiles@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f16074eb53c7..7a466ea962c5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -677,8 +677,6 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xsk_buff_pool *pool;
 
-	sock_poll_wait(file, sock, wait);
-
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
@@ -690,6 +688,8 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
+	} else {
+		sock_poll_wait(file, sock, wait);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))

base-commit: 0be2516f865f5a876837184a8385163ff64a5889
-- 
2.29.0

