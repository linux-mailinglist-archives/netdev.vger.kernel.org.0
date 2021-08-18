Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99BC3EFC12
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbhHRGS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbhHRGQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:16:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7230AC035438
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w68so1076468pfd.0
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6F2rp4AnP3NGeIGZ05xMXWJjpPIK4Jb97h13JojrAko=;
        b=YS7HjPWIYN/hi0zY9J/Qa3kdLiLH0jPYZVcT09h4hTpyhsDz72uJbEQwv0OM8Fb7ql
         znv7CvxzeA0Qz0xPN1dyRP+5WGpweGQpGYgBdMyCMyHPS7sb4OP7X3quoy3fBQtKt91Q
         43CDuW+AiWTyS8i2ju09BtUBAVM+UeJJMXG1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6F2rp4AnP3NGeIGZ05xMXWJjpPIK4Jb97h13JojrAko=;
        b=hzGy7MShonllsjnIw3Fiq1tE1qOT1HOcBpIxmg7WLdFL53Hg0Q4rbCSk9b5zYCocU9
         +vQcOXtSM7xssXVxp3L5Wd5Lfenw3KMKpMbu4vKDptZ+ZQC0U2/HGK+jwcoAj5O71THe
         8luEiNMMGTGJmJivPwBwAnCrTglP4D99qrbzcoFnwYN7Cx2QbCus1A9sKWKz6CHXD26c
         dlFaAP+pAuJMTROJ0sxTy/iiHDLUxAmUc6Zn4C2yigjaAE23ZA65whVySG3r6Oni2lMc
         xLp+/l3xfM/Pu4s+4rja6FWbu8ndjZqY/6UgxP8kftyu5QULi9ybJy9j0Oi2ZCERThAa
         B91w==
X-Gm-Message-State: AOAM533hPNkbdn7ZHEATbr2JROq++23rQcFOjbG0YYjePnUHO987eIYG
        tvtVwQU3eBmkl+Tq9JKhZfUcQQ==
X-Google-Smtp-Source: ABdhPJyzumo6IYb/F48cHTjkdOuaBCTlR115MA4uwjlzC1JKyL0YMWal0YnIIHyVxOdZVX+0g5WHNQ==
X-Received: by 2002:a62:648c:0:b029:3e0:80dd:9b9e with SMTP id y134-20020a62648c0000b02903e080dd9b9emr7793195pfb.10.1629267260047;
        Tue, 17 Aug 2021 23:14:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q3sm5628541pgl.23.2021.08.17.23.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:19 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 46/63] iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl
Date:   Tue, 17 Aug 2021 23:05:16 -0700
Message-Id: <20210818060533.3569517-47-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2404; h=from:subject; bh=rquyWjDPJAfPxGH6VKiA2jIuZnWvLU6UgPqN/0FyQ/s=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMoZBU+AZTLPLboKA2tsHcUYnxXofUjzUeVV5jM TIxpyi+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKAAKCRCJcvTf3G3AJvHSD/ 44+6rU5jvReItNvFdWkzxvCu3Zfc98qUS6K5JULs74yaY9KObRjykrNvK0Am5wl91nOIUyOidTpbY8 gj5vdxz6Zn5qaupcsAyy9fMyJ/+o6OIVPQVkpg4q/1xaUe9XJBw7EuoHQ00xZOSITrFQxedJAa0OAv dDdUw2IJMSVp1BsKrqZ8zwnx6OGNmdcku1qJXAyXdUPATD3x8PsX1xW9/NxTPuIQTj7FklQQxnfOVi VM13p6OU2dfVTiA1MK0kBRp4tdKoR/yNDNbe6P8SBH4R+bXwe0CsulDmCc2+ySkpmoFz5Zs02RsCMW GqoOF37v9Un0rA9+BTw45+PmTWENIznqpoX86i1KrfPcRoQNLXy9z8wlq+eLzIvdRxFlRQ0KUXkX0f 0gvjYVFDNzhTQYMNABAPN1q4DUm5J4vXD2Na1e16bvF0v0fmgTDLw5ZjtW+s7lUQKEkjmMqeBNOT+Y xctphKqxjE0Q3GAfUhUMBlcKKfnVS0MkEPrQpdYePDhu92xpbEb1MR4J6wYY4kSlPNUtkpnSkccN1L /8vDJalPNghDaWw+eZU5YfymPY1LdOBA+9X5cVqUEglZUr356BU/Ynk+xpBRobnBRlejxkrHcHUA4g f+Tt4SJV/gbQboppXKrKMmuQZiynIRvgIxU13ahhCZLHHDEZKdsOOAbppgSQ==
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
index 291471d12197..6519ea8ebf23 100644
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

