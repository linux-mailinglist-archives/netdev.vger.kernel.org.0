Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8693F1C425E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgEDRVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729667AbgEDRVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:21:38 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE384C061A0E;
        Mon,  4 May 2020 10:21:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f3so13167213ioj.1;
        Mon, 04 May 2020 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=T0bFivZkGCPqQDuoXyfkeADSXLeemmjLzmCAHYc6sAw=;
        b=lW6oLhb+oEywGN3MgMXgDiA7i+xWpKjzHgPF2CXL2c3dxfNfxSfQ2ka9tqBLakp5BZ
         dJJAgUHytLIib5kf9wfq4VPnofV/5KO6zvOK8YzQncwOXgODTfrPLhZiOzkNKOIBN4En
         pwGOkx8a3o2tgkL/W8+xqNSgIhwruqVFePioyn+gjdVAaWwpB7aDgvXAXm//w42r0iWe
         IMNKLxi6tYiWZHj7JmupS9ew6sH3iF+e3fQtxQRW7KDiac4MaM/wLMGUMssoDYYrEO+a
         J/2ZtmpzLEI1WygjQiRuJU82GRcr8QFNQnTZ63mbl6qC2mXB68qPBIZs8sHklyUGxt0a
         wPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=T0bFivZkGCPqQDuoXyfkeADSXLeemmjLzmCAHYc6sAw=;
        b=EIaQu+n9sYTsixfj1jexXD6QCHQKcoanngvqD/4MnuBr4Q9ZJkw9DNUlL+5+r40hJF
         RZjyCKuAhFwUsiBgeX+d46h6JAX6Km9ZoWV+N506+BEjPIejp4OJ6DwhOd0wYlodlefg
         oiV284vJzpIaeBwvASnC6DD9U9aA3JZNaJtNnGpoglOr2/s0lo8nJws4QVbuUuCP5gmT
         xzo5CuYzbc/qKSH5iCkvkGNvi09DYiI85ZvVNywxg0k/cI0iHEkrzT637qrOjaawUmSt
         kBIP41XLq/1Qji0W/xiYUIHIJBQuuwYlx64HkFOtwrbXGjpSMGwcFn837+JHVUMK07wX
         9YEg==
X-Gm-Message-State: AGi0PuZWkVWbpFrtzAcD2ATjWdOq8O3Yg65h2tkMomtw2vyBxCkW7o34
        WBhNUGUqoWNEvZPVmZvABNgystYG19w=
X-Google-Smtp-Source: APiQypL5eECy1DSxNzoKkk5/d16TitveVmE3ptOBJrD+G3me0Q9PJ8GgS95DXe5bqOjk+wDQkdp0DQ==
X-Received: by 2002:a6b:14d0:: with SMTP id 199mr16521233iou.11.1588612898128;
        Mon, 04 May 2020 10:21:38 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r2sm3609501ioo.51.2020.05.04.10.21.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 10:21:37 -0700 (PDT)
Subject: [PATCH 1/2] bpf: sockmap,
 msg_pop_data can incorrecty set an sge length
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Mon, 04 May 2020 10:21:23 -0700
Message-ID: <158861288359.14306.7654891716919968144.stgit@john-Precision-5820-Tower>
In-Reply-To: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sk_msg_pop() is called where the pop operation is working on
the end of a sge element and there is no additional trailing data
and there _is_ data in front of pop, like the following case,


   |____________a_____________|__pop__|

We have out of order operations where we incorrectly set the pop
variable so that instead of zero'ing pop we incorrectly leave it
untouched, effectively. This can cause later logic to shift the
buffers around believing it should pop extra space. The result is
we have 'popped' more data then we expected potentially breaking
program logic.

It took us a while to hit this case because typically we pop headers
which seem to rarely be at the end of a scatterlist elements but
we can't rely on this.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7d6ceaa..5cc9276 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2590,8 +2590,8 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 			}
 			pop = 0;
 		} else if (pop >= sge->length - a) {
-			sge->length = a;
 			pop -= (sge->length - a);
+			sge->length = a;
 		}
 	}
 

