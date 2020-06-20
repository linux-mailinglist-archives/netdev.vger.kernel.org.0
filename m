Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2043E202071
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbgFTDbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733006AbgFTDas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:30:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF0EC0619DA
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:30:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b201so5397211pfb.0
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RzFNSuLALDDrnyEKhGNtGgKFtIzldBQWpd31RJVV1bk=;
        b=fzu/PCWhtk9lQC+R9MKh2Me02oxRal6DiRCuEURCWK9sXWB/CpSiB5Uv2tVNAE/CrC
         pGWzf/0loKr3cRxZRQNqF3uIOTSAInn1Kw7+AX1oW2pUGkJe0aav9Q03vOKBlLqHKkBU
         gGXsmhzRkdIhnbv/YLNgb64tFfCa2ZymPC9BU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RzFNSuLALDDrnyEKhGNtGgKFtIzldBQWpd31RJVV1bk=;
        b=ROsq/UnbNncrROEag4oMw3YwJbyd0Pz2e11qSszMclbH4Nb132SMA8jD6T0XuTY8P8
         yGC3rqFVRwhVJXbfXUggNMIFKmYjAiNtV9RgX9Zt7secnzkRQzLD0MdYJfHgXKw8e9fC
         CG1QYblTdzIBdenRHclGCc2+RrTGs25R8IeGK/eiqgw0lpRyzbc8e22NwbysVYMD2znq
         6C9XAOiF5JJiIeeEAGnr5ytAfhNzL313FRXE6Fyi2pEfNswjulrapQSj5r/ZjFXC0sR5
         /45BgyqWn2bvUJxsXYFFjGsHYSTI/nDMMHOFdKzksyj8uy/ZHq9c7Ppik6+BB2QP/joi
         LYXQ==
X-Gm-Message-State: AOAM530MabaLPRitI//t5tT13NiX3WBmaqMmiiZ5Ih/kol9WKefSaShK
        HfVnbTHyqohonEVq4XS1Z8MBeA==
X-Google-Smtp-Source: ABdhPJxH7/9V1MTULJxl6mnEJxFeDjiakGfZWrFzazGy+IRxsSCrDXTNem0tGYNNX/5vbkAV8ntgLg==
X-Received: by 2002:a63:7c51:: with SMTP id l17mr5231899pgn.303.1592623822618;
        Fri, 19 Jun 2020 20:30:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 1sm7140732pfx.210.2020.06.19.20.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 20:30:20 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v2 08/16] spi: davinci: Remove uninitialized_var() usage
Date:   Fri, 19 Jun 2020 20:29:59 -0700
Message-Id: <20200620033007.1444705-9-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620033007.1444705-1-keescook@chromium.org>
References: <20200620033007.1444705-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using uninitialized_var() is dangerous as it papers over real bugs[1]
(or can in the future), and suppresses unrelated compiler warnings (e.g.
"unused variable"). If the compiler thinks it is uninitialized, either
simply initialize the variable or make compiler changes. As a precursor
to removing[2] this[3] macro[4], just remove this variable since it was
actually unused:

drivers/spi/spi-davinci.c: In function ‘davinci_spi_bufs’:
drivers/spi/spi-davinci.c:579:11: warning: unused variable ‘rx_buf_count’ [-Wunused-variable]
  579 |  unsigned rx_buf_count;
      |           ^~~~~~~~~~~~

[1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
[2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Fixes: 048177ce3b39 ("spi: spi-davinci: convert to DMA engine API")
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/spi/spi-davinci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index f71c497393a6..f50c0c79cbdf 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -576,7 +576,6 @@ static int davinci_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	u32 errors = 0;
 	struct davinci_spi_config *spicfg;
 	struct davinci_spi_platform_data *pdata;
-	unsigned uninitialized_var(rx_buf_count);
 
 	dspi = spi_master_get_devdata(spi->master);
 	pdata = &dspi->pdata;
-- 
2.25.1

