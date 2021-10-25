Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6DF43A598
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhJYVP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhJYVP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:15:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C8860E05;
        Mon, 25 Oct 2021 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635196386;
        bh=01iIj49VElT6TxzwlH2LuH1RkkRDZAWZcL+HbJ6Tfos=;
        h=From:To:Cc:Subject:Date:From;
        b=RAwiXnqdWfSWuhGEEmo5Exx4YcI688hOL5Gd45gpTSvLCwk7JKUbGAg7orzXTXcFv
         RS45vvWuH3a4r4ekE6LsvA4i5JUY4IdW6B0NFjYvKvVhSbs4/AICXOIXyfob8FOGpW
         7i8Ce3HT2Dfn1CN54u3KJHTWbGJ+39eo03p2LAdhSk8GSbLjawrTvLy7KfbKIAjVsf
         tr6SBYTl40R+aahuACM1qoaKsljTFnhyOQsGpWM26DKJ7K54P7hCH7+vgJ/hvK8yvf
         YKXi8WSlfsLEGnh7NQTNd5N6LNEA2JR7El4nD/6ffiSXoARytzTuB8D0ZyHCbkV69e
         dckyieN7dZszA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 1/2] net: ax88796c: Fix clang -Wimplicit-fallthrough in ax88796c_set_mac()
Date:   Mon, 25 Oct 2021 14:12:38 -0700
Message-Id: <20211025211238.178768-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.1.637.gf443b226ca
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/asix/ax88796c_main.c:696:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
        case SPEED_10:
        ^
drivers/net/ethernet/asix/ax88796c_main.c:696:2: note: insert 'break;' to avoid fall-through
        case SPEED_10:
        ^
        break;
drivers/net/ethernet/asix/ax88796c_main.c:706:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
        case DUPLEX_HALF:
        ^
drivers/net/ethernet/asix/ax88796c_main.c:706:2: note: insert 'break;' to avoid fall-through
        case DUPLEX_HALF:
        ^
        break;

Clang is a little more pedantic than GCC, which permits implicit
fallthroughs to cases that contain just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing breaks to fix
the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1491
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index cfc597f72e3d..cf0f96f93f3b 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -693,6 +693,7 @@ static void ax88796c_set_mac(struct  ax88796c_device *ax_local)
 	switch (ax_local->speed) {
 	case SPEED_100:
 		maccr |= MACCR_SPEED_100;
+		break;
 	case SPEED_10:
 	case SPEED_UNKNOWN:
 		break;
@@ -703,6 +704,7 @@ static void ax88796c_set_mac(struct  ax88796c_device *ax_local)
 	switch (ax_local->duplex) {
 	case DUPLEX_FULL:
 		maccr |= MACCR_SPEED_100;
+		break;
 	case DUPLEX_HALF:
 	case DUPLEX_UNKNOWN:
 		break;

base-commit: dcd63d4326802cec525de2a4775019849958125c
-- 
2.33.1.637.gf443b226ca

