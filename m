Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BE313F6C9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389429AbgAPTHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388035AbgAPRBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDC524686;
        Thu, 16 Jan 2020 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194080;
        bh=ZuXK0zsZBjp/NFllYnbQs7l9KPmqZ3d4TfhruDTFvYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAKiP+uFnETg+EXdXgcOK18ERxIc8QKYaQPHEGJLieZ5fj3if0omTqkw6uG25CBUS
         hyZ9e53akLWL2gAcQyKtLVvt402538QpFspoaBouAEBJakUuY41Fb4ekVVah3xZC0p
         6LxuMNGKT87PSAOEOHZB2F9bI+P78TS/W1KkFWSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 186/671] net: dsa: b53: Do not program CPU port's PVID
Date:   Thu, 16 Jan 2020 11:51:35 -0500
Message-Id: <20200116165940.10720-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 10163aaee9671b01b2f4737922e1a4f43581047a ]

The CPU port is special and does not need to obey VLAN restrictions as
far as untagged traffic goes, also, having the CPU port be part of a
particular PVID is against the idea of keeping it tagged in all VLANs.

Fixes: ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all VLANs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 426ec1c05799..9f21e710fc38 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1175,7 +1175,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 		b53_fast_age_vlan(dev, vid);
 	}
 
-	if (pvid) {
+	if (pvid && !dsa_is_cpu_port(ds, port)) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    vlan->vid_end);
 		b53_fast_age_vlan(dev, vid);
-- 
2.20.1

