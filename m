Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E39264E91
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgIJTT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgIJTSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:18:49 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D0C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:18:49 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z2so5743087qtv.12
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZQMFJCPsuLKWJGu7YJd+2eHAavCNLtJCmyONTA04vw=;
        b=X81Pou8f3n8MyLxKV7/kTqgGOYqArIlb58D1088jv+G9mpycRBYMp+SITUy27Nzq8V
         0Az7ni9d+Rla5ojZMFCxvcUx+rneiOf+oxRzFOmJEBAU0BhechQhffH70cTMRA/5MFW4
         e69O2yaz+yfrEhPIqcCt67WFmcvG8CNPhTyJnbG4gkFRUZGB2E6bVsCAfIgEscw2FVz5
         2/t0lOZrjpLj6jAY86I1tjZP35P+JtPmWtrkmsYIDLiouovv2cz2PJg1P1H1b7G18RVR
         Uv3na+OYNTwTIXcGfXRRQvGOrwLD4gjQlFx6kPIBgxKxLQGus6FFDt8Z3YFTuhxotVSn
         Ot6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZQMFJCPsuLKWJGu7YJd+2eHAavCNLtJCmyONTA04vw=;
        b=l7CkIU0BbiNhpsbCcFVsgwmX3xcTUyxbzDYZNCC0n3X0bzelpiueaqPDhhmQpytxz5
         Wo12U7wC+ke4uwdI08pL2bMoVGmlWU4Qvh9gOvwwd3/weaam/kMa/NaEVIjlAIZYBJcH
         l0aVjAJ0ZQqBAsEbr/SUtnr11sPuAmLdTXN2mFwPa6SX6XlzpXOuiV6gl5h0Yu1bSBSv
         KDFTRfWuD7FDhRdwwlT+co0N+gXte/ZK3ttvwRHWjYuYSgpvQ4COXS9iHCryUe3QPMzX
         wPrArJK8xwpONoIrjMQc5G2ZtrRj9/By9arIBDrt2dx8RgU9ycdgUSNSp4v41C3Ye/ei
         BM3Q==
X-Gm-Message-State: AOAM532+Tsbu/j+qzF6xSZzgB2u+Oi7nPo70sV/lbH1pc1NT9S6lbSqD
        WIRHytNC1LN6lTXceUeZxu0=
X-Google-Smtp-Source: ABdhPJy9E8T93UvBqU072ZTOj6injpniPGhjvIxoSyzoW7OLolARSU81ke1/U0iXixPukm7qQ3cVzA==
X-Received: by 2002:aed:36aa:: with SMTP id f39mr9857223qtb.297.1599765528351;
        Thu, 10 Sep 2020 12:18:48 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id g131sm7089086qkb.135.2020.09.10.12.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:18:47 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Subject: [PATCH bpf-next v2 5/5] tcp: simplify tcp_set_congestion_control() load=false case
Date:   Thu, 10 Sep 2020 15:18:47 -0400
Message-Id: <20200910191847.2871574-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Simplify tcp_set_congestion_control() by removing the initialization
code path for the !load case.

There are only two call sites for tcp_set_congestion_control(). The
EBPF call site is the only one that passes load=false; it also passes
cap_net_admin=true. Because of that, the exact same behavior can be
achieved by removing the special if (!load) branch of the logic. Both
before and after this commit, the EBPF case will call
bpf_try_module_get(), and if that succeeds then call
tcp_reinit_congestion_control() or if that fails then return EBUSY.

Note that this returns the logic to a structure very similar to the
structure before:
  commit 91b5b21c7c16 ("bpf: Add support for changing congestion control")
except that the CAP_NET_ADMIN status is passed in as a function
argument.

This clean-up was suggested by Martin KaFai Lau.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Kevin Yang <yyd@google.com>
---
 net/ipv4/tcp_cong.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index a9b0fb52a1ec..db47ac24d057 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -362,21 +362,14 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 		goto out;
 	}
 
-	if (!ca) {
+	if (!ca)
 		err = -ENOENT;
-	} else if (!load) {
-		if (bpf_try_module_get(ca, ca->owner)) {
-			tcp_reinit_congestion_control(sk, ca);
-		} else {
-			err = -EBUSY;
-		}
-	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin)) {
+	else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin))
 		err = -EPERM;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
+	else if (!bpf_try_module_get(ca, ca->owner))
 		err = -EBUSY;
-	} else {
+	else
 		tcp_reinit_congestion_control(sk, ca);
-	}
  out:
 	rcu_read_unlock();
 	return err;
-- 
2.28.0.526.ge36021eeef-goog

