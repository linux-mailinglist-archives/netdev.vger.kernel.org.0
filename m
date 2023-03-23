Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4716C6D1D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjCWQPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjCWQOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F9D22020
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679588029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KbMR0xrX13/vpqXtbfb3ZQ/trhkNWEMduVf+oaF3Fe8=;
        b=ePgoR3e/HJUjVc/izt8I1GH6kbxr4FjvnQ7mvCU0iH2RnJHJnPNm7F4STlIC3CucMWmXrD
        4DmqvQHPkxSc6ai4GdmV4+QGE3RwcMZzhKorf+zTdm+6n7IDfQNh8S1oN5WWdT09u2divM
        21bJiFIrjOihYRZauG7MF/owQEnb0ZY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-mkT0HR43OceuxqUL592S5A-1; Thu, 23 Mar 2023 12:13:47 -0400
X-MC-Unique: mkT0HR43OceuxqUL592S5A-1
Received: by mail-qv1-f69.google.com with SMTP id oo15-20020a056214450f00b005a228adfcefso11112796qvb.2
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 09:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679588027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KbMR0xrX13/vpqXtbfb3ZQ/trhkNWEMduVf+oaF3Fe8=;
        b=bVT5YHtyh08xE/rPKwMEsQSHL8CUkGBb+MqW41xI0IJHsW+x1yVVVLQy6x6erlk91l
         FIPNpU1mww2tPLUsqpiwnruSziN4/49N8lT8qh0hBN+mva0NDmY0kUGzL/vo+rg3j9vD
         IjbdauYC9M0FGjmmaTPV/0yich5uwrHW7YMXyiU2zrcTYdWDig5QMFBs/UMtX6J2wXUM
         Pbt6qIOHV8c5Va5vK03TUj55xOOawS30baxyB6AVt2FZAvnnKhzh6J8BS1q+YS1lv8/n
         /c1++k267pWdifuArMrtrezp0lnhzyg99NzYbh6ZlO/8GXGUZumt0F9Rz8XatKfun2Yt
         4alw==
X-Gm-Message-State: AO0yUKVyavCJ7Cjh4JveO7HM6DQM1yW0EPC5u69NhQ7TqfTbdb4sYzBy
        Vn11LciAENLLPvYm4Fr+So8NoloqpkPSs5Mz0oiCAwjLwCYkbjP7BNMXv0OtcGXtAeGmeM1N3vv
        lf7X+asgJAs5D58/8
X-Received: by 2002:ac8:7fc6:0:b0:3e3:8ed5:a46b with SMTP id b6-20020ac87fc6000000b003e38ed5a46bmr7580395qtk.34.1679588027005;
        Thu, 23 Mar 2023 09:13:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set8iOLbXObqxCv5YZqFAUuGys7Qtjn8a01N2100PrXD69Su2AVUSuvrVzwG1RwXwNk3swo0Zcg==
X-Received: by 2002:ac8:7fc6:0:b0:3e3:8ed5:a46b with SMTP id b6-20020ac87fc6000000b003e38ed5a46bmr7580361qtk.34.1679588026709;
        Thu, 23 Mar 2023 09:13:46 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c20-20020ac86614000000b003e1080e0f8csm7631543qtp.16.2023.03.23.09.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 09:13:46 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        yangyingliang@huawei.com, alexanderduyck@fb.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH] mISDN: remove unused vpm_read_address and cpld_read_reg functions
Date:   Thu, 23 Mar 2023 12:13:43 -0400
Message-Id: <20230323161343.2633836-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/isdn/hardware/mISDN/hfcmulti.c:667:1: error: unused function
  'vpm_read_address' [-Werror,-Wunused-function]
vpm_read_address(struct hfc_multi *c)
^

drivers/isdn/hardware/mISDN/hfcmulti.c:643:1: error: unused function
  'cpld_read_reg' [-Werror,-Wunused-function]
cpld_read_reg(struct hfc_multi *hc, unsigned char reg)
^

These functions are not used, so remove them.

Reported-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 31 --------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index e840609c50eb..2e5cb9dde3ec 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -639,23 +639,6 @@ cpld_write_reg(struct hfc_multi *hc, unsigned char reg, unsigned char val)
 	return;
 }
 
-static inline unsigned char
-cpld_read_reg(struct hfc_multi *hc, unsigned char reg)
-{
-	unsigned char bytein;
-
-	cpld_set_reg(hc, reg);
-
-	/* Do data pin read low byte */
-	HFC_outb(hc, R_GPIO_OUT1, reg);
-
-	enablepcibridge(hc);
-	bytein = readpcibridge(hc, 1);
-	disablepcibridge(hc);
-
-	return bytein;
-}
-
 static inline void
 vpm_write_address(struct hfc_multi *hc, unsigned short addr)
 {
@@ -663,20 +646,6 @@ vpm_write_address(struct hfc_multi *hc, unsigned short addr)
 	cpld_write_reg(hc, 1, 0x01 & (addr >> 8));
 }
 
-static inline unsigned short
-vpm_read_address(struct hfc_multi *c)
-{
-	unsigned short addr;
-	unsigned short highbit;
-
-	addr = cpld_read_reg(c, 0);
-	highbit = cpld_read_reg(c, 1);
-
-	addr = addr | (highbit << 8);
-
-	return addr & 0x1ff;
-}
-
 static inline unsigned char
 vpm_in(struct hfc_multi *c, int which, unsigned short addr)
 {
-- 
2.27.0

