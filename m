Return-Path: <netdev+bounces-596-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7168C6F8604
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA794281091
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F369C2C8;
	Fri,  5 May 2023 15:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC15383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0BBC433EF;
	Fri,  5 May 2023 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683301322;
	bh=NB80E6sDOFiSRHYILHBdaX6WhxtoaeKVAuWkNhd3wwY=;
	h=Subject:From:To:Cc:Date:From;
	b=SrtVLCEhwHM/elDANECgFAdlbN0N3IWeoQ/5k0VXflXofpnHeosjPV320rVdktYOH
	 YFfB1qfxCIRbFX7dkULQf5HcEAl+LAsNbDlraeeDHv0ysW1Nu5Bw3Bhe2lNaeU/KH3
	 slTeJbX1FGzkPQV8Am1F4o0wtB8Wd7hartj9cX9kIE4Xi0vguS/ve1Pi4NQRgwFpJ/
	 UAQw8wBfXRwL462/ik+k/VG1g2EkmLDv/DXSyGYg6CcjM1DkDgM/hLWZ/uDeqdoqwc
	 cziv3sD9+u5CdyIZkE+gHyCyMzTSwDqx0jGXa9o43ZjKH3Ongy0irCUhR9C8fseL0r
	 j6ZlmnROupgEw==
Subject: [PATCH RFC 0/3] siw on tunnel devices
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: BMT@zurich.ibm.com, tom@talpey.com
Date: Fri, 05 May 2023 11:41:50 -0400
Message-ID: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Chalk this one up to yet another crazy idea.

At NFS testing events, we'd like to test NFS/RDMA over the event's
private network. We can do that with iWARP using siw from guests.

If the guest itself is on the VPN, that means siw's slave device
is a tun device. Such devices have no MAC address. That breaks the
RDMA core's ability to find the correct egress device for siw when
given a source IP address.

We've worked around this in the past with various software hacks,
but we'd rather see full support for this capability in stock
kernels.

A direct and perhaps naïve way to do that is to give loopback and
tun devices their own artificial MAC addresses for this purpose.

---

Chuck Lever (3):
      net/tun: Ensure tun devices have a MAC address
      net/lo: Ensure lo devices have a MAC address
      RDMA/siw: Require non-zero 6-byte MACs for soft iWARP


 drivers/infiniband/sw/siw/siw_main.c | 22 +++++++---------------
 drivers/net/loopback.c               |  2 ++
 drivers/net/tun.c                    |  6 +++---
 3 files changed, 12 insertions(+), 18 deletions(-)

--
Chuck Lever


