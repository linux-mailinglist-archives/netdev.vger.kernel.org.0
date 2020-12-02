Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A2E2CCA03
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgLBWyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLBWyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:54:40 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F19FC061A04
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:54 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id q3so195940pgr.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LmHdAbmwBOhO2WKfWjteVd7BXf+Pgg6Y34Kjyfl9lHc=;
        b=KdH3eIlGr/VpSPvX4vj4A+qzZellFQMMBG6OrvGzOFnCXwGBVlRFnnCoBneHKxoCBZ
         dlj78lcyFqsqgE2LSff8JFI9i4GzJ+aPNmlKCSBxVmcCtcVRk2/7N5zT64+Il/L5S6mn
         fi99ue1/4IRWeMhnCDvKXp8Hik/PLaHE0NkswM8yTBsHEWU3HJNcDtxPJ6pWYAtZjWxi
         lHCbue3ezW2M1zUs9788nSCmQbdHQS/CKoKHzGUu+lUYfnUOPaafdvCrvE0Hd1h05S0G
         uXt6MXsu1wwtwzWux0t3hz7FdmjU5uT9RL6c3FVxWX/BbADA7wY9/ql9HzMX8rbibzDn
         q3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LmHdAbmwBOhO2WKfWjteVd7BXf+Pgg6Y34Kjyfl9lHc=;
        b=a2qOueLZ9SqdyHWcVtnMCHE6S/7p7ew4QnwW+fXZFZrwpo84KPlag0WIKD7lhLrFqN
         m1YZQK+eluT9UUpA38z185pj0Gyq11tjltch4OnAPW+v5Pfz2mcqVTu2hoO13CK6DTe/
         Wi5HnJ6RpHarMOwdh7+0MFhXZ9cWivOLba6u8jOA4ADxiVQSTxg0PIf7cfTLBsmx6qva
         KwVr70TrepjYAK8647Edwl1P9f0+V8vndSFGhIhNS0SzW4ph0WKwXP6D9mX/NKbz361m
         UkEYBUoNldzeLnfjLwtWRuuTTGSujasv6jpTaw4w4wqEWd5bvWc5VgGIpQpJRQt1RrqZ
         5e2Q==
X-Gm-Message-State: AOAM5333+FKTo9qf+LDz+56ziYQMmko1KNuA4rsm5ZYoa5NP1XmyXDFQ
        7J9+drOcFNi/KOtzCchXXIY=
X-Google-Smtp-Source: ABdhPJwB7Rg7pvtSBNN60K2S1NtLp/dGhesHCnCEgMuaqWcQSDomZ5IepMbZhT371yHTgVLPhcGIjg==
X-Received: by 2002:a62:790f:0:b029:18a:ae57:353f with SMTP id u15-20020a62790f0000b029018aae57353fmr200101pfc.78.1606949633858;
        Wed, 02 Dec 2020 14:53:53 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:53 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 0/8] Perf. optimizations for TCP Recv. Zerocopy
Date:   Wed,  2 Dec 2020 14:53:41 -0800
Message-Id: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

This patchset contains several optimizations for TCP Recv. Zerocopy.

v3: Fixes 32-bit compilation, stylistic issues and re-adds signoffs.

Summarized:
1. It is possible that a read payload is not exactly page aligned -
that there may exist "straggler" bytes that we cannot map into the
caller's address space cleanly. For this, we allow the caller to
provide as argument a "hybrid copy buffer", turning
getsockopt(TCP_ZEROCOPY_RECEIVE) into a "hybrid" operation that allows
the caller to avoid a subsequent recvmsg() call to read the
stragglers.

2. Similarly, for "small" read payloads that are either below the size
of a page, or small enough that remapping pages is not a performance
win - we allow the user to short-circuit the remapping operations
entirely and simply copy into the buffer provided.

Some of the patches in the middle of this set are refactors to support
this "short-circuiting" optimization.

3. We allow the user to provide a hint that performing a page zap
operation (and the accompanying TLB shootdown) may not be necessary,
for the provided region that the kernel will attempt to map pages
into. This allows us to avoid this expensive operation while holding
the socket lock, which provides a significant performance advantage.

With all of these changes combined, "medium" sized receive traffic
(multiple tens to few hundreds of KB) see significant efficiency gains
when using TCP receive zerocopy instead of regular recvmsg(). For
example, with RPC-style traffic with 32KB messages, there is a roughly
15% efficiency improvement when using zerocopy. Without these changes,
there is a roughly 60-70% efficiency reduction with such messages when
employing zerocopy.

Arjun Roy (8):
  net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
  net-tcp: Introduce tcp_recvmsg_locked().
  net-zerocopy: Refactor skb frag fast-forward op.
  net-zerocopy: Refactor frag-is-remappable test.
  net-zerocopy: Fast return if inq < PAGE_SIZE
  net-zerocopy: Introduce short-circuit small reads.
  net-zerocopy: Set zerocopy hint when data is copied
  net-zerocopy: Defer vm zap unless actually needed.

 include/uapi/linux/tcp.h |   4 +
 net/ipv4/tcp.c           | 446 +++++++++++++++++++++++++++++----------
 2 files changed, 343 insertions(+), 107 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

