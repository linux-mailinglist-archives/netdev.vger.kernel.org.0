Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E855733E6C9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCQCX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhCQCXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:23:08 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742DCC061763;
        Tue, 16 Mar 2021 19:22:57 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l23-20020a05683004b7b02901b529d1a2fdso379388otd.8;
        Tue, 16 Mar 2021 19:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7t1Cfs8H2HbGyVb7MF8qotYR3LVXoHtvMAt7AMQoiNA=;
        b=NZhtP1DFevuAvKRKCJowKvu5jUK+G/ISBVQ7AKsNfZ046w5wjEWT0PsV2w/j0uMOx1
         725teOlyiK+hCVzvfsao/Hvbfs6AoLgRLe+i+JnWNi8Zh5Rrr2q0WMlHVT6r/G2Vb811
         58yirvzFgG88rqIyJXTas/xB1Pn9rL3x0yKw/u6n6uOIhcPQ2Fis4jaEXduVjDRT5HHa
         5wEpi3Jn/3uIRc+dN37iTHOll7RZlg4TyF3qEbtSGeFhoms0cu7+p8vhk+J7Guq4ZKQ8
         UPsRiiomwMinweVXywvSjbVtih/4gidwPRD2sJ0oCKDus34HWqKXfNqkf+0nps+ETnhy
         8VSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7t1Cfs8H2HbGyVb7MF8qotYR3LVXoHtvMAt7AMQoiNA=;
        b=JpCaA2mjk4v4PU4ShGFpknmpGdg/sIkhk72Zc19ES3Mh8NZLDR35p/5qBoSY5qgBhs
         dgTmjGXg7DP9iK53H/dYnlwpBdqDINbI0wZgWOKwZmORRE18+LOalg9PyaTkg39KFF4C
         kpjArkGkktrnkcXLh4UHyfyW2Ek1xD6MuUBCdgQcwGfTdzmc13rHqVqvfcBjiWI+3GSB
         dQ8sVjyDyF0CWmIsbIvlhfH3zcCwxWpBqUa9u/1NYpJNqpH4/WTVTamReFo8zXUfrUo4
         AKtxe9XBVnUl7AUTrldMJhvizWtQDEBexFWNpPZNCExzi+CxPmguxLnKLzEYQWQ5i9nr
         DzdQ==
X-Gm-Message-State: AOAM530fnV+NPKQvm2K4tAtVROY9aNIYvPVf/K9ITduBm9+9BMYN4meS
        uYhiS3YJ7YDiqeQfYU2R3u8urHhLStZ3iw==
X-Google-Smtp-Source: ABdhPJyCZduzlDACu9NARwiC4E1UiKSVIxAghFsHR/4XFl+hAMw4em3Ze7eg0XJGlceBk0Pp7eildg==
X-Received: by 2002:a05:6830:1e14:: with SMTP id s20mr1516843otr.199.1615947776730;
        Tue, 16 Mar 2021 19:22:56 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:56 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v5 10/11] sock_map: update sock type checks for UDP
Date:   Tue, 16 Mar 2021 19:22:18 -0700
Message-Id: <20210317022219.24934-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now UDP supports sockmap and redirection, we can safely update
the sock type checks for it accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 596cbac24091..5ec8f8ce5557 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
 
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
-- 
2.25.1

