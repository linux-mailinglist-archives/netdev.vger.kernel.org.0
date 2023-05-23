Return-Path: <netdev+bounces-4749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D72F70E185
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFDBF1C20D7C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F00200DB;
	Tue, 23 May 2023 16:14:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872D41F95D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52CBC433EF;
	Tue, 23 May 2023 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684858496;
	bh=VU9f3arJtkgBmwukhFX5GE6wPJrU38Y6u8+/F4OpoNM=;
	h=From:To:Cc:Subject:Date:From;
	b=MR3zB1g/V4o0lvB3JMGg01nmiZtqk1WlhtCkcLl5934GNjjDERFV94u6O+1kL2Tsr
	 A5MaKDh0GII7Vg1a+U0kIEcirOZjWahtYlzzL+PB5NKgc/NhqlwKJaryi9pwk5rMGO
	 651VTqunkNYvWuTImhKAfnvI/7OPVZ+p6xxfneOXojO3YfnEJYBrRKS0TY1z7lrYGU
	 g/pK7ZRye0U1m/6nwmkvk/MTCGPbjbVjgNoASdclGxYDZSZufh17KkSNPWtci4cbQx
	 U72B98Ub15Hy6gxqR+YUKh3uaC/6LbzpugwrEklITJgkm184nk1HcHonxuKzI+6b+f
	 x8x17BXGWzH8Q==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org,
	i.maximets@ovn.org,
	dceara@redhat.com
Subject: [PATCH net-next v2 0/3] net: tcp: make txhash use consistent for IPv4
Date: Tue, 23 May 2023 18:14:50 +0200
Message-Id: <20230523161453.196094-1-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

Series is divided in two parts. First two commits make the txhash (used
for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
doesn't have the same issue). Last commit improve a hash-related doc.

One example is when using OvS with dp_hash, which uses skb->hash, to
select a path. We'd like packets from the same flow to be consistent, as
well as the hash being stable over time when using net.core.txrehash=0.
Same applies for kernel ECMP which also can use skb->hash.

Thanks!
Antoine

Since v1:
- Rebased on top of latest net-next (one minor conflict).
- Dropped patch 4/4 ("net: skbuff: fix l4_hash comment") as we didn't
  come to an agreement, thread for reference:
  https://lore.kernel.org/all/20230511093456.672221-5-atenart@kernel.org/

Antoine Tenart (3):
  net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
  net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
  Documentation: net: net.core.txrehash is not specific to listening
    sockets

 Documentation/admin-guide/sysctl/net.rst |  4 ++--
 include/net/ip.h                         |  2 +-
 net/ipv4/ip_output.c                     |  4 +++-
 net/ipv4/tcp_ipv4.c                      | 14 +++++++++-----
 net/ipv4/tcp_minisocks.c                 |  2 +-
 5 files changed, 16 insertions(+), 10 deletions(-)

-- 
2.40.1


