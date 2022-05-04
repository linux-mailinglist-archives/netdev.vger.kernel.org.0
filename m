Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5529251AF16
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357442AbiEDUdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242751AbiEDUdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E154FC47
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 719AFB828EA
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E455FC385A4;
        Wed,  4 May 2022 20:29:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FFrSFPT5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXUXIRy0jjJgFCxyFXWQ3B/2zHeD/g4PR8nNav/mZg0=;
        b=FFrSFPT5yhLBahpG2lk5Bxpt43M05PTAbIX0PV45ZdbFc49/z5j/CRK17ygWKqdpq+Cxt1
        T5+EPBVgaAqzHtCmF5ZVTs3bWKt6Soj/eUZzaCl0vFrpDoM3KnX7QOblZQMElVJlqTjJ6G
        DLDfl4D3qYp3rZgaVjHC2rUtbAyaSLg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 19546d6d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/6] wireguard: selftests: limit parallelism to $(nproc) tests at once
Date:   Wed,  4 May 2022 22:29:16 +0200
Message-Id: <20220504202920.72908-3-Jason@zx2c4.com>
In-Reply-To: <20220504202920.72908-1-Jason@zx2c4.com>
References: <20220504202920.72908-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parallel tests were added to catch queueing issues from multiple
cores. But what happens in reality when testing tons of processes is
that these separate threads wind up fighting with the scheduler, and we
wind up with contention in places we don't care about that decrease the
chances of hitting a bug. So just do a test with the number of CPU
cores, rather than trying to scale up arbitrarily.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 8a543200a61a..69c7796c7ca9 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -22,10 +22,12 @@
 # interfaces in $ns1 and $ns2. See https://www.wireguard.com/netns/ for further
 # details on how this is accomplished.
 set -e
+shopt -s extglob
 
 exec 3>&1
 export LANG=C
 export WG_HIDE_KEYS=never
+NPROC=( /sys/devices/system/cpu/cpu+([0-9]) ); NPROC=${#NPROC[@]}
 netns0="wg-test-$$-0"
 netns1="wg-test-$$-1"
 netns2="wg-test-$$-2"
@@ -143,17 +145,15 @@ tests() {
 	n1 iperf3 -Z -t 3 -b 0 -u -c fd00::2
 
 	# TCP over IPv4, in parallel
-	for max in 4 5 50; do
-		local pids=( )
-		for ((i=0; i < max; ++i)) do
-			n2 iperf3 -p $(( 5200 + i )) -s -1 -B 192.168.241.2 &
-			pids+=( $! ); waitiperf $netns2 $! $(( 5200 + i ))
-		done
-		for ((i=0; i < max; ++i)) do
-			n1 iperf3 -Z -t 3 -p $(( 5200 + i )) -c 192.168.241.2 &
-		done
-		wait "${pids[@]}"
+	local pids=( ) i
+	for ((i=0; i < NPROC; ++i)) do
+		n2 iperf3 -p $(( 5200 + i )) -s -1 -B 192.168.241.2 &
+		pids+=( $! ); waitiperf $netns2 $! $(( 5200 + i ))
 	done
+	for ((i=0; i < NPROC; ++i)) do
+		n1 iperf3 -Z -t 3 -p $(( 5200 + i )) -c 192.168.241.2 &
+	done
+	wait "${pids[@]}"
 }
 
 [[ $(ip1 link show dev wg0) =~ mtu\ ([0-9]+) ]] && orig_mtu="${BASH_REMATCH[1]}"
-- 
2.35.1

