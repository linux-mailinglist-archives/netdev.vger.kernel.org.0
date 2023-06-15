Return-Path: <netdev+bounces-11041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D63731459
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466FC281739
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C85D6120;
	Thu, 15 Jun 2023 09:45:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B9F5697;
	Thu, 15 Jun 2023 09:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF640C433C8;
	Thu, 15 Jun 2023 09:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686822357;
	bh=VXmgec0SvoWNjD+zQJUGR2dz0bJtpAmkZ85WuhMZ1Vk=;
	h=From:Date:Subject:To:Cc:From;
	b=ul02Ap/uEzBhWv5cvpcsaJ49I13Y8VZvNH5Lz1HvhDCmylTKEAaFsm2M3XlB7l1E7
	 D9qWbeZtCI77KdL8iMwRa2zC26kh7u8TiVOK9Ja0OmiVBFdOemN/3NNEKpPigwEE8W
	 c96Vto88G0n29VaVkOeWa5A/KfqIZy7+ZM5/ZkWwVNuoryumL7+mHaAS/+swfQECKv
	 HdXS+ZbvFgplp//3I6dI0sGR54dkLMw/6hZuYIQtCe4SvHO9ThGbRNYXmJM6OUQMVM
	 u/NQIweyXo9T0lWOtT/+xoUjwIIQTNZ9FsVhd7WxrIGSpCZp2q5nkvueUoo0WjRCnP
	 EqWj4wLbDtf+Q==
From: Simon Horman <horms@kernel.org>
Date: Thu, 15 Jun 2023 11:45:36 +0200
Subject: [PATCH RFC net] igc: Avoid dereference of ptr_err in
 igc_clean_rx_irq()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
X-B4-Tracking: v=1; b=H4sIAL/dimQC/x2NwQrCQAwFf2XJ2cB2pSJeBT/Aq3jYpq9toKwlW
 0Uo/XeDxxkYZqMKU1S6hI0MH636Kg7NIZBMuYxg7Z0pxXSMp6ZlHYVhxstq3AKDIMm5j5m86HI
 Fd5aLTN6U9zy7XAyDfv+LB91v11Cw0nPffyFv31Z7AAAA
To: Jesse Brandeburg <jesse.brandeburg@intel.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>, 
 Andre Guedes <andre.guedes@intel.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Florian Kauer <florian.kauer@linutronix.de>, 
 Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
 Jithu Joseph <jithu.joseph@intel.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Paolo Abeni <pabeni@redhat.com>, Vedang Patel <vedang.patel@intel.com>, 
 intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, 
 bpf@vger.kernel.org
X-Mailer: b4 0.12.2

In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
to the skb local variable. This may be an ERR_PTR.

A little later the following is executed, which seems to be a
possible dereference of an ERR_PTR.

	total_bytes += skb->len;

Avoid this problem by continuing the loop in which all of the
above occurs once the handling of the NULL case completes.

This proposed fix is speculative - I do not have deep knowledge of this
driver.  And I am concerned about the effect of skipping the following
logic:

  igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
  cleaned_count++;

Flagged by Smatch as:

  .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'

Compile tested only.

Fixes: 26575105d6ed ("igc: Add initial XDP support")
Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 88145c30c919..b58c8a674bd1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2586,6 +2586,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 
 			total_packets++;
 			total_bytes += size;
+			continue;
 		} else if (skb)
 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))


