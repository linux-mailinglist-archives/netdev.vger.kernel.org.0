Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB59493187
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350318AbiASAAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350316AbiASAAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:00:30 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA836C06173F
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:29 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k189-20020a25c6c6000000b0061274ece35eso1293692ybf.22
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=j1wymuyNneDLxC4G3Kq+FWd7ly86xgZeoDXyGQTSt8Q=;
        b=Gnn0ljfk3mj6cM033ZeXeBMFxJsOHoRejtOJI26MpGkp1YeiX7CZXQe3kHELNbTXC0
         GU7DWluMxjmg//3xy9rOz8edpEF8XY5qaI4DRDy+AkcHF9Wuq5hL616YacUSEI9jBEZe
         H57wkkkXbuBiAIxM8QMgXozaMRssjv/eBL6fz0Jy5SNLkpUF+DmtQu8cXXvKMOTd/xrc
         tJ08hXjht+QVASFZsnzLVNWWZB9ZQep2G7FmjwbHfxEVwJqBvFLAOsOQJgG4PrvkP5Cc
         PiGvcDwRVjD/lfAb/VKNh1sB++mgIaObscyXIErdGawC/zdQFzzuWysoaeLK37izVbcN
         9AMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j1wymuyNneDLxC4G3Kq+FWd7ly86xgZeoDXyGQTSt8Q=;
        b=JkV3xizSuujvRvgVp8j7DA78O8uS4atpTze//unV4rrYXDNW4ChEwr+1suMk47v68t
         9evZY6aJ3TE6UBMQdijOI0AAqHJGk7DtgVjgA9R490KyL6w4pvY0uKpSEX8WUzX0A94W
         L0tFO60pfSAVe6sy1G850e6zmzUb2rqmvcrrlBOTmoAD83BgGFqAY16/6RJI4EpetVZs
         2UxHZa2gJxnpMBNHDIbx7K/G4K19VDyk8RvD6mY81u39eYlkKHc/6PIwjvHAnAr4e7Jp
         FBgqnTWd0x4sEF471PaGnbNb5xYeOJLeYsn5njQb3o3dVXkUfO14VhJaCEYfjlPtG2/X
         Ss3w==
X-Gm-Message-State: AOAM531egvQhuxI6lv0un+fYJDiEGRuSZQ1eVB4NuQDWyU5J/cfTbhAc
        K2uSGFbsyJungtRH4QU7rIYoxFiHH3TITA==
X-Google-Smtp-Source: ABdhPJyi0yKIBstfUGQMpxit+Pl4jiBxrHvRrcVlxIGVy0uS4fTSJD+TIl5cYcXbkvBph/iLUGr7W8vK659CbA==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:543f:65f4:6992:2c5a])
 (user=evitayan job=sendgmr) by 2002:a25:145:: with SMTP id
 66mr21313125ybb.234.1642550429238; Tue, 18 Jan 2022 16:00:29 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:00:14 -0800
In-Reply-To: <20220119000014.1745223-1-evitayan@google.com>
Message-Id: <20220119000014.1745223-3-evitayan@google.com>
Mime-Version: 1.0
References: <20220119000014.1745223-1-evitayan@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 2/2] xfrm: Fix xfrm migrate issues when address family changes
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@google.com, benedictwong@google.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_migrate cannot handle address family change of an xfrm_state.
The symptons are the xfrm_state will be migrated to a wrong address,
and sending as well as receiving packets wil be broken.

This commit fixes it by breaking the original xfrm_state_clone
method into two steps so as to update the props.family before
running xfrm_init_state. As the result, xfrm_state's inner mode,
outer mode, type and IP header length in xfrm_state_migrate can
be updated with the new address family.

Tested with additions to Android's kernel unit test suite:
https://android-review.googlesource.com/c/kernel/tests/+/1885354

Signed-off-by: Yan Yan <evitayan@google.com>

---
V1->V2:
- Moved xfrm_init_state() out of xfrm_state_clone()
and called it after updating the address family
---
 net/xfrm/xfrm_state.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b0eeb0aef493..1ba6fbfe8cdb 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1579,9 +1579,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1668,6 +1665,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+
+	if (xfrm_init_state(xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
-- 
2.34.1.703.g22d0c6ccf7-goog

