Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B72B0D65
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgKLTDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgKLTDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:03:00 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCAFC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:59 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id v12so5375575pfm.13
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fMyNeyMIQsirgjnCDGnyYpd6LU6jKA1eMXSUgYknCfA=;
        b=mMdZq0TqbhvbECFPkP5NrcF27u8ZaM+0BT7pGvEgWLZw+S4Ro96+qcXTgx5c8Ed9ZY
         MQA8IgpdmTrU3FFDiy0Uy22uXqfpCKoYpKv39CfBUEhhU00nvG0CQiCANJrbf9e/rUxC
         DOhg236RXtfTRKxacbanc3Srw9fdOEoNGGPLe8vQ/JpGk5iDuou29TgeJIF8e1eGUDTi
         8X5Zg7Bk/X4wBr/Z9Zaccn69GWyvOz2qiKugw5uZ0QbQnsIq65r+8BRPoazn7lElKcIU
         kqw9+XWv3f0T9rkPsU36tJy+YNe4obxgOq4fwqA0xP1DDq79lu/SweLTWbkHgLW9Al+o
         ZPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fMyNeyMIQsirgjnCDGnyYpd6LU6jKA1eMXSUgYknCfA=;
        b=Sib/S5mxLXV9XNIggA0k2CgGWkH9brsqB287cYNQa8QfHzF7/BxGb6oYlxrHemTkSL
         w17lyamcvPOlF5KrQ8tHYzMkwhDwjo1IyGEANcr9cICrc54OugSOJeDYGYAM2aKwx00e
         jZ4sCgjRghM0nSi2WMm86NFfOnIGaKXpGsEIOrJCJs1IQYmBhkbDVCr/DUXCR9Yjjctw
         OJCoOIjTxIkpb8NlAstFPa5pLOSLs4E6/sLt0tSxdkucDodtaDW83UzlfeEIrMaEPucQ
         a3A0F2yX1u5VjYGp0yqUHrLC+SE5u5QSbTqk/8X7iixHS18GiqdoAX4ivJEQ+cu4qb7S
         e83Q==
X-Gm-Message-State: AOAM533bdme8uMvxYOpdfkNy0BJnZhHQ1jx7FPBfSk+mnxVoWJ8q227u
        4LB8gextbdBFi27od46Nn4o=
X-Google-Smtp-Source: ABdhPJwC2RgJ1FH0a2O+NqqX59YSlLjb4439DSuUKbP/LrSyBizn4tpwrFFZl0lZddqo5T5xTXgRyA==
X-Received: by 2002:a63:fc1c:: with SMTP id j28mr720539pgi.95.1605207779125;
        Thu, 12 Nov 2020 11:02:59 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:02:58 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 5/8] tcp: Fast return if inq < PAGE_SIZE for recv zerocopy.
Date:   Thu, 12 Nov 2020 11:02:02 -0800
Message-Id: <20201112190205.633640-6-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Sometimes, we may call tcp receive zerocopy when inq is 0,
or inq < PAGE_SIZE, in which case we cannot remap pages. In this case,
simply return the appropriate hint for regular copying without taking
mmap_sem.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f3bd606a678d..38f8e03f1182 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1885,6 +1885,14 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
+	if (inq < PAGE_SIZE) {
+		zc->length = 0;
+		zc->recv_skip_hint = inq;
+		if (!inq && sock_flag(sk, SOCK_DONE))
+			return -EIO;
+		return 0;
+	}
+
 	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
-- 
2.29.2.222.g5d2a92d10f8-goog

