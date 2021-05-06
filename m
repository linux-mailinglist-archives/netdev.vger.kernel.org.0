Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F425375B63
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 21:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhEFTHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 15:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhEFTHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 15:07:21 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D792AC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 12:06:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m37so5390894pgb.8
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 12:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j6J6CpxsQ7gS0PpUJWqTvOgMCsKuAKIECvvQwf7YPwM=;
        b=vcp2hgXO4r/d3gVdxdhzQKBVhTum7/0ccHBf8UHIpKfszDdB2ArQBXONS550pHxPeG
         smDpQOU50ruI4tJ+HORRS5e5J48YT0ilrJnszoY9hC5tZaD9MOtKdVOZckLS7+eiAz97
         yyk+edF5Xyzxfw9r/5Dmfmjvqbcb6Y3JL3sjM0u8UFDsEUoe6QhGtuMR8IYqm7aAwLVm
         +fRYq0OF3NVAgCHRUNqeYuTpx8+gw9lCpTwhVHyoibd5N5AixKpvPB8grdF4n983wacy
         kiBzpCP4ouhCqEzytpNjji11HWT6pjXzw+Rh1vZtjIshfY1J8pCYYhiNU4C2YQCQrjcH
         eTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j6J6CpxsQ7gS0PpUJWqTvOgMCsKuAKIECvvQwf7YPwM=;
        b=t3vlyJkxVdxmq4L27iXmIeO0MtzyBOAZR/I7mVQpa/MueOykUjjGZr9o0PgECxyBVS
         dtSOGSjRV5PCExe/zIKRL09HSglp1NhX0Et2521+6ccplYVzF9LRKrsrek8Xo+K8oGO6
         g1gXCQM3+urYmFoEL6aUHPC0s4lBZ2DEwTUEnpolbI1gcZU1RbO7kExVjeobYV4skP1z
         ebGLRZ4WyFN9mt769CFXVBbLwVmpjIEaEOzra2/uXJgE/seX9E9GpJ2XNfqxEvmYOzv6
         SL365JYcCgIRfo5UVHlFXj066t10dr+f+D6gZa5NpXiDOJDRI8wgANyhY15MVKDHYgXx
         3x3Q==
X-Gm-Message-State: AOAM533GYJ9nDuvLIhNVnxZ7AJBffkg8RAoXeuFqeCt8AWWe02OossHl
        bgBHL3TtaZBrZHOXukNIaIGJkN/mqtU=
X-Google-Smtp-Source: ABdhPJymj01Zbqz35q1wtQpe6FUhuJCyQjABhrQ8T5wuhEOAZaojIZfE40cWRps6eX01JcniiAEzKw==
X-Received: by 2002:a65:45c3:: with SMTP id m3mr5706228pgr.179.1620327981453;
        Thu, 06 May 2021 12:06:21 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2e8b:9dfe:8d6b:7429])
        by smtp.gmail.com with ESMTPSA id z27sm2891730pfr.46.2021.05.06.12.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 12:06:21 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net v2] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
Date:   Thu,  6 May 2021 12:06:17 -0700
Message-Id: <20210506190617.2252059-1-arjunroy.kdev@gmail.com>
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
---

Changelog since v1:
- Updated "Fixes" tag and commit message to properly account for which
  commit introduced buggy behaviour.

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

