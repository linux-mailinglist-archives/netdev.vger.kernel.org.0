Return-Path: <netdev+bounces-1704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1696FEEF1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A60C12815BC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA0327703;
	Thu, 11 May 2023 09:35:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7282A1B8E2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC5C433D2;
	Thu, 11 May 2023 09:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683797700;
	bh=crRv1Vnj9RTAsAkgf7GSp+Q07xBzhGYU+aIE9spMxUw=;
	h=From:To:Cc:Subject:Date:From;
	b=bXVyzBLhxIVMKf2LX6FgIsurwJ2Qc87P8bRIpmOj/uWjH+R5mq9cQdCFQ+xKb1bKD
	 nuAqn1LJaBcwgE506mDD32OwrJ318nXrf18+92tkQJTSFl6YfSVKGd0WNHyMUUzqHD
	 IbebD02RvEVmOcoem1u1va+mG/XnBkqMDwbXRxQHmnz6lAv1LSeN3xlr4ShwMQ0wFh
	 YluCJ592fp0zCCwULactFOSuBL09VIKROzQzpvkDS+T+9EIOriM+SRnUsLZ4RUmi4u
	 ZA7B9oxvCmfywJ9N6UmFKveUPVQlCiKbt8rK7WbX9gn+PjQrHNa4tWqy4o3VkDF34U
	 xEt9whRJV/emg==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
Date: Thu, 11 May 2023 11:34:52 +0200
Message-Id: <20230511093456.672221-1-atenart@kernel.org>
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
doesn't have the same issue). Last two commits improve doc/comment
hash-related parts.

One example is when using OvS with dp_hash, which uses skb->hash, to
select a path. We'd like packets from the same flow to be consistent, as
well as the hash being stable over time when using net.core.txrehash=0.
Same applies for kernel ECMP which also can use skb->hash.

IMHO the series makes sense in net-next, but we could argue (some)
commits be seen as fixes and I can resend if necessary.

Thanks!
Antoine

Antoine Tenart (4):
  net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
  net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
  Documentation: net: net.core.txrehash is not specific to listening
    sockets
  net: skbuff: fix l4_hash comment

 Documentation/admin-guide/sysctl/net.rst |  4 ++--
 include/linux/skbuff.h                   |  4 ++--
 include/net/ip.h                         |  2 +-
 net/ipv4/ip_output.c                     |  4 +++-
 net/ipv4/tcp_ipv4.c                      | 14 +++++++++-----
 net/ipv4/tcp_minisocks.c                 |  2 +-
 6 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.40.1


