Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E004835E3
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiACRam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38418 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbiACRaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C020BB81074;
        Mon,  3 Jan 2022 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A360BC36AEE;
        Mon,  3 Jan 2022 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231017;
        bh=l7CVo2z3VIAukLP5OI+M20kymgqAuMyHZpmtDAElU0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyHjNQvCTSEFG+1a2zOkzbjx1h6015uwXST6CgQmRDRkUGoGpykoyLGUhWxlY0hQV
         BQTEJspQhNhewHJk83EzsMsMt7PBGZCBfahjx+71DvWW/QE/4B65ifK64BeVtL9rMR
         nhmlDZqNAW8186CpyfctiY0JcAulOH37nPK2sAo8f3p7v8CVZdpoeW9ULx0gA1jPJM
         ZqBcRTuAuFcbvGCiRnoRPmgwSfBL2EB1ye7JbLP6Wi1YR7zpjwS3L++PAFDbP2IvAN
         E+mZB48Hz9vRIkjUwmJARpf5OksLYIT8V85/JtYKdIJViYfgOQ2H715dWEsVoXqM0T
         4DkvrRvX0n5Tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamir Duberstein <tamird@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 8/8] ipv6: raw: check passed optlen before reading
Date:   Mon,  3 Jan 2022 12:30:01 -0500
Message-Id: <20220103173001.1613277-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
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
index 00f133a55ef7c..38349054e361e 100644
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

