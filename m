Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B2A29A00F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442575AbgJ0A07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410046AbgJZXxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157712231B;
        Mon, 26 Oct 2020 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756401;
        bh=x2VzrOmid5aVY9WAx3Z3mqj5B63Us9NQmZHN+hh2kUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+fEL/OHSVEXKv1BftBtQmwL89T2ws96zIH5UKSqR5vgiuw39Q4fqBQCI0MBQsANL
         dz5r5cIBCTKjhMp4dBp+GToZggVOWrZvF1QOV8qpP5077DsmF/0HGYiWiL69JbbJxp
         u3wSSe9aJGuAbDHbMviU9b0LWzjMvoF6cDX264Dc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 061/132] samples/bpf: Fix possible deadlock in xdpsock
Date:   Mon, 26 Oct 2020 19:50:53 -0400
Message-Id: <20201026235205.1023962-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
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
index c91e91362a0c6..a2f8033ab9c3d 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1028,6 +1028,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		complete_tx_l2fwd(xsk, fds);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-- 
2.25.1

