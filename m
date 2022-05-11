Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3838522A92
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiEKDzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbiEKDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:55:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C12108A5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:29 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v11so891343pff.6
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2p2fPjfsIsJ6E9/ORkfpw1BwG9ijb5KY/aOnRzBglX8=;
        b=pUfw03v2yYPpGXgiiO1AI1VBqjOOMzwAHj2d2Yks2pr5NwxeXTDwKx+aDG4hnBLUPJ
         DyRLE8I/8b4bz9D8mjyxi6HdnDigwv22Gs6PYIxPKG7cAtPUMJKXw++F4iyGPgCS7oB/
         ySiOS8IQFGWr+Cax/kEOnhxLlG7w4r3dNHAB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2p2fPjfsIsJ6E9/ORkfpw1BwG9ijb5KY/aOnRzBglX8=;
        b=v1qBBF2aHa+piTihMY+l7JOZt3MutDdtC4z1jZfsYG4RLNWfKLWQsJNgcudTzm15k2
         LIISYAMjgNc6ANo2/sxdOFj+J0nK1sTwIivL4IS9TyDQAnOK5sfUDxLi79NidxaqYE0h
         9GRX8oMLumIqXJJKJf2PjPEJVvLbiECJy5jNt86R2akZqVIsjq9BYGq9wNpPNC+qyUZ+
         +8qvqTZKn0E0xhe9qGdYao3yUivhunvz3pY3eHzRYJua0//kKLJJiZLnQGb9qaGt+aYP
         mqGurvMiT45AQYj7jmCO4F/Vs+hCWHF1+LTAiaGwedcm5FuVUaNhagYw8iW3KsbVVlH2
         SkYw==
X-Gm-Message-State: AOAM533PD2bGdAXj/YwL7t9q05llYv2Lyg9DPMAglwLpYUpv33WLba3u
        hLKvIpxt2qCiFTSw1Lwr7v6wN831rpNejm2TvTBMlQZkuzHTJ9blsNdpjkfMc5Ka5Bm9/ztZiLX
        jmBLJcPitQvUBHZJPmUdT/9D3+K/yM9FPcDEpDYW7aidvnvhHeMbtC9mh3evv/M2IOxnK
X-Google-Smtp-Source: ABdhPJzc/72l8fO9n7RvaaUC+1kyZHe2Tt9jHZADFhzTnhiYXdy4MIHTlfNLC8Izcw43sJcjBnCDXA==
X-Received: by 2002:a63:e16:0:b0:3c6:12b1:ce15 with SMTP id d22-20020a630e16000000b003c612b1ce15mr19238632pgl.37.1652241328326;
        Tue, 10 May 2022 20:55:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0015e8d4eb1f7sm442789plh.65.2022.05.10.20.55.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 20:55:27 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next,x86 1/6] arch, x86, uaccess: Add nontemporal copy functions
Date:   Tue, 10 May 2022 20:54:22 -0700
Message-Id: <1652241268-46732-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a generic non-temporal wrapper to uaccess which can be overridden by
arches that support non-temporal copies.

An implementation is added for x86 which wraps an existing non-temporal
copy in the kernel.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 arch/x86/include/asm/uaccess_64.h | 6 ++++++
 include/linux/uaccess.h           | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 45697e0..ed41dba 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -65,6 +65,12 @@ extern long __copy_user_flushcache(void *dst, const void __user *src, unsigned s
 extern void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 			   size_t len);
 
+static inline unsigned long
+__copy_from_user_nocache(void *dst, const void __user *src, unsigned long size)
+{
+	return (unsigned long)__copy_user_nocache(dst, src, (unsigned int) size, 0);
+}
+
 static inline int
 __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
 				  unsigned size)
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5461794..d1f57a1 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -234,6 +234,12 @@ static inline bool pagefault_disabled(void)
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline __must_check unsigned long
+__copy_from_user_nocache(void *to, const void __user *from, unsigned long n)
+{
+	return __copy_from_user(to, from, n);
+}
+
+static inline __must_check unsigned long
 __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 				  unsigned long n)
 {
-- 
2.7.4

