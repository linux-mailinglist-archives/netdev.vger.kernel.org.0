Return-Path: <netdev+bounces-3430-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8597071C6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB4A928165E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E4031F19;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95903111B4;
	Wed, 17 May 2023 19:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14751C433D2;
	Wed, 17 May 2023 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350994;
	bh=aV+Tom0vzGiCzHAjUNrBK5m78ldvUmIwkOTfIJRN5Z0=;
	h=From:Subject:Date:To:Cc:From;
	b=cz9g9F29BhCQ4d/tUTfbV0k4+GvBTpepR0k8jOckt1DBi/DvMxJvE/tNfoaB0RIZ4
	 iwK3jSVVBmnIsi7Zc5SfyNLiA25tw9O10O7FuYJFWb2z/RkXUqqPOnrQFQd6Kyckf0
	 cNZUIamNxTFbN9p6/8LWd+wKd++LSgLiPKn8rmqmIa4Zpc5HMPLhQxTt4yHq/bfGbF
	 zOszOMTGUujYkWA6Du1TT7ZtkqC+3mENpwACo5+AVIOMehpUKrbmA9VmyTRLML7U7T
	 hKjO8FpgWQys6GtMqreVVZSOWxsFQpNuYLiF8CPSpFHFgagLpoHdFEcj+MwS5QQtN0
	 G6DIkpmB9ZpdQ==
From: Mat Martineau <martineau@kernel.org>
Subject: [PATCH net-next 0/5] mptcp: Refactor inet_accept() and MIB updates
Date: Wed, 17 May 2023 12:16:13 -0700
Message-Id: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP0nZWQC/zWNwQqDMBBEf0X23AXdoqT9ldJDNNO6lyhJKAHx3
 12FHubwZpiZjTKSItOz2Sjhp1mXaNDdGppmH79gDcYkrdzbvhs4IwaOKKZa2Gy5bBfgnZPHgF7
 IyqPP4DH5OM1nHXVdUjmDNeGj9Xp80X+H3vt+AOmBpZuLAAAA
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

Patches 1 and 2 refactor inet_accept() to provide a new __inet_accept()
that's usable with locked sockets, and then make use of that helper to
simplify mptcp_stream_accept().

Patches 3 and 4 add some new MIBS related to MPTCP address advertisement
and update related selftest scripts.

Patch 5 modifies the selftests to ensure MIBS are only printed once when
a test case fails.

Signed-off-by: Mat Martineau <martineau@kernel.org>
---
Paolo Abeni (5):
      inet: factor out locked section of inet_accept() in a new helper
      mptcp: refactor mptcp_stream_accept()
      mptcp: introduces more address related mibs
      selftests: mptcp: add explicit check for new mibs
      selftests: mptcp: centralize stats dumping

 include/net/inet_common.h                       |   2 +
 net/ipv4/af_inet.c                              |  32 +++----
 net/mptcp/mib.c                                 |   6 ++
 net/mptcp/mib.h                                 |  18 ++++
 net/mptcp/options.c                             |   5 +-
 net/mptcp/pm.c                                  |   6 +-
 net/mptcp/protocol.c                            |  21 +++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 112 +++++++++++++-----------
 8 files changed, 122 insertions(+), 80 deletions(-)
---
base-commit: af2eab1a824349cfb0f6a720ad06eea48e9e6b74
change-id: 20230516-send-net-next-20220516-8dea88296e52

Best regards,
-- 
Mat Martineau <martineau@kernel.org>


