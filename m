Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73A02B2B3F
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 05:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgKNEKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 23:10:00 -0500
Received: from novek.ru ([213.148.174.62]:35010 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgKNEKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 23:10:00 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 53C7C502E6C;
        Sat, 14 Nov 2020 07:10:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 53C7C502E6C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605327005; bh=ufRLmNxcaW/sju01n4BlG/GU7pHq/ui45wXfw4YCuGA=;
        h=From:To:Cc:Subject:Date:From;
        b=J4uxJfFXMs/1IwOgXUJuCMZMNYgMiBLcXKFlHUPJk4D7hey1cdB1624ypFrkeXdn1
         6d54NL+vxL3Rx7MfWdAh/3w5eVpzrmW0ygvRRtkhZFiQoPogW/+8y119pIq1Ggwv1X
         5ZyXqYjl46qQj8v4pnJKr6ksqc4zW9wvOSdK9b4o=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net] net/tls: fix corrupted data in recvmsg
Date:   Sat, 14 Nov 2020 07:09:42 +0300
Message-Id: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tcp socket has more data than Encrypted Handshake Message then
tls_sw_recvmsg will try to decrypt next record instead of returning
full control message to userspace as mentioned in comment. The next
message - usually Application Data - gets corrupted because it uses
zero copy for decryption that's why the data is not stored in skb
for next iteration. Disable zero copy for this case.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 95ab5545..e040be1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1808,6 +1808,7 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		if (to_decrypt <= len && !is_kvec && !is_peek &&
 		    ctx->control == TLS_RECORD_TYPE_DATA &&
+		    (!control || ctx->control == control) &&
 		    prot->version != TLS_1_3_VERSION &&
 		    !bpf_strp_enabled)
 			zc = true;
-- 
1.8.3.1

