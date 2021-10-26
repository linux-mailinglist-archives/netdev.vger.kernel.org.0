Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A820B43B9B3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhJZSjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbhJZSjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 14:39:47 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B401FC061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 11:37:23 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso21150531otl.4
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 11:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forshee.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MMIv9yBqWj19F4j9cz8FHqbcowS96PYR2dCRyNDqEdI=;
        b=OYBybNm/Ypa0I7EEA43Ixtr/lHebvrHBDN/dN2bgf8EyZg/oyr9axB48J3sOppBGVe
         qcF6J6Ym67B6Be8/WFccUxJ1vujQSLx/fwxLJlDowuejuvQaA1niTtcRfx6mOnE2V+bM
         USL9BvsTdoXPxsfmt3gf9f/V7j3V2dBvDkztw7anZfio7IOX7l2i9iJj+/phR4+PWDtc
         exQVbeNben6UJQTazGXxaHPklgwtOXbPH1zZqNWjT8sCmuqcOQZThQy9Q0iK8cJYK/YZ
         86Fnsl6N3fr93kiLtknAh5sbFRKSt8Wp1fAapC6eNgHC1imvQ7fNoquZxPpwWe6t2lQZ
         UrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMIv9yBqWj19F4j9cz8FHqbcowS96PYR2dCRyNDqEdI=;
        b=tmDX7xO48L/BGfWbYUZsUbVWSecC05sDS+MptxMBpoDpPWJYEk+o3fXbTz+fpG9peF
         Rlb7ddOovqGG4T37v18ZoFyuszP/jKYC9F3cyDF9vRhDLJJlQdqr6m1+lSFHQRaJWI7D
         571kbk0l01RuAB+guK1+COFWW8scY9Fwa3Ug4KlPIsEOhiIZ1sNAvsBSPmJ3thjb8xj6
         dBRLwX48pG+IZwdNAam8uRU7ZQtv8gv6EYMPC4wbA6njU/CK6ofLKO0LyL6sY8cH4EU3
         lX8B/6nYio/XXzkNEVQAvxyLFc8/X22TDkAIlFPA832r9fJH3wOtNVgThho7PYURSlDP
         aEnA==
X-Gm-Message-State: AOAM533SMcYpUaWnkCOn0T2jQ6fGK2rxISOpbahDzZt6oqXu7myAzhv4
        DDOV+FFTOwO4LLGBXPbjEd5CHA==
X-Google-Smtp-Source: ABdhPJw1kW+ORDSncXkNIkFOkxu06ErFATerWIpMGCr4CCzzU1jUcOdETKP/1dIT979TsrY/+XFowg==
X-Received: by 2002:a9d:5548:: with SMTP id h8mr8584427oti.241.1635273443100;
        Tue, 26 Oct 2021 11:37:23 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:fca3:95d3:b064:21ae])
        by smtp.gmail.com with ESMTPSA id l24sm4032727oop.4.2021.10.26.11.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 11:37:22 -0700 (PDT)
From:   Seth Forshee <seth@forshee.me>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/1] net: sch: simplify condtion for selecting mini_Qdisc_pair buffer
Date:   Tue, 26 Oct 2021 13:37:21 -0500
Message-Id: <20211026183721.137930-1-seth@forshee.me>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211026130700.121189-1-seth@forshee.me>
References: <20211026130700.121189-1-seth@forshee.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seth Forshee <sforshee@digitalocean.com>

The only valid values for a miniq pointer are NULL or a pointer to
miniq1 or miniq2, so testing for miniq_old != &miniq1 is functionally
equivalent to testing that it is NULL or equal to &miniq2.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 24899efc51be..3b0f62095803 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1500,7 +1500,7 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 	if (!tp_head) {
 		RCU_INIT_POINTER(*miniqp->p_miniq, NULL);
 	} else {
-		miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
+		miniq = miniq_old != &miniqp->miniq1 ?
 			&miniqp->miniq1 : &miniqp->miniq2;
 
 		/* We need to make sure that readers won't see the miniq
-- 
2.30.2

