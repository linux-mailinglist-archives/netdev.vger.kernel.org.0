Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE228F8B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 05:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbfEXDUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 23:20:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41917 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbfEXDUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 23:20:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3so4214391pgp.8;
        Thu, 23 May 2019 20:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/46rsZ0TTMrZw/Frg4uFqjjAL1q6S8X5odognbNJDoY=;
        b=U0zV4CMfeMlVJWaUSgQ8PLNxvkC7aaW5aY89tbgl4GaWQU9Hytv9KaCr4wB7cP/3+/
         eyAmLSx0MVQv7+FYZGKEGkuPZf5ajCwkatcsePz56UoZvUHrRM8tJQb5uIyI4JMs5rcy
         zci/srp1GX2M7ji6XHLLZsnDq2xYpEkh9K+2h6NHRzYlpuUB8W55RzrpezKijTRg1w21
         q76WbfjwE3llc4+aE8ZYtT4uI9t0yJz3dJLl1TUxsq24iJC3nf0d9mv4AYGoB8tAZn8v
         l8Den+dLrfUoExfU8Z49Hzn2Jw7ZFwgdykpVDRkwSjL1i0NrjKsRHDV9CVNZSz5ViTQw
         CZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/46rsZ0TTMrZw/Frg4uFqjjAL1q6S8X5odognbNJDoY=;
        b=kP+KagRvX8r008BxAjA6xJxIJs123Rzb8U+bLvGuMV+TgUIcs3DtpRxOh2fz3tVWZI
         MQeLDL9rfRvYbeS6Oi/bR2lePCsXDNhbWCx4U4/Nrtzw7CM19tYI4DATIoFJRibZOab0
         x7EUbNIsbS/FsjA9esDZAIDwo/o0ewxt0BTwEN25XtIE8gmdTjsw4u/fPReR8ALFoGJr
         W1G75N8ucs3to44bsRvzhNBoJZZvccTB9NDDzoeWRO2tqlI8hNIy0KP6pHqerScZD2P+
         N4HM5wz+ZbwquiwjOUi0+LQIbgPrpIRZTNK/IsvIC7RK9u06O3IM4DWSuL+cexJoA8ir
         7CKg==
X-Gm-Message-State: APjAAAVt88D6oNEDP2X/9dsgb8+I7iCId1IToZw/jK8DeOlQCEztyIHu
        f6NwIxGJeGIb8eG88389fjW7wABwLSA=
X-Google-Smtp-Source: APXvYqxbWSM+hI4uIW27uLHuDqC0XCB3kIbdcREdqzqdWBfwnTb7NoUXPaJHLvecNEQncC+9q1QBmQ==
X-Received: by 2002:aa7:8219:: with SMTP id k25mr16878817pfi.38.1558668021303;
        Thu, 23 May 2019 20:20:21 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id g17sm902746pfb.56.2019.05.23.20.20.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:20:20 -0700 (PDT)
Date:   Fri, 24 May 2019 11:19:46 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
Message-ID: <20190524031946.GA6463@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function ip6_ra_control(), the pointer new_ra is allocated a memory 
space via kmalloc(). And it is used in the following codes. However, 
when there is a memory allocation error, kmalloc() fails. Thus null 
pointer dereference may happen. And it will cause the kernel to crash. 
Therefore, we should check the return value and handle the error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

---
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 40f21fe..0a3d035 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -68,6 +68,8 @@ int ip6_ra_control(struct sock *sk, int sel)
 		return -ENOPROTOOPT;
 
 	new_ra = (sel >= 0) ? kmalloc(sizeof(*new_ra), GFP_KERNEL) : NULL;
+	if (sel >= 0 && !new_ra)
+		return -ENOMEM;
 
 	write_lock_bh(&ip6_ra_lock);
 	for (rap = &ip6_ra_chain; (ra = *rap) != NULL; rap = &ra->next) {
