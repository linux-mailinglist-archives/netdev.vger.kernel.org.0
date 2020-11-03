Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2618B2A3AC1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgKCDAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgKCDAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 22:00:15 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F2AC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 19:00:15 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 133so12937637pfx.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 19:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rKuA1J0fQFngMY8QOoEjFYIDNgu7oy9UWPcZS97DD/k=;
        b=Ba54/j0jz9YQdURJor5UulnaCZGvYCuEVcmZgdy7PQJwRk7PwG3L7LZOqE7fKHLuOO
         BwoghN2SEjC2tlLUOgVgA3tt8JgrIOcEgPT9T9lWkVSn2GeFtGi23GJlSFaUCjRMB1Pi
         1O/PzyTRPLL5Ff1NPqzdNR8V8m2ZmXK19CY4h4mCK96aE9ineICxbmYZDPYwC4Y1f9R7
         GnSUlfgGftYAK8HNuiEmEVEQaYFjkGAiRjVDWM56xX5WaxH8AC5Xch0wwT+eEokc6QUv
         S3g3RG78lpmQx/Q8lsyqRw2ao5zsuiy7SJvKB9IO2TlDxdPD0UoaBQ78Q2t2KLuwXYFU
         RZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rKuA1J0fQFngMY8QOoEjFYIDNgu7oy9UWPcZS97DD/k=;
        b=BHI9JMcTXGxHc5z8XriN8fh96MYwd9kWtlpkFPEvnuua6K7GKHa1kiOWhjggTBBOwP
         U0m0S6IypVr2vkuywSrhXjLrxo2lcqsGfYMjZgH3ok9fposfxxW48UC2CEdPokR8SouM
         bGro5W7v7m7ps/xzEDru6Rw8LBFKKeklgl97kAb+y9jtt4FtSp2Uf56Dx7o0BTBRWJGO
         oYIvhEYcnjPPTiTXJj5Aq98Yngr8bibGe8yg8nf6XCUC93bDeCfnuwuZ5fsKGBj4Okqv
         3hie0cuSndbnzSDjQRZ49Z+crQYeEDzhauo609EwHe2qvykI1tmvwvtt//qonYvDiIxF
         3hYw==
X-Gm-Message-State: AOAM532TNbCMT9rcTT5ydOeKOrUzghHi2YoXc/i22d6mnibFLbIWElL7
        BiykhrRZLxa9TSWBtS6wSKV6pM8Pz1K6CQ==
X-Google-Smtp-Source: ABdhPJx3NF45fWltYMSCFIq3F38Qi46AF5RBfJrAqBnhehV+yjWpr7UBua2GRhLYW5f5YLKypclLJw==
X-Received: by 2002:a17:90a:2e07:: with SMTP id q7mr1407782pjd.103.1604372414672;
        Mon, 02 Nov 2020 19:00:14 -0800 (PST)
Received: from localhost.localdomain ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id f4sm852851pjo.54.2020.11.02.19.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 19:00:13 -0800 (PST)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Subject: [PATCH ipsec] xfrm: Pass template address family to xfrm_state_look_at
Date:   Mon,  2 Nov 2020 18:32:19 -0800
Message-Id: <20201103023217.27685-1-ajderossi@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a regression where valid selectors are incorrectly skipped
when xfrm_state_find is called with a non-matching address family (e.g.
when using IPv6-in-IPv4 ESP in transport mode).

The state's address family is matched against the template's family
(encap_family) in xfrm_state_find before checking the selector in
xfrm_state_look_at.  The template's family should also be used for
selector matching, otherwise valid selectors may be skipped.

Fixes: e94ee171349d ("xfrm: Use correct address family in xfrm_state_find")
Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 net/xfrm/xfrm_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ee6ac32bb06d..065f1bd8479a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1075,7 +1075,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, family,
+			xfrm_state_look_at(pol, x, fl, encap_family,
 					   &best, &acquire_in_progress, &error);
 	}
 	if (best || acquire_in_progress)
@@ -1092,7 +1092,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->mode == x->props.mode &&
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
-			xfrm_state_look_at(pol, x, fl, family,
+			xfrm_state_look_at(pol, x, fl, encap_family,
 					   &best, &acquire_in_progress, &error);
 	}
 
-- 
2.26.2

