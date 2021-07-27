Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A73D80CB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhG0VHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhG0VHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:07:03 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42699C061799
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1073908pjh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p/9n5XlKkS6wfkCIPw1DbbDsmNaE09gzmWAUlzSJHk0=;
        b=SW72vFpyRvi/mMVr/UQMOgHPlxYF/P0e1ZiidnPntTAcbmVZzEGGh8mQvyc6/PMYan
         7VRaIK2m566aD8CTsIKSvbx/ZXJ+9IYZ/X/O7tqEYF1n1rL4di55gpn/tChdbhLwc+Wz
         CXtVDDX34F4hVt3hvgvuSFi8Unf3XeFPwkISI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p/9n5XlKkS6wfkCIPw1DbbDsmNaE09gzmWAUlzSJHk0=;
        b=BDwWmBCJb52Q+L7WmySau2ImT8An1dptSAUcms9LRQjq94cOuU7Z0koxE13RqWOqD2
         iTVNUF4QxgHyr9FpRibqC9/01KGtBdgJoHFh2w4UMkrvD39PXlEIwS3fPXmwZwllmW1m
         FvHAXj4uz9O9YHXfDFpPpqGCo0WlJm4eokb1chiA/BIdQtUe+XigR6xRglMpkIgp+ZXc
         tDnUUXrLeBj51FrenRYmQZWHEzhgrKdcyBW1H1nSkXnJFRC1a2waC+BDrywc2J9d3rl2
         lLINEgUCVnDwtIvntHOeZMOsQIdidcsl5RHGnhEzaW10/4SIWXw59D0U+4268M7IjTIw
         XvHQ==
X-Gm-Message-State: AOAM533eB5qYLCWPA+0gVSRW6uV0Epv/XRzdDnA/yvhrMiNj2e4v2fQN
        ttvfrm1hOMGAGis0YFU9SJzQbA==
X-Google-Smtp-Source: ABdhPJxaFQSeLhkc1zJ2oaBRJsMZBtjwIKQhIZuTJXa2K2J8IKVPpYMViisfXlARKBOGaL/7RusDbg==
X-Received: by 2002:a17:90a:12c7:: with SMTP id b7mr6026153pjg.205.1627420017868;
        Tue, 27 Jul 2021 14:06:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r18sm5038817pgk.54.2021.07.27.14.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:54 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 41/64] net: dccp: Use memset_after() for TP zeroing
Date:   Tue, 27 Jul 2021 13:58:32 -0700
Message-Id: <20210727205855.411487-42-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; h=from:subject; bh=setFCuudESAmPvU7TENmlV2MS4FRl7JRml2jjTFJDIg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOJKZ5loXhOKkjkBoj4absMkEGlM+ZkGAgDZtTY /isiJOGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBziQAKCRCJcvTf3G3AJl2GEA CkmbILRtScVKazMb1tWpR5Wl/pQ4wUktuV62qIpYEEpFPkHrnESIQz1ChkzSepdcASTNc4T6oa0NP9 WsXo723hzRQElBcUpAdaEQZWe/aRzQgxz6NuJ0ucec44ap26fdlOUq5jkNdSul5xj992thaeMiUWHl M4YJzdgCpzk8OEKhzLzvrViKkK+IaPDmTMBwHh7u5gjX9tk2OqSPx/ZXot6tYvhFg6/Oy0vv+xHrlp iovAgyyLvDPGPpUEgGj2aKBFXc/d/xxdCSuI3b1elrnHoEBod1sM3BVLd8BTraljZmNAi7wrINJzHM eu2aKaVwpvUJwWQr2BuBBRGeV74y1K8w+/Tvp0fufvz6558D1uGi5jCrDj5V4/Nj5+HrvI6IbWlYbY NSCPJB6kzUX1DRdtcu/6/wMtBFe02I7zLytHfwOcQVNqWqm6EA+YewjYVECp7lCvhT+po+Tp2LcZA6 YKyyOzP6+CTDLOyriNbgoebelLFhlWWOSb9rZGEBhs9FxI4qFJJAxmatGkCcUH0MYAz6v5PPfjvR86 yjrrxYWYwC6cjmhctqIhpAdMEd0GZec2ed3KYFABa9OyGSC8Ezex48JITcr9RBnKCdqux3UCJodziE nhi84Hw40jD0Ho9czi4juaFwDxA2xtuq+zKB1K159GTFsJfOh3CFAYS1xoow==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/dccp/trace.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dccp/trace.h b/net/dccp/trace.h
index 5062421beee9..3c2594da49fc 100644
--- a/net/dccp/trace.h
+++ b/net/dccp/trace.h
@@ -60,9 +60,7 @@ TRACE_EVENT(dccp_probe,
 			__entry->tx_t_ipi = hc->tx_t_ipi;
 		} else {
 			__entry->tx_s = 0;
-			memset(&__entry->tx_rtt, 0, (void *)&__entry->tx_t_ipi -
-			       (void *)&__entry->tx_rtt +
-			       sizeof(__entry->tx_t_ipi));
+			memset_after(__entry, 0, tx_s);
 		}
 	),
 
-- 
2.30.2

