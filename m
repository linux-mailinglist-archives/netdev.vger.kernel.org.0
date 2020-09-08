Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96402608C8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 04:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgIHCyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 22:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgIHCyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 22:54:10 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB39C061573;
        Mon,  7 Sep 2020 19:54:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 5so9021817pgl.4;
        Mon, 07 Sep 2020 19:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=yyzJ/s/iIy93G8Neie/jyd8WFkJl+mIOVm/D6MxtDMA=;
        b=qgev+G4ZGCA64TCbnB3CNJIMO3JW7eY+/mKY9B00bzS+BGG0H/3ELT+FfDOOuuc/oW
         uozmgOlexicMpqTHjUBcbYKK5rVgFFMWIH5TkW94hF39cODeQ5YtLVw7g8ZOQEUTcaae
         tyKlHarMmmveoHimv5Oraq3cDPSc0wI3WTXkkbg8dYCQbLnMjm6qO7MBi+l9YynWT49j
         RjF8B3EUoPKY73FB2RX1rtORtM6q611o8qyTuOdkDtBoypXfaGeFmOEI/oyDfLN2Aok4
         fEaoW5k0LR9h7Ois5Pwlicl6R4fqOdpl+OCw12cOFtjd+oC3P9q7g5gTdDrurRdXXum+
         462g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=yyzJ/s/iIy93G8Neie/jyd8WFkJl+mIOVm/D6MxtDMA=;
        b=NB6st9w0Gx1u6+7lI+p5bra8Nv6L1OypRoqnkEf7VBLokQIvgqNk/ijGnCwPfWAY6v
         8G+Kpn6thaBLCr0PKWP/rG8etSkEjDtsPj3aHbLrlDlxd21YZMu1y4K7eLt590iVsroe
         5TYAfmPD8P73Q78cA/kSAnIzlfhNHwxnqCP2ET6Z5M80SltCFUHfn6mnzqsHzIkwZHk9
         0H0xtmfZlm1ZzA40yzEIfFwdqkeYlfgpNxfWeSVJVKOcTj5MfJv8NqwSsxZyN8WNom0R
         wnjrMEvKBesNxLaBw3OWtnzsiwIGUuCuZuhrFF26czLgT4hyGbhPr26GWxot8XmTfxMB
         npHA==
X-Gm-Message-State: AOAM5315MvXUVoe96nMJi8XnnWY3cyvzIMHjDlglXjk95GvRFxtuYy5+
        IpTbJm+2vPbPzxvP680HzPY=
X-Google-Smtp-Source: ABdhPJwyX91J7MrtQtxan2fBXP2PCgs2x4JRLmCZRVezjasuue5+G9AYhGipHjR7vKj+vsw6GL9h/w==
X-Received: by 2002:a63:146:: with SMTP id 67mr5181147pgb.331.1599533649382;
        Mon, 07 Sep 2020 19:54:09 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 204sm9185163pfc.200.2020.09.07.19.54.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Sep 2020 19:54:08 -0700 (PDT)
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
Subject: [MPTCP][PATCH v2 net 1/2] mptcp: fix subflow's local_id issues
Date:   Tue,  8 Sep 2020 10:49:38 +0800
Message-Id: <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1599532593.git.geliangtang@gmail.com>
References: <cover.1599532593.git.geliangtang@gmail.com>
In-Reply-To: <cover.1599532593.git.geliangtang@gmail.com>
References: <cover.1599532593.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mptcp_pm_nl_get_local_id, skc_local is the same as msk_local, so it
always return 0. Thus every subflow's local_id is 0. It's incorrect.

This patch fixed this issue.

Also, we need to ignore the zero address here, like 0.0.0.0 in IPv4. When
we use the zero address as a local address, it means that we can use any
one of the local addresses. The zero address is not a new address, we don't
need to add it to PM, so this patch added a new function address_zero to
check whether an address is the zero address, if it is, we ignore this
address.

Fixes: 01cacb00b35cb ("mptcp: add netlink-based PM")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2c208d2e65cd..3e70d848033d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -66,6 +66,16 @@ static bool addresses_equal(const struct mptcp_addr_info *a,
 	return a->port == b->port;
 }
 
+static bool address_zero(const struct mptcp_addr_info *addr)
+{
+	struct mptcp_addr_info zero;
+
+	memset(&zero, 0, sizeof(zero));
+	zero.family = addr->family;
+
+	return addresses_equal(addr, &zero, false);
+}
+
 static void local_address(const struct sock_common *skc,
 			  struct mptcp_addr_info *addr)
 {
@@ -323,10 +333,13 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	 * addr
 	 */
 	local_address((struct sock_common *)msk, &msk_local);
-	local_address((struct sock_common *)msk, &skc_local);
+	local_address((struct sock_common *)skc, &skc_local);
 	if (addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
+	if (address_zero(&skc_local))
+		return 0;
+
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
 
 	rcu_read_lock();
-- 
2.17.1

