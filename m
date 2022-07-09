Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D26C56C60F
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiGICxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGICxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E911A7AB1A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828F26256A
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4160C341CD;
        Sat,  9 Jul 2022 02:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335183;
        bh=791FcZbvrzXtwnf2kLpu/ojWqVeQVm34PW0H/EELjyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrKidCBhyS/MNLwLlGvLBdbT3Ks8W94g3QECcSsWodjMVfzULhORhMxelevoRXjo4
         Q5xw6r67x55ecSVU100U9q9X456dIjzfaYOpI5He5uu2Tygh8KujEW+2Ipo1J10+vP
         kgWwyh0SxiioUxyxCJK66meh/xbz/ZzuEryxu8bOL2O/kcoWSefURmBFJTPZ9JQS3B
         RLpQSpFfakBlrPx978L7qwPt2LWD3KizsXtoN3v8b2VpLa28D0ZaoFHeGR+Jilc/yK
         3juFNdx8vEWxv7feh5Z8myEekE5sf/TiQAp+skBgxDW/kB3oLU3lGKYxzMrtBasqOs
         hQejT5lKzLTwQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] tls: rx: add counter for NoPad violations
Date:   Fri,  8 Jul 2022 19:52:53 -0700
Message-Id: <20220709025255.323864-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220709025255.323864-1-kuba@kernel.org>
References: <20220709025255.323864-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed with Maxim add a counter for true NoPad violations.
This should help deployments catch unexpected padded records vs
just control records which always need re-encryption.

https://lore.kernel.org/all/b111828e6ac34baad9f4e783127eba8344ac252d.camel@nvidia.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/tls.rst | 4 ++++
 include/uapi/linux/snmp.h        | 1 +
 net/tls/tls_proc.c               | 1 +
 net/tls/tls_sw.c                 | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index 7a6643836e42..658ed3a71e1b 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -282,3 +282,7 @@ TLS implementation exposes the following per-namespace statistics
   number of RX records which had to be re-decrypted due to
   ``TLS_RX_EXPECT_NO_PAD`` mis-prediction. Note that this counter will
   also increment for non-data records.
+
+- ``TlsRxNoPadViolation`` -
+  number of data RX records which had to be re-decrypted due to
+  ``TLS_RX_EXPECT_NO_PAD`` mis-prediction.
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index fd83fb9e525a..4d7470036a8b 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -345,6 +345,7 @@ enum
 	LINUX_MIB_TLSDECRYPTERROR,		/* TlsDecryptError */
 	LINUX_MIB_TLSRXDEVICERESYNC,		/* TlsRxDeviceResync */
 	LINUX_MIB_TLSDECRYPTRETRY,		/* TlsDecryptRetry */
+	LINUX_MIB_TLSRXNOPADVIOL,		/* TlsRxNoPadViolation */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index ede9df13c398..68982728f620 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -21,6 +21,7 @@ static const struct snmp_mib tls_mib_list[] = {
 	SNMP_MIB_ITEM("TlsDecryptError", LINUX_MIB_TLSDECRYPTERROR),
 	SNMP_MIB_ITEM("TlsRxDeviceResync", LINUX_MIB_TLSRXDEVICERESYNC),
 	SNMP_MIB_ITEM("TlsDecryptRetry", LINUX_MIB_TLSDECRYPTRETRY),
+	SNMP_MIB_ITEM("TlsRxNoPadViolation", LINUX_MIB_TLSRXNOPADVIOL),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e12846d1871a..68d79ee48a56 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1596,6 +1596,8 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
 		     darg->tail != TLS_RECORD_TYPE_DATA)) {
 		darg->zc = false;
+		if (!darg->tail)
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXNOPADVIOL);
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTRETRY);
 		return decrypt_skb_update(sk, skb, dest, darg);
 	}
-- 
2.36.1

