Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C276E20B830
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgFZSZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgFZSZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:25:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE22C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:25:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u8so5027584pje.4
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHDLZSZFF/fReafmKpcwSmbU0UojBwx6AdtrA+a0AOU=;
        b=W7UbYje/jDqQ6Uw2SQ8e25BNXHyuXR9ZEqULMg0UDPKotVFzTKmYHmiXD2GsbLakSg
         FFIDXRI4OErUBUoX6EvWqb2qwGMu0K4G0qlzmfqrKa7ct7uNmBBNazQJf0J79dq73V1r
         IzeNQtkLhifaGZLEi04AzJF89fj0p9phOlIyB/S6Hi0w0wempXalj0AQbvZD3/+vzmFv
         afUsY5jlCBOeE5JINLPHm5d16a2Y2ubu6E4OJmFhoqIjtmV6gtl3ufmCkSLL4LZvynxX
         ScWtpfahFuTHqiHnGwYXQUPsSFupBHEGGIz2M8y22mLw47wCLPM6qR/LkHjhHR6pW/ts
         tTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UHDLZSZFF/fReafmKpcwSmbU0UojBwx6AdtrA+a0AOU=;
        b=m0kE4r9BQ+eCSmU/Y/2nvPfaCn2+2YDbyKMYTUM0BxUCxyyeTbo8ikQ3DFpsdmHd+4
         hHrh2UAXs/m4H+xdP2k0mZV1qw8Icx9Zok+Bjg+Ng6BJANN/Pe487Ib+VGiMeCfmkoW4
         hpzuWRuR67rNgJWbnR5iRUH5eSowXnvH0ZDAtet0vHdTXvo9xmH7/28jVjcgyDpHqh5G
         Ond4hMVxZDYCDfjs/2Epe4afPUrzG26EuGtzpNhfePCkSZljROd3E2gHRz/kWTWmRBbG
         ypb3/BkF9rhkrddXA89rBnUODCQBSv5tuIEChpqtm9XnB8iwjYIaheVpCc+iA5Aw741T
         j+ZQ==
X-Gm-Message-State: AOAM530zwZ7xbZEfJbRtlPZtLndDCtZCXAd2UmeNRwn18lf2kGK2K5Eb
        I38Uf1X9/liQE5W96Yv8jP/ZHQ0n4bo=
X-Google-Smtp-Source: ABdhPJzSukX2jr7tjyliXrr2fWhpr6VgdMGltl934p0cDjuAeEp+WxXC/UyjPx7Zypr+ou71f00lJA==
X-Received: by 2002:a17:90a:a383:: with SMTP id x3mr5033480pjp.199.1593195930628;
        Fri, 26 Jun 2020 11:25:30 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2601:642:4780:87f0:b554:afd3:52c0:2f89])
        by smtp.gmail.com with ESMTPSA id j126sm26448574pfg.95.2020.06.26.11.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 11:25:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [Patch net] net: explain the lockdep annotations for dev_uc_unsync()
Date:   Fri, 26 Jun 2020 11:25:27 -0700
Message-Id: <20200626182527.9842-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lockdep annotations for dev_uc_unsync() and dev_mc_unsync()
are not easy to understand, so add some comments to explain
why they are correct.

Similar for the rest netif_addr_lock_bh() cases, they don't
need nested version.

Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/core/dev_addr_lists.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 6393ba930097..54cd568e7c2f 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -690,6 +690,15 @@ void dev_uc_unsync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return;
 
+	/* netif_addr_lock_bh() uses lockdep subclass 0, this is okay for two
+	 * reasons:
+	 * 1) This is always called without any addr_list_lock, so as the
+	 *    outermost one here, it must be 0.
+	 * 2) This is called by some callers after unlinking the upper device,
+	 *    so the dev->lower_level becomes 1 again.
+	 * Therefore, the subclass for 'from' is 0, for 'to' is either 1 or
+	 * larger.
+	 */
 	netif_addr_lock_bh(from);
 	netif_addr_lock_nested(to);
 	__hw_addr_unsync(&to->uc, &from->uc, to->addr_len);
@@ -911,6 +920,7 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
 	if (to->addr_len != from->addr_len)
 		return;
 
+	/* See the above comments inside dev_uc_unsync(). */
 	netif_addr_lock_bh(from);
 	netif_addr_lock_nested(to);
 	__hw_addr_unsync(&to->mc, &from->mc, to->addr_len);
-- 
2.27.0

