Return-Path: <netdev+bounces-11756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2DA734511
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 08:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FBA11C20A3A
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 06:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C501EDD;
	Sun, 18 Jun 2023 06:30:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148AA21
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 06:30:11 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686971717;
	Sat, 17 Jun 2023 23:30:06 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 2E07E5FD23;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1687069802;
	bh=u+fcFS3dqsuVQT3On0sBLY1S/hTyjxjZms+L7QfEFpw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Uu+85clokbFCTR26zd33Y/qeOKNu75KB2yyD5BrPDtojIwaGeN9ymBJbvS4838fRX
	 CV/uN78NuTHd9wCFd7Q3SMgup88aVikKqXoV6kCqsFd5cwQ8My5O+UT0U8wk9axEER
	 RRRah44iWGrPfz4JE1mokI/0Ahu5ZWi+bRkBNGQqmJpQIcnsg25mZkSDDXX3W0VP04
	 3AdRSY2YJYj3YGXCXJsRaD2TpUN+TbQtiEHWYJTdGOdRLtif3vMlFFdVc2BIfXrCkF
	 sn+8WpJP0mWzXM5Gg5575GJXkq1lAlsKbdD/umaCXQRmFGToLUghC0skd93Rlp7EzQ
	 vnym1wVECNy8g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sun, 18 Jun 2023 09:29:56 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 0/4] virtio/vsock: some updates for MSG_PEEK flag
Date: Sun, 18 Jun 2023 09:24:47 +0300
Message-ID: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/18 01:53:00 #21507494
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

This patchset does several things around MSG_PEEK flag support. In
general words it reworks MSG_PEEK test and adds support for this flag
in SOCK_SEQPACKET logic. Here is per-patch description:

1) This is cosmetic change for SOCK_STREAM implementation of MSG_PEEK:
   1) I think there is no need of "safe" mode walk here as there is no
      "unlink" of skbs inside loop (it is MSG_PEEK mode - we don't change
      queue).
   2) Nested while loop is removed: in case of MSG_PEEK we just walk
      over skbs and copy data from each one. I guess this nested loop
      even didn't behave as loop - it always executed just for single
      iteration.

2) This adds MSG_PEEK support for SOCK_SEQPACKET. It could be implemented
   be reworking MSG_PEEK callback for SOCK_STREAM to support SOCK_SEQPACKET
   also, but I think it will be more simple and clear from potential
   bugs to implemented it as separate function thus not mixing logics
   for both types of socket. So I've added it as dedicated function.

3) This is reworked MSG_PEEK test for SOCK_STREAM. Previous version just
   sent single byte, then tried to read it with MSG_PEEK flag, then read
   it in normal way. New version is more complex: now sender uses buffer
   instead of single byte and this buffer is initialized with random
   values. Receiver tests several things:
   1) Read empty socket with MSG_PEEK flag.
   2) Read part of buffer with MSG_PEEK flag.
   3) Read whole buffer with MSG_PEEK flag, then checks that it is same
      as buffer from 2) (limited by size of buffer from 2) of course).
   4) Read whole buffer without any flags, then checks that is is same
      as buffer from 3).

4) This is MSG_PEEK test for SOCK_SEQPACKET. It works in the same way
   as for SOCK_STREAM, except it also checks combination of MSG_TRUNC
   and MSG_PEEK.

Head is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b

Arseniy Krasnov (4):
  virtio/vsock: rework MSG_PEEK for SOCK_STREAM
  virtio/vsock: support MSG_PEEK for SOCK_SEQPACKET
  vsock/test: rework MSG_PEEK test for SOCK_STREAM
  vsock/test: MSG_PEEK test for SOCK_SEQPACKET

 net/vmw_vsock/virtio_transport_common.c | 104 +++++++++++++++-----
 tools/testing/vsock/vsock_test.c        | 124 ++++++++++++++++++++++--
 2 files changed, 196 insertions(+), 32 deletions(-)

-- 
2.25.1


