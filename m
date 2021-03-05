Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB84032E358
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 09:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhCEIHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 03:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhCEIHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 03:07:39 -0500
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Mar 2021 00:07:38 PST
Received: from forward100o.mail.yandex.net (forward100o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2123C061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 00:07:38 -0800 (PST)
Received: from myt6-de4b83149afa.qloud-c.yandex.net (myt6-de4b83149afa.qloud-c.yandex.net [IPv6:2a02:6b8:c12:401e:0:640:de4b:8314])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id 9E1C54AC30D0;
        Fri,  5 Mar 2021 11:05:55 +0300 (MSK)
Received: from myt5-ca5ec8faf378.qloud-c.yandex.net (myt5-ca5ec8faf378.qloud-c.yandex.net [2a02:6b8:c12:2514:0:640:ca5e:c8fa])
        by myt6-de4b83149afa.qloud-c.yandex.net (mxback/Yandex) with ESMTP id rMTlpl49ET-5tHS1pR0;
        Fri, 05 Mar 2021 11:05:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1614931555;
        bh=rnfl6AI5bEmxaZZVWj+EEwQpJ+T1unrBHAWdm/Ymb9g=;
        h=Cc:To:From:Subject:Message-ID:Date;
        b=p14fcp6P2rJwgKpQvq6+TM12U9G7eJsI1Aod4qkBBhGz/XCRFWKMCEknvgG5a6uPH
         FDwATwt/OtuRQf5LoZ0P9LXmBvNVBmogIkavmHAoaqZwuYCKf2Ke8oGh/FXyj1Db0A
         4ys8KaNB957b246DDBGDkXsoqv3DHVztvH5akhaU=
Authentication-Results: myt6-de4b83149afa.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-ca5ec8faf378.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ZbnJKQx60t-5sJuaweI;
        Fri, 05 Mar 2021 11:05:54 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Message-ID: <962223cc9f1cd71814c66f563e35f53cc220f5ce.camel@yandex.ru>
Subject: [PATCH v2] CIPSO: Fix unaligned memory access in cipso_v4_gentag_hdr
From:   Sergey Nazarov <s-nazarov@yandex.ru>
To:     linux-security-module@vger.kernel.org
Cc:     paul@paul-moore.com, davem@davemloft.net, netdev@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 05 Mar 2021 11:05:54 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to use put_unaligned when writing 32-bit DOI value
in cipso_v4_gentag_hdr to avoid unaligned memory access.

v2: unneeded type cast removed as Ondrej Mosnacek suggested.

Signed-off-by: Sergey Nazarov <s-nazarov@yandex.ru>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 471d33a..6e59902 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1162,7 +1162,7 @@ static void cipso_v4_gentag_hdr(const struct
cipso_v4_doi *doi_def,
 {
 	buf[0] = IPOPT_CIPSO;
 	buf[1] = CIPSO_V4_HDR_LEN + len;
-	*(__be32 *)&buf[2] = htonl(doi_def->doi);
+	put_unaligned_be32(doi_def->doi, &buf[2]);
 }
 
 /**
-- 
1.8.3.1


