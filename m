Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0E54A45C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352194AbiFNCHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351610AbiFNCGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:06:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244EF34B8D;
        Mon, 13 Jun 2022 19:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E8DFB81698;
        Tue, 14 Jun 2022 02:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C5DC385A2;
        Tue, 14 Jun 2022 02:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172340;
        bh=kY7M+cF6jVAw2h72tzuT6A72g36+rLAemXxLHPg6FwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9o3lM6ESKcoYA4JzLz/wPXI2I4nVQUshmD14ZHWHEx/WDEInJNwGZTR02Hp+lBUg
         qhOmxXQMpR8yoSSnYnW3sKaI3ImwsfmNBhxEmkHhxzOtkMa+Hg8rVzTtC0WPvtnjCR
         uzlZI7mzb6iCVIjBvN9adtsWIBOgbdAE8OP9p22cBTjIV/mzX3HJTcW4eXR3y2xJMG
         WP5w3fVq18u02SjJkI05rVFKrVU+KqeVw5cDQDftAh8wpvacE/q8W0FzIzsgEdVTka
         kKhK3SGC9kUVHyKdLF2v7/2iY4p++oHtKhonMMyAmvpu9SCDCdvpLGl2znlFMLwXV8
         77dY5BHYu5wWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 34/47] ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg
Date:   Mon, 13 Jun 2022 22:04:27 -0400
Message-Id: <20220614020441.1098348-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
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
index 96f975777438..d54dbd01d86f 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -502,14 +502,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
-	int ulen = len + transhdrlen;
+	int ulen;
 	int err;
 
 	/* Rough check on arithmetic overflow,
 	 * better check is made in ip6_append_data().
 	 */
-	if (len > INT_MAX)
+	if (len > INT_MAX - transhdrlen)
 		return -EMSGSIZE;
+	ulen = len + transhdrlen;
 
 	/* Mirror BSD error message compatibility */
 	if (msg->msg_flags & MSG_OOB)
-- 
2.35.1

