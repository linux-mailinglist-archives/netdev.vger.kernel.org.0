Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE751CCC3
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386796AbiEEXfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357493AbiEEXfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:35:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2123C5EBC3
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:31:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c9so5101862plh.2
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 16:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dk85sWuvWwyFVSp6EaPRyXx5QUr9wUHTKQTFrQ86w9c=;
        b=VGyCsfpxonBGljswD8tfluQxqkgxzE2Jm6aBEYg3Bs4U7qL3AcjZk5MOOqkHF2LBKr
         ZBI52zr6myjmu+7/Y6K09j7Z6myWTyNRotQffYjE7Av+XSkaMgw4luRMY+l7mCss/lLS
         k4bqNNQUiHasVoLGJExVtJJTkbnhQvTO1B59g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dk85sWuvWwyFVSp6EaPRyXx5QUr9wUHTKQTFrQ86w9c=;
        b=yHd9ObJcK2lu6uiCSgKNPOX9lRYCjN1jmO/PsnVBLc2k86i5UHg7R2gOaIKoIFnDlE
         dZqrIzH7gEZ0tzi+fZOLewKu5Yok8VhrPBtcclpqC99iiopFAkUteGE2bf+Pf8LnJH5C
         zzSom1fCMLGFPWVwjL8sfD8OxB8PFzfTXifsqjZDxid1GzRzbHwSeK3ycV/hcSO2xhMa
         35uit+g0DoDbIdCE2rpz4Q71ZHwdF/QXamlUK7uYOvXKNwTz1WzW89Ez9mflpVr3zRVH
         vY0Ow/ECh6bXZA4tU91AJBlsxaCrTAzNXQH/B3CZ51fYATcd0OuKEHUT7tQD5Xti5Bxm
         l1Hw==
X-Gm-Message-State: AOAM531c+g1U7yBE5vJIz4ElhF0QxhqfY2zKosG24giMK+ozhD8d4O3u
        CIIE2O51tYivqWEYaeNdxisvryURx8YQ6Q==
X-Google-Smtp-Source: ABdhPJxH+ypbt+mk2nYkMlhFdncL+IzYFTyUt8newyL0X7o+W+8oDNFZLei2V9TQRXdacwcM952gAQ==
X-Received: by 2002:a17:90a:730c:b0:1da:4630:518e with SMTP id m12-20020a17090a730c00b001da4630518emr785478pjk.239.1651793484604;
        Thu, 05 May 2022 16:31:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f70200b0015e8d4eb2cbsm153810plo.277.2022.05.05.16.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:31:23 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: chelsio: cxgb4: Avoid potential negative array offset
Date:   Thu,  5 May 2022 16:31:01 -0700
Message-Id: <20220505233101.1224230-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4559; h=from:subject; bh=UPw9JrMNx/oB5GYowYRkwaqWmTgDk6MsLr0FPBcBgQY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBidF40hYaMLJgXj8olYq6kdxmrN4lNiUzmUn5c3l0W HGi5yAWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnReNAAKCRCJcvTf3G3AJjdjEA Cj2tF/TXIA6laBYY6MPfrUeB8XyihZQY1nrEREAXcISDaQveOLuaKbIP77YdV4UJG2qM6kK6caNs7Q +j6i8TCsoY8yz5RcJxwXXYL50OJdhoSQfc8Wf2/TfdOdAF9UDhwpHAuHo0AhV1dHYMcTTh16SOMrX4 eHQj/YjGSSHFJzPhUdI6LM2csVkNoNUBRzMThDXhtJ+3PV8PQr3DZfSwIr5Ogqw3CE+kUaFRFuJj+O 0IZfKjg0MBB5svqQuRaRTiIXhDsUL5zS6+Jusjli5T5IvnxRTRDfZMqWvcsxCME1agJhIz9z99K4nc bAnZL0asN9ZV9BTUY0tTxLYnEG7j/cgMJvB9jS1cBWigpfYRfkIP2vbKTclwrUbD+yGCyhBkQWZvLS HJFzAhExnwQxYITTwyaLbTO8W0YDOYOJ9EYmmkNcSJYCb4bEb6o8LCuj3guOdvKfZ8KxzFA0Ixr4LG f0rEiHV7EtFhJsme28QscbCGbjqp3OTEUyZu+17GSsvNWbxnvXh9AHKboF5Wmf0yDWzYpCMBeYqHqV GGp5MGxWweHDDPI4G28rKp9YJppivmfbUCxw/D2KJmoWgAqxI4hwWA1bmOF5dRgTrbx9vcCDYCHOeh x5w3iXmMxXesKSSI2PwPSLVjBVW4xreOK0J4uTqHbHeXbMG5ydCVF5+TjMrA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using min_t(int, ...) as a potential array index implies to the compiler
that negative offsets should be allowed. This is not the case, though.
Replace "int" with "unsigned int". Fixes the following warning exposed
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
v1: https://lore.kernel.org/lkml/20220503144425.2858110-1-keescook@chromium.org/
v2: use min_t again.
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index e7b4e3ed056c..8d719f82854a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	na = ret;
 
-	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
+	memcpy(p->id, vpd + id, min_t(unsigned int, id_len, ID_LEN));
 	strim(p->id);
-	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
+	memcpy(p->sn, vpd + sn, min_t(unsigned int, sn_len, SERNUM_LEN));
 	strim(p->sn);
-	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
+	memcpy(p->pn, vpd + pn, min_t(unsigned int, pn_len, PN_LEN));
 	strim(p->pn);
-	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
-	strim((char *)p->na);
+	memcpy(p->na, vpd + na, min_t(unsigned int, na_len, MACADDR_LEN));
+	strim(p->na);
 
 out:
 	vfree(vpd);
-- 
2.32.0

