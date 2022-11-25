Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1044639174
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiKYWbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKYWak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:30:40 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7D56573
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:32 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ho10so13079053ejc.1
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1JR5Int83weGmlDAZ8KCrVS6bbZMLt4JJ3mk20BbRU=;
        b=RWKW8xV74p4li70/5s11jS4IMkdN4+7dKoqNldNA7UJtb4Za3VO0dPs8G39JsRzUGu
         +o2P9Km+PZyYTlHfnUUdTKa5bATCZFfcIjWnOSZdXnDQPc4TWFPESbOzozEsovGsAsO+
         m2ZIFsnekdYcooRTDcsm7DgJG4Pbt9HdW3BL1y5SL6kVPS8ljHrqaC4btj82QFfIWqPE
         N7BhXB7YCjZjQ8zLls9AH++MPQYD7OgxBJ3A1CNbBKyxsxB2vpY2dBX1UZbuaNNmPJlH
         HJkNHkHzMn1nxu/GjCRkugB4ZzETsKPR5mCKklI+cwQV1cXPHowQ2LgX+uDsHqEqAEaS
         lA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1JR5Int83weGmlDAZ8KCrVS6bbZMLt4JJ3mk20BbRU=;
        b=vuERPE5yMDtd1EybA0YZ+Tp2Zee0LLaRxbHJy2ui2o/yeICkp8/H0ilztSeJw84+3M
         lupJJiH84PIDaTxa3RX91GJODHlN27AXKj9PfShxtWOwlCcGP58kUt7o5AIFFuOSGUML
         Z5lGBpMzAA3M/7aDwdfkgqcBEaptL6a8l8+nHigeS8NSTtjO7q4Eb5ABXsKX0ST03RxR
         zStJMcNzr2r/zsadcbJQAdB8LyNyU32mi14TsGtCvPw2N/Lb0pXqBsFaDj9+jDJEMTIT
         KIzXdLf5i9KAg6uD5HvAQomW9Z0yK/ydVm6W8tHbeNRpiCj/ayPKkmjUn4SXMaL5+2l0
         0SxA==
X-Gm-Message-State: ANoB5pmXFXX/H+mG999wA6IS19EPWyTusG3iB1Z3PGFr4m3hjZ/yyLJw
        rUku9d5nLXmGcj0aZjvnRCCOrw==
X-Google-Smtp-Source: AA0mqf6/KaVU8ozp1mPAfv+uvG0KA7+NnHu3Lv4jEQzLA+NDOIARu1lAoMykMsNVUIpXNklan6SN7w==
X-Received: by 2002:a17:906:4dcb:b0:7bb:d6e5:6b1c with SMTP id f11-20020a1709064dcb00b007bbd6e56b1cmr7575596ejw.104.1669415431000;
        Fri, 25 Nov 2022 14:30:31 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id q1-20020a056402248100b0046267f8150csm2254612eda.19.2022.11.25.14.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:30:30 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] mptcp: add support for TCP_FASTOPEN_KEY sockopt
Date:   Fri, 25 Nov 2022 23:29:53 +0100
Message-Id: <20221125222958.958636-8-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1958; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=8soZSefjdC1P5SPfpTSfBA9V7b6DGdkwS8pfXBGPBIk=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjgUHQCot9Zm8fgwY3GN6Emj0jLhXjYgKZQVRSfcZm
 +EK5pgGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4FB0AAKCRD2t4JPQmmgc81PEA
 DdalZkgR4/ghd4mFPTlTnp7uG0BFTlS1tyM3PG7S6Fgr/APXIEq9KJ5ZiNbWgvK3KuAIJcI/TZmWLF
 Jei7MndFIqbYYZ49hnG2G36CivbeR362ir2Mb9dpOq7UWq1oJ5b0LN5r8NZmwkdC+/JH13l7XZMHXj
 RizEcuS7gMc6jtg8KtoDTE6QWaOh9RiYMWRkEcyT5TW0qwHF80x6BJLJmtUs85891b4Vi3N+vMtuij
 hgpk1KfGLCczOwK7duRP5EjC7OtPTZk9HLqDjlKohLpMJM3ei2UlgcWqeF+MYstQ5BTGbBnEs9/HVM
 OzrzmQvi6QRJsjNyoG+7njrN3zV6y165jtOtjoNlfbWyXGPEuZuzhV2JX2XBJWyvjGFeRWJeojule6
 N7ZihmUMUwpX9RYZUy8HtutZceHwGeio8rDKtHsYjDGpJxlR+Zvx+6NazM5xHNxMzUbKmdXAJXDxRd
 JSsynUxdJYJvofBsauB+qQgvQAUSBuBgLGvKcYzscJD0JjDxlxIcjW4KUBZczzhtGX/0Ib0kdeERiq
 xjUDT4xm95kQGnNS1zH3JAarn8TXzbMrIB20A1i0qE0nRJy4DWqwi5IH54t+qxn7ZdX1udL8GmSF5i
 /IARWmzBFTbJUkqj5LBKFiiD3iAfU5kxzeTuKnDs8o/G4DC2XxSJunl6C7cg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this socket option is to set different keys per listener,
see commit 1fba70e5b6be ("tcp: socket option to set TCP fast open key")
for more details about this socket option.

The only thing to do here with MPTCP is to relay the request to the
first subflow like it is already done for the other TCP_FASTOPEN* socket
options.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index c1bca711c35c..a47423ebb33a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -561,6 +561,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_INQ:
 		case TCP_FASTOPEN:
 		case TCP_FASTOPEN_CONNECT:
+		case TCP_FASTOPEN_KEY:
 		case TCP_FASTOPEN_NO_COOKIE:
 			return true;
 		}
@@ -570,9 +571,6 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		/* TCP_REPAIR, TCP_REPAIR_QUEUE, TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS,
 		 * TCP_REPAIR_WINDOW are not supported, better avoid this mess
 		 */
-		/* TCP_FASTOPEN_KEY is not supported because
-		 * fastopen for the listener side is currently unsupported
-		 */
 	}
 	return false;
 }
@@ -804,6 +802,7 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 		return 0;
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
+	case TCP_FASTOPEN_KEY:
 	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
@@ -1170,6 +1169,7 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_DEFER_ACCEPT:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
+	case TCP_FASTOPEN_KEY:
 	case TCP_FASTOPEN_NO_COOKIE:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
-- 
2.37.2

