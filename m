Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B0E299D31
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437588AbgJ0AEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411017AbgJZX4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 326CA22202;
        Mon, 26 Oct 2020 23:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756559;
        bh=xXQCAi1UanTxXmdmTXNwci+zWfS1jsM/sBq4Gzk2pFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlGwyHU8vUZjhbt0rqJ/G4w4PQpxbbbS60VrFztXa30uOsO2aCw+M4StsHT3giiLt
         AwCF0AFygKj0kYhJFWoqoefZDvj9w8auNW8AgMXM1rdW6aZyBhxyU5KKSKoFyk205D
         +jMPl3/BP3cuYluMs/UloOptjyv0QLOOGUkDm0eI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/80] samples/bpf: Fix possible deadlock in xdpsock
Date:   Mon, 26 Oct 2020 19:54:31 -0400
Message-Id: <20201026235516.1025100-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 5a2a0dd88f0f267ac5953acd81050ae43a82201f ]

Fix a possible deadlock in the l2fwd application in xdpsock that can
occur when there is no space in the Tx ring. There are two ways to get
the kernel to consume entries in the Tx ring: calling sendto() to make
it send packets and freeing entries from the completion ring, as the
kernel will not send a packet if there is no space for it to add a
completion entry in the completion ring. The Tx loop in l2fwd only
used to call sendto(). This patches adds cleaning the completion ring
in that loop.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/1599726666-8431-3-git-send-email-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index df011ac334022..79d1005ff2ee3 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -677,6 +677,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		complete_tx_l2fwd(xsk, fds);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-- 
2.25.1

