Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147E849BC08
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiAYT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:26:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36862 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiAYT0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:26:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A788EB818C2;
        Tue, 25 Jan 2022 19:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960C5C340E0;
        Tue, 25 Jan 2022 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643138793;
        bh=kyf0fBuyLxoLx1MUqMK5zUGymedo4pfkJrSdske5Tnk=;
        h=Date:From:To:Cc:Subject:From;
        b=VJf5g0XdmTzrj1XQlhdy7Krt3mjRTUCv2ZDCa1UVRuMjj5Dzwh3WvDqu35Ge8f5mf
         v8CjGbTdjTd0l8cCcAYEgGYVWEBQqVvp7Q1Yzrd03kGCWtO10EQneler1Y1sYWZFCA
         G33zOLj5fg5sr2uKrzzZxFtFDoB5E89vPIRstickLdvOOnYLs1Gtzv06wxODFPnqBt
         YVhMe4XmwWWMBV5S+WPEqs7NZ71jA7QsF8Iwo1B6JMlEcxueT3Kk7CDfnsvYRV8cSs
         xkTG8k/Hqe7xD816kAuhHnPpOt9Hdv5kQIKSccsdUyuAPaM6Ytnvei3oQmixqjxiGs
         K/MJMSnL/xdSQ==
Date:   Tue, 25 Jan 2022 13:33:19 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] nfp: flower: Use struct_size() helper in kmalloc()
Message-ID: <20220125193319.GA73108@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worst scenario, could lead to heap overflows.

Also, address the following sparse warnings:
drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:359:25: warning: using sizeof on a flexible structure

Link: https://github.com/KSPP/linux/issues/174
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index dfb4468fe287..ce865e619568 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -356,7 +356,7 @@ __nfp_tun_add_route_to_cache(struct list_head *route_list,
 			return 0;
 		}
 
-	entry = kmalloc(sizeof(*entry) + add_len, GFP_ATOMIC);
+	entry = kmalloc(struct_size(entry, ip_add, add_len), GFP_ATOMIC);
 	if (!entry) {
 		spin_unlock_bh(list_lock);
 		return -ENOMEM;
-- 
2.27.0

