Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508506C312A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjCUMCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCUMCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FE4AD3B
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679400093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZUORpevlKQiU73IYOa4/Bo2bFBpxSB0mQvJe2zWG4uk=;
        b=hD59h++Z1XUDa2nri5jA5aOYdQsDtGg98PKHBKtRNUnwrYYTF6xQcHiOwSCMf6X7i33wfe
        ySQSrSAIB3SZ9kXgSIS8PJW30dCIsPnMntiVe6x0wSenmY+c3RfsocCGVpLQ5bIXXuatXh
        C/DfocrOh+29rjgHvfkPmK3lQCnuHMQ=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-wQLEzDZ7OTWLV-lFdm7IDw-1; Tue, 21 Mar 2023 08:01:31 -0400
X-MC-Unique: wQLEzDZ7OTWLV-lFdm7IDw-1
Received: by mail-oo1-f72.google.com with SMTP id d2-20020a4a5202000000b0053b5874f94aso397908oob.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679400091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUORpevlKQiU73IYOa4/Bo2bFBpxSB0mQvJe2zWG4uk=;
        b=7EGEiUCGCVVDEhw1BqCs+lG8yz01f07kiM7aC5npFsR9DmNJCclaeWalJUEa/b2RA8
         mLVkSvWb4bclCm458+iusDdLWYbabW7m74qOQ8MumIid2j6YecrT5YJRZOJn8FG7lUEH
         X86wmy7pS2qyQQrl8PJbzJDpKGLg99RAoD90U1fqiqZO5uEm8q5yD2bHbtKJcPEIWeBc
         D6IPVqCBsLtzl2HwUYZNTvcTrSQa9pKWmBK/Po06srkmVRVrWkojD1ny9IZssXXnRBe/
         pQZj+cYqjugilZLfYBofXRnvkFwr2sR0JSAe3xFcISm/pJls/t58vlc+Se55bd08bbP0
         /cJw==
X-Gm-Message-State: AO0yUKWfgYVFU7X3AXZRfyrxRt3G0r3Yn3eMTPzeBj57+RqzIBIEaGQc
        si9yjoXdgPv9mc50JPsAloj5srIpoLuS74dZ51+2YeRLK9YvGtRMLtJ8sBHiRTCEsXMMY3wAOzI
        UZx8o9H1h4dWgskA/
X-Received: by 2002:a05:6870:8289:b0:176:263e:9965 with SMTP id q9-20020a056870828900b00176263e9965mr871706oae.44.1679400091080;
        Tue, 21 Mar 2023 05:01:31 -0700 (PDT)
X-Google-Smtp-Source: AK7set899kmqLmAPg7MyUnAjH/WqMmEGz8KcW68wrb4VDOu+woQ52tQV+an0Qn8sOt6JqzR5VPkhdw==
X-Received: by 2002:a05:6870:8289:b0:176:263e:9965 with SMTP id q9-20020a056870828900b00176263e9965mr871660oae.44.1679400090393;
        Tue, 21 Mar 2023 05:01:30 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t72-20020a37464b000000b00725d8d6983asm9163201qka.61.2023.03.21.05.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 05:01:30 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        kuba@kernel.org, alexanderduyck@fb.com, yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] mISDN: remove unused vpm_read_address function
Date:   Tue, 21 Mar 2023 08:01:27 -0400
Message-Id: <20230321120127.1782548-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
This function is not used, so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index e840609c50eb..ac665cf64f8c 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -663,20 +663,6 @@ vpm_write_address(struct hfc_multi *hc, unsigned short addr)
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

