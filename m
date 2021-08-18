Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE73EF881
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhHRD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhHRD0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:26:54 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D64C061764;
        Tue, 17 Aug 2021 20:26:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n12so958245plf.4;
        Tue, 17 Aug 2021 20:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmiPhOCESicdvfFuj6THhsiLBc+/I7VEPM1Ey/NV9KE=;
        b=Mqzf2GWQaakc9VYcQ9iKSR9/71BwrOPczyjxedQ7LX2mLq83LfPWA0NSnmx3vz61TO
         hyZ5/rySTNhVQQqO+1W+kpT03vJDPnqq7FS8RR3/uKbcPLg3nZAE8QCtMZY7aoXWmrbe
         8VhVPehHwqs1wCwDTdrpm1ZTAXmpeJ4fzR91gjEFcNx6dBnHjt2D4SChhxc2+FuHZ4vD
         H5ZWe2o0Y+AAMJ35by/ojAEusVJIt3fm4HDOH6Jq/v1qZ4BxVAa4fbpPtFeVsX5Hwysq
         HZMoEY3QrhoWuBlAxi09zmXhyTPxJ8jmmmCJkA7n/ZpIqFEVODFEBVC6ybw5EWCOg0TS
         m73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmiPhOCESicdvfFuj6THhsiLBc+/I7VEPM1Ey/NV9KE=;
        b=hE3c3tGes/YVEA4gVcBNDHR9b5WEFlglMWrwf6xgSPDx1hBUDmb4o6oN4vse94C2mp
         R6LrvOMMsb5/A+4VFlKYF6TESEF2oIPmJ43z4vx6ednbma2UNjKZW3AkmjPb2XDors6I
         m+9UzSsXu5uxXB7CzPS8ERxJT4740CCP+cFN4WBBjeJ7kzIaErbzIgiqtTJQrEbuyncj
         tFsJEsKAObGUGom3Jkmu1oUExgM40meV4OT39Z2naa83iqTBrtIMKSg6PhI1fv9zlemj
         vwaVxS4+QHxGsM786ArSaJEBX4wivq9/0ofOa3ecnERhadxdRLI3PvgpkVSjg9l7wH62
         R3qA==
X-Gm-Message-State: AOAM530VmJCEseKVhJYBdtZdZIHQwyJEVHuh1JwKar+j7ktdhKq7RJgJ
        YcaeeEEgrCQf25UUMm6W6oA=
X-Google-Smtp-Source: ABdhPJyk1sMK+ZXuDr8Bk5yw3mMIUAJlzJQFAD426qUqiky382ouaAG+iEY3s492xW/hYe/2FbjzLg==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr6797809pjo.29.1629257179526;
        Tue, 17 Aug 2021 20:26:19 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.182])
        by smtp.gmail.com with ESMTPSA id f23sm4125899pfd.61.2021.08.17.20.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 20:26:19 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     dan.carpenter@oracle.com, Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: xfrm: assign the per_cpu_ptr pointer before return
Date:   Wed, 18 Aug 2021 11:25:53 +0800
Message-Id: <20210818032554.283428-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipcomp_alloc_scratches, if the vmalloc fails, there leaves an oudated
pointer in *per_cpu_ptr(scratches, i). However, in the error handling of
ipcomp_init_state, if ipcomp_alloc_scratches fails, it will invoke
ipcomp_free_scratches directly. This functio will vfree the per_cpu_ptr
pointer. If the pointer points to an invalid memory, the kernel crashes.

Fix this by moving the assignment of per_cpu_ptr point before return.

Call Trace:
 ipcomp_free_scratches+0xbc/0x160 net/xfrm/xfrm_ipcomp.c:203
 ipcomp_free_data net/xfrm/xfrm_ipcomp.c:312 [inline]
 ipcomp_init_state+0x77c/0xa40 net/xfrm/xfrm_ipcomp.c:364
 ipcomp6_init_state+0xc2/0x700 net/ipv6/ipcomp6.c:154
 __xfrm_init_state+0x995/0x15c0 net/xfrm/xfrm_state.c:2648
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2675
 pfkey_msg2xfrm_state net/key/af_key.c:1287 [inline]
 pfkey_add+0x1a64/0x2cd0 net/key/af_key.c:1504
 pfkey_process+0x685/0x7e0 net/key/af_key.c:2837
 pfkey_sendmsg+0x43a/0x820 net/key/af_key.c:3676
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723

Reported-by: syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: 6fccab671f2f ("ipsec: ipcomp - Merge IPComp impl")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/xfrm/xfrm_ipcomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..01dbec70dfba 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -223,9 +223,9 @@ static void * __percpu *ipcomp_alloc_scratches(void)
 		void *scratch;
 
 		scratch = vmalloc_node(IPCOMP_SCRATCH_SIZE, cpu_to_node(i));
+		*per_cpu_ptr(scratches, i) = scratch;
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
 	}
 
 	return scratches;
-- 
2.25.1

