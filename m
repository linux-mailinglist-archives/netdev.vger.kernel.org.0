Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012034EF62B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242127AbiDAPav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243947AbiDAO4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923D3C558B;
        Fri,  1 Apr 2022 07:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB1DA60BAF;
        Fri,  1 Apr 2022 14:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41D5C34113;
        Fri,  1 Apr 2022 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824241;
        bh=Z34E3aJ2B7w4LgQQAjnx3XNpB3vym7f9a/TuaI151q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR2ettCY7SEObQHmxXirS7p+GorYg/b3cCI6/8yMTWWzHYN6+iiMiJ3vssXS36Tp0
         hWXgW/uMAh7HTWfyo41zTnucinPd3DcD/GE3i0YBtPwpsCAqPwk5u1k9v2D73oY3Vz
         OT1vBDoueRKdyBdWaQZ3XUw49ya4TaRyWDnPhHN7Q8YmodRLLGvEX8DxPJDcRJivie
         Z7ewjGX2koPQKVZhXiDd0lkdzcpheaLhqDLzAh3dx4i6uwV+uzcoqis4TxQp1TSvY1
         nRAS/7JzMm9K/Vt7Ic29v156+jJvorZ7UAhIRqudz/hHO+gO++xaLDYAZC9nhLyZjj
         V1IkJJJhUxxlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 47/65] Bluetooth: use memset avoid memory leaks
Date:   Fri,  1 Apr 2022 10:41:48 -0400
Message-Id: <20220401144206.1953700-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

[ Upstream commit d3715b2333e9a21692ba16ef8645eda584a9515d ]

Use memset to initialize structs to prevent memory leaks
in l2cap_ecred_connect

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0ddbc415ce15..012c1a0abda8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1438,6 +1438,7 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
 
 	l2cap_ecred_init(chan, 0);
 
+	memset(&data, 0, sizeof(data));
 	data.pdu.req.psm     = chan->psm;
 	data.pdu.req.mtu     = cpu_to_le16(chan->imtu);
 	data.pdu.req.mps     = cpu_to_le16(chan->mps);
-- 
2.34.1

