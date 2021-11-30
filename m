Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03348462D4B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhK3HHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbhK3HHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:07:16 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8637DC061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x6so82224720edr.5
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pM7Wb9OHxYU4Pb1IxUY6BrM958hr+TqWW5D8jHDE20I=;
        b=BaGFP4F06wjtZ9B5ZOBHOrn/SG5cpe9IJiioUCcy1L+E0vCWOGboLdVIcJEiHdBPvU
         jY6WHYdpQAzwRC5vxcIr2ZsJNiRKkuhCjWuxZAqfhL2FR11XtMOaHkCk8+M0cDdD1GDS
         yBrWsKNpAaFFq1hPdXwlkhQ2ReeIV6BxTaDQy12hU/1vQNBR+UUssooAlMW6EzSFBJ5v
         2OL0JO/1OGgGyrL8z4rd36UzlfdJMBnwdcCVRvCAyP8v5zUq5tlt9GfzRSW6IW0ftpOH
         vV0l9dIRd4ugzsqQ+z0ZhdhllGzhbds+Nf8jFvJfjt/0euRaQ+tzSq8Io1Dsv9gQkeqS
         J2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pM7Wb9OHxYU4Pb1IxUY6BrM958hr+TqWW5D8jHDE20I=;
        b=wfgjQe1+7cAKCWc26QO2vbfSf0OgiWpb3Q2sijLyS1fRjBmabDxAzI0l89WPj+eaVM
         UKs9dTHQQ/Owms7vQUKFLNyLDdIrYauzNE3F9Z8UOvaYr4Z+ng25xKIR7/Av+/82Bc5A
         onHtZdLGEkjmKiqnlHZ5hIcwocVyhkU+PTFNrxYockAfnYtPX3iifJT9vSBtlVL4vEtZ
         T/KtRwpcAXzyH0jrlGS7SyCNp1dQ1PumI+2ffBCRmumngugH3S3TvQtOChV00aImqUYE
         SkZ9dhPhvzXnJ6CKGNmEUBo08sjrr+fq60mSpbXQLK0icY5dZ9XEiOZ0aBtZDJP0v9id
         C+oQ==
X-Gm-Message-State: AOAM530rl0biNhH6I5DVrCC6H8Z7yCz1BMHI1zXFCVr3Zu+4Lf/K4s9D
        EZTtPuIiR7m+nM5GysvYz0Q=
X-Google-Smtp-Source: ABdhPJwTeqJL6CEzSSCWHdmavWQV6i8OoBlN5McRiPP+bOGhtYBAJ5twhPHyuJrIqS9imm+MtvL5sA==
X-Received: by 2002:a05:6402:34d1:: with SMTP id w17mr81730472edc.229.1638255836180;
        Mon, 29 Nov 2021 23:03:56 -0800 (PST)
Received: from localhost ([45.153.160.134])
        by smtp.gmail.com with ESMTPSA id oz31sm8504419ejc.35.2021.11.29.23.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:03:55 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: xfrm: drop check of pols[0] for the second time
Date:   Tue, 30 Nov 2021 00:03:12 -0700
Message-Id: <20211130070312.5494-3-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

!pols[0] is checked earlier.  If we don't return, pols[0] is always
true.  We should drop the check of pols[0] for the second time and the
binary is also smaller.

Before:
   text	   data	    bss	    dec	    hex	filename
  48395	    957	    240	  49592	   c1b8	net/xfrm/xfrm_policy.o

After:
   text	   data	    bss	    dec	    hex	filename
  48379	    957	    240	  49576	   c1a8	net/xfrm/xfrm_policy.o

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1a06585022ab..f1bf43b491dc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2680,7 +2680,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 	*num_xfrms = pols[0]->xfrm_nr;
 
 #ifdef CONFIG_XFRM_SUB_POLICY
-	if (pols[0] && pols[0]->action == XFRM_POLICY_ALLOW &&
+	if (pols[0]->action == XFRM_POLICY_ALLOW &&
 	    pols[0]->type != XFRM_POLICY_TYPE_MAIN) {
 		pols[1] = xfrm_policy_lookup_bytype(xp_net(pols[0]),
 						    XFRM_POLICY_TYPE_MAIN,
