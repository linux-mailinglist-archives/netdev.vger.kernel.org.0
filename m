Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58B11A9CC7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897256AbgDOLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897191AbgDOLg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3067D20936;
        Wed, 15 Apr 2020 11:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950618;
        bh=5KeCAVtoMwPKXDT6A0LjaClAan+jh+idXoAY0C6EKHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjd5mGFnUPF/gRqXr4D3UMYjrHWAoJF4huiMSGwitJpaSHT4rZEMIDpPe7+8zVA9J
         5Z0id42S/foXjyyHyfEPLlZGA6XLC3x3MOl/i00+1W1vrH3npoFXjJqZIbpsc11qFQ
         E7pHMltYc6UREb4t/jnUNfK/shB03XT6hU+v15fw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 110/129] SUNRPC: fix krb5p mount to provide large enough buffer in rq_rcvsize
Date:   Wed, 15 Apr 2020 07:34:25 -0400
Message-Id: <20200415113445.11881-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit df513a7711712758b9cb1a48d86712e7e1ee03f4 ]

Ever since commit 2c94b8eca1a2 ("SUNRPC: Use au_rslack when computing
reply buffer size"). It changed how "req->rq_rcvsize" is calculated. It
used to use au_cslack value which was nice and large and changed it to
au_rslack value which turns out to be too small.

Since 5.1, v3 mount with sec=krb5p fails against an Ontap server
because client's receive buffer it too small.

For gss krb5p, we need to account for the mic token in the verifier,
and the wrap token in the wrap token.

RFC 4121 defines:
mic token
Octet no   Name        Description
         --------------------------------------------------------------
         0..1     TOK_ID     Identification field.  Tokens emitted by
                             GSS_GetMIC() contain the hex value 04 04
                             expressed in big-endian order in this
                             field.
         2        Flags      Attributes field, as described in section
                             4.2.2.
         3..7     Filler     Contains five octets of hex value FF.
         8..15    SND_SEQ    Sequence number field in clear text,
                             expressed in big-endian order.
         16..last SGN_CKSUM  Checksum of the "to-be-signed" data and
                             octet 0..15, as described in section 4.2.4.

that's 16bytes (GSS_KRB5_TOK_HDR_LEN) + chksum

wrap token
Octet no   Name        Description
         --------------------------------------------------------------
          0..1     TOK_ID    Identification field.  Tokens emitted by
                             GSS_Wrap() contain the hex value 05 04
                             expressed in big-endian order in this
                             field.
          2        Flags     Attributes field, as described in section
                             4.2.2.
          3        Filler    Contains the hex value FF.
          4..5     EC        Contains the "extra count" field, in big-
                             endian order as described in section 4.2.3.
          6..7     RRC       Contains the "right rotation count" in big-
                             endian order, as described in section
                             4.2.5.
          8..15    SND_SEQ   Sequence number field in clear text,
                             expressed in big-endian order.
          16..last Data      Encrypted data for Wrap tokens with
                             confidentiality, or plaintext data followed
                             by the checksum for Wrap tokens without
                             confidentiality, as described in section
                             4.2.4.

Also 16bytes of header (GSS_KRB5_TOK_HDR_LEN), encrypted data, and cksum
(other things like padding)

RFC 3961 defines known cksum sizes:
Checksum type              sumtype        checksum         section or
                                value            size         reference
   ---------------------------------------------------------------------
   CRC32                            1               4           6.1.3
   rsa-md4                          2              16           6.1.2
   rsa-md4-des                      3              24           6.2.5
   des-mac                          4              16           6.2.7
   des-mac-k                        5               8           6.2.8
   rsa-md4-des-k                    6              16           6.2.6
   rsa-md5                          7              16           6.1.1
   rsa-md5-des                      8              24           6.2.4
   rsa-md5-des3                     9              24             ??
   sha1 (unkeyed)                  10              20             ??
   hmac-sha1-des3-kd               12              20            6.3
   hmac-sha1-des3                  13              20             ??
   sha1 (unkeyed)                  14              20             ??
   hmac-sha1-96-aes128             15              20         [KRB5-AES]
   hmac-sha1-96-aes256             16              20         [KRB5-AES]
   [reserved]                  0x8003               ?         [GSS-KRB5]

Linux kernel now mainly supports type 15,16 so max cksum size is 20bytes.
(GSS_KRB5_MAX_CKSUM_LEN)

Re-use already existing define of GSS_KRB5_MAX_SLACK_NEEDED that's used
for encoding the gss_wrap tokens (same tokens are used in reply).

Fixes: 2c94b8eca1a2 ("SUNRPC: Use au_rslack when computing reply buffer size")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 24ca861815b1d..d6cd2a519d9fb 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -20,6 +20,7 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/auth_gss.h>
+#include <linux/sunrpc/gss_krb5.h>
 #include <linux/sunrpc/svcauth_gss.h>
 #include <linux/sunrpc/gss_err.h>
 #include <linux/workqueue.h>
@@ -1050,7 +1051,7 @@ gss_create_new(const struct rpc_auth_create_args *args, struct rpc_clnt *clnt)
 		goto err_put_mech;
 	auth = &gss_auth->rpc_auth;
 	auth->au_cslack = GSS_CRED_SLACK >> 2;
-	auth->au_rslack = GSS_VERF_SLACK >> 2;
+	auth->au_rslack = GSS_KRB5_MAX_SLACK_NEEDED >> 2;
 	auth->au_verfsize = GSS_VERF_SLACK >> 2;
 	auth->au_ralign = GSS_VERF_SLACK >> 2;
 	auth->au_flags = 0;
-- 
2.20.1

