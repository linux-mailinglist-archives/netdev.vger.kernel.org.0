Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CAC2E8BD0
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhACK6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhACK6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 05:58:41 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA89EC0613CF
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 02:58:00 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D7whl413ZzQlXh;
        Sun,  3 Jan 2021 11:57:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609671477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9SktLxIy72Xj3cfHbRAEn6bCA7hGfch0KKoYjD3irDo=;
        b=lk1kSef7SfHFGJrGxBPvhzhy69Pci97tUna3qsFUbp3T7dhSJDp6W+LAqkyXgthrkU4j9x
        pIzJEDUB/1Ofg4sTagkrajBQk4RPhsY+ZqNqvq9ScibY7w/lVJONyjXMezRL4i5wpqkgmw
        es7/xAMJhPCEWH1o38166+5noCjTajpzehKUL83GLt/57MTNGTS2zr1S7AVgX0Bd1R8siX
        1KwrmwNaZOB/DuM6fK8yCqaDkyMsSbhkMzwo8j85s5Dwc0hJQRSvMc/W2qv6nYYfLDkMHI
        bcuePKdnax/k3zGjwJD+5tYiipza4IcQg6+qObUFkRSTPAlQJmFlLpKTWf1ZVA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id p3EXHhXI1jaW; Sun,  3 Jan 2021 11:57:56 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 v2 2/3] dcb: Plug a leaking DCB socket buffer
Date:   Sun,  3 Jan 2021 11:57:23 +0100
Message-Id: <b72e89d917297a254a7a4fd79a64db20faf9e08f.1609671168.git.me@pmachata.org>
In-Reply-To: <cover.1609671168.git.me@pmachata.org>
References: <cover.1609671168.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.32 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9AFB11859
X-Rspamd-UID: 9149e1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCB socket buffer is allocated in dcb_init(), but never freed(). Free it
in dcb_fini().

Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")
Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - Add Fixes: tag.

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

