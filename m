Return-Path: <netdev+bounces-10678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B41AB72FBF7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D3271C2084A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D1E6FD0;
	Wed, 14 Jun 2023 11:10:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC11FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:10:17 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8580F1BF6;
	Wed, 14 Jun 2023 04:10:15 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f8d0e814dfso4311455e9.3;
        Wed, 14 Jun 2023 04:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741013; x=1689333013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uaBKkQp1n+OMyFkJ4TccLXFe9/y5NjGE3wk3E7F2JvA=;
        b=aEQGBhuOhMcvepCZIHegFR8Z3BhLUEvvbWEn58YGVzQpFalk3Z1VE2mnjFNyoadmYo
         8vKcEtvcq4FyB8fhgwcUjGkHt9P3Vv0txXRkH4Arv26GcZaanWDsaz080KjinfxNdYwz
         YV2Z9O7moHXbRVMb95XyOtCL3QM923J3kimARa5/6rd0+B/vZDUjnBSDdYxZgQPZdfs0
         zGReWQHNmey1/c3G414HeOUQsIGSL6RBptQ62mfbsOlWUwfoEQusDacy8JpKHIsH1sjL
         7ie1QgbARdo5SdHxKIt4v+EAT0LQmcJPo/Zybev+B+TS3FbNN/6fN6bdATYEVEb469YV
         l4cg==
X-Gm-Message-State: AC+VfDwH+ydwPNtPwbR1y1hzkYIW+hLlMVYt45JbHSG3L6bTvEeKjgow
	MLDm/wpLmVN7N4xiQZtTcHAc2h5kp15bpQ==
X-Google-Smtp-Source: ACHHUZ79Tg78hSeMYf8i80+UZt8j9D/RlqBQsLBMUfXLapLy25sgMHC6tE+7wSGFK8RGyoW5cYNMeQ==
X-Received: by 2002:a05:600c:257:b0:3f8:dac6:58ee with SMTP id 23-20020a05600c025700b003f8dac658eemr645823wmj.5.1686741013367;
        Wed, 14 Jun 2023 04:10:13 -0700 (PDT)
Received: from localhost (fwdproxy-cln-007.fbsv.net. [2a03:2880:31ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id u26-20020a05600c211a00b003f42314832fsm17115663wml.18.2023.06.14.04.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:10:12 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: leit@fb.com,
	asml.silence@gmail.com,
	dsahern@kernel.org,
	matthieu.baerts@tessares.net,
	martineau@kernel.org,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dccp@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org,
	ast@kernel.org,
	kuniyu@amazon.com,
	martin.lau@kernel.org
Subject: [RFC PATCH v2 0/4] add initial io_uring_cmd support for sockets
Date: Wed, 14 Jun 2023 04:07:53 -0700
Message-Id: <20230614110757.3689731-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset creates the initial plumbing for a io_uring command for
sockets.

For now, create two uring commands for sockets, SOCKET_URING_OP_SIOCOUTQ
and SOCKET_URING_OP_SIOCINQ, which are available in TCP, UDP and RAW
sockets.

In order to test this code, I created a liburing test, which is
currently located at [1], and I will create a pull request once we are
good with this patchset.

V1 submission was sent a while ago[2], but it required more plumbing
that were done in different patch submissions[3][4].

PS: This patchset depends on a commit[4] that is not committed to the
tree yet (but close too, IMO).

[1] Link: https://github.com/leitao/liburing/blob/master/test/socket-io-cmd.c
[2] Link: https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
[3] Link: https://lore.kernel.org/lkml/0a50fae3-1cf4-475e-48ae-25f41967842f@kernel.dk/
[4] Link: https://lore.kernel.org/lkml/20230609152800.830401-1-leitao@debian.org/

V1->V2:
	* Rely on a generic socket->ioctl infrastructure instead of
	  reimplementing it

Breno Leitao (4):
  net: wire up support for file_operations->uring_cmd()
  net: add uring_cmd callback to UDP
  net: add uring_cmd callback to TCP
  net: add uring_cmd callback to raw "protocol"

 include/linux/net.h      |  2 ++
 include/net/raw.h        |  3 +++
 include/net/sock.h       |  6 ++++++
 include/net/tcp.h        |  2 ++
 include/net/udp.h        |  2 ++
 include/uapi/linux/net.h |  5 +++++
 net/core/sock.c          | 17 +++++++++++++++--
 net/dccp/ipv4.c          |  1 +
 net/ipv4/af_inet.c       |  3 +++
 net/ipv4/raw.c           | 23 +++++++++++++++++++++++
 net/ipv4/tcp.c           | 21 +++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  1 +
 net/ipv4/udp.c           | 22 ++++++++++++++++++++++
 net/l2tp/l2tp_ip.c       |  1 +
 net/mptcp/protocol.c     |  1 +
 net/sctp/protocol.c      |  1 +
 net/socket.c             | 13 +++++++++++++
 17 files changed, 122 insertions(+), 2 deletions(-)

-- 
2.34.1


