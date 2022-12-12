Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA48C649CB5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiLLKn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiLLKlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:41:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182B8FCC6;
        Mon, 12 Dec 2022 02:36:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D7E60F97;
        Mon, 12 Dec 2022 10:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CFFC433EF;
        Mon, 12 Dec 2022 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841407;
        bh=0/pZdp075E7mcGyKJ6P0qvqA4lTlNFQUUkYTBYcKxsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a45VC9Nb8POnAIcb5ipSrAz2kXShFXxEDQdZl+HZ/DBvl+N/c+ofkXmcq2zavnbzC
         QW6Rfi9UTyFdgEOc+cmXUGKXyNg3QlTrS3qWTREq457SH+Nwi3sGTo7zOzh8ialw2J
         lZtTSq3ROJlEBz4P7aJlFHyjQqI+zK+ymtWpJJlfiOKKNnlihNYm5JHx8MXA1o7srY
         RxW+gKZMow1QJyxQ2f5sXHkPjUvxeTozvutk9n4DjtjBwTinDR/hxDDi+DY+j3QyDp
         TTfkBzEHBK4IJrbxY2OXre5rqubfJl/62xKpHsdEynmGNRJri3MJMdrsGbH4qnRPJg
         PH30FC9RRkm/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sungwoo Kim <iam@sung-woo.kim>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/7] Bluetooth: L2CAP: Fix u8 overflow
Date:   Mon, 12 Dec 2022 05:36:31 -0500
Message-Id: <20221212103633.300240-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103633.300240-1-sashal@kernel.org>
References: <20221212103633.300240-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit bcd70260ef56e0aee8a4fc6cd214a419900b0765 ]

By keep sending L2CAP_CONF_REQ packets, chan->num_conf_rsp increases
multiple times and eventually it will wrap around the maximum number
(i.e., 255).
This patch prevents this by adding a boundary check with
L2CAP_MAX_CONF_RSP

Btmon log:
Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.264594
= Note: Bluetooth subsystem version 2.22                               0.264636
@ MGMT Open: btmon (privileged) version 1.22                  {0x0001} 0.272191
= New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)          [hci0] 13.877604
@ RAW Open: 9496 (privileged) version 2.22                   {0x0002} 13.890741
= Open Index: 00:00:00:00:00:00                                [hci0] 13.900426
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.273106
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #33 [hci0] 14.273561
        invalid packet size (14 != 1547)
        0a 00 01 00 04 01 06 00 40 00 00 00 00 00        ........@.....
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.274390
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 00 00 00 04  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.274932
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 00 03 00  ........@.......
= bluetoothd: Bluetooth daemon 5.43                                   14.401828
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #36 [hci0] 14.275753
        invalid packet size (12 != 1033)
        08 00 01 00 04 01 04 00 40 00 00 00              ........@...

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index fb2abd0e979a..0e51ed3412ef 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4210,7 +4210,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
-- 
2.35.1

