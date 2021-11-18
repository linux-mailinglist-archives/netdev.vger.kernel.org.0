Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4B44563FE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhKRU0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhKRU0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:26:38 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBD9C06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:23:38 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z6so5071340plk.6
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQNsqAqVViEU3XvBO/CRhKayo7Uy9hYK0KAzIytsmBA=;
        b=HooZPLmEmuWp0i73mi2Xmp58mGSg0YRZRUfaTTR8lk/sRwRpp6XrfKzpRO/kMQHO7l
         f9Lwg74kAODtdQvYU2rGt0M1rYl0JffCJwA9YijRev1D/7yvXJlslbRyJgjAH32wwAZR
         B/b0NKEfnM/5U8v359vYnvEUV/ozCefq0OTGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IQNsqAqVViEU3XvBO/CRhKayo7Uy9hYK0KAzIytsmBA=;
        b=NPfy/EwMPLxokrYhn3W2WPyotuUswnGTdIFUy4wgMehap3NXGsLOlm9hp1JG1sxNmi
         uqUBDdZPUhWLiHsGH1up9HGwdWKS3MEijlVz6/YxFgYX0hYvY4Pa6b3fQm/NSzwhLKPj
         gWDJLtDZGDenHchVG1fTRGGNCGkULKtJEZDfCu1Da+8zX5SdZQp1ExkIZPYqQC9Li4x5
         hAh9IZuBYNbk+qywHjJ6BwsFh8KxapVL6ZLY6lCWzTvwlg8E6cU+q0gouQyfdcICw0FZ
         VM2Rz4i4eEC+RenqUdWB0pIFcw3PYKw/pf3PGE1XbEBLF59EBftKGXr3OQ/ql+PnA66F
         My6A==
X-Gm-Message-State: AOAM533V6Ap3pYYOEu5rPOSrXBVI53YKGalnGH1IA7DooA53RfJ18Bae
        R4XQkWfHHrVq6sJ/M/KBo8sYWw==
X-Google-Smtp-Source: ABdhPJypqzdGLd0A00SSS7G3WjBvbGDWJFvBCPFhTOnBO9Zy8s/HE2BF+uUxaJp1pxzcyn9aKmUXmQ==
X-Received: by 2002:a17:90b:4b09:: with SMTP id lx9mr14063965pjb.100.1637267017586;
        Thu, 18 Nov 2021 12:23:37 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm461344pfi.56.2021.11.18.12.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:23:37 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Potnuri Bharat Teja <bharat@chelsio.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl
Date:   Thu, 18 Nov 2021 12:23:35 -0800
Message-Id: <20211118202335.1285836-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2101; h=from:subject; bh=r0RjNW1nt8hO6RUISrpRK9oSUV76aQP0ukBh+E6zpXY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrZHk5MDbm9O/fZR6Lin9O4U7uvALO7jxjVNquJ+ nX+c/BGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa2RwAKCRCJcvTf3G3AJtLoD/ 0VMGNmHYtW3sXAkw7Jp68P4uEZynPoPbYo+O7pExC/ORBNQ5LW+o2sSbBuNdf6eokFzIAbbC7h7ICk NxU/WzUJAcRUTXyDDIns8RorZCTZdXlIN2s/M2qUuQ0ARja4ngwvvVkq9Rmy6v5vn5aJ1We3vTQdiU BEVvE+Shy5Drh2cwZkOCVkvnkdv1lIXgjcueAV+Ugh1qTpnCsG/ymoeMsaOxeal5Bns0kerpAMsX7N zh2/OePfy/6C0VYeL5fczA434KVY6g2kg77hxxZH5inhE1bn9+lLAHLYliAEJzsriuV5kIeCMYVmZO IV4JmFxsrB19LnGF5t3p59UjxIBweNfw3ced7MF8PI9GBkQfRGNeMipEUvhXfQcTFg/fH6n5xHgPaQ HjKQckFssw2aJWJ0/lxDWN7BkLaTHgM/WfevzpljjNmsQ13ByOIQMLrEFcRu47Wj1FppcCSA7bB5wW K8dsdcfXUmBLKnWYC9FVH8+/CQRwX5QOU9/qFTAgoCOWpso8n5tBeky/DNNMtHgLh3tQbsFz+tQLpr EVj9J07u13wziRTjKbUUDCoSigImU24zYnWqyGyIxI0PokOHwphNpTrw0jP4ertITdfff0SI7KKek5 bTPcNg4b7lj7qH54hf0m4DJLIBngP3HKk6vZ0PJ0viFDFT01pw0rcCmsoSPw==
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

