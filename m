Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7721E1EB79B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFBIpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:45:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFBIpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591087510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CuKIvsOKOIvk4PgTEV+w10FX9zJ+bEdYmI8o+OCWkZ8=;
        b=MzhIAo2lE4GaKxnKqMDYAncYqEWJAV/iAuJoU2dagVDqKZxCRcTRnnCyyfz1lidTnvAl7X
        IPCOf8NMf1tEST1lAa357gcVxLkj/vtHdhgMWYYPa/hucnjFN7/VKKDWfN2HelokwGcvjF
        LKbeMMglTnK+lc2W0AJoEjqJjD0b07k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-cLwt-kx6OwCgdivPVxDqjA-1; Tue, 02 Jun 2020 04:45:09 -0400
X-MC-Unique: cLwt-kx6OwCgdivPVxDqjA-1
Received: by mail-wr1-f72.google.com with SMTP id p9so1101316wrx.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 01:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CuKIvsOKOIvk4PgTEV+w10FX9zJ+bEdYmI8o+OCWkZ8=;
        b=EwWxsYriK6Nm6Jfqymn4j4UKfveVJ4GSA668OqheGi8IlJ6DJcD08Z9VosojRuExXS
         bq8eG9raVxfYiI74KT1MUqVATiHo1rnjkSZKR9pLqKHyPeYoEfPaBkYsdBFKGr31A9Px
         aom5PAtV3VKhRvfTkqtWtnIAHATggRJSARsvt53NkcTThS5A71wrIF2K6OO+U1i4DN/y
         q0V3hCi+hBZ8OeoKiDEU1jH8e0cgb6tj21aiGGHvnFSbd6UDlMwJPfrbLV4K9a9CpUU5
         70/iajibT9uucrmaBWZLVizIFGgLuwmRGSyn1UA1pnXKyqCNIisZNsY0vmSMbAW7PuEF
         4bSQ==
X-Gm-Message-State: AOAM531gG39bP/EvGmyLBQPZEyKoZHDwXmQZiPWYoPT9Cd6mm+VvppiG
        eVzJ3FUfiFq6JBnybcjG6oRc3DVBmcUPrb0AMEP/v5wTZiy6TZjC1uxxHsPfWcYJO+g+89Kzg8G
        F72cTTWnXqySfa+8d
X-Received: by 2002:a5d:630f:: with SMTP id i15mr24940741wru.309.1591087507795;
        Tue, 02 Jun 2020 01:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ22UiA8sXk0/1qLnLosKcnojExBRC52xg//ViCQ9TUbf65ilRTCSHKvDsX3BUKlBzqgKotw==
X-Received: by 2002:a5d:630f:: with SMTP id i15mr24940731wru.309.1591087507613;
        Tue, 02 Jun 2020 01:45:07 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id u3sm2642917wrw.89.2020.06.02.01.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 01:45:07 -0700 (PDT)
Date:   Tue, 2 Jun 2020 04:45:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602084257.134555-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So vhost needs to poke at userspace *a lot* in a quick succession.  It
is thus benefitial to enable userspace access, do our thing, then
disable. Except access_ok has already been pre-validated with all the
relevant nospec checks, so we don't need that.  Add an API to allow
userspace access after access_ok and barrier_nospec are done.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Jason, so I've been thinking using something along these lines,
then switching vhost to use unsafe_copy_to_user and friends would
solve lots of problems you observed with SMAP.

What do you think? Do we need any other APIs to make it practical?

 arch/x86/include/asm/uaccess.h | 1 +
 include/linux/uaccess.h        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d8f283b9a569..fa5afb3a54fe 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -483,6 +483,7 @@ static __must_check __always_inline bool user_access_begin(const void __user *pt
 	return 1;
 }
 #define user_access_begin(a,b)	user_access_begin(a,b)
+#define user_access_begin_after_access_ok()	__uaccess_begin()
 #define user_access_end()	__uaccess_end()
 
 #define user_access_save()	smap_save()
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 67f016010aad..4c0a959ad639 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -370,6 +370,7 @@ extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
 
 #ifndef user_access_begin
 #define user_access_begin(ptr,len) access_ok(ptr, len)
+#define user_access_begin_after_access_ok() do { } while (0)
 #define user_access_end() do { } while (0)
 #define unsafe_op_wrap(op, err) do { if (unlikely(op)) goto err; } while (0)
 #define unsafe_get_user(x,p,e) unsafe_op_wrap(__get_user(x,p),e)
-- 
MST

