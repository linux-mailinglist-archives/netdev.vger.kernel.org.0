Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB4D4455ED
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhKDPDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:03:08 -0400
Received: from mail.bitwise.fi ([109.204.228.163]:45188 "EHLO mail.bitwise.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhKDPDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 11:03:07 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 11:03:07 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.bitwise.fi (Postfix) with ESMTP id 51FA2460026;
        Thu,  4 Nov 2021 16:51:03 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mail.bitwise.fi ([127.0.0.1])
        by localhost (mustetatti.dmz.bitwise.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mMmti2dS-Exf; Thu,  4 Nov 2021 16:51:00 +0200 (EET)
Received: from localhost.net (fw1.dmz.bitwise.fi [192.168.69.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: anssiha)
        by mail.bitwise.fi (Postfix) with ESMTPSA id 9F54A460046;
        Thu,  4 Nov 2021 16:51:00 +0200 (EET)
From:   Anssi Hannula <anssi.hannula@bitwise.fi>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, Phil Sutter <phil@nwl.cc>,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Subject: [PATCH iproute2] man: tc-u32: Fix page to match new firstfrag behavior
Date:   Thu,  4 Nov 2021 16:42:05 +0200
Message-Id: <20211104144203.3581611-1-anssi.hannula@bitwise.fi>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 690b11f4a6b8 ("tc: u32: Fix firstfrag filter.") applied in 2012
changed the "ip firstfrag" selector to not match non-fragmented packets
anymore.

However, the documentation added in f15a23966fff ("tc: add a man page
for u32 filter") in 2015 includes an example that relies on the previous
behavior (non-fragmented packet counted as first fragment).

Due to this, the example does not work correctly and does not actually
classify regular SSH packets.

Modify the example to use a raw u16 selector on the fragment offset to
make it work, and also make the firstfrag description more clear about
the current behavior.

Fixes: f15a23966fff ("tc: add a man page for u32 filter")
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Cc: Phil Sutter <phil@nwl.cc>
Cc: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
---

I suspect the original behavior was intentional, but the new one has
been out for 9 years now so I guess it is too late to change again.

 man/man8/tc-u32.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-u32.8 b/man/man8/tc-u32.8
index fec9af7f..507589bd 100644
--- a/man/man8/tc-u32.8
+++ b/man/man8/tc-u32.8
@@ -427,7 +427,7 @@ Also minimal header size for IPv4 and lack of IPv6 extension headers is assumed.
 IPv4 only, check certain flags and fragment offset values. Match if the packet
 is not a fragment
 .RB ( nofrag ),
-the first fragment
+the first fragment of a fragmented packet
 .RB ( firstfrag ),
 if Don't Fragment
 .RB ( df )
@@ -644,7 +644,7 @@ tc filter add dev eth0 parent 1:0 protocol ip \\
 tc filter add dev eth0 parent 1:0 protocol ip \\
         u32 ht 800: \\
         match ip protocol 6 FF \\
-        match ip firstfrag \\
+        match u16 0 1fff at 6 \\
         offset at 0 mask 0f00 shift 6 \\
         link 1:
 .EE
-- 
2.31.1

