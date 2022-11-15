Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329416293ED
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiKOJLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbiKOJLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:07 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA921E1D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-349423f04dbso130655457b3.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b0YyahNj2Zvm6NvOfL2D9vMZ8vKhHxd5MfdejYaMVGo=;
        b=Mbmu2SDQ5a7AmXFkD6VG1SuaLF12GPCeLperCgZe7O1uL1/61NoGMff+Sq5x9TCRjz
         ebSva1VJsxQiwevZK2BvsrQ3RkatHYUW1TT1/cEjSn3zlN3jjELPyJNu2lCLnn9VOWeq
         Y+AHglsgUXiy0nVm4PTzY2d59Zjv1o5xFqmPkAQIeTdHte4LxziAjHSHBuNByedM6lR/
         z/5bAwqhKOTDEC+f3a8dxAKJX/YRlF1ziZW45yX8ZJRlLhCBtbIW+90Bh+dXUYx/VOlM
         fqyMSJoRVQz6ruPr7nl0pDSZ2viaKza0exmvmTgQse384dCeZPyPFHZDgwtGe6wfE3gb
         ajGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b0YyahNj2Zvm6NvOfL2D9vMZ8vKhHxd5MfdejYaMVGo=;
        b=pn/R+YfnZKuBBn0RqI4C4pGaNmJQwmBsrIrrOfT8iaRPSqi9ySNpOb0Tw46Np+RDqb
         Cx677rQW9jz355YWP4TxXVmySGFyEFJN2xPPJPcrU0FwttXpU+3nc49tOAGx3YXTBb4w
         oAVfdQHtqVZdiH3SVxjrRpOA+mkqs0QdhZGrpoIPkyBRjfrzojTMRgHQlKkbW1MUEzBN
         qJnP1Be8SxYqFcMqiC+AAX4hNSLNuYpKn/r2TunrFSRusO8zFOVa/NVWBuUMynBQpMuV
         rFS7GRMLX3VCIsXIZC6MHRfG0lzTHQpD+hq0qIuvVbRTH/InAemFHjTx8Nj2z9Ij3pyh
         r51A==
X-Gm-Message-State: ANoB5pnEbIlszQ3s9Nu+pOGGq7kWJENWRfLIqu0zNGXHHpFG/l5zduub
        oEHjxOhMtAaS/xlGVddBkG+gqHksZI6Kyw==
X-Google-Smtp-Source: AA0mqf5wPJVO3WaTvMZ76Y61u2ldYDX8jG9N3ixSJKw8V4XiNTP7BwTvMDvjmIo1kXRSC74RrIe+1XJf98BEmA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:24cd:0:b0:6dd:e49a:6039 with SMTP id
 k196-20020a2524cd000000b006dde49a6039mr2080339ybk.274.1668503465205; Tue, 15
 Nov 2022 01:11:05 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:10:56 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-2-edumazet@google.com>
Subject: [PATCH net-next 1/6] net: mm_account_pinned_pages() optimization
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adopt atomic_long_try_cmpxchg() in mm_account_pinned_pages()
as it is slightly more efficient.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 90d085290d49d864b8431f99a19dbda867d9c03b..4bf95e36ed162611e8245c64c6caeecf9f60ef5d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1267,13 +1267,12 @@ int mm_account_pinned_pages(struct mmpin *mmp, size_t size)
 	max_pg = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	user = mmp->user ? : current_user();
 
+	old_pg = atomic_long_read(&user->locked_vm);
 	do {
-		old_pg = atomic_long_read(&user->locked_vm);
 		new_pg = old_pg + num_pg;
 		if (new_pg > max_pg)
 			return -ENOBUFS;
-	} while (atomic_long_cmpxchg(&user->locked_vm, old_pg, new_pg) !=
-		 old_pg);
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &old_pg, new_pg));
 
 	if (!mmp->user) {
 		mmp->user = get_uid(user);
-- 
2.38.1.431.g37b22c650d-goog

