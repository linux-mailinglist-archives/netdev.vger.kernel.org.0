Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D897462045
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbhK2TXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344344AbhK2TVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:21:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B764DC0619D4;
        Mon, 29 Nov 2021 07:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F973CE1302;
        Mon, 29 Nov 2021 15:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE3C53FCF;
        Mon, 29 Nov 2021 15:39:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MB8Dq5go"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Aba6aA6q9ogO13EXrfpw6br4OENwKZzEo/2XtBkfPE=;
        b=MB8Dq5gog3oDch096tuUa4cRJrKwtFtgKq+qgblXydVowY2yZqwWSScTUwlGqAsrNkZg0o
        65I2kVVQZwK2LWRdqXMHeXFfjF+Hiv8FM/QeuynZDooSLZI2gbq1FWTqtb/wYQR9ZS+XhT
        GbwbLaAfXy/QgT50+AxEL8BXWRLKuig=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 0ed898ba (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH net 02/10] wireguard: selftests: increase default dmesg log size
Date:   Mon, 29 Nov 2021 10:39:21 -0500
Message-Id: <20211129153929.3457-3-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The selftests currently parse the kernel log at the end to track
potential memory leaks. With these tests now reading off the end of the
buffer, due to recent optimizations, some creation messages were lost,
making the tests think that there was a free without an alloc. Fix this
by increasing the kernel log size.

Fixes: 24b70eeeb4f4 ("wireguard: use synchronize_net rather than synchronize_rcu")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 74db83a0aedd..a9b5a520a1d2 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -66,6 +66,7 @@ CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_CONSOLE_LOGLEVEL_DEFAULT=15
+CONFIG_LOG_BUF_SHIFT=18
 CONFIG_PRINTK_TIME=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_LEGACY_VSYSCALL_NONE=y
-- 
2.34.1

