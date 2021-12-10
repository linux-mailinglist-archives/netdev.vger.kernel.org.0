Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005EC4702A9
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbhLJOYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:24:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241943AbhLJOY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639146051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/VVqJ2rvS3+utXonMTYrBEeM8oEcGBPKY47J7o2598=;
        b=AfavxgpAJDdQWq0vAtzwH+onxUq78z3uBbiu/eirPajPtNsE88/foRQMcbpHRhB5FF7Zbl
        WTvmCLy0AIXwWEkKtBsNwegt/FnUyLBsrZYeDb6wFR7QGRPSWEZJO7Rrx7vZWVid6Ak4sF
        72Y6t9T1LtfDSUyg/+oyBGerUqzCSk8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-yRxVxmAWNnqJZeZTU1lGwg-1; Fri, 10 Dec 2021 09:20:48 -0500
X-MC-Unique: yRxVxmAWNnqJZeZTU1lGwg-1
Received: by mail-ed1-f72.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso8322656edb.11
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/VVqJ2rvS3+utXonMTYrBEeM8oEcGBPKY47J7o2598=;
        b=Wigb7SqXwooeSPoIOJBI/Xp69xIWeRRQZp/0X4lDEr6NOe0ipozDfeZey7JNvFbGXC
         46tT/e5YB264voXmpp58k46YdQXeRc5S1oDsUeoxgJrTDc5lEZbgpMiCAStVNzoC8arC
         Qw6SBou8ZyjL8WwhK9MyrLnhUp52fJbti6ODWwOLMkkYwBy38wFjCDAS5OSCldt5YQtH
         NXEM5M6k3FYdt/1+Ii0S1SDi4XPSFBTKwStab8fS8Cj1jy7c7RPDHb3yrk8U0l59T5CV
         VdGpR8hP8TonQ2i4PyrT9fq4rltU9q9+kG70q3QjUmVTR2WCeRZFIx9pgFKGGtdtaotG
         ZF2g==
X-Gm-Message-State: AOAM530U18tnMBg3NSbLrA/kWfjr6tH+ZvMsXV2JJpMK5aFviSoJ9+N2
        LOMNgNNNG41uAdqV192cI1D0qLfyXlVIfk+tQEmFPEdXQnVw8+5IyJmg3ioLaMhhRbwkbo45l1x
        ZIillofKc8MaIrmPg
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr25105930ejo.6.1639146047487;
        Fri, 10 Dec 2021 06:20:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygJnist17UHDMW8D4EUaIkEDOOVeGrf44pwwm7ZeZlsXBFH+sRB0NUFyYcAA8Ez2Q79ey1yA==
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr25105871ejo.6.1639146047095;
        Fri, 10 Dec 2021 06:20:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qk40sm1579659ejc.2.2021.12.10.06.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:20:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A317A180471; Fri, 10 Dec 2021 15:20:45 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/8] page_pool: Add callback to init pages when they are allocated
Date:   Fri, 10 Dec 2021 15:20:01 +0100
Message-Id: <20211210142008.76981-2-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211210142008.76981-1-toke@redhat.com>
References: <20211210142008.76981-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new callback function to page_pool that, if set, will be called every
time a new page is allocated. This will be used from bpf_test_run() to
initialise the page data with the data provided by userspace when running
XDP programs with redirect turned on.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/page_pool.h | 2 ++
 net/core/page_pool.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..a71201854c41 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -80,6 +80,8 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
+	void (*init_callback)(struct page *page, void *arg);
+	void *init_arg;
 };
 
 struct page_pool {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..fb5a90b9d574 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -219,6 +219,8 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
+	if (unlikely(pool->p.init_callback))
+		pool->p.init_callback(page, pool->p.init_arg);
 }
 
 static void page_pool_clear_pp_info(struct page *page)
-- 
2.34.0

