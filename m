Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8866566B5
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 03:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiL0CZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 21:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiL0CZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 21:25:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9BC2707
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u7so12009648plq.11
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vc9dKkOu9Bxzey4EMEiWLkvY83L8oxqqOyKDYNLTu5g=;
        b=wbZLVqKZnCa58wA2i8a8+KZ6p3B3BKGx6AZ5PJqw+pOt7brvZts5glurkjMa11iFTL
         RqjgkaYA+1yRF5BXn8Ld/InkXNROzQ7xFuLueevxDuXqNWEQgc7qt9MHvWCt2gqQdUPX
         oV+d9kpPZel6sq7QA6S5wG+nBa4rNygSq+Y4dzCgVtqv0Cp4+GptPOCMPkIQ0MGwh7E7
         UGrrRMjFjndiyuydtbO7/txh6wJtnsFynXdAaGl75AIxNvGmnvZs4jsyZJ+Ka/N8tvP+
         wkzUFhNrc9FDCKWp9R2bbGbBvrjLsZQFep1xZ/uI21A9InML4Q9l6dMopWZX7sQNyEU6
         nSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vc9dKkOu9Bxzey4EMEiWLkvY83L8oxqqOyKDYNLTu5g=;
        b=tD46O2HpEuyZpa+779ETd+RyA1uuKjxm6XZr4Y1hlL8+NIh5c2M4Fx8kUJs1+4sOMi
         QbhefkJADq13tN+E26KKCL+Ih+Kw60AhpH7cAlDEIRl6mUi5urPhRYgP2/OJk3yi/IqJ
         uYNnUOtEOsprfyIzCjsM8EgE+3dVK77BBjPCKMpN4Scg3Pebowb8YD5z4KSEHVLm+ZNL
         vwtF04frhIh0Dl+K1wctjL2sCONEblWQOJLPT8JqU7p5sbisSQW2xaPBzUbUJC6QbpCz
         MakmH4QcUKlCWl4D+nQwAkRRqCoO1gmf3UiA56i9jZ30pAEd6OmQhsqo2rj3zoGsbCGF
         uKYw==
X-Gm-Message-State: AFqh2koKyp+gFzL2CMfe6N/gjV/rtkl47L0oD9uFoXVhDNWWJcC3XGZ6
        py4Q8rWHgF+PraBBPHVWbQMkXQ==
X-Google-Smtp-Source: AMrXdXtZe0PP83G04+jg1kuf3vdXwhv44n2Bde+IvwOeyqGGAZ7SMJJgmZfCmhv40gnPTO2AXV5aUw==
X-Received: by 2002:a05:6a20:3b9c:b0:ac:94a1:8afb with SMTP id b28-20020a056a203b9c00b000ac94a18afbmr19088805pzh.13.1672107938858;
        Mon, 26 Dec 2022 18:25:38 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:38 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 1/9] vringh: fix a typo in comments for vringh_kiov
Date:   Tue, 27 Dec 2022 11:25:23 +0900
Message-Id: <20221227022528.609839-2-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227022528.609839-1-mie@igel.co.jp>
References: <20221227022528.609839-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probably it is a simple copy error from struct vring_iov.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 include/linux/vringh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 212892cf9822..1991a02c6431 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -92,7 +92,7 @@ struct vringh_iov {
 };
 
 /**
- * struct vringh_iov - kvec mangler.
+ * struct vringh_kiov - kvec mangler.
  *
  * Mangles kvec in place, and restores it.
  * Remaining data is iov + i, of used - i elements.
-- 
2.25.1

