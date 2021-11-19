Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF4456EAE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhKSMI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:08:28 -0500
Received: from smtp1.axis.com ([195.60.68.17]:15691 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhKSMI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1637323527;
  x=1668859527;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=57/QJ6in35nvPvU4ig8kvOqeNLXlQjO2HkYYKefPH8A=;
  b=V5HnyaO7fWb+WPv8Upjj+2s7EMr0DowlAdcyp0uRsC7VXfhKhhXpngGV
   GvneCUueSqCRRW44bN72sgXYbZIBrt7okQyP4D/aybGpqvn1crFFGNKsD
   enQqJ5+qMYWXt9zitWVgVbfYUKpq7nwVUuiss/ECgVepHcyd7ZX9z10i9
   UyN5m35FXL3PqOlgLYIPBg5i5HVLwgFqcA64C77+prYoYtMCM2dNYhcch
   uZuzCPj2A8o2LZETIg+lcOOUW7M3fEwDyPhOpTrR542lz7C+PH7VmUhKR
   8QTZuOuAd1l8x5qmFdOMbyoH3muFk7DtX2iUN3bKJHja8VeGDfLUhmrNS
   A==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH] af_unix: fix regression in read after shutdown
Date:   Fri, 19 Nov 2021 13:05:21 +0100
Message-ID: <20211119120521.18813-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On kernels before v5.15, calling read() on a unix socket after
shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
previously written or EOF.  But now, while read() after
shutdown(SHUT_RD) still behaves the same way, read() after
shutdown(SHUT_RDWR) always fails with -EINVAL.

This behaviour change was apparently inadvertently introduced as part of
a bug fix for a different regression caused by the commit adding sockmap
support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
unix_stream_proto for sockmap").  Those commits, for unclear reasons,
started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
while this state change had previously only been done in
unix_release_sock().

Restore the original behaviour.  The sockmap tests in
tests/selftests/bpf continue to pass after this patch.

Fixes: d0c6416bd7091647f60 ("unix: Fix an issue in unix_shutdown causing the other end read/write failures")
Link: https://lore.kernel.org/lkml/20211111140000.GA10779@axis.com/
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 net/unix/af_unix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 78e08e82c08c..b0bfc78e421c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2882,9 +2882,6 @@ static int unix_shutdown(struct socket *sock, int mode)
 
 	unix_state_lock(sk);
 	sk->sk_shutdown |= mode;
-	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
-	    mode == SHUTDOWN_MASK)
-		sk->sk_state = TCP_CLOSE;
 	other = unix_peer(sk);
 	if (other)
 		sock_hold(other);
-- 
2.33.1

