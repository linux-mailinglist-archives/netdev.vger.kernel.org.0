Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D896B278833
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgIYMxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgIYMxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80BFA2072E;
        Fri, 25 Sep 2020 12:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038414;
        bh=M+RP/klM8mJ/hXyQDk2kbS5oj9shWR1CNkMe/84/Klk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7U3B6GETcg56nzY1mgy1BZwKsJtKVTdPFkmaNRwlZJCi/23YxyDifHdawJGdsjDK
         mgGZ4us3KVci9me03QvSavdboJrzLxmEhxFCRkb5FVys+pvWzmfRLUz7t0eHmKo0Ax
         W70X5eRQFoo5p7eaCtuIcDky+Fc23IKjVp1X0RnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Salyzyn <salyzyn@android.com>,
        netdev@vger.kernel.org, kernel-team@android.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 01/37] af_key: pfkey_dump needs parameter validation
Date:   Fri, 25 Sep 2020 14:48:29 +0200
Message-Id: <20200925124721.158581982@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
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
@@ -1855,6 +1855,13 @@ static int pfkey_dump(struct sock *sk, s
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


