Return-Path: <netdev+bounces-1626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF306FE942
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B65201C20D2C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB7563B;
	Thu, 11 May 2023 01:20:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08604620
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3B9C433EF;
	Thu, 11 May 2023 01:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768041;
	bh=XC3YMuaiDHLortmFHjdiCgMg1ZwQaX56koOncz4/fBk=;
	h=From:To:Cc:Subject:Date:From;
	b=jyUhE3GprLGMAgJtttu7Vh8DeZHnRqeXbTs8plKLn80AA8kSl5H4AVr+3JlUssqqH
	 uVPfRaMf/UnEZ13ktsUcYg4se4AxYhRGazfFSR30i+Ju1ZO1eQung2alG08hICGbTb
	 O+OWHg16UvNGo6sJNZNeYhXtU8ljXJ2bAxCpdGzLlX+x4Fh6fDnvyFHsZF2jY+UFXP
	 mUV37BApcVgY84TMwuJ05aQG8rcH51pb37Mi0G02mt/a0aeDDlz0OsJRGos/XpaWm4
	 IYrpFOWIdv2D4nH/mnqgPECp8cEd/ox+ygQXG4Ooy3XkPgb+df+NNuRfog66WCThvp
	 +vSH9ulrHQoTg==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 0/7] tls: rx: strp: fix inline crypto offload
Date: Wed, 10 May 2023 18:20:27 -0700
Message-Id: <20230511012034.902782-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tariq, here are the fixes for the bug you reported.
I managed to test with mlx5 (and selftest, obviously).
I hacked things up for testing to trigger the copy and
reencrypt paths.

Could you run it thru your tests and LMK if there are
any more regressions?

Jakub Kicinski (7):
  tls: rx: device: fix checking decryption status
  tls: rx: strp: set the skb->len of detached / CoW'ed skbs
  tls: rx: strp: force mixed decrypted records into copy mode
  tls: rx: strp: fix determining record length in copy mode
  tls: rx: strp: factor out copying skb data
  tls: rx: strp: preserve decryption status of skbs when needed
  tls: rx: strp: don't use GFP_KERNEL in softirq context

 include/linux/skbuff.h |  10 +++
 include/net/tls.h      |   1 +
 net/tls/tls.h          |   5 ++
 net/tls/tls_device.c   |  22 ++---
 net/tls/tls_strp.c     | 185 +++++++++++++++++++++++++++++++++--------
 net/tls/tls_sw.c       |   4 +
 6 files changed, 177 insertions(+), 50 deletions(-)

-- 
2.40.1


