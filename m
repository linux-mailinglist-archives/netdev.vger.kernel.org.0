Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A5A41AF77
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbhI1M5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240852AbhI1M5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257C8611F2;
        Tue, 28 Sep 2021 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833727;
        bh=fM6tqvUHtXgbjxtWtxna9zDvOYzYTwynikJGkmmVJ20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcTL0vOcGNB4uKcnoWA0fO869N76RZyCb5/N2GidT88pnhbsMutwDG5vxglWObpOb
         LX9fE/Kh5Krcb1PtPYBeZHqoHF8euJznrkilnZdNY3M3PFPs2+r7H2Q46pFjnB5/ET
         yrSVu8zsc/iQiA9F860obr3nx5FZdbrx1IDHMXCejhosFeNyHHq6oT0HoV0//yBONR
         tb4q3O/RP4k13yjYRaA+tWDkCEE5ypqGG/Y0l0vjVYoUi5Pq8eIdqKlMowHsAUF22/
         EpNlrpJdxLd57WLmGz5Di//EYiAV7GLLmPAsJIwxgW9sQZikCmvt3epSCvmW2/8Q6P
         zVHRIM4NGMTnw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 5/9] ppp: use the correct function to check for netdev name collision
Date:   Tue, 28 Sep 2021 14:54:56 +0200
Message-Id: <20210928125500.167943-6-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_name_node_lookup and __dev_get_by_name have two distinct aims,
one helps in name collision detection, while the other is used to
retrieve a reference to a net device from its name. Here in
ppp_unit_register we want to check for a name collision, hence use the
correct function.

(The behaviour of the two functions was similar but will change in the
next commits).

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index fb52cd175b45..c3e2f4da9949 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1161,7 +1161,7 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 		if (!ifname_is_set) {
 			while (1) {
 				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
-				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+				if (!netdev_name_node_lookup(ppp->ppp_net, ppp->dev->name))
 					break;
 				unit_put(&pn->units_idr, ret);
 				ret = unit_get(&pn->units_idr, ppp, ret + 1);
-- 
2.31.1

