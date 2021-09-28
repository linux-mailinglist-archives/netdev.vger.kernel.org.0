Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4C41AF76
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbhI1M5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240841AbhI1M5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45413611C3;
        Tue, 28 Sep 2021 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833724;
        bh=KsFqiEy9aWDPlVhl7llh9H8jF/gcHv/Mi5pL+JtQQnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg5qsnJdNLMqmtb5fWCRVp8GRseKQH6j8nrPWXiVfTcBEd9aPFjZ474/2ICkA1+kY
         QCiV68D1p4pMisFOtjj+5v+ydT5drPtQN++5bTHnUe4wPH1Q1nPEoLzpXul6cVD4zH
         ob1LoorVsQnbOm3Q0OIUXZzoaBc/HtNJzAEc24Owy1KAoEUMgsdUOng86dCpBYNVs8
         Bna66B5eeMd25FfbEBxTJGcQ4y5p/OXq4Y2qZr6XWmEzGK0RMco/Jwrv7eRsLGgAiu
         gNMrubuGuQrLWPvz6vjuehgp5+qWJReT39srTcpj51IxSicQsA3cYD/f+fDH41GFui
         f/t6UTnomRRkQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 4/9] bonding: use the correct function to check for netdev name collision
Date:   Tue, 28 Sep 2021 14:54:55 +0200
Message-Id: <20210928125500.167943-5-atenart@kernel.org>
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
bond_create_sysfs we want to check for a name collision, hence use the
correct function.

(The behaviour of the two functions was similar but will change in the
next commits).

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/bonding/bond_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index b9e9842fed94..8260bf941ca3 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -811,8 +811,8 @@ int bond_create_sysfs(struct bond_net *bn)
 	 */
 	if (ret == -EEXIST) {
 		/* Is someone being kinky and naming a device bonding_master? */
-		if (__dev_get_by_name(bn->net,
-				      class_attr_bonding_masters.attr.name))
+		if (netdev_name_node_lookup(bn->net,
+					    class_attr_bonding_masters.attr.name))
 			pr_err("network device named %s already exists in sysfs\n",
 			       class_attr_bonding_masters.attr.name);
 		ret = 0;
-- 
2.31.1

