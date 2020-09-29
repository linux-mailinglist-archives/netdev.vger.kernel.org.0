Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A3027C3A0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgI2LHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgI2LGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A377E21D7D;
        Tue, 29 Sep 2020 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377611;
        bh=IU6ZR18VAbdvVKXPApeLcq2M46/qop60Mav5MIT49AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPV+9hBLZ8RkQ5+2PnVT6pWegaMpaGL/dBRh7zauhtBU2xT2Hob1cOC9Lh+Vsn6cy
         ealr4qilNmk7mH1fLUcppPHqdjd+9PffGCPK6/TpMN6y2kcnnU5imUmZQEcFrLVugp
         xXuKQpmHUW1GVpTjFE53LIO369SmRMnv7zVd/CT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Salyzyn <salyzyn@android.com>,
        netdev@vger.kernel.org, kernel-team@android.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 001/121] af_key: pfkey_dump needs parameter validation
Date:   Tue, 29 Sep 2020 12:59:05 +0200
Message-Id: <20200929105930.251873166@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Salyzyn <salyzyn@android.com>

commit 37bd22420f856fcd976989f1d4f1f7ad28e1fcac upstream.

In pfkey_dump() dplen and splen can both be specified to access the
xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
when it calls addr_match() with the indexes.  Return EINVAL if either
are out of range.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/key/af_key.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1873,6 +1873,13 @@ static int pfkey_dump(struct sock *sk, s
 	if (ext_hdrs[SADB_X_EXT_FILTER - 1]) {
 		struct sadb_x_filter *xfilter = ext_hdrs[SADB_X_EXT_FILTER - 1];
 
+		if ((xfilter->sadb_x_filter_splen >=
+			(sizeof(xfrm_address_t) << 3)) ||
+		    (xfilter->sadb_x_filter_dplen >=
+			(sizeof(xfrm_address_t) << 3))) {
+			mutex_unlock(&pfk->dump_lock);
+			return -EINVAL;
+		}
 		filter = kmalloc(sizeof(*filter), GFP_KERNEL);
 		if (filter == NULL) {
 			mutex_unlock(&pfk->dump_lock);


