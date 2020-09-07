Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6A26013A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgIGQde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730601AbgIGQdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C9D21927;
        Mon,  7 Sep 2020 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496403;
        bh=TTWkATQ6EXKEp+vAuj7niHV5cTlbg6tkuzwmJGjMVgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLuisueBvb9gJP9sLQ3kzxDje5f2dxk4nzz82OTbgD16VLnMxgclF6rsIpvQnURZP
         9/Jr1v3RAcHBabJDHrTA7lN86Hu3qcoBOtnvsBvIOxpIZozRMLQpWUje8E0JY1kqUC
         1KMrc8iRvc1WvSSZM1u1mnTF6mKASAN8mF7tSXX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 49/53] drivers/net/wan/hdlc: Change the default of hard_header_len to 0
Date:   Mon,  7 Sep 2020 12:32:15 -0400
Message-Id: <20200907163220.1280412-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 2b7bcd967a0f5b7ac9bb0c37b92de36e073dd119 ]

Change the default value of hard_header_len in hdlc.c from 16 to 0.

Currently there are 6 HDLC protocol drivers, among them:

hdlc_raw_eth, hdlc_cisco, hdlc_ppp, hdlc_x25 set hard_header_len when
attaching the protocol, overriding the default. So this patch does not
affect them.

hdlc_raw and hdlc_fr don't set hard_header_len when attaching the
protocol. So this patch will change the hard_header_len of the HDLC
device for them from 16 to 0.

This is the correct change because both hdlc_raw and hdlc_fr don't have
header_ops, and the code in net/packet/af_packet.c expects the value of
hard_header_len to be consistent with header_ops.

In net/packet/af_packet.c, in the packet_snd function,
for AF_PACKET/DGRAM sockets it would reserve a headroom of
hard_header_len and call dev_hard_header to fill in that headroom,
and for AF_PACKET/RAW sockets, it does not reserve the headroom and
does not call dev_hard_header, but checks if the user has provided a
header of length hard_header_len (in function dev_validate_header).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 386ed2aa31fd9..9b00708676cf7 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -229,7 +229,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->min_mtu		 = 68;
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
-	dev->hard_header_len	 = 16;
+	dev->hard_header_len	 = 0;
 	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
-- 
2.25.1

