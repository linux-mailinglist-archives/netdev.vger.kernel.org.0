Return-Path: <netdev+bounces-3147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D128705CA2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 068AC28135D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3517917E3;
	Wed, 17 May 2023 01:50:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E5017C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C15C433EF;
	Wed, 17 May 2023 01:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288253;
	bh=St+PSjn0UYuZ6pAcTnJEkE+TEFT0C2HJx6i4r8tnGb8=;
	h=From:To:Cc:Subject:Date:From;
	b=KHeKgqwsYnQuwVgmUwezHygaIAQNTGPtZ2cpeUt1ElaOg0eLMxQ1yFtiyJxQP1abb
	 2viv5QAvmsmtzCXyow24Genl/ccMqKjL9fPgORXIWPZW33Pf/jfvArEpUFKYW+sEvg
	 ceJjh/Z3LKwOlxthdNuJqYm/Zb5BVAfS2Mge/tX4Rm8rJ237A+hbkX0h/3pSstmpcW
	 elyrVydn2AwHKTO4uR+Fp5A6qpsYh34TFoU9OAnU+wm6EcZnU6DUYQ/IQAt0PZPCH3
	 vclRVbJOphc/iprU2kw7uJEmlRWUsIRAMpz8H13Y9Shv0lbiPdr/LTMO8/lGWJDMQs
	 lb8QVrvQNkxQQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	tariqt@nvidia.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/7] tls: rx: strp: fix inline crypto offload
Date: Tue, 16 May 2023 18:50:35 -0700
Message-Id: <20230517015042.1243644-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The local strparser version I added to TLS does not preserve
decryption status, which breaks inline crypto (NIC offload).

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


