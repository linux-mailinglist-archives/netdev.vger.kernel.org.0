Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF8176B16
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgCCCsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgCCCsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42BC246A1;
        Tue,  3 Mar 2020 02:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203692;
        bh=HBrpjshP9o/0uIYBDnOR2VB3PHUj1bRV4+rvjl1a4eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aleMQn4rqdhM5u/QP+JNjh6MoMlgISnLlN/qIOvhRx02mwogYr3pNzgLTcZpSHVAz
         czS7J6Qz5vdngGof8TLDLqrS8yyy7yT8I5A0ZzKlXKppf+nUKxGoZhRRmi8Wf1vJ8V
         MmCM50xxQOGspJtNZUPZ75j/Hh96dzVyBzrjujkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/58] net: dsa: b53: Ensure the default VID is untagged
Date:   Mon,  2 Mar 2020 21:47:08 -0500
Message-Id: <20200303024740.9511-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit d965a5432d4c3e6b9c3d2bc1d4a800013bbf76f6 ]

We need to ensure that the default VID is untagged otherwise the switch
will be sending tagged frames and the results can be problematic. This
is especially true with b53 switches that use VID 0 as their default
VLAN since VID 0 has a special meaning.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 7ed667b304d1f..d618650533b65 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1353,6 +1353,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 
 		b53_get_vlan_entry(dev, vid, vl);
 
+		if (vid == 0 && vid == b53_default_pvid(dev))
+			untagged = true;
+
 		vl->members |= BIT(port);
 		if (untagged && !dsa_is_cpu_port(ds, port))
 			vl->untag |= BIT(port);
-- 
2.20.1

