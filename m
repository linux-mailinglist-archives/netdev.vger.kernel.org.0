Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC20025F8AC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgIGKm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbgIGKmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:42:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E25C061573;
        Mon,  7 Sep 2020 03:42:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so3349081pjg.1;
        Mon, 07 Sep 2020 03:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=GvP4iFXXoq3p0iFcUHKogS3wXUFF8Mnk3rfmYJaO3RA=;
        b=eDY6abH6Dateob4AYMJ6MPQQ1R2iYfe4O2yNRABJidUvO8MYRbtZ5RhEoVFl+uRKXD
         C6uN+Lyxuolk0K/hvsDnqHjf5oCG6Ap5Raav38u4YBk0NR3M+LJAR2t8YzFmldQ69+cK
         C1DdYxj/C+/anY9n4U2udccI3XvxJm9ZMaI9SY2lMuoiIm1f+pAcC2EcyetTNJ9ljDdA
         I/0nglFJfMKERaHwXUpyUxDCsuSxOlHEEietpPwAlyKRiLgyZ05ShStLsZskbrbrlfsP
         DOas1nAVihDvtkYsAMuU53T68+j68MoLcULTL7MFwSOu5GAnPe8oTDMLb6wFVIT3Pd/s
         vk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=GvP4iFXXoq3p0iFcUHKogS3wXUFF8Mnk3rfmYJaO3RA=;
        b=XJV3M16pRspbxB42n5mhXtedtObju8V7K7VsRRuLZ/vdVKfX3QG1jmV6DUhcr83dP4
         ldd5jYjVCVoTO9Gifa6quLDjaql8UfJOLsU06uXU2eQqwk46OfwG85SZ/T4iQLp0Kec5
         vTTHkbjOUfXX5PIWWx4sxm0CxGmHGf8NZ5LcOmzSfR4unS5a61eh5bFflYcP9xdlkS/1
         OeQBD8lPKrckNwGGUymlhd8hB5XfB2eHi3VPLe3i9ViAqYR05X7+7uT7v5jLDch/KYbz
         m7O1cuAaNS20Ov9j2ty8pmL+25hKSKAKwz+FCun4FWlBjCUpoMRF91eYrJrqzKH1fOC0
         CyfQ==
X-Gm-Message-State: AOAM53017y7+9UJ0nQrljBtR4abqnAKRUlzY6wsxT1kA07trgLduij1j
        +odhvS5s4mRG8r1gkjSq0T8=
X-Google-Smtp-Source: ABdhPJyC4BGRwYAxiQNOGTDt8RFlE+FrU3E3jwKV7jZMEpweVm0hIav0i+zEEEcHeVZkWB1VkOV61Q==
X-Received: by 2002:a17:90a:414e:: with SMTP id m14mr18861206pjg.186.1599475367509;
        Mon, 07 Sep 2020 03:42:47 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id m190sm14307294pfm.184.2020.09.07.03.42.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Sep 2020 03:42:46 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net 2/2] mptcp: fix subflow's remote_id issues
Date:   Mon,  7 Sep 2020 18:29:54 +0800
Message-Id: <7187516ee5a9f17a7bf1e4aa9a849da2dd56a734.1599474422.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
References: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
In-Reply-To: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
References: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set the init remote_id to zero, otherwise it will be a random
number.

Then it added the missing subflow's remote_id setting code both in
__mptcp_subflow_connect and in subflow_ulp_clone.

Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/subflow.c    | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index dc2c57860d2d..255695221309 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -186,7 +186,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *local;
-	struct mptcp_addr_info remote;
+	struct mptcp_addr_info remote = { 0 };
 	struct pm_nl_pernet *pernet;
 
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e8cac2655c82..9ead43f79023 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1063,6 +1063,7 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_subflow_context *subflow;
 	struct sockaddr_storage addr;
+	int remote_id = remote->id;
 	int local_id = loc->id;
 	struct socket *sf;
 	struct sock *ssk;
@@ -1107,10 +1108,11 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 		goto failed;
 
 	mptcp_crypto_key_sha(subflow->remote_key, &remote_token, NULL);
-	pr_debug("msk=%p remote_token=%u local_id=%d", msk, remote_token,
-		 local_id);
+	pr_debug("msk=%p remote_token=%u local_id=%d remote_id=%d", msk,
+		 remote_token, local_id, remote_id);
 	subflow->remote_token = remote_token;
 	subflow->local_id = local_id;
+	subflow->remote_id = remote_id;
 	subflow->request_join = 1;
 	subflow->request_bkup = 1;
 	mptcp_info2sockaddr(remote, &addr);
@@ -1347,6 +1349,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
 		new_ctx->local_id = subflow_req->local_id;
+		new_ctx->remote_id = subflow_req->remote_id;
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;
 	}
-- 
2.17.1

