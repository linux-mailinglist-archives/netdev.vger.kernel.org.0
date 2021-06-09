Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32B53A111D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbhFIKfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237099AbhFIKf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gxp4+onf8wuO87Iii4KRL2PGeBHDLINdkwBz3RXDQ8I=;
        b=T2CJqXdpOltf5zPOQAefDXoAqJoDp/l8SysxRlyzRBPiWMMcAi3xIuHIMA8iaqvo67Hb/h
        biVz9uBa6ON7EcPV2QpmrDBvgrmqM39rA/TY8d0LasbfXvuNYn2yZIqJ1XiG7tPbqc1mqK
        RpKfIbtzzhMmqqxgKI0Kx2Jfnm5vC9k=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-Wc-j9V56P_m-0lmt9NRwNg-1; Wed, 09 Jun 2021 06:33:33 -0400
X-MC-Unique: Wc-j9V56P_m-0lmt9NRwNg-1
Received: by mail-ej1-f69.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso7871149ejc.7
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gxp4+onf8wuO87Iii4KRL2PGeBHDLINdkwBz3RXDQ8I=;
        b=CXeo+7dZb0yR4PTcaR11VIDfEezMkntoKnmp8xjYG+8jyeZ1rnL3TxxTzMvoFbIQ5i
         LD4I5xv7FcckSo7gVLBh79K4CzAVgi++/2VhkpreBgrTdmM+HkVTlVQZfYtb6v7snk05
         I2higTEWuTxSwEvQNI1AOp7ioe5ZakY6x6rlv5JMgWXCiZQbEu5+XOZKwDM3j/Vtn2qu
         nZNNBubt9fpSLBz1lzrM8u3vbz0xIEcJMcfCdWDyXjjUFfhDx+GXDIZwc3ciYc27QKbz
         HIroSH9z9KJyZcP7nsJGO26BL1/apG4hCCVDZoP0Tam7xBYLuCk1ODHoLSIhVLbt23jK
         l80Q==
X-Gm-Message-State: AOAM532MtAi44hMWo1JVm+b5420Wzfia00hrhGVaHCXpgP5YP4/j2OLD
        3Hf3Q4CG3lD5zn1rWrVRLBuOLvoL4qQz/4JWIfzkV4ovmKlLtxMVBYYuk0qbP1USF/oVbpXPm8O
        Iy0TDUWIYoXdpmw3f
X-Received: by 2002:a05:6402:26c7:: with SMTP id x7mr2175506edd.383.1623234812141;
        Wed, 09 Jun 2021 03:33:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2igLZbG/g6/sOl81ouk5Bu5Pe7/HfADpKcVG79f8SVe4ZITtwLk2lEhEJTshHty5qumc5Xw==
X-Received: by 2002:a05:6402:26c7:: with SMTP id x7mr2175482edd.383.1623234811710;
        Wed, 09 Jun 2021 03:33:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t2sm917109ejx.72.2021.06.09.03.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5C2EE1802AC; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next 01/17] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
Date:   Wed,  9 Jun 2021 12:33:10 +0200
Message-Id: <20210609103326.278782-2-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
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

