Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDAB1ED96D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgFCXd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgFCXcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:32:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F457C00863B
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 16:32:18 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so1371940plo.7
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 16:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vlsGh/2A3yd9dyMlCDYBd0p4l1T5Oo7IaL6NTs2MBUk=;
        b=TU9flWAg9FMH+Npku3SFev/YYK6vvYYCp6jsnIW2uRPdSGDM2UMjhH0to/RSt2mcu+
         +tEJTAZqQ0UV4spAC//nbMEU4YZmc6CW1cgHcGYV50zllOcjZjx+9n/jCEKcVaB/68HX
         WckrYbpJZIVMmdggrVZUzoJLKS1NezuTTfatg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vlsGh/2A3yd9dyMlCDYBd0p4l1T5Oo7IaL6NTs2MBUk=;
        b=JXu5wY6EP5XXZBPVoogGcR5GznN688BsseY97KbrHyAXzQ/oZcr6cS9pnfEfpuoZfi
         5lKxiBhonrskDQcXnIc1hL9sVxktX2htjr6eHYrVWu8yR6V+/RZ7UgnlNFmghNSKM5MT
         RGDSKdTLBvjXl0itbWHgjgdlAgY2xKd3ijM3R6kJs6ogjrx/oTXdt/dsSrpl/27996Jb
         m5Em+SeBrytH7WKBrL0PrAbLlEgl3S7N5qEYOdp064dFtTHhzjWXkol2jbMCKyxxJvMF
         EsddSvtQ+Ijj8wehfUdCK7zIPOV1iQ2hHtnZ5kGLdNm2uHTCAVkeJmFUVzOqOh483yNu
         5XQA==
X-Gm-Message-State: AOAM531VZ/NXCYlcP+YpCkyghPxXJy4mAj67MogFo/E/27plHNoj/HgA
        gR31MRiZnyvBH+DO9GA57iWLow==
X-Google-Smtp-Source: ABdhPJyBu+lQtrGYhp3WZ7ZyvY1X8s9WoOeJvHWXF5Ulh61p00d2PYdWCaVGKn3LkWqTOEtrYGlBGw==
X-Received: by 2002:a17:902:aa0c:: with SMTP id be12mr2119692plb.241.1591227137753;
        Wed, 03 Jun 2020 16:32:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b1sm3836817pjc.33.2020.06.03.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 16:32:16 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: [PATCH 06/10] clk: st: Remove uninitialized_var() usage
Date:   Wed,  3 Jun 2020 16:31:59 -0700
Message-Id: <20200603233203.1695403-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603233203.1695403-1-keescook@chromium.org>
References: <20200603233203.1695403-1-keescook@chromium.org>
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

drivers/clk/st/clkgen-fsyn.c: In function ‘quadfs_set_rate’:
drivers/clk/st/clkgen-fsyn.c:793:6: warning: unused variable ‘i’ [-Wunused-variable]
  793 |  int i;
      |      ^

[1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
[2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/clk/st/clkgen-fsyn.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index a156bd0c6af7..f1adc858b590 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -790,7 +790,6 @@ static int quadfs_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct st_clk_quadfs_fsynth *fs = to_quadfs_fsynth(hw);
 	struct stm_fs params;
 	long hwrate;
-	int uninitialized_var(i);
 
 	if (!rate || !parent_rate)
 		return -EINVAL;
-- 
2.25.1

