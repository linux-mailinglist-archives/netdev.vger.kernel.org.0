Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175113D80CC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhG0VHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbhG0VG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:06:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D6BC06179B
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e14so10502plh.8
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KNJkxRbTZjBfSAYGR3816TShm8Emkoyf8ZdfkqPS+FQ=;
        b=TTGjFuoejzZ4UcURjJ4pPdNPDe9Jn5SyFBfglcq90IykesIiOVEkCdbcD/m3+qhdva
         slQ4ePKQ6iwR++JiczF3JHBNNuTp4LyRmWMRuqTcdz+fw6qszodvFvFG5Ibp5X/LllWc
         +fRyxKvk7rn5leQezWTlqBpgyuWYKt8lRuKMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KNJkxRbTZjBfSAYGR3816TShm8Emkoyf8ZdfkqPS+FQ=;
        b=JFKpJ8u9NBL2N1NxlhSHv3qmNwACZpjvBKTyYFYq5HlTQ9Ce3qLdxHLnenG1yAd/BO
         E0FmqESeuq/eZd2hyKvOHXdeA/hWgwCPy0W830++uO6yPp+eQZn9fnYKNGjoIkDKDogi
         7MW5XETkUFlafC3kXxP9Fnhf0Sa6fC+x4uXr7KMQSPSZJXGnkrEnoUUm3/Q0FT7lRw8m
         jIsnJE0wadcPpcMG02p4qQB0k2buZoWL8l224FOg+Z7BkQ4sZSJKrcXpW0o19WPfrGTw
         faWGGCn34AjjW8tKK/2fEzsO7eoKNySB+dtHe87Tub/HgiyI9mzoRwpoDo2cab1PmGRE
         yktw==
X-Gm-Message-State: AOAM532cx6EdzHT1iis4sQoRxkDTArJ1Bc6UNENGzpGiT9zZlNL0tS6+
        k8RMfgPh0Muu6Y+mQxyoROOKZw==
X-Google-Smtp-Source: ABdhPJz8+E+SDb3LoAbaQEcUj/nENGUTPsEXTKFEfKJ+U87AixQ7X8CbyjH9KY5gO+50OJnIiipy2w==
X-Received: by 2002:a17:90a:5a4c:: with SMTP id m12mr6207285pji.15.1627420014655;
        Tue, 27 Jul 2021 14:06:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g8sm4556875pfu.30.2021.07.27.14.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 44/64] iw_cxgb4: Use memset_after() for cpl_t5_pass_accept_rpl
Date:   Tue, 27 Jul 2021 13:58:35 -0700
Message-Id: <20210727205855.411487-45-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2100; h=from:subject; bh=gV9IZTM5qU7jcRGph/XDG3+fKRJKxoN9HOMcsfOyL0A=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOK/UN78x/osAzwgMKupSwSrhwjEeLTXqK++CZi 7CH6/zyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzigAKCRCJcvTf3G3AJi+aD/ 9wSoxGLjbf3nMxhdx0FTNoLb7tUlFlGp+wsA1eq4h8eLG5OlOTzsA8IwsIgBPWp2/c4lh/3h8Wej9u tFFoUjbe3EwfDLU01dywIYam3R6J6s+TD7jpKeWz0MWD2NFKTvNmK/r5nlDA+crVlsHLnuBl7ozHdp Uoh/Bz4xC9nN82aPUAif26+yocqytHa2sw58nHCezNegk9sqBcHUCoNnFodMubFs/UgzD7hGOsd+1B aOhnYDdb2QaqaHaKTplZpcofR90e0xKWhk0CRSg83IE3RApySZo8s2Q4xTS1Ma3eB82/7z+gvwQXWY hia/xw+mpgLBcAZ0jCu/itWg4QCogWD2bkotmQJEfjL9TXjZCGUa2NGLC/CnEfFKcyutnljBecv1EH 0Q9xXQNOo4tw2JZcb6z7NV4dR0L+tjj3BeFNlPgNbG4VgwmG7uKubRriMRe5NSZBE38cW0fSq5rQ3Y T/5J6pZ+p6FMSSVheYF8tjScBuAHu1NRrxeGGj9Wx4M222kdbmFmeXqMdbCPWOgSfuuCWozDcs7p7z +9BLk6YAP2L0i/Fh9KBLAPtQ43onOWXv77p4r/RE/gXudIT6F++lAYSdbKOI9/3skSabDHdxRbQYhk 1gswdeOGaLRaDVm2CSKXSrfli04Bjbp+JUMycYvzS0p20FUxvYZuh3eQYepg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct. Additionally, since everything
appears to perform a roundup (including allocation), just change the
size of the struct itself and add a build-time check to validate the
expected size.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/cxgb4/cm.c            | 5 +++--
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 291471d12197..7129ae025b2d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2471,7 +2471,8 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 	skb_get(skb);
 	rpl = cplhdr(skb);
 	if (!is_t4(adapter_type)) {
-		skb_trim(skb, roundup(sizeof(*rpl5), 16));
+		BUILD_BUG_ON(sizeof(*rpl5) != roundup(sizeof(*rpl5), 16));
+		skb_trim(skb, sizeof(*rpl5));
 		rpl5 = (void *)rpl;
 		INIT_TP_WR(rpl5, ep->hwtid);
 	} else {
@@ -2487,7 +2488,7 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
 		opt2 |= T5_ISS_F;
 		rpl5 = (void *)rpl;
-		memset(&rpl5->iss, 0, roundup(sizeof(*rpl5)-sizeof(*rpl), 16));
+		memset_after(rpl5, 0, opt0);
 		if (peer2peer)
 			isn += 4;
 		rpl5->iss = cpu_to_be32(isn);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index fed5f93bf620..26433a62d7f0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -497,7 +497,7 @@ struct cpl_t5_pass_accept_rpl {
 	__be32 opt2;
 	__be64 opt0;
 	__be32 iss;
-	__be32 rsvd;
+	__be32 rsvd[3];
 };
 
 struct cpl_act_open_req {
-- 
2.30.2

