Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C352E1DAF
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgLWPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgLWPBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 10:01:48 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583B4C0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 07:01:07 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k10so5601763wmi.3
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 07:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JrQSH2MVBIjuywB4NLeJh9r33dYCKne04P7WmhZwxJY=;
        b=ap322yUldm/X+2OOF5upgEYK2dbBe2aUKetPdgYw2I+V1ejF/iFPtnrAmwNYxWTdoy
         CABmz1UCHG4Kg0hYrVrysNCJub5Hm+pfWzHk4TXviDcoHIXltDENPRyOHkMwCe1mU5B2
         kBt4DqgvgwtmeL1s1zZh1MCEFYLpeE5ZnX+K37kBwy0/FZRGZ7wXYASDXJhMzu/Z+GSj
         OOsZEey1c5x6Sk/hgPG2J6Y7ETmkEOo94WT8sPjy8sTIxlrqIj2K/x7rtMdPFJ5C0xaI
         SuMFjeNXkEj3kGz3mkXMPbhu9sCMnN0F1DEbMNxLhk4uhlPkIV6BR/pkXzjUEk1qvJS8
         uvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JrQSH2MVBIjuywB4NLeJh9r33dYCKne04P7WmhZwxJY=;
        b=Y8K19V+OM8kNR022nIjkXkYiOedqbIb71vtFCXsAiJz2YXCCUCCbYNDcbITeFJWW8s
         IooRcqCFayGY5tCcUNVf0W9g+LJkm7Ka05iOWBTUt7E7IJUvNtjWSKubbPNjGdQrVqhD
         ag54c0wU38f7FVE+A3rnSeW9xXPLBtbh1l4sPkg82khS6jMpIdlRyUO+7uz52hAgz6TK
         xUDIpENWJ1jVlTTLAvcbF112XTHhWcjgeMqP0LG2GgekYGrehWwP5kojZKqqePRBrdor
         LIcyuckycBvLEYxQBRfzV3uUgF6xjl/T2fJWsE42mBL9JT0y3GuQ2Khg9xMkhK0+vLEE
         ln2g==
X-Gm-Message-State: AOAM530k7sEublWiACe8ZhV173hUCepZGpg94eVikt/eVShuNvkvukPL
        cnGVX3smrnJLj0A94h6pKmE=
X-Google-Smtp-Source: ABdhPJxnz6sz1KIEhQdZ2Rm8q5ZJ05oIAbGtwoYXqvkWrDAWceLLfIShm7Zded1/gMIkb1p5/Bd1NQ==
X-Received: by 2002:a1c:234d:: with SMTP id j74mr174987wmj.18.1608735665724;
        Wed, 23 Dec 2020 07:01:05 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id b127sm41709wmc.45.2020.12.23.07.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 07:01:05 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     lorenzo@google.com, benedictwong@google.com,
        netdev@vger.kernel.org, shmulik.ladkani@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec] xfrm: fix disable_xfrm sysctl when used on xfrm interfaces
Date:   Wed, 23 Dec 2020 17:00:46 +0200
Message-Id: <20201223150046.3910206-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The disable_xfrm flag signals that xfrm should not be performed during
routing towards a device before reaching device xmit.

For xfrm interfaces this is usually desired as they perform the outbound
policy lookup as part of their xmit using their if_id.

Before this change enabling this flag on xfrm interfaces prevented them
from xmitting as xfrm_lookup_with_ifid() would not perform a policy lookup
in case the original dst had the DST_NOXFRM flag.

This optimization is incorrect when the lookup is done by the xfrm
interface xmit logic.

Fix by performing policy lookup when invoked by xfrmi as if_id != 0.

Similarly it's unlikely for the 'no policy exists on net' check to yield
any performance benefits when invoked from xfrmi.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..2f84136af48a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3078,8 +3078,8 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 		xflo.flags = flags;
 
 		/* To accelerate a bit...  */
-		if ((dst_orig->flags & DST_NOXFRM) ||
-		    !net->xfrm.policy_count[XFRM_POLICY_OUT])
+		if (!if_id && ((dst_orig->flags & DST_NOXFRM) ||
+			       !net->xfrm.policy_count[XFRM_POLICY_OUT]))
 			goto nopol;
 
 		xdst = xfrm_bundle_lookup(net, fl, family, dir, &xflo, if_id);
-- 
2.25.1

