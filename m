Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D56F66EA
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKJCke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfKJCkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FCA9222C4;
        Sun, 10 Nov 2019 02:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353632;
        bh=H6WRcRF4jr5TKpnkFhGUjOIpidjg4AoHJXVq/R2DmTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPWZWmrs+U37S2EQ+w7t2vNPp8zy+H/dH3PkgYDFUBhNQl3MOr6VYqZo2yoJ+cmJK
         ykmg8D5xfixo3cXW3DFP5/b+26RJkaHhmSna6r7Y4bDU6Y1N4Y/HP4wxnwoQ/ZpoGW
         yek4PuVvtbePeG8OrOQ9EjPhXwyNVx+4pNdzsnD4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 015/191] samples/bpf: fix a compilation failure
Date:   Sat,  9 Nov 2019 21:37:17 -0500
Message-Id: <20191110024013.29782-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 534e0e52bc23de588e81b5a6f75e10c8c4b189fc ]

samples/bpf build failed with the following errors:

  $ make samples/bpf/
  ...
  HOSTCC  samples/bpf/sockex3_user.o
  /data/users/yhs/work/net-next/samples/bpf/sockex3_user.c:16:8: error: redefinition of ‘struct bpf_flow_keys’
   struct bpf_flow_keys {
          ^
  In file included from /data/users/yhs/work/net-next/samples/bpf/sockex3_user.c:4:0:
  ./usr/include/linux/bpf.h:2338:9: note: originally defined here
    struct bpf_flow_keys *flow_keys;
           ^
  make[3]: *** [samples/bpf/sockex3_user.o] Error 1

Commit d58e468b1112d ("flow_dissector: implements flow dissector BPF hook")
introduced struct bpf_flow_keys in include/uapi/linux/bpf.h and hence
caused the naming conflict with samples/bpf/sockex3_user.c.

The fix is to rename struct bpf_flow_keys in samples/bpf/sockex3_user.c
to flow_keys to avoid the conflict.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/sockex3_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index 5ba3ae9d180ba..22f74d0e14934 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -13,7 +13,7 @@
 #define PARSE_IP_PROG_FD (prog_fd[0])
 #define PROG_ARRAY_FD (map_fd[0])
 
-struct bpf_flow_keys {
+struct flow_keys {
 	__be32 src;
 	__be32 dst;
 	union {
@@ -64,7 +64,7 @@ int main(int argc, char **argv)
 	(void) f;
 
 	for (i = 0; i < 5; i++) {
-		struct bpf_flow_keys key = {}, next_key;
+		struct flow_keys key = {}, next_key;
 		struct pair value;
 
 		sleep(1);
-- 
2.20.1

