Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0DB60284A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJRJZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJRJZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:25:38 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFF62F0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:25:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i6so13231782pli.12
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MUGpXXu/YLX6vB16EEikz0mUodhAtO8kh4qarh/vsQ=;
        b=JtNmvf1ubSjiH1NO0qolmx2k/7lVy3Sznt8a8J8fM31erknTm2/E4tqjoxnBJwLEUi
         f3Ub/BNwRaIM6jgFHsYdDtJ86QHx2fNnwdn55tyNvD6wbcQXSG9/JRY/lQnc85sRdv8Z
         Ea4kYzXelL/Wlo0P6SmcA4mO/+bqaZgW1FYXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MUGpXXu/YLX6vB16EEikz0mUodhAtO8kh4qarh/vsQ=;
        b=D7acgN3Oi1ZaF9W7A3otFLUy9TBvjJeo8iiNOaWeYRucWLK9KNBpkgsHza9fafvmdh
         xZiFGrBQt8kYQ6YOXQngKQtGOm+8OrNXecSN2iKivZUcceE46rLNWDmZhvgkgm4J0LxP
         JKfMLd+iIfwGaERM7/X/xaIem4xQ4QgJexf3Eo0Vn8gf6ATw1IuiOncoVD8rk1CQ74pP
         ktwCXqRJSRkZT49lvyMAqXIr7TPfZ07p/8Xy5EuOE0XCiNzEaymV5M8ODNqSeE3TBRR+
         XrNpW7jbExq+DgXcor9/HoBHb4lxDXCiD/7CnyYgCwjK1oo+apz+kVqqDgvI1Lvy2YuT
         Uf0g==
X-Gm-Message-State: ACrzQf0MLLUf4vJfAjuFZsWBDiVZGnV3+EYEw5INGoaVMpWR8EEqV4/E
        h0ZsaK96e4Rvo/yJJ262l98ZJQ==
X-Google-Smtp-Source: AMsMyM5fHoJkZ04COrIOtFCeb2dhusZr7vVpO96gDwpJ6y8MRdxE8qYSAnuq4a+oCbS8YJhDc9xMOw==
X-Received: by 2002:a17:90b:350d:b0:20d:5438:f594 with SMTP id ls13-20020a17090b350d00b0020d5438f594mr38870290pjb.216.1666085128750;
        Tue, 18 Oct 2022 02:25:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o125-20020a62cd83000000b00561c179e17dsm8694847pfg.76.2022.10.18.02.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:25:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ruhl@www.outflux.net, Michael J <michael.j.ruhl@intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v3 1/2] igb: Do not free q_vector unless new one was allocated
Date:   Tue, 18 Oct 2022 02:25:24 -0700
Message-Id: <20221018092526.4035344-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018092340.never.556-kees@kernel.org>
References: <20221018092340.never.556-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1396; h=from:subject; bh=R8ylvO6BqWbNVREdX/u1o3d4rMnlPe7DgQcXRdLK/uk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTnEFGT/npSNQmG6Pg/wQsD1SJfFxPxu2rbyaqXID oCQB78+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05xBQAKCRCJcvTf3G3AJi7vD/ 96KK47LIncnqzTUMut5a5skw4vihz4xnknY7/ue9t+x9mLj8qHg68Bwhsj1s6Ei3FnMALk3w768VYs SWUJUKa88nfLmMsRyuuiv/GTuK+tV2alLC3zKeeLtuPkJZIpyoNJwHOvRCJK8iOk6/dHj5XBXtOOr1 WEv8l8xFabrpKP3Pmf3DxpM4T3Fp/rmj8cCa8rnX6wvcH0nQwL5Jhtp7ZZ2wB9VuSRi1wg63+on06o HYBlb23VbUFT1uO4xKE0RlsmQlP/4y9JJmgScoRQkr1eQoIbL4uR4tX3ke8KTzviQUllgpIcN/HKHO 3EDeF9pKlGLcenyNmM9RDXH0dW1bLrNiAJ5f6yaaVWLx8MAooB4nY6dVUi9WiF2DJuZuEQenqPtlB6 StgzPvNXcrHnuhXvMO2GcNYO6VSfxhypAGYmHZKw6IQXOCzYF6yjVQW7Yji1kcmn1rk+aAC7rAetO5 NkxrAUM6cASntDrRuZK7kTOeOTuoHu8xS0XJttoDEy9dSJlLHNkMw7xIvR5ydp2oUpVfsCDGqKzyWm fhbrVNLgZtECKGDo1+eaDPoDYIskAVsjWf5kTjfLVOd+UrVNXtm9Kj4lolcvXjs38jYkx0OPzUy7mE x2lTxueP8LPPu50EdJIIy8Xy1olop7KKBYCeVB9wDl0PgbIz8gffRV7gFaUQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid potential use-after-free condition under memory pressure. If the
kzalloc() fails, q_vector will be freed but left in the original
adapter->q_vector[v_idx] array position.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f8e32833226c..6256855d0f62 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 	if (!q_vector) {
 		q_vector = kzalloc(size, GFP_KERNEL);
 	} else if (size > ksize(q_vector)) {
-		kfree_rcu(q_vector, rcu);
-		q_vector = kzalloc(size, GFP_KERNEL);
+		struct igb_q_vector *new_q_vector;
+
+		new_q_vector = kzalloc(size, GFP_KERNEL);
+		if (new_q_vector)
+			kfree_rcu(q_vector, rcu);
+		q_vector = new_q_vector;
 	} else {
 		memset(q_vector, 0, size);
 	}
-- 
2.34.1

