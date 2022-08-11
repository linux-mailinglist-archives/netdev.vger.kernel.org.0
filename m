Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1955900DF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiHKPrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiHKPqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51EA79A7E;
        Thu, 11 Aug 2022 08:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF03B82156;
        Thu, 11 Aug 2022 15:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5581C433B5;
        Thu, 11 Aug 2022 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232448;
        bh=xd2PSARypbXlsiv+xUlqcCkvCp6QI2mZBUuB/PH+cSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAhWCiGRhSS3SVqevME9vqLbuiU2UPFbWwR6Y/ajIuCkOlsEi2b+HuyItFA/wlkDm
         5y97/uDEQ0weplTi+FqftkAlRd/yaBpk2VEtLcjiuWX1m11f71hxCf/SGyYol6kRJe
         oaXlg1NmRcVmZBH0zXuMWde80B90uL52AXLGyamdMTcQ0Ak2uZZKDpz0EMQb5Ilj51
         a8lVAZLKv+BqslBLXU0+MFPETY20y+BszdM/aheP2H/s/hjdN4m6QTADZ2XHgeawTS
         HB6RBnhjqiGOgRuXE95HQSQ05LCQ0lWCOJd/vPoCRmr8Gl4IRtC4hV1woRtDhg7/4b
         yBZW1088PjnBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 082/105] Bluetooth: use memset avoid memory leaks
Date:   Thu, 11 Aug 2022 11:28:06 -0400
Message-Id: <20220811152851.1520029-82-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit a5133fe87ed827ce94084eecb7830a6d451ef55c ]

Similar to the handling of l2cap_ecred_connect in commit d3715b2333e9
("Bluetooth: use memset avoid memory leaks"), we thought a patch
might be needed here as well.

Use memset to initialize structs to prevent memory leaks
in l2cap_le_connect

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 52668662ae8d..77c0aac14539 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1392,6 +1392,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 
 	l2cap_le_flowctl_init(chan, 0);
 
+	memset(&req, 0, sizeof(req));
 	req.psm     = chan->psm;
 	req.scid    = cpu_to_le16(chan->scid);
 	req.mtu     = cpu_to_le16(chan->imtu);
-- 
2.35.1

