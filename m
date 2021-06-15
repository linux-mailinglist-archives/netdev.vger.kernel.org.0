Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C73A8356
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFOO5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231274AbhFOO5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623768907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gxp4+onf8wuO87Iii4KRL2PGeBHDLINdkwBz3RXDQ8I=;
        b=Ro3mOVqYwuMlkAgcIBfxI+x/BnGTgITw4VNuRC0gU71ZSYGO5Yqemed8MoLNL1CHMLZfGI
        w9KxJQnNBOMBn2N/UCAak/1STlVlMuGgtPdBPHcVqLw99rediUGL0+tsjxxkrZuCDQb0Ln
        2SBpA4aO6uclw1VhTNnjOdKyHyoKKxM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-qe8IcxMmPo-oJCMCML7_Pw-1; Tue, 15 Jun 2021 10:55:06 -0400
X-MC-Unique: qe8IcxMmPo-oJCMCML7_Pw-1
Received: by mail-ed1-f72.google.com with SMTP id t11-20020a056402524bb029038ffacf1cafso13027471edd.5
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gxp4+onf8wuO87Iii4KRL2PGeBHDLINdkwBz3RXDQ8I=;
        b=fY5908mlwg7PEtgWYYd5PDiz/oCz20t24WQ/YGV8K6bC4kzZyby2tTgfmUJXt8QlBT
         HMKCE7a/s+K/ZuMkuJQLB7us09Wgvma7+PMQ75kwh1RqcsYT2FDmP/dNCPOiz+jTBRFp
         snkNJM63P4vWF7NaTfjl6e0lC0nvCnbSgA8mOllTyodBHK6FBIjkeCzjI7+veFOX456Y
         Iq1dFlhigvdWS1lghsYOeRYh5VWpcUWNGBeg8l2gNQk5V6XU1UJ10NsqvmOzPRTsjgvU
         XUL84a/jtxTGKRgb4XG5eKcSkbVgFL4ftyp+ICetQEGwkeW6o7YIdDA4WaqsqFlnP6QY
         +Lig==
X-Gm-Message-State: AOAM532UTsh41DWtdolPc0TRLa+oDYbCDKlgrHskDzrV29mm81AHbvJI
        ++0OdMIr6uijdnJRK5iXvjruYR9h3nyQuUz2CImLXTUeZP0+qirVTfJMYSOaNSlb6IJCrMSGyql
        v7Bqzw9b6V7WAdZ3u
X-Received: by 2002:a50:b2c5:: with SMTP id p63mr10055607edd.5.1623768905657;
        Tue, 15 Jun 2021 07:55:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/YwZa9hwA5T/K0ZvJNmG1D6JAT7VKQUI+n0jma5WK9p1jIeM6YWlaebazh4ioDqp7gZhVVw==
X-Received: by 2002:a50:b2c5:: with SMTP id p63mr10055582edd.5.1623768905390;
        Tue, 15 Jun 2021 07:55:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ci12sm10333745ejc.17.2021.06.15.07.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:55:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A7CD31802AB; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 01/16] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
Date:   Tue, 15 Jun 2021 16:54:40 +0200
Message-Id: <20210615145455.564037-2-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

The xchg() and cmpxchg() functions are sometimes used to carry out RCU
updates.  Unfortunately, this can result in sparse warnings for both
the old-value and new-value arguments, as well as for the return value.
The arguments can be dealt with using RCU_INITIALIZER():

        old_p = xchg(&p, RCU_INITIALIZER(new_p));

But a sparse warning still remains due to assigning the __rcu pointer
returned from xchg to the (most likely) non-__rcu pointer old_p.

This commit therefore provides an unrcu_pointer() macro that strips
the __rcu.  This macro can be used as follows:

        old_p = unrcu_pointer(xchg(&p, RCU_INITIALIZER(new_p)));

Reported-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/rcupdate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9455476c5ba2..d7895b81264e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -363,6 +363,20 @@ static inline void rcu_preempt_sleep_check(void) { }
 #define rcu_check_sparse(p, space)
 #endif /* #else #ifdef __CHECKER__ */
 
+/**
+ * unrcu_pointer - mark a pointer as not being RCU protected
+ * @p: pointer needing to lose its __rcu property
+ *
+ * Converts @p from an __rcu pointer to a __kernel pointer.
+ * This allows an __rcu pointer to be used with xchg() and friends.
+ */
+#define unrcu_pointer(p)						\
+({									\
+	typeof(*p) *_________p1 = (typeof(*p) *__force)(p);		\
+	rcu_check_sparse(p, __rcu); 					\
+	((typeof(*p) __force __kernel *)(_________p1)); 		\
+})
+
 #define __rcu_access_pointer(p, space) \
 ({ \
 	typeof(*p) *_________p1 = (typeof(*p) *__force)READ_ONCE(p); \
-- 
2.31.1

