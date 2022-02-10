Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5C4B19EB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345969AbiBJX6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:58:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345964AbiBJX6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:58:05 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354723AF;
        Thu, 10 Feb 2022 15:58:06 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id c188so9480085iof.6;
        Thu, 10 Feb 2022 15:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wCe8l6BzIf39UXY71HrtaLDcF4n6vO18YFKJdpw4cXQ=;
        b=fI2SwxxZTVMqpxGhquBSWDyfIQ9U9DsAgpF9gRFwhpoAula9Vdzc1QlFVFHC1U6hwI
         ABtDL5EahVrOMWQOjSc1cxNHQioV9menjUMsuOH/Cnz8hecA97jxN6sPuk95u7nVfkQV
         v9wtNrSgpkd8oKfTH9OUi7v/x70ZavMozIl54AC5RULi2izx6U5HggOLYqF4OGCV8xvC
         S2cFxQ+81wUoSrp358Cp/BnH7gOLObY9fktA/0i7ZL+H0LeU4Gh8hM6p7+fRhxCwSkx6
         mo4eV4AeXA5Mg/ksXKxD2Mw7++3/aR12BIxW+0jlVA0zfkk45kSAnE0jXh1mlQ8+k9e9
         HVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCe8l6BzIf39UXY71HrtaLDcF4n6vO18YFKJdpw4cXQ=;
        b=vOoOGJkTXl1/xJAci7WVAv8LPEgWzHzOUoeu+uu+6AUAe/we+WIt278IVZddlc/BfE
         w42Noycd7YAaNw/nGfBFjnVtr17Lfo5re7NQByJPGO41uuXS/+5MLvlloQ9ZRu7d3Afw
         n8tDWxUDtbIbdDoxyK+sckpgdUI3Ez+ygeuhFyAQB/j8ys1XeeBwDeHuhZY0xnlrjBB3
         JECbe6MRTradiW6PNfa1303aMTpw6YruLgHZj65xTgXOg572vOxHzBTSShFOstMEFnqJ
         3JLAHisLYOGEiJ+QFm9V+O0u6Rvy6tAHRVU4TrLYYLNkhDvS4cDZAwOepfw9Uc6XGgxw
         2YhA==
X-Gm-Message-State: AOAM533H8A67IBTF9xr0wqatuIj3UO0xWQEkWCweRHfXiv+8YVKd0TZx
        4wkr3xP1fP+i42Q5pXuFUj0=
X-Google-Smtp-Source: ABdhPJyy7xzUjWAsxQE/FjXnUixngXgx0pMBOB0uizulIEe8wbp5Hbd+lionqAo02gVkXrx+e9ndLw==
X-Received: by 2002:a05:6602:492:: with SMTP id y18mr4939747iov.95.1644537485609;
        Thu, 10 Feb 2022 15:58:05 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id t6sm12773865iov.39.2022.02.10.15.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:58:05 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 30/49] ixgbe: replace bitmap_weight with bitmap_weight_eq
Date:   Thu, 10 Feb 2022 14:49:14 -0800
Message-Id: <20220210224933.379149-31-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ixgbe_disable_sriov calls bitmap_weight() to compare the weight of bitmap
with a given number. We can do it more efficiently with bitmap_weight_eq
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is (or can't be) met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 214a38de3f41..35297d8a488b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -246,7 +246,7 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
 #endif
 
 	/* Disable VMDq flag so device will be set in VM mode */
-	if (bitmap_weight(adapter->fwd_bitmask, adapter->num_rx_pools) == 1) {
+	if (bitmap_weight_eq(adapter->fwd_bitmask, adapter->num_rx_pools, 1)) {
 		adapter->flags &= ~IXGBE_FLAG_VMDQ_ENABLED;
 		adapter->flags &= ~IXGBE_FLAG_SRIOV_ENABLED;
 		rss = min_t(int, ixgbe_max_rss_indices(adapter),
-- 
2.32.0

