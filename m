Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0C518712
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiECOsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiECOsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:48:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7927439161
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:44:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so2400022pjb.5
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 07:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8AVZNz1T1fbKBPaS1jbLfs2nSYwxCJeZrFfZY3AuXg=;
        b=YgIR+HSs5Fl2nL+1avLDSIxzGwgrqQZg4BiwSjU0cu9k2bxpynzPGC6wvWGoMkvHfv
         yMI9a0zmrILdE4gbdtT/4db5hjs7b+NxgPwkibcXWrjxuWgC0hV/jH5qF4vcbryjtJi/
         KvzOXe86/hQ0c/8QofStHRq2f0dDshoXPcr9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e8AVZNz1T1fbKBPaS1jbLfs2nSYwxCJeZrFfZY3AuXg=;
        b=adr2CFCi9duwUC+IB9YWZ/FRzYuYqyJiE5SbwcjbK+FF7K4JDqLaurlkswuwhcihkK
         wrrAbqE7qXip5l6ncYeFZbU611sbvNS8YgZgbYcMnkUF/KexaaeO3/BKXO2eeCrG4R+N
         wnj9m2AxK/CO5bEvskidUJtuE66mpU42/GtI8E9o9cQ9xqZzoJJLZQj7n+LAVgpod6O/
         cPDxcTjHkw/6Nsu2BeopYY5Z6qShSDFfqojwqdTtoGEeoLlxeJehIHM4ClasH6bJza2J
         gG935zDVY689Dx+vPR0ImwlqtX9MdJedDmWWtp+DikAE5RQQ1edNXJs0fliUsqI/jaBF
         2JLQ==
X-Gm-Message-State: AOAM5318XZu1EnIICpZeDhZ6uI3HY1ya3tcQrQdHpXJaBg3kFJDPdjzO
        zVktseK146P6Spq1vK2S/jhNWvpWKxkoFQ==
X-Google-Smtp-Source: ABdhPJxpqQbtuAURmpaH45+EofYX7rkQQIunIhDE2JG2HBB7V2ZaoSOsrzkTFHzKRa1O/qRfMqbtMA==
X-Received: by 2002:a17:90a:b106:b0:1d9:7cde:7914 with SMTP id z6-20020a17090ab10600b001d97cde7914mr5052946pjq.56.1651589098978;
        Tue, 03 May 2022 07:44:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902ba8400b0015e8d4eb230sm6387973pls.122.2022.05.03.07.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 07:44:58 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net: chelsio: cxgb4: Avoid potential negative array offset
Date:   Tue,  3 May 2022 07:44:25 -0700
Message-Id: <20220503144425.2858110-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4431; h=from:subject; bh=+8uAMoqqS0Bcfw8fZYr6KoQkcNcm36Imb2FI1uAd3hw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicT/Jv8v/feIVKVuIyt5mmkMRPZzdczQGAeIED/S7 Sue6QWmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnE/yQAKCRCJcvTf3G3AJnSlD/ 9g7H+DltIHtP9cfNn3f84D/otBGRybV39ENgfcteZPAekvVAxWbzFXVXjV1DCl2HYb6XH94aYgCCvl VjgPLaI2AgI1z6oeSF4FXEZ8Oj+pmwDMBZOwIXpViXgs7UbPQWvC88ax1BUlLCHKdz1cUtZoY/SohH lRdgXNPqyqFjAUyvop6yPb1TyhHTn6DgIzfF92/c/VwB0rgIci9AuoyQ6xSrrse11Q4Q9IVBGgsUSv IcJThpwqDXdsRe0KtlJf6dRV0aB9v9RX6kEvKrx5T4ovBu6XqgSgW5Kjj1XubGyevRDDyU0k/ttLPh Hpzhx+t9n/UC5k+gCFS3q+e1tGbaVF1LOASAs1nhCw7RnSCT/mekDTlJSKwLN+WxfPvQPjCMCF8wh9 Ra3Gb0Uezm2UiXIkAZ4FbQZPP5MR5zARIfUGmT4ChTTw84uORVP9rRBuv1xxBpuNg3HDmfYzu4/UJM ZDJit+SFwwho3EK2zZlweact3kjnuUzcR+v11rY52Ejxl/H/wf0BVWzmJS7nO3tjeIBLn9E86n5uP+ 3iInLzOk4swgV/dqvq/xjSvecKICXVVtvOgnP1pkYAkguEdt46US/lUJhZI/FMIH7uAcCTbH9ARg/A jTjJNdk3gEUCPfhSDLdbzKvYzfYIr95z2fYT1LAc6hfj/RdtVBlXjY9EhL7g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using min_t(int, ...) as a potential array index implies to the compiler
that negative offsets should be allowed. This is not the case, though.
Replace min_t() with clamp_t(). Fixes the following warning exposed
under future CONFIG_FORTIFY_SOURCE improvements:

In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/rcupdate.h:29,
                 from include/linux/rculist.h:11,
                 from include/linux/pid.h:5,
                 from include/linux/sched.h:14,
                 from include/linux/delay.h:23,
                 from drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:35:
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c: In function 't4_get_raw_vpd_params':
include/linux/fortify-string.h:46:33: warning: '__builtin_memcpy' pointer overflow between offset 29 and size [2147483648, 4294967295] [-Warray-bounds]
   46 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:388:9: note: in expansion of macro '__underlying_memcpy'
  388 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:433:26: note: in expansion of macro '__fortify_memcpy_chk'
  433 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2796:9: note: in expansion of macro 'memcpy'
 2796 |         memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
      |         ^~~~~~
include/linux/fortify-string.h:46:33: warning: '__builtin_memcpy' pointer overflow between offset 0 and size [2147483648, 4294967295] [-Warray-bounds]
   46 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:388:9: note: in expansion of macro '__underlying_memcpy'
  388 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:433:26: note: in expansion of macro '__fortify_memcpy_chk'
  433 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2798:9: note: in expansion of macro 'memcpy'
 2798 |         memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
      |         ^~~~~~

Additionally remove needless cast from u8[] to char * in last strim()
call.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202205031926.FVP7epJM-lkp@intel.com
Fixes: fc9279298e3a ("cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()")
Fixes: 24c521f81c30 ("cxgb4: Use pci_vpd_find_id_string() to find VPD ID string")
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index e7b4e3ed056c..f119ec7323e5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	na = ret;
 
-	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
+	memcpy(p->id, vpd + id, clamp_t(int, id_len, 0, ID_LEN));
 	strim(p->id);
-	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
+	memcpy(p->sn, vpd + sn, clamp_t(int, sn_len, 0, SERNUM_LEN));
 	strim(p->sn);
-	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
+	memcpy(p->pn, vpd + pn, clamp_t(int, pn_len, 0, PN_LEN));
 	strim(p->pn);
-	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
-	strim((char *)p->na);
+	memcpy(p->na, vpd + na, clamp_t(int, na_len, 0, MACADDR_LEN));
+	strim(p->na);
 
 out:
 	vfree(vpd);
-- 
2.32.0

