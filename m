Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4192E2067
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgLWS1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:04 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2153EC0617A6
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:24 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4D1M9B4zJ7zQlQd;
        Wed, 23 Dec 2020 19:26:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhd79ovJMPfGuj/KQbltwWnwT4dn+aDlV4OxIxy1DFo=;
        b=ZPb4Gpuo/20k3PaIJuALfwI06JcvPI0YYSjNOk2EXNhnKFNimaWgipyT+Xn+kzWFzNdHTe
        2K2JshDtu8SDJuoc7ckb0N4X5fOgD1gj0Y4kfWtrbmdWwSxB9j0RV3agETNeiNjTdNkf4m
        ambTfa1D5ZTHHVn56ZjnEsOQc2Y0cIDq+l3vYtUunAdNYPHgommt736M4so1zWfZm+g2le
        RvVgIE0jJ2NOfypy48Im++FWdI2PB42l96lUf+YETVJPpBmH9bkwx33Z5J8u8uRftfHd4h
        NFrvBlKWLpW/NKANX3uh6ajLTzjmiVHzxOjkPq6pWSF43l1d/iSMGWR3Xk4IOg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id plGMWGk9xHhK; Wed, 23 Dec 2020 19:26:16 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 2/9] dcb: Plug a leaking DCB socket buffer
Date:   Wed, 23 Dec 2020 19:25:40 +0100
Message-Id: <d7c46872da43b9e7bd04b7d4fef6e0b6fd339014.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.01 / 15.00 / 15.00
X-Rspamd-Queue-Id: B304817F1
X-Rspamd-UID: 302a61
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
2.25.1

