Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FDE47378F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbhLMWd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbhLMWdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:33:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFA7C061D5F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id iq11so12901292pjb.3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3eqcTIWiC+KHyQNr9D4gbvRaeijCgA+zD3SwshilTo=;
        b=bSotBO1SifpAEcn65dx6taJwcyVfz70TuvaLmRPzGaoK9y1HTyzmxWlb/dtNfrgYEQ
         8epiPZSD71JVyY8D/Nwlrsil5OLe5OWwJmyUOOCx+9P0CSr7rJHBN/vWbZq9dbLt/pXb
         8iiXLz+CqQlt+qI4AGu7Dtxt9SHIHEV7m8T9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3eqcTIWiC+KHyQNr9D4gbvRaeijCgA+zD3SwshilTo=;
        b=Eif2q15VsExy3SI4LUkhbcMPWHT9b4GRXXM0hOREhAzVu+weYhR++y9FDTcN36RmQf
         wgggUD9NOltVnrplPoQ9WdCNTcTY1QtGxzZdPlkrTOEi0pmpnZrAqDTgwSO/Y3H45F46
         GanmpoGOacdDsVWWAhsWeIqiO8ybB1jZiVeXRVy5hCrorAB1d1/Q0RYdpIXmHEGhfSr1
         cGRcS16dyY2Sp5Th3cHUQZ2PgvUjbu/gvTIwPtb5xPK1gwCWHqWG5vCAk4ByrRxXTRZ/
         PQeDLJJ9Cmyzi2DItFA0US/Y9+zmu1d9cQY3uP5oxHJbqgU8v1zqJsWVydSpwqZayMp9
         ukYA==
X-Gm-Message-State: AOAM5307MNjiy45fOdQcop0BDh6OaMIF/kEc8ZjEun+JY/XdxxYI/gNy
        A1ROa44d/ks30gXjN6w+UpgTYg==
X-Google-Smtp-Source: ABdhPJydJaUt968ItHIsV+C+S8DmxMrxQt/Lk2QzQLpgJNl2hHaYMZ8aIZwavexDYTU8q4oLhCgpOw==
X-Received: by 2002:a17:90b:e83:: with SMTP id fv3mr1153098pjb.115.1639434821738;
        Mon, 13 Dec 2021 14:33:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q17sm14966913pfu.117.2021.12.13.14.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:33:40 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl
Date:   Mon, 13 Dec 2021 14:33:26 -0800
Message-Id: <20211213223331.135412-13-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211213223331.135412-1-keescook@chromium.org>
References: <20211213223331.135412-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2404; h=from:subject; bh=NRZzV2Wm+qN1hLpw7oPDOvO2yOStk7XcopUutjYf66w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBht8o5I5L7op6wxBNo8ZoE2HZhjRGQ3UxHlr8nNIus yAqJvR6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbfKOQAKCRCJcvTf3G3AJp1zD/ 9jAFtNeIQm4EewUKA78ifdR6IkV6fNLr41dqbxD0xSgeQS7WokCTQXDEw8OfoPXzLUR0Jdi66DbXNg KG+CiCejrRqs6r08bnPj02LGJEyYzQ7ZwUShJC7B1rJ4Tn7NIVLWlKK29Wbi+eocXdHhSFKezYG3SQ 6Ltml+Nij5zu1T9ZZk09JiJg8zP3JekDyjIq7BGuZWAhddAU/l/C4eLIFQcFaF7huoImo3aXgVVVyI H19k9KJR9zQPTsr8wrHwCVVmlaQISb3Wy8DXFFBwFHz6K7L4mse4I3HxL64l/wJzZbpqVfJ4OXiyyU eIk2EekyUx8315bGoYkRryWNwIlFmiwOJsx9ZGX4HDKGqCGbrOFfAVUzn3rvJEjiBVCoqXxoU47qFq DW6AMqHa4Z2J5I+fsEdrarF+6Rs9MWFeOlPvt0KMsLCCDAgqiKiwK+RYNpR23zuSxXCUi5LjZbIySf OLs7o0i5LHW5129oVTW+uQELXJbUBN/EW9FJEd9GmR6USXdaFAK5+nbAJVZBuC33NIKnkwN09UcGMr LYIkrtghJWNmsCfcZXFJH/ZnAkh07XbcEjVILyAt2qfoTTD4zTJbBGjMdUumewIKLCurQoVF4LvpDL IJu5l+8Fr4zZRE80JbW+hvIlyij8sNL/K7c+cvFvR39dgMXtliIXLXRzui3g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct. Additionally, since everything
appears to perform a roundup (including allocation), just change the
size of the struct itself and add a build-time check to validate the
expected size.

Cc: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/cxgb4/cm.c            | 5 +++--
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 913f39ee4416..c16017f6e8db 100644
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
+		memset_after(rpl5, 0, iss);
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

