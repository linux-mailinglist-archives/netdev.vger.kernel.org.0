Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D724C442
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHTRMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbgHTRLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:11:31 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168B5C061388
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:31 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x18so1626023qkb.16
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TprXnGjijq3y+NFkKvqy7Kb/WDKfn8pQZD2ICR8FoaY=;
        b=GuCkuujFfNH+K8er5uA7hFGdirYdlcT+ZrOsxgmzcW1yAsmR385cvBQ4zWjwBhi0Pq
         L5w0MjEMlEFt90o/LF9xxZZr4nbQbPP1R4xLnjlz4dib9fkwmky2eTXwyeHjXrzmdBc5
         pG+CP+2koOQPTeeIbMHIrfK4nV4yYce3TBfRW8gYHvseHFU7lN12RDRPbfpBMKIcG1YA
         N9INuR4zAiS1Zt2bwSpvXC2x+RjzrrDCsosyobyHZ1O8PWvSj7yuNRqMIyBSiBTbGqaR
         tds5En+RKhGVpGDEGdbgE9sgsxP8muvs3U5JtCJBQYUAtmyNyPGJ/gm/1z3ljB06ViGO
         UIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TprXnGjijq3y+NFkKvqy7Kb/WDKfn8pQZD2ICR8FoaY=;
        b=XWS2mLo+1nMs46jthGHzKcuV3blUWWzvRGmH7wsTOYSTWM92tVaR0URu2SMYGLEp/3
         yra2ZZ6TLzvp229goBGKh/DdVs76oqVtkvUgHuhar7GA2HL4Pj1abJogmErpqhTiUOex
         qnrFEwx9TnftYZnb1+Tcj2v0qBXSJTi0VM8pzAU5Psjm3k4ugQ7b3HdyOgpzf/8Z1GYL
         Q9YTWO20oc4oJugBBJhsAhUhvSt5gpX98g7Mh3IY2JgM7r19vffR2xCb5VTwP0QLQHrP
         96tAgCWSYhFNSuWh8fgXEWXI800iwRkoVKIY1QSPNxck4k8SBBRZ/5Qc0FXCVkQErYrg
         dgmQ==
X-Gm-Message-State: AOAM532SOeY/DekU6oRdyoamO+3Lobdv/KnclRypW+Ywosdq5VWOcXVd
        a9u1wdTEqktEw19JFqmuPVDF3O7kqIG2wg==
X-Google-Smtp-Source: ABdhPJwrb05+UGEqWEcmVcTfH+GSWx90kgx6LdI5LX7v7yBACkmTBY+6kM/fWPbtJoDnFt/8oH8U6JJk6IEENw==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:ad4:4c0a:: with SMTP id
 bz10mr3809138qvb.78.1597943490225; Thu, 20 Aug 2020 10:11:30 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:11:18 -0700
In-Reply-To: <20200820171118.1822853-1-edumazet@google.com>
Message-Id: <20200820171118.1822853-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200820171118.1822853-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next 3/3] selftests: net: tcp_mmap: Use huge pages in
 receive path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One down side of using TCP rx zerocopy is one extra TLB miss
per page after the mapping operation.

While if the application is using hugepages, the non zerocopy
recvmsg() will not have to pay these TLB costs.

This patch allows server side to use huge pages for
the non zero copy case, to allow fair comparisons when
both solutions use optimal conditions.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index ca2618f3e7a12ab6863665f465dea2e8d469131b..00f837c9bc6c4549c19dfc27aa2d08c454ea169e 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -157,6 +157,7 @@ void *child_thread(void *arg)
 	void *addr = NULL;
 	double throughput;
 	struct rusage ru;
+	size_t buffer_sz;
 	int lu, fd;
 
 	fd = (int)(unsigned long)arg;
@@ -164,9 +165,9 @@ void *child_thread(void *arg)
 	gettimeofday(&t0, NULL);
 
 	fcntl(fd, F_SETFL, O_NDELAY);
-	buffer = malloc(chunk_size);
-	if (!buffer) {
-		perror("malloc");
+	buffer = mmap_large_buffer(chunk_size, &buffer_sz);
+	if (buffer == (void *)-1) {
+		perror("mmap");
 		goto error;
 	}
 	if (zflg) {
@@ -256,7 +257,7 @@ void *child_thread(void *arg)
 				ru.ru_nvcsw);
 	}
 error:
-	free(buffer);
+	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
 		munmap(raddr, chunk_size + map_align);
-- 
2.28.0.297.g1956fa8f8d-goog

