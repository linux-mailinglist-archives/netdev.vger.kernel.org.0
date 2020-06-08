Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AACE1F24AF
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbgFHXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbgFHXVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 167A320814;
        Mon,  8 Jun 2020 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658493;
        bh=DlI6oCseilzi6eilp8Gz7Ep8tm7QK7mbRC7ltwIV4Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTgts6CMhflbKbhwABViQu3iwTunrq2/Zon1TGBWvRTl5hc9uqw+PObJZ+6Xd6j2s
         ySiHlhX8tqc7BTgpMPumcbZ77r3byO2EiCSTzgctFVqD4Nutq9HjT/54APJT6MUMIC
         2Sj1jtMT+gE+LyQX29qd+cLxSdlX+8HXfrdciCO0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Mao Wenan <maowenan@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 126/175] veth: Adjust hard_start offset on redirect XDP frames
Date:   Mon,  8 Jun 2020 19:17:59 -0400
Message-Id: <20200608231848.3366970-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 5c8572251fabc5bb49fd623c064e95a9daf6a3e3 ]

When native XDP redirect into a veth device, the frame arrives in the
xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
which can run a new XDP bpf_prog on the packet. Doing so requires
converting xdp_frame to xdp_buff, but the tricky part is that
xdp_frame memory area is located in the top (data_hard_start) memory
area that xdp_buff will point into.

The current code tried to protect the xdp_frame area, by assigning
xdp_buff.data_hard_start past this memory. This results in 32 bytes
less headroom to expand into via BPF-helper bpf_xdp_adjust_head().

This protect step is actually not needed, because BPF-helper
bpf_xdp_adjust_head() already reserve this area, and don't allow
BPF-prog to expand into it. Thus, it is safe to point data_hard_start
directly at xdp_frame memory area.

Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
Reported-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/158945338331.97035.5923525383710752178.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9f3c839f9e5f..88cfd63f08a6 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -510,13 +510,15 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 					struct veth_xdp_tx_bq *bq)
 {
 	void *hard_start = frame->data - frame->headroom;
-	void *head = hard_start - sizeof(struct xdp_frame);
 	int len = frame->len, delta = 0;
 	struct xdp_frame orig_frame;
 	struct bpf_prog *xdp_prog;
 	unsigned int headroom;
 	struct sk_buff *skb;
 
+	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
+	hard_start -= sizeof(struct xdp_frame);
+
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
@@ -538,7 +540,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			break;
 		case XDP_TX:
 			orig_frame = *frame;
-			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
 			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
@@ -550,7 +551,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 			goto xdp_xmit;
 		case XDP_REDIRECT:
 			orig_frame = *frame;
-			xdp.data_hard_start = head;
 			xdp.rxq->mem = frame->mem;
 			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
 				frame = &orig_frame;
@@ -572,7 +572,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
-	skb = veth_build_skb(head, headroom, len, 0);
+	skb = veth_build_skb(hard_start, headroom, len, 0);
 	if (!skb) {
 		xdp_return_frame(frame);
 		goto err;
-- 
2.25.1

