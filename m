Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E9375A52
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbhEFSoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbhEFSoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 14:44:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80355C06138A
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 11:43:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 10so5938742pfl.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 11:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WHV64Q9OCDtMSUOAG1jY5VbXZzKskf+t8Seao2K3m0=;
        b=t3UcXXX+iDSGlTkcadXwM8/p7PtGZn/hmdeZ5MyDHpiwe1DBqf518B3K/OOkp1oT0a
         TjiX6RalJ4eGuOc9gLS9mR8eZNx5R25Pha5zwhTzxX8Smg5i+EOPxyS2oeshGyJQPRbN
         wEKQJhnS46tVOUcO9E1Okfj99QggCOLb1KLaXWeBcQ1KPGKn5MKMtTXFoQ0ZF3tWGfdg
         UtsxB9/bHu0QOGQWj3UKnYD12len0dOIlaZ8LkPV9fGVUFAIN8j7+QuaBH41kopL/Tsu
         Hd+9be92b/DOKDWYGBo3k4M/Q+0sHEMOJM27RHpW/4/tl09KPM29xZWQpzb2AhXDjfFb
         sJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WHV64Q9OCDtMSUOAG1jY5VbXZzKskf+t8Seao2K3m0=;
        b=iycq36TGLUrW3T7EyUDZh9hxSj2eyl/BxLA2Uaij0BrXv6edvvJuRyg8bC8e13lNi6
         lQWfdzP+b8IofYBsz6HWsKFkIasRT5642vTeZP8RfLW3xqixCXTjQS8NpdNFyszFqa6g
         KCWJEsTR5D+gPLzC6X/lVVNtar55/mijHccdpPiA0TO8O/7nrVj0sLvKEkn01cmRuGCC
         XIUg2IWuTskHsrpeGjQbSzFQHg1BAmpauPq6PXmANmNDSbRZPHvjPiieKTjkVDUz3Kp8
         XceVbqyuOYGTk6C/Vh8LtYvnZywLumN2x1lhbtZIkzpY1FriCtTWDqPc0RcD9RkBJs8Y
         xknA==
X-Gm-Message-State: AOAM533wSp/jE107MfVO8NHtgbn1qRBCZ21vrER1JHJO2iQK2NgI9wi1
        WHdmeLaOI4hEJ6NmyfuWUMtd9+gyxe4=
X-Google-Smtp-Source: ABdhPJyXpTyLnxclCrXixwNRWwQ9hgCArlegLHEnOXiXpNC6T6Fs4hEzwz63hB5CYkRIDHxRx9xxpw==
X-Received: by 2002:a63:3d87:: with SMTP id k129mr5696112pga.57.1620326586067;
        Thu, 06 May 2021 11:43:06 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2e8b:9dfe:8d6b:7429])
        by smtp.gmail.com with ESMTPSA id a13sm2432011pgm.43.2021.05.06.11.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 11:43:05 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
Date:   Thu,  6 May 2021 11:43:00 -0700
Message-Id: <20210506184300.2241623-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

A prior change introduces separate handling for ->msg_control
depending on whether the pointer is a kernel or user pointer. However,
it does not update tcp receive zerocopy (which uses a user pointer),
which can cause faults when the improper mechanism is used.

This patch simply annotates tcp receive zerocopy's use as explicitly
being a user pointer.

Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
Signed-off-by: Arjun Roy <arjunroy@google.com>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e14fd0c50c10..f1c1f9e3de72 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2039,6 +2039,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 		(__kernel_size_t)zc->msg_controllen;
 	cmsg_dummy.msg_flags = in_compat_syscall()
 		? MSG_CMSG_COMPAT : 0;
+	cmsg_dummy.msg_control_is_user = true;
 	zc->msg_flags = 0;
 	if (zc->msg_control == msg_control_addr &&
 	    zc->msg_controllen == cmsg_dummy.msg_controllen) {
-- 
2.31.1.607.g51e8a6a459-goog

