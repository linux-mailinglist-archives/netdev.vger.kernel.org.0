Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB1828F425
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 15:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbgJON7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729930AbgJON7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 09:59:20 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4315FC061755;
        Thu, 15 Oct 2020 06:59:18 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h20so3239285lji.9;
        Thu, 15 Oct 2020 06:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=NUxjUxK1UOjxJEs0sPUcbM0Q7UmykeuJXNehNgeC4os=;
        b=SxE4hu0nIW8d9CxZuSSQucGDhpDWAJCqHTQon4nhkHHa1u4sXv8dvr6WicFxvzdJCT
         OKcKLMqsAWlQqMb6tWnuCr5VfOchxfHssiq0rhHW5Ln/db2PRu7n/Rc+VH9sVItGhwXi
         bdhipbO+w1OESJcJjePodL00BGokEXQi9b7T+Jbu9bG5GX1FBwVWSXH9JN4X9+++r8+U
         zU60U0VVB7YmrFHfeDNlTJUtZsRxDcOttUlzw3qalrZ6UgOJcngt320qujsCzGzbPDJl
         Sm/1z6xwACZ9Jo5dllMeJ0MDC5Xb21crCLj+eocwkHyjzZX1XMq4+S4/19nUol8kHgmg
         F83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=NUxjUxK1UOjxJEs0sPUcbM0Q7UmykeuJXNehNgeC4os=;
        b=Y1mKmFGaSCiFIMg9ngD7CxjVXAcKMnxhiWfaWVXWgRZ9+8tesCk16CoT36Eqpaf4a4
         9fVLDCkyuikRzDtbFSgAEdvUaeHUylGSSTP7riqNZgesCD0SNBld6Tp3TREOIpDfutW7
         8AoXcbUE5FUfdTjDU025Z1WKiXkNrzipA5zd2yWfJwVrdMZqgC02VQwuYdmok7vHqY3o
         qYimY5Ow8nk9LJBXfxopaRiT39McrfSmMdf8kRPLpeOIRUinvupN1gdg0uXjhEDIixNa
         OrbTvgiPRNNyiyi0TzDgUlSRItwrKenSV9NB24rDPLaakDVSX27qE1L0voe2cH4Lrtm9
         neow==
X-Gm-Message-State: AOAM5312sOsTOyZCvA73swIqRX1SlQvLc6bvk3ZkHhkwrEuAx3UApbLn
        y6j1UtjdfaPbSiKh3+jSzTc=
X-Google-Smtp-Source: ABdhPJyMRkMWl9yQoCpJe18WPtKYFz7L52PVGN0R7Kqr9KUlwEx2f1pX3XN9kdarM/wBmRxQA96rfA==
X-Received: by 2002:a2e:9744:: with SMTP id f4mr1250265ljj.71.1602770356732;
        Thu, 15 Oct 2020 06:59:16 -0700 (PDT)
Received: from laptop ([156.146.58.201])
        by smtp.gmail.com with ESMTPSA id s16sm1328855ljj.35.2020.10.15.06.59.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 06:59:16 -0700 (PDT)
Date:   Thu, 15 Oct 2020 16:59:08 +0300
From:   Fedor Tokarev <ftokarev@gmail.com>
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        anna.schumaker@netapp.com, trond.myklebust@hammerspace.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ftokarev@gmail.com
Subject: [PATCH] net: sunrpc: Fix 'snprintf' return value check in
 'do_xprt_debugfs'
Message-ID: <20201015135341.GA16343@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'snprintf' returns the number of characters which would have been written
if enough space had been available, excluding the terminating null byte.
Thus, the return value of 'sizeof(buf)' means that the last character
has been dropped.

Signed-off-by: Fedor Tokarev <ftokarev@gmail.com>
---
 net/sunrpc/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index fd9bca2..56029e3 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -128,13 +128,13 @@ static int do_xprt_debugfs(struct rpc_clnt *clnt, struct rpc_xprt *xprt, void *n
 		return 0;
 	len = snprintf(name, sizeof(name), "../../rpc_xprt/%s",
 		       xprt->debugfs->d_name.name);
-	if (len > sizeof(name))
+	if (len >= sizeof(name))
 		return -1;
 	if (*nump == 0)
 		strcpy(link, "xprt");
 	else {
 		len = snprintf(link, sizeof(link), "xprt%d", *nump);
-		if (len > sizeof(link))
+		if (len >= sizeof(link))
 			return -1;
 	}
 	debugfs_create_symlink(link, clnt->cl_debugfs, name);
-- 
2.7.4

