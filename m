Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5372E2608CC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 04:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgIHC4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 22:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgIHC4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 22:56:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D357EC061573;
        Mon,  7 Sep 2020 19:56:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v196so9764771pfc.1;
        Mon, 07 Sep 2020 19:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=kmcZx1efgyiwxd8i4daWvO803rq/Bn4EFGyYaODUC10=;
        b=WpljHXZ4qcFl5YflPHEhUG/uib5qeFPcnUyiXgXNWuaG7tJc0QYQRWd3pwM24dhDwX
         h/rZwSDflBgkgQGbC8EM8exKBM0UjlUgRYe9sDQaL6EfnbBMSwSEP3aFhZORmKRFjlTs
         hnONKlRVEY4356lL93i4O9g64fyAxG7jUpT9qTxoILjx+sD3w4GcWfGVjbSmZCdyLXDV
         PyHCecyI4a5j9yhaWf3o2+99z7o3ioOOKaOyqFmvYB6eHr+TL8V8bWQ5muAEvWnI5TqH
         Q4FHldJN/Wa9iNPNQNNiBEFM15Z+8ia0gUjmmm/YySoGiFZTwStCjfa2znx2cH5uaU+T
         pj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=kmcZx1efgyiwxd8i4daWvO803rq/Bn4EFGyYaODUC10=;
        b=VElKbh1M7HA8Kgd3xy8IT/5mmWhfFxQHVgGuYV+kFgTDdPgkm6RaTBJoJxGJh+7IRk
         zcl2Ui+XBeYYsaKsHByzWHQeIYKBgAa/bI8TyEQ0iSTH0EiOe4WczDExLbk0iyCei6dJ
         EFJM7MLNTjwZx5uyEojpBkJJ+7tjlA3Ep/mjV03FzCEECcqs1t7ciJD7unq/+Er74nds
         BBozJFSoRxcr5GM1WIUndpu4nKDwUdiWBDyozlTY3sQrHKF6EG/Oy0eDAWwSk4YfWpAz
         4JyvmUHXoiQ3HeaFJ6qBfM7xl6hM9LPE/wKyuENnyU3xTbXvFJA1+ZOnr/OQ6T0hzFav
         /N5g==
X-Gm-Message-State: AOAM5307+yNKAoUhODmFMqyzk1/Q8rfolkJpC/VAEizOXS4MDM+xThtI
        KvQpMDxOj3SHDqonRp/+XHY=
X-Google-Smtp-Source: ABdhPJyEKABSDzk6tjhsePwW4+cKhjbi8DxSguLX9VEnwzvFwEbNc2+VfZZhbZbet5n/0l6YVn9dTw==
X-Received: by 2002:a63:5f03:: with SMTP id t3mr18573059pgb.258.1599533780451;
        Mon, 07 Sep 2020 19:56:20 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id gn24sm384247pjb.8.2020.09.07.19.56.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Sep 2020 19:56:19 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH v2 net 2/2] mptcp: fix subflow's remote_id issues
Date:   Tue,  8 Sep 2020 10:49:39 +0800
Message-Id: <0127c08400bdf65c03438b0b6e90e4ab72ea1576.1599532593.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1599532593.git.geliangtang@gmail.com>
References: <cover.1599532593.git.geliangtang@gmail.com>
In-Reply-To: <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
References: <cover.1599532593.git.geliangtang@gmail.com> <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set the init remote_id to zero, otherwise it will be a random
number.

Then it added the missing subflow's remote_id setting code both in
__mptcp_subflow_connect and in subflow_ulp_clone.

Fixes: 01cacb00b35cb ("mptcp: add netlink-based PM")
Fixes: ec3edaa7ca6ce ("mptcp: Add handling of outgoing MP_JOIN requests")
Fixes: f296234c98a8f ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/subflow.c    | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3e70d848033d..bd88e9c0bf71 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -181,9 +181,9 @@ static void check_work_pending(struct mptcp_sock *msk)
 
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
+	struct mptcp_addr_info remote = { 0 };
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *local;
-	struct mptcp_addr_info remote;
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

