Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEDC2ED309
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbhAGOtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:49:55 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38847 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbhAGOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:49:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BC59C1850;
        Thu,  7 Jan 2021 09:49:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 07 Jan 2021 09:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=G3k0Af7NmpKDN68SDhDcQ4gAWdNN8kOpme1/dP8Y2Og=; b=BcWqYacY
        tnjeNremnWaNxwhqEkCUbThFlvDv3ay+PL9hMmopaYtUKmAlvFJOueSqA7+iRDPR
        LA0SMb+jhI7vhKi2Dy2P5e7MTs+dALcbzfU6NWb4/0nwiuDg5suoTo/rEeE1Nnsz
        V47BEfE+0sPMCEFu9H3crx1MgW4i0jfSPEN7ADrkK49LIQD3xP3eqmDc5hm8nWs/
        LlpExwzre8Zvle7l893IX6jlv9QOrj4Ah8RPkodtTCscXf4WaSVYRgKF/MC/HlEC
        8rP7fuzDrxfkZuLu1JoCK8In+QMlCVh6UHcPnrWnd8UzNxOE3c37djX4HbmVRgq9
        icB/wt17VeYLhg==
X-ME-Sender: <xms:ZB_3X7yXw1FSDMoXKZ9J9gMSVkDkNlGEA7A1hrx4tEjmpoW_JrAvcg>
    <xme:ZB_3X8MAsV1rdep3t7IHXTYEtXb0EjL8f7PN5fXjvuT3VPFVTbo8D3csqnJITVQaf
    aC5Djlf9E8jpg0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZB_3X3RwaFakNgZhseXgAcjlfkT8KBlZ8hlx-PJ-L_0lW6gQ31n_uw>
    <xmx:ZB_3XybMBL5-Xa95yO50-eTOTiYNIDrn3ISkUxoDajiQDYjmVIV87g>
    <xmx:ZB_3X80HTxC3tioJAa1_l_J2XofQaZcSgrnl7krR69p4MwF-7KR36Q>
    <xmx:ZB_3X1n7r4Y0OboUh0LNLXWisDWSzUV6xlPMqJtQL336ONeP-ZnUTQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE2E1108005C;
        Thu,  7 Jan 2021 09:49:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/4] nexthop: Fix off-by-one error in error path
Date:   Thu,  7 Jan 2021 16:48:21 +0200
Message-Id: <20210107144824.1135691-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107144824.1135691-1-idosch@idosch.org>
References: <20210107144824.1135691-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A reference was not taken for the current nexthop entry, so do not try
to put it in the error path.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5e1b22d4f939..f8035cfa9c20 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1459,7 +1459,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	return nh;
 
 out_no_nh:
-	for (; i >= 0; --i)
+	for (i--; i >= 0; --i)
 		nexthop_put(nhg->nh_entries[i].nh);
 
 	kfree(nhg->spare);
-- 
2.29.2

