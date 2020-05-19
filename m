Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726F51D9D21
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgESQpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:45:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:49676 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgESQpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:45:43 -0400
IronPort-SDR: nPWdz64cdutvQPGzMWohidFqAnc18Jxf+n2BqLkIlcO1NbwRcHDo5vJr8I2dwlUhNFhzRLHYDW
 pUL1FPK8qeSg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 09:45:42 -0700
IronPort-SDR: scU4BeV9PwU040qBzt4QH7647csY4ywEKrmkWHsmhsTU2VYg+rpZYdZkEjnUg/KeUEdPMxBe/0
 5P7Eb7IbJoaA==
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="343193477"
Received: from tmalsbar-mobl2.sea.intel.com ([10.255.230.83])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 09:45:42 -0700
From:   Todd Malsbary <todd.malsbary@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Christoph Paasch <cpaasch@apple.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] mptcp: use rightmost 64 bits in ADD_ADDR HMAC
Date:   Tue, 19 May 2020 09:45:34 -0700
Message-Id: <20200519164534.147058-1-todd.malsbary@linux.intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changes the HMAC used in the ADD_ADDR option from the leftmost 64
bits to the rightmost 64 bits as described in RFC 8684, section 3.4.1.

This issue was discovered while adding support to packetdrill for the
ADD_ADDR v1 option.

Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Todd Malsbary <todd.malsbary@linux.intel.com>
Acked-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ece6f92cf7d1..0e11fb3d908f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -550,7 +550,7 @@ static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
 
-	return get_unaligned_be64(hmac);
+	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -567,7 +567,7 @@ static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
 
-	return get_unaligned_be64(hmac);
+	return get_unaligned_be64(&hmac[MPTCP_ADDR_HMAC_LEN - sizeof(u64)]);
 }
 #endif
 
-- 
2.25.4

