Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31C23EFC06
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhHRGSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238800AbhHRGQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:16:29 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38499C03326D
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 7so1078077pfl.10
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hsGHodQW7BgMepqmaGaetFXuKMTT3ZW1whu3YzYCf8E=;
        b=chkB2Egl3g4Hj/WoopucGSp8JEGrZQBb17iw+f5FZVJ88kmKbQgr9VmudEIjafNmTE
         FU+5/DnwuxN2T0PQuBqDKLSVlxbWgQNmuDbo93m2QOjwn8S/Nmj1KRmXQbdeWCM95LZY
         12niQpi/k6iQ3pEmgTEwMOYCV0dGWkKcHe2PI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hsGHodQW7BgMepqmaGaetFXuKMTT3ZW1whu3YzYCf8E=;
        b=fl55qFOnNC4ox9bZUXHTWOz4Y0UteGOdRzYziGMPDtmW0xGuWg0o4WvLda6DDvye8O
         fyKqfskoTfOHgEZzZF6demV8vobVTRrJE1vsFOdKHEBMyH2d0RufzS0WVTrQGMVKzwSa
         CgkWx9/9AF8z9qTpm5dXmrKb1P6D/y6/UmVtMN/3QDtbw2arzt5UzdxYUPXOKclybjeE
         SAqSHqsTOrbGsJ9oOgVtSHfsNktU2UPXGrMWsoUIUr/klEzwDQYJeJwwSNSfV/wSnxBP
         TLfsl7V9mIbtB1UhDGD6VXBzyTSioRPfzpMpJS0Hc8Oi9Yi67zWUuAHXP3x8LgRcrIeB
         DOzA==
X-Gm-Message-State: AOAM530fkdBVIMSCA5aixrXdeSChBuQ0AkkTdZLOAw7e3WAdx7jCdAsk
        CV+uC4ZIO63C1Hpo0JmFN0iGPQ==
X-Google-Smtp-Source: ABdhPJzyxDStzvV0SEJOZX6pzOD1ZhMBNkc4S43QSApxA2j4lcyMvoA5D5UGsMDwrMeS2qx+i1yP6w==
X-Received: by 2002:a63:5902:: with SMTP id n2mr7166965pgb.305.1629267262822;
        Tue, 17 Aug 2021 23:14:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q26sm4699734pff.174.2021.08.17.23.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:21 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 48/63] IB/mthca: Use memset_startat() for clearing mpt_entry
Date:   Tue, 17 Aug 2021 23:05:18 -0700
Message-Id: <20210818060533.3569517-49-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; h=from:subject; bh=6zw6bd38jtlUGiQNcgA+7Vj02RWEpIKH1rjaE20U52M=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMoltYN7PTWawkHd68VShtA89JYpvOPT9nwsL7B vMD1Gn+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKAAKCRCJcvTf3G3AJgWLEA CA0G8Um7L9QM3tAuk76gzDtGgj6wfZwbHC3gmdPYC4fe5ViwFuFPhPDIlMHnL5Oaft4DZAwvc4TUnI oTxi1AdRfYTfE3lw4LW1em7VDzoYiVdw68YpBJ6do2fEl9ZGK/0mX3zcOafcrAhiHBuet2CjOfPy6t Tq/8ys2f8EU1h6DXTZ5tCPSIi63+7bfI5g0u1GpcBNVQxt4gUaxR4O//oIO5lDG9qKBGuDeUG4v6MF sHcWe6CfAarnlC0ya+ORhjNk8xnbf+b/imo8zl4s0q9DrLXdZ7MNrxO3aI+5yaF2he2ea/hR5kliNG YKO8GWAbKimKYTi8SSFhhsLXFP/6Cks+GGfoihg9Z61PjIiHMhORoWY/P5pTQd90wKeXB9yySfHyeZ isD2ZFnlRhy403y1grxuLe0zaAw5SJXbwyy8thi3DDo7KeX4P92gmWueLuIvjcNP5Kj+GbCcV6vLSm nxByMIRVJuZ4ixj94olxP7vKtNZVvUPh4Ov/qwOFpG7f9rOHf1gXBcckiuBMeL+pZcSr/txM5+0jYN bYjM3KyxyB1TZMYtX1+WjrDISwqn5Gx8m/HAuDxJZ1l4CvotvblNbCStzkY4CxA2N1gZ+rSUQBe+yU YuRbJ6v7hrWUPvepMgl5M8bAqRbVyqW4hTUVa18TP98a9UAYJi8u4E2DpSiQ==
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
of zeroing through the end of the struct.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/mthca/mthca_mr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index ce0e0867e488..1208e92ca3d3 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -469,8 +469,7 @@ int mthca_mr_alloc(struct mthca_dev *dev, u32 pd, int buffer_size_shift,
 	mpt_entry->start     = cpu_to_be64(iova);
 	mpt_entry->length    = cpu_to_be64(total_size);
 
-	memset(&mpt_entry->lkey, 0,
-	       sizeof *mpt_entry - offsetof(struct mthca_mpt_entry, lkey));
+	memset_startat(mpt_entry, 0, lkey);
 
 	if (mr->mtt)
 		mpt_entry->mtt_seg =
-- 
2.30.2

