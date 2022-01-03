Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE594835C4
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiACRaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbiACRaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA08C061792;
        Mon,  3 Jan 2022 09:30:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54E76B8107B;
        Mon,  3 Jan 2022 17:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E713AC36AF8;
        Mon,  3 Jan 2022 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230999;
        bh=Y0J8XBrSx5+EYNohAi7G2j5UtwGyHqbFfjrqlSDfVyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlUC0lUUhqzPOqeJtqigQRSmE2T17zZIeM045sco/KznQc0M3T1oSaccAKVv5rjWP
         kuSnnLtVb0rGohKSYaEd/PLaXzz/W5VDWYP1EgskjAAYmKHK7G5cx3EJgjMRBhrPSE
         qnvdol9ctNtoU+cty4QssBRh70spbkq9RNX3iBLU7xe+vbnrppQKPFfPuYHei8z5Lu
         ItkAs5bp0DLxlfan3MS2qCDJXZRUSg2H77WGhDUEwF47eFZqXbcx5/NAXJV9VAr71w
         5mYfzg5cqoGl6RcgHlvTKaHDzoanjUFqwufqnlUhe502v4EEb4KW/aihBabZNG2YvN
         x5BMZQGBlEZdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamir Duberstein <tamird@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/16] ipv6: raw: check passed optlen before reading
Date:   Mon,  3 Jan 2022 12:28:48 -0500
Message-Id: <20220103172849.1612731-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit fb7bc9204095090731430c8921f9e629740c110a ]

Add a check that the user-provided option is at least as long as the
number of bytes we intend to read. Before this patch we would blindly
read sizeof(int) bytes even in cases where the user passed
optlen<sizeof(int), which would potentially read garbage or fault.

Discovered by new tests in https://github.com/google/gvisor/pull/6957 .

The original get_user call predates history in the git repo.

Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211229200947.2862255-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 60f1e4f5be5aa..c51d5ce3711c2 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1020,6 +1020,9 @@ static int do_rawv6_setsockopt(struct sock *sk, int level, int optname,
 	struct raw6_sock *rp = raw6_sk(sk);
 	int val;
 
+	if (optlen < sizeof(val))
+		return -EINVAL;
+
 	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
-- 
2.34.1

