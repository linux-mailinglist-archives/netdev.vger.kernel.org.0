Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A3547201C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 05:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhLMEuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 23:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhLMEuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 23:50:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540D5C06173F;
        Sun, 12 Dec 2021 20:50:17 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so13774824pjb.2;
        Sun, 12 Dec 2021 20:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K8UgjFbNrfoKG5dBtZR8yfwtf/X9x+T1OZqh+X+snqA=;
        b=Pr+0E9PvCcaXhyQIJIxFqkyLoKq3NUn2bL1O/QvOsnrCctzkBMgLd/8ozElA6zNv63
         MYcwRa4JNe+YWNolt4SlZrcQQKa84FbcdAMbF7NMCPJtOr882fsbaPl61NZ+R391Txxb
         A6af1xnwNtyFgNO4sCIuPnWiCoxumQRNnzfaDnNriZIyyvJlzJAqebWi1MJyC0Dmhu3B
         qGTo2ICGDBULzraAS0Y4LP3zbEJnurCk53yHUKthlj+lka35R2/sHA6UVchSTWpicRNA
         S//1a8JPY5YVqvHKIOScpyGOKmrjzbiDIlSbu001Owevd0klKyt2/o50jks/fdRbjfGj
         ahBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K8UgjFbNrfoKG5dBtZR8yfwtf/X9x+T1OZqh+X+snqA=;
        b=4Pg9NCwOf5cNE4+65IR2NWJ9n/PeF6GWBSdT4Hj6Bn6TutjU3kGtFqxncVCA4rooiQ
         FwfHwU8+Vp8j08OBpBF6MZ+SS0Y5RrwNjjHG+qe6lf8hDVzDNHbV7J8105BlC8mVKBVo
         TPejHOcc+0Yyt/X6bXkkVnTwCEL31txQBSvcbu6/TpTMwj4pJBPeInGIcd99rNATx19s
         vuJ7xYoyqVZb6hK9R8WOqUndhT4LxJRS8J06LwN6GUVAAQA/GMTknt6J+Mh8xI5Mqr9f
         sMxnelFlQGeLvETCva6NdGdcSB6HQXuWqgeTwjfhkPEaw31xBD0LT/mE8nxEAw0aPpHw
         C07w==
X-Gm-Message-State: AOAM532fSuXZrTyisQ02oj4jn8cyMdM7Lecaj+nB5yscLPn7p8Gpj3jw
        58351K4vAStIG+BUhLKsBgc=
X-Google-Smtp-Source: ABdhPJwkRUeINSVoHWYgrbSKJiFZp8EU7zhrbl2rDNw8ESwNMvYKoTRCoHZpAzqHvXrOXgMlF5n66Q==
X-Received: by 2002:a17:90b:3b4d:: with SMTP id ot13mr11293239pjb.196.1639371016597;
        Sun, 12 Dec 2021 20:50:16 -0800 (PST)
Received: from localhost.localdomain ([170.106.119.175])
        by smtp.gmail.com with ESMTPSA id z22sm11259932pfe.93.2021.12.12.20.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 20:50:16 -0800 (PST)
From:   mengensun8801@gmail.com
X-Google-Original-From: mengensun@tencent.com
To:     jasowang@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        mengensun <mengensun@tencent.com>,
        MengLong Dong <imagedong@tencent.com>,
        ZhengXiong Jiang <mungerjiang@tencent.com>
Subject: [PATCH] virtio-net: make copy len check in xdp_linearize_page
Date:   Mon, 13 Dec 2021 12:50:12 +0800
Message-Id: <20211213045012.12757-1-mengensun@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: mengensun <mengensun@tencent.com>

xdp_linearize_page asume ring elem size is smaller then page size
when copy the first ring elem, but, there may be a elem size bigger
then page size.

add_recvbuf_mergeable may add a hole to ring elem, the hole size is
not sure, according EWMA.

so, fix it by check copy len,if checked failed, just dropped the
whole frame, not make the memory dirty after the page.

Signed-off-by: mengensun <mengensun@tencent.com>
Reviewed-by: MengLong Dong <imagedong@tencent.com>
Reviewed-by: ZhengXiong Jiang <mungerjiang@tencent.com>
---
 drivers/net/virtio_net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 36a4b7c195d5..844bdbd67ff7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -662,8 +662,12 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       int page_off,
 				       unsigned int *len)
 {
-	struct page *page = alloc_page(GFP_ATOMIC);
+	struct page *page;
 
+	if (*len > PAGE_SIZE - page_off)
+		return NULL;
+
+	page = alloc_page(GFP_ATOMIC);
 	if (!page)
 		return NULL;
 
-- 
2.27.0

