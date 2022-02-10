Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB0B4B19D8
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbiBJXxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:53:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiBJXxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:53:41 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0831D5F75;
        Thu, 10 Feb 2022 15:53:42 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q204so9473512iod.8;
        Thu, 10 Feb 2022 15:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dlcn0c8FYc7DODG7QrUeh/RDtAB+I+F4Kdfoio51FaI=;
        b=pT8V02cRnyvge4g/jEw/vfDpSCJQ6mG8f5/2aDrsolSd6MEJ2MeTditvg5HTS3jTiY
         WtGZZX0/SoKQZhzIgkP9n0Dcpz+r0Ry6EqlDS1ADj+r+2ulVo+sw3mWYm6spJo0j4izv
         N1Ts5gZLSbXcfXixzzF1vDOzXCcZZGoO1De22gzUYl4uxS93hxyIA0QHPiwWxW7NznE1
         lewNaZm3nBzJFJx6tYvobMi78QVigZ22b58D/vnMuMkpRkUzPV6fqocJUenoiOeZYDlQ
         W543WAQd+q0/+WonyRm+lCqOpJHOTkjXAKKjvaVnXKxFWTPxKbP0S6V7BC0ngGjwAxig
         dinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dlcn0c8FYc7DODG7QrUeh/RDtAB+I+F4Kdfoio51FaI=;
        b=3A6NIwIeavoUYipRWjuzK5wDwLiStp3ujhMBqkbMCPiFG2V1zHwhxY5wL+EGKT0/vM
         ekStjIW8QaWB7flsLaAq6TiLJpgtyEHRDRnrow64mvjGxxXzg2yyIwLgOZWiwlayXUW1
         Y2hrDRA3+yncT6Ip1zF7G+yGNrT1/lqphYY7ybP2zkEPIiL/wICxzhlnY2WPk9D6Fcn3
         DCnrcauleYcUKIsdDpVHGmvRxtb2ve61bRcEHFliF/nPKOrL7fG2KOG5/mDgOvqQFxXC
         zNTIe9OKSk2xoYNQyciNnGg0Jvi5NWE88C5zLegXeY6xx8fLScAeQP0V1/9hwm3UjZRq
         mT+Q==
X-Gm-Message-State: AOAM531XCfY+wDmFG2PImSr9TRASQNlQg6DQ3lWygVqdoYJb+MglgtYV
        MH+A6fjHm8frxgfWu4r2a64=
X-Google-Smtp-Source: ABdhPJy1cnRyAEVSz8FK6oisjYTOYyOW5apveqRHtmqXfgAdrv7GPswYZO2OmUFJkYqdisR1K1A0IQ==
X-Received: by 2002:a05:6602:2c8d:: with SMTP id i13mr5215640iow.181.1644537221384;
        Thu, 10 Feb 2022 15:53:41 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id e17sm11144879ilm.67.2022.02.10.15.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:53:41 -0800 (PST)
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
Subject: [PATCH 28/49] iio: replace bitmap_weight() with bitmap_weight_{eq,gt} where appropriate
Date:   Thu, 10 Feb 2022 14:49:12 -0800
Message-Id: <20220210224933.379149-29-yury.norov@gmail.com>
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

drivers/iio calls bitmap_weight() to compare the weight of bitmap with
a given number. We can do it more efficiently with bitmap_weight_eq
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is (or can't be) met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/iio/industrialio-trigger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index f504ed351b3e..98c54022fecf 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -331,7 +331,7 @@ int iio_trigger_detach_poll_func(struct iio_trigger *trig,
 {
 	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(pf->indio_dev);
 	bool no_other_users =
-		bitmap_weight(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER) == 1;
+		bitmap_weight_eq(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER, 1);
 	int ret = 0;
 
 	if (trig->ops && trig->ops->set_trigger_state && no_other_users) {
-- 
2.32.0

