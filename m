Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEB440551E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355110AbhIINIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357663AbhIINDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 418C263281;
        Thu,  9 Sep 2021 11:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188790;
        bh=OTeBBEk+/aMmAs7ageVFeEy3xXpZOhG0XdHKbdu/UtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQToCvwT6gKsqgzEwik+CHwmZQzvcb+qrLcIxxkwA0OgQnWsODLYLIsL0ZA3HXxwT
         sdTPrTNgWPqzohMSRSCb4ecryEFUdaFthxOQkX6S5goqM6asNX99tc93FrBo7wdNxf
         dzGwZrXIMlY63Ewhe6btN53ZEVnqFTo8RK02ZkZ93fDi83GuEOi2DrZIp1ALHQUxD0
         ZotmefDg0t8QlUYYmwZtVuuG05XUlVZL+U5LA4tcDuHvzDfH4lLV6g4W5FuYo8ck5S
         CiSjWtUExmiPZ9tC1iTXtcrCpat0eA7jPcMOFaWbeYQ4H2p6Ddyf6xYietABvecoeE
         Bo+2R81ZEiKaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 39/59] rpc: fix gss_svc_init cleanup on failure
Date:   Thu,  9 Sep 2021 07:58:40 -0400
Message-Id: <20210909115900.149795-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 5a4753446253a427c0ff1e433b9c4933e5af207c ]

The failure case here should be rare, but it's obviously wrong.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 27dfd85830d8..4f41a1bc59bf 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1861,7 +1861,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
-- 
2.30.2

