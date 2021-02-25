Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B83325A2D
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhBYX1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBYX1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:27:21 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79598C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:26:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b15so4511622pjb.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P6hH+7bykaXAExrEEjsW6EzGMwPir3FK+m2/HLK3JqU=;
        b=F9uoh6M7as76KzxcqLovJ7EYra3Gd08chPDWcwtJW1o4gwRcV8Ay7nqUJpPAxDncgr
         1dx+MUKisxD4R3854yrT4bqjG9ZieOhMYzB59GYefObsZqusRpiVqrBWxCwWjjT3J+Bd
         peyTuwrOuO4aLmYa35+gINx/JPBA375Uv4UjtBrjG+fM3mIJpRDZORR9+6uNgqp4UV7S
         NoB2w33rzqMLOCojRBq1CJ6Ncs16C7rLVGhIS0URwCwCI29YYAz1gBolqN9baQTM1rIz
         KRsbbaxzmRsJg9YR2NRR+WbpRgVyk8hDI/qVSSDYcPsGLhafEUxph+JH3eO47zJC2uhv
         rJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P6hH+7bykaXAExrEEjsW6EzGMwPir3FK+m2/HLK3JqU=;
        b=fVLPXn4NMcSSrbdkwMQVqLzc3N6CFbK/+lSaCabMoshoPThGGk73FnabRzlsJLU79v
         xEAr9/O5ejYFKrWrUseWRWCo14bQRnvrre1PNbZU3U6sOYbjvPz+0xg7YoXL/g8o2lmX
         SmW6uqhrbm/SZUEeZt2QNUFfFp3tcVdzNqvnuP6ng7Dt/ng/gr5XBf9q+m/hNl+TI8RH
         gzNa48X8reWvjwc3FYDRUF3uG9TZ3emxrNRJwb1IOgctyTDOMBkJhMowhdbzi5z3eH/w
         melT3k7uQ+kIPxMCkkW3jLH9NxOwesL+tHuc0sALPnL3InWXqOcAG+3Ppg5f/bmFQL3K
         A9Sg==
X-Gm-Message-State: AOAM532C7p5YHhbhTKDn6/ZmeT5tCSi6g4laaoc44fCVjwNWEVjT18gv
        5xBVcEqxrM3Khhm5LmyzbKs=
X-Google-Smtp-Source: ABdhPJzTsHBWjDZ+3jGk0RYo+cU8zdM1/OtQSc09Ltw0TvW9on334jXTQqQhSV4WleQ0h6kqLRRXBQ==
X-Received: by 2002:a17:903:3052:b029:e3:c30f:15a0 with SMTP id u18-20020a1709033052b02900e3c30f15a0mr414213pla.53.1614295601044;
        Thu, 25 Feb 2021 15:26:41 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2dc5:f1cb:e2f5:7297])
        by smtp.gmail.com with ESMTPSA id h123sm5207629pfe.115.2021.02.25.15.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 15:26:40 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net] tcp: Fix sign comparison bug in getsockopt(TCP_ZEROCOPY_RECEIVE)
Date:   Thu, 25 Feb 2021 15:26:28 -0800
Message-Id: <20210225232628.4033281-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

getsockopt(TCP_ZEROCOPY_RECEIVE) has a bug where we read a
user-provided "len" field of type signed int, and then compare the
value to the result of an "offsetofend" operation, which is unsigned.

Negative values provided by the user will be promoted to large
positive numbers; thus checking that len < offsetofend() will return
false when the intention was that it return true.

Note that while len is originally checked for negative values earlier
on in do_tcp_getsockopt(), subsequent calls to get_user() re-read the
value from userspace which may have changed in the meantime.

Therefore, re-add the check for negative values after the call to
get_user in the handler code for TCP_ZEROCOPY_RECEIVE.

Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arjun Roy <arjunroy@google.com>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a3422e42784e..dfb6f286c1de 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4143,7 +4143,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 
 		if (get_user(len, optlen))
 			return -EFAULT;
-		if (len < offsetofend(struct tcp_zerocopy_receive, length))
+		if (len < 0 ||
+		    len < offsetofend(struct tcp_zerocopy_receive, length))
 			return -EINVAL;
 		if (unlikely(len > sizeof(zc))) {
 			err = check_zeroed_user(optval + sizeof(zc),
-- 
2.30.1.766.gb4fecdf3b7-goog

