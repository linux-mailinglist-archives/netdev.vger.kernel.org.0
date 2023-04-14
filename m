Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE76E2553
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDNOJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjDNOJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:09:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE61BC154
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:51 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l18so17573002wrb.9
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681481311; x=1684073311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZhYE929PeAd0ZLAU9yqicLsmxgzSrjpBPOp2nmL8n0=;
        b=aqtuhrKb79sOWSOu6w3w1lpzSVh3Aokv6l+YXXFIQk+r0U0XQFAQqKBQLM5r7wKuig
         OycDp8uWtXg5G+e0+tVn6uv1AGd5hFY+wzwFgha++3wfanjGcmK9aXvavN7Ok2OJNlVV
         DxdVfuipATJj0lHVqp0Z3LCDMu9qIyxNRc5hHYG43D5lcpzinDtK4roPAWvZkbqTX3Z4
         8EdLMUw1qkgGCR9llXwHMpe1SKug/5WLudbCbnnR+36Yfn9vZUKUAMrvzUiOLqS+HKRC
         TEdFZ9CxNHMMhWXg/tTL3BdSAz3oEUbXDIDnbf62SuJj4LUdzUwzMNgJ3RxAiEq+B46K
         XAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681481311; x=1684073311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZhYE929PeAd0ZLAU9yqicLsmxgzSrjpBPOp2nmL8n0=;
        b=bhmMXttwlwfXOWLvSUH54hs2/YTJzvpCEYI/mlB+mSmoy2aPQiLr+VG/hsBxNu2cKx
         PjXEA1O0EPB66tIN+BXj11NtoA67z9b0ifjBd3nnJ8Tc2Vsak1Oh7+eCx2phauSaZk6A
         yLtDvzl8E416Vm/GCah/v+XV4eTI21bUdw+wyNGCD0GhjcJZUeZu1KAoBdrLE2cVvAl8
         WlhSc7IaDQYD33YgGmXVaJXbRGcCSxgOLwm70eJtzqDz57wWS9YQJfK7IH4IPdmA6IFl
         FiIV64gbE2tHczFjh2xu+0A5KhX4pf1UgAGEo5CTdtf27kZhXSRJLchgLxlRdo8/sSzS
         kaKQ==
X-Gm-Message-State: AAQBX9e9W1SArNNQY5abJFBJV4XUmdRUBnYCJLKdCFQy60sEo+d9nAH3
        U7DTonl/v2e2n6vTqG5fYQw0Hw==
X-Google-Smtp-Source: AKy350bC0YLATDwLaGi/WjX6qGTi/ArN0VO/DMfyxCq2ra8Uuxbp1f/Tr9reLgFfc0HAbymqwYQrWA==
X-Received: by 2002:a5d:4e11:0:b0:2f4:fd50:9cb8 with SMTP id p17-20020a5d4e11000000b002f4fd509cb8mr4382629wrt.42.1681481310078;
        Fri, 14 Apr 2023 07:08:30 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d58c5000000b002f47ae62fe0sm3648185wrf.115.2023.04.14.07.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 07:08:29 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 14 Apr 2023 16:08:02 +0200
Subject: [PATCH net-next 3/5] mptcp: move fastopen subflow check inside
 mptcp_sendmsg_fastopen()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-3-04d177057eb9@tessares.net>
References: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
In-Reply-To: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2817;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=P9n60YIe/mfn8CQZAad2UIBXi/vdPChGGnKW1QV+jTM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkOV5ZosafB8d9GNmNZ1meFhcnycRNpkZenoavp
 FVmCcOlLviJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDleWQAKCRD2t4JPQmmg
 cxHQD/4z3riXqfAZUhX4rcRrvxKx561jC5T5Wn/xk9PLqTfmLJM/J+uDRno+meTIsy3Gt0zlws5
 /zWj/eS3bIKsxwNffgmkKUDm59OH2DRnN6WN9mKXadPQ53+30TerpxmXB6GLGCxmMM2Fa22ZApE
 8EbRWfppLAO37JDArFx46THJ3SHS0Fghm5DmFbL6X9gdOSNCZElMiRn1mxRheOEaFqAtn0Zl2+w
 JLV6h+h1kV6RGfN36zxDzMOZhZIQnTcSqAB73D2enOuvukL/LW9nse2sS1Su7Uvu7x7867reBRX
 NydxcCYUemkiiZVRjePSOKxtc5L3GNoK++uAv78Ey1RdMivWGHmd12tfsP5E4ZB0RaqISBLOuoA
 DRnwJYNuJU0i5qGgcHX+q21Bo9GoXbxJsllDlIFJ2bGwXk2HLpVMoK83qpq3Owp86/dgPqWqc2R
 t9qzQO7UCOWO21uRpiDwf3KYtvAMOFINATu8zszRrKngatOAxKlO1cnyn+e9jFXoxw1OTx93NAx
 +XCSwQwkZh9lfY9CM/9GmFH+hLE+av2heTVPGaw6HbOklRTwGQZc1pjE4DuZnop6+ukd1JGeK5K
 6OUp9tsP2FShZcNXuOtG+EpEtUGXPEqRQTtPeK4tQ+MEitgxVJzwKFjW7cX7neAe0xevXESU/0m
 CsvfP0paDYtH01A==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

So that we can avoid a bunch of check in fastpath. Additionally we
can specialize such check according to the specific fastopen method
- defer_connect vs MSG_FASTOPEN.

The latter bits will simplify the next patches.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9cdcfdb44aee..22e073b373af 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1662,13 +1662,27 @@ static void mptcp_set_nospace(struct sock *sk)
 
 static int mptcp_disconnect(struct sock *sk, int flags);
 
-static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msghdr *msg,
+static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 				  size_t len, int *copied_syn)
 {
 	unsigned int saved_flags = msg->msg_flags;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sock *ssk;
 	int ret;
 
+	/* on flags based fastopen the mptcp is supposed to create the
+	 * first subflow right now. Otherwise we are in the defer_connect
+	 * path, and the first subflow must be already present.
+	 * Since the defer_connect flag is cleared after the first succsful
+	 * fastopen attempt, no need to check for additional subflow status.
+	 */
+	if (msg->msg_flags & MSG_FASTOPEN && !__mptcp_nmpc_socket(msk))
+		return -EINVAL;
+	if (!msk->first)
+		return -EINVAL;
+
+	ssk = msk->first;
+
 	lock_sock(ssk);
 	msg->msg_flags |= MSG_DONTWAIT;
 	msk->connect_flags = O_NONBLOCK;
@@ -1691,6 +1705,7 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 	} else if (ret && ret != -EINPROGRESS) {
 		mptcp_disconnect(sk, 0);
 	}
+	inet_sk(sk)->defer_connect = 0;
 
 	return ret;
 }
@@ -1699,7 +1714,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct page_frag *pfrag;
-	struct socket *ssock;
 	size_t copied = 0;
 	int ret = 0;
 	long timeo;
@@ -1709,12 +1723,10 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 
-	ssock = __mptcp_nmpc_socket(msk);
-	if (unlikely(ssock && (inet_sk(ssock->sk)->defer_connect ||
-			       msg->msg_flags & MSG_FASTOPEN))) {
+	if (unlikely(inet_sk(sk)->defer_connect || msg->msg_flags & MSG_FASTOPEN)) {
 		int copied_syn = 0;
 
-		ret = mptcp_sendmsg_fastopen(sk, ssock->sk, msg, len, &copied_syn);
+		ret = mptcp_sendmsg_fastopen(sk, msg, len, &copied_syn);
 		copied += copied_syn;
 		if (ret == -EINPROGRESS && copied_syn > 0)
 			goto out;

-- 
2.39.2

