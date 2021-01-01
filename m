Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C722E85EB
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 00:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbhAAX1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 18:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbhAAX1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 18:27:13 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B24EC061573
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 15:26:32 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4D71PH6W93zQl8w;
        Sat,  2 Jan 2021 00:26:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609543583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+SSA/tKLAZNuX9m+VmZebTLJbN8oqxxPR7RpqfiePDc=;
        b=MTg9cbE9d54LKGCsZZfozJcCwd1lr4d3TVDeif7Smr/o63c2ZBF3tHHnxYpxxCileB2Cl9
        WPS1/RGses8O82OB1Rd+bQYIMgPta5w28Og6WUBW5Sv5TlP4wTBnYVFlm1JtG4d4n6L8cL
        7Xy1Xve0/hCW3KryrkpClTHsLfAqtxzgpI1XGEkBtCfJv1yfM4VSoDlv2rHNHO0uQl2ZjO
        Opwyt1jvl64IMH/RpXt1mFaBTn9AfhTnTVksFcKRT89I7BaRGLIkEAuRvUJt1gvDqHEiLm
        aOx6ItoXf4A+oV3apPEMijUAchE29LEmKC4T8x/DxAAZvk+qYbiZ8jVvcjuUoA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id OVhJfDYUzPqn; Sat,  2 Jan 2021 00:26:23 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 2/3] dcb: Plug a leaking DCB socket buffer
Date:   Sat,  2 Jan 2021 00:25:51 +0100
Message-Id: <664c9ab05595c821f2295fbebc982f82c3e0d884.1609543363.git.me@pmachata.org>
In-Reply-To: <cover.1609543363.git.me@pmachata.org>
References: <cover.1609543363.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: AF92017DD
X-Rspamd-UID: d391cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCB socket buffer is allocated in dcb_init(), but never freed(). Free it
in dcb_fini().

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index f5c62790e27e..0e3c87484f2a 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -38,6 +38,7 @@ static void dcb_fini(struct dcb *dcb)
 {
 	delete_json_obj_plain();
 	mnl_socket_close(dcb->nl);
+	free(dcb->buf);
 }
 
 static struct dcb *dcb_alloc(void)
-- 
2.26.2

