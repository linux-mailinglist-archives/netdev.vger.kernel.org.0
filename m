Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CCD375D35
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 00:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhEFWgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 18:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhEFWgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 18:36:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A7AC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 15:35:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p17so4107939pjz.3
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 15:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=04GW86lDPR4GDfEJrkYeSR17wXpHPmu4c6UoEnvjWnw=;
        b=DkwTCST9DLmhZSbB6vrmjtnWuavrJni0dJ2o6/5BV89PS2/6OxBAcCLwMrSytgdbPl
         BvECCH/VOgLjliRgjq3U5P+w3FcNEEjTRGrBlOfwnVZXNH9g4YO5mVoMSPPGa1iJqJWM
         MnEbCYp+CLVFkzjABdq/nMglkTi2ynhGFxc+WaxoSC4+NNGswcUb9DcFhkDsLOvjXS1F
         +1WaO+cfWQMFAvEEFfFgWk/mBaiz8MNCQTwf9Z1bPLC9cNaWNVe4JBaXhmXyGSlXVp3f
         85K2026eqmwpFAmzEGWKPRiMqt1aObVSELHemS/1DKdY2OdjLj5KbezN56SqR3byrhxt
         s57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=04GW86lDPR4GDfEJrkYeSR17wXpHPmu4c6UoEnvjWnw=;
        b=ZbuQygMUjYG4EAIyxl9FC7RpZbcXHiNiSgKWj9DTu+VFEnTMNAb7jKJpXKuhm25Ljj
         kkrxK+07x08T3gacaQjHfKviYUzdViCZUQ4JgLPU6EUIC38T2ROrTSrRu76Wy0Vyv8kd
         NHRPxCA471T7OsFuw8DdRr/vbJ3AzBkEVSTMzbXVechFqKw5i4s4metxBCMb+WsQXbZL
         ZvuhIXgj3n5rmzHY/rOeuXcpVHMHXtcWnupebPiMTTRrWClJOZ14zpK7hZ5souZUSCPA
         bD6s14zpu4t0dbiWrFrNnJkga4IKi3ay8m9pygrQbH9GcYwt0MXMUFA1QoKmQOfGqS1b
         eKaQ==
X-Gm-Message-State: AOAM530Mbmxzo47qxujNFxMhpgwVCkcuJ8a5I+zvtIIR89gz4Fxg0gnw
        lXDE63SSqkAUzJqj3633edg=
X-Google-Smtp-Source: ABdhPJxwOi0K57qhp9RGbZfDUhl4+rOenG9p2RLCSzuBDneUHIjhe3xPmgzRSAznzR5kCFAwPxH1Qw==
X-Received: by 2002:a17:90a:fa0e:: with SMTP id cm14mr20097526pjb.59.1620340536667;
        Thu, 06 May 2021 15:35:36 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2e8b:9dfe:8d6b:7429])
        by smtp.gmail.com with ESMTPSA id 16sm10574095pjk.15.2021.05.06.15.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 15:35:35 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net v3] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
Date:   Thu,  6 May 2021 15:35:30 -0700
Message-Id: <20210506223530.2266456-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

A prior change (1f466e1f15cf) introduces separate handling for
->msg_control depending on whether the pointer is a kernel or user
pointer. However, while tcp receive zerocopy is using this field, it
is not properly annotating that the buffer in this case is a user
pointer. This can cause faults when the improper mechanism is used
within put_cmsg().

This patch simply annotates tcp receive zerocopy's use as explicitly
being a user pointer.

Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>

---

Changelog since v1:
- Updated "Fixes" tag and commit message to properly account for which
  commit introduced buggy behaviour.

 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

Changelog since v2:
- Updated CC list. Added review-by annotation.

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

