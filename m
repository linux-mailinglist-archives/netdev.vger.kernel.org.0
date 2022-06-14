Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795EC54A64C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353445AbiFNCYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355354AbiFNCYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:24:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C004199C;
        Mon, 13 Jun 2022 19:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 992DFB816BB;
        Tue, 14 Jun 2022 02:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840CAC341C4;
        Tue, 14 Jun 2022 02:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172659;
        bh=hpr7dPZ5XWl9ycqC+kESLO4L50zCczShqrP2GtHInnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyKIwjx9ro8+8qZiYMyvXR8hLEcNkIR82WqMiJEs14aYgKcprVxMcMPsk2AT+szrr
         D96kHDuLkyR+Dw0QaKcAHccEPk90WqZMjJCKBiaLO0bEvUkKDcF86/IkIlmEQdNK+h
         4wcbww3MhHT3LpQlGMg86O7vD1eutpE1zcj8pqssaXogo8dBfvTJ93EhKmLBSVkfgO
         h+b9Z4fKyCOSmv5WqwcwAm0EiaxoTAMPqqz9We9o78lswPXHc2MDUmQoEetUzefJxM
         QCxhAU3maQeE5be20+AUE2eek58m0RrIastTl9x5otRlZe2NfLvDgzXIcQ+DAuo/wm
         YSV//TUJ0clxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/12] ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg
Date:   Mon, 13 Jun 2022 22:10:39 -0400
Message-Id: <20220614021040.1101131-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021040.1101131-1-sashal@kernel.org>
References: <20220614021040.1101131-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit f638a84afef3dfe10554c51820c16e39a278c915 ]

When len >= INT_MAX - transhdrlen, ulen = len + transhdrlen will be
overflow. To fix, we can follow what udpv6 does and subtract the
transhdrlen from the max.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/20220607120028.845916-2-wangyufen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ip6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 76ef758db112..e412020029df 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -518,14 +518,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
-	int ulen = len + transhdrlen;
+	int ulen;
 	int err;
 
 	/* Rough check on arithmetic overflow,
 	   better check is made in ip6_append_data().
 	 */
-	if (len > INT_MAX)
+	if (len > INT_MAX - transhdrlen)
 		return -EMSGSIZE;
+	ulen = len + transhdrlen;
 
 	/* Mirror BSD error message compatibility */
 	if (msg->msg_flags & MSG_OOB)
-- 
2.35.1

