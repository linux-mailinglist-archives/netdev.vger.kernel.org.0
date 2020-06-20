Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3330B2020C2
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgFTDcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733044AbgFTDa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:30:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93919C0619E8
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:30:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e18so5396697pgn.7
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53EFvIpvLtL19VTcgKVkwQhb1JNYVFCG8WLiohIrzpg=;
        b=hXEDT+oQwZV/0j93NEptSD6lkCmisgOBhpbn5Vp8lS7WhqstyLUjYh8/pubGfJlegl
         cIZZuP2lTlcYx/X9xdQps0HcFapdlSQ3sZeyQSQTzkk3YYv8X66EUy9+bLD5pYpGJ7K8
         f/p23iF9Lj5ZdC2ePxyPtJFko+YDM3iaXqXxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=53EFvIpvLtL19VTcgKVkwQhb1JNYVFCG8WLiohIrzpg=;
        b=Uw6WjJ9C5rApmx3SW/MEt7nlitZuOIWpSoPErJ4eqKxIPeu1xJojtz05ISRhHv004L
         SqbBl6jHdn/cRrJA3sxrKHQ3ApyB9Jn2sh8v7w6XsCGIRYUw130CtVG7jG5r49v9npQ/
         xsiYpJdRnWTq1m8Ti5b+MkeLYVqPtsD5dfHay/l7WTOmv/alDHP+80oY9wn+JjfGsskq
         Faj1G55O3N2Bv7OR8v0IInq88CyMKNipD+Bdw11A2P+nbeoGT1RGNl/yJcaultUTo0ad
         os8udQmxNMMup2MjenuaUEFoYo1ndpOYBpTc5IiPuEMCgk7Rqe2r7t8kJ3EVAmcSDFa7
         cRIQ==
X-Gm-Message-State: AOAM5336SRkxnPhYx/+xEe8QTnsqVdZQuyTgXU0WUmIdczLTkM9it81Q
        LdvW2vT8ugYRK404o+qey4vzRQ==
X-Google-Smtp-Source: ABdhPJzWWDTo3fA3qlpxXPt9t+m0l3tQUgBSNT3cCPjCzr+IkMUIJTgiw4SJHjx8tKw0+dOG4rlAaQ==
X-Received: by 2002:aa7:9f10:: with SMTP id g16mr10814981pfr.47.1592623824106;
        Fri, 19 Jun 2020 20:30:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w77sm7615693pff.126.2020.06.19.20.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 20:30:20 -0700 (PDT)
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
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v2 07/16] clk: st: Remove uninitialized_var() usage
Date:   Fri, 19 Jun 2020 20:29:58 -0700
Message-Id: <20200620033007.1444705-8-keescook@chromium.org>
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

drivers/clk/st/clkgen-fsyn.c: In function ‘quadfs_set_rate’:
drivers/clk/st/clkgen-fsyn.c:793:6: warning: unused variable ‘i’ [-Wunused-variable]
  793 |  int i;
      |      ^

[1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
[2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Fixes: 5f7aa9071e93 ("clk: st: Support for QUADFS inside ClockGenB/C/D/E/F")
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

