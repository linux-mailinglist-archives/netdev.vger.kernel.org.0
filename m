Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98123EFB79
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhHRGNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbhHRGMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:12:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA3FC0698FE
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:06 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q2so1141414pgt.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bf2aGZjkA9ZdJwTs2unG/S+9qMUhCrqY/7iHdHkH31E=;
        b=A5I0FSkL7KTi0It4kgEm27RXwjzTjYiZalV5qb+BVbRkycsgZ6clnB+HMIO88/Lahs
         zUfCqQaTXkbN7vGog/kgYObDuP3sM9ypsYZBTKoYz0zdY2laHeTI6MGbyFuVzp/UhIbz
         SA33K0vtCtLYBcIuPH619Gf/JvwDe9tUUYn/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bf2aGZjkA9ZdJwTs2unG/S+9qMUhCrqY/7iHdHkH31E=;
        b=OWQmqHgCUGtb2Zew6kxDA9rH/Ydn65J/TCg8i0FkBC0fvjMcuPhBVOSdw2XEfWLl4z
         Y0Kf74bxIlOspXfpuzb5ppya1Sl9alD/axw3mjPanHnNrGSeRf3p5KEcMESASX5XTgsE
         AZKziO7Gl1p9SxnvrsOd5OBcqjHEkugricatK7u12aKR51JuneZw/HcdyYxjoY57e4yU
         iFNNYYxR21DV3yYuVGKf7guvHJfqhggCky3HQzE5Ya57XIZRavKzT6n1S481pbkbcTr/
         V90D9irIGl2Bh3KfyndpdDhxPpWdsRECS43pphhb1snJJ/UTryPbFkmrAl4GNj22hGN0
         ZoEA==
X-Gm-Message-State: AOAM530fc+uuAYkA2BnKn9wuvU8BXfQH+IkC7X9yo/rklsTRLb2+f5bj
        t2VSRXEQHvEismT69XkJjhTg3w==
X-Google-Smtp-Source: ABdhPJzIwbxoplLwgyMwAYMY+AYzEbGav9ejSeaA2oSrg/gnLSdaifU6G3gvCszWYv19xo6NLd4rnA==
X-Received: by 2002:a63:101c:: with SMTP id f28mr7267532pgl.330.1629266766044;
        Tue, 17 Aug 2021 23:06:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c9sm5531358pgq.58.2021.08.17.23.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 60/63] net/af_iucv: Use struct_group() to zero struct iucv_sock region
Date:   Tue, 17 Aug 2021 23:05:30 -0700
Message-Id: <20210818060533.3569517-61-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2231; h=from:subject; bh=bmKbsRP16CnR5PXdPB4ZiDx9DBCysB2r4z9hIIKiJic=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMrUiy3wzC2Tbpf2LUdDadDtk7FYIB+hFtnsIrW fkTfIlqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKwAKCRCJcvTf3G3AJkYyD/ 9ucWeKdq8Xqqc/QXVsAWFOW9NzYhLInbMDw4OW5CozZyRbnOPk352gq63xaqMFMsclZFLEMQ9TTO33 7OYOFG7yKLJH7xWiqIvXwLztLuZw+JXSioGcmPOGOtg8hAXa8jiQ1KixmMPPGspos7hxqSuEzt31Y0 tNY4L/eDOvurxWrZsBGWm1b1k5PsAc+g8zMvnFzCBDhHj7YU0n+DSqAqBOzdrAc/BDQ6WwCtZWZgHn VVMCXM0qPf/ljXYEYnUK+ZZnl/WfbDvNoDPpsLQ0zZXhIhNtT3BKEfer/GfabdgopxSGXxTV+7JLfW 4zvjCOjHDppWfw99ppMZmvMvDN3k26ttKsLH7cVJ+kxEk9IZohT1lAGOfHEd7n+qAs4B4SrYMGb0uM wnIP+9JGQlViNQCZz8651n9z1vC3LX6PQlO5oS2pjadtH/dqxOhmIw392G3ODhOfboU0ZOnPR3pfTA vv8hjA/ukE5Dt/9T5+e3XaDNef7XzWGuEJy//3iyWc+lV/f+ruPwosN4rWo7gnyIbF2CgCgdasK6ZN PvgpQFRdA0UU/KoP4B9xx0S3rtUne33iTi/VsaHcMSUoisF52ghW2rt/M1apXDnx8RSFOroKKUUTSX 3+F+WfyISvDRWznlKXQ44kQRHNtJUEKNW8cFL9JBRk7SYT4Mh7lRv9p5s4KQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark the region of struct iucv_sock that gets
initialized to zero. Avoid the future warning:

In function 'fortify_memset_chk',
    inlined from 'iucv_sock_alloc' at net/iucv/af_iucv.c:476:2:
./include/linux/fortify-string.h:199:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  199 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-s390@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/iucv/af_iucv.h | 10 ++++++----
 net/iucv/af_iucv.c         |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index ff06246dbbb9..df85d19fbf84 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -112,10 +112,12 @@ enum iucv_tx_notify {
 
 struct iucv_sock {
 	struct sock		sk;
-	char			src_user_id[8];
-	char			src_name[8];
-	char			dst_user_id[8];
-	char			dst_name[8];
+	struct_group(init,
+		char		src_user_id[8];
+		char		src_name[8];
+		char		dst_user_id[8];
+		char		dst_name[8];
+	);
 	struct list_head	accept_q;
 	spinlock_t		accept_q_lock;
 	struct sock		*parent;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 18316ee3c692..9446e2771d31 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -473,7 +473,7 @@ static struct sock *iucv_sock_alloc(struct socket *sock, int proto, gfp_t prio,
 	atomic_set(&iucv->msg_recv, 0);
 	iucv->path = NULL;
 	iucv->sk_txnotify = afiucv_hs_callback_txnotify;
-	memset(&iucv->src_user_id , 0, 32);
+	memset(&iucv->init, 0, sizeof(iucv->init));
 	if (pr_iucv)
 		iucv->transport = AF_IUCV_TRANS_IUCV;
 	else
-- 
2.30.2

