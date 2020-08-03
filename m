Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1423A724
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHCNDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHCNDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 09:03:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD1FC06174A;
        Mon,  3 Aug 2020 06:03:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f9so11282349pju.4;
        Mon, 03 Aug 2020 06:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Dk1JpiJy7gpZrrgIE7T6CKQLb01ltccUvx3/3PuXm3g=;
        b=X1ovxLTvwaJecHoNmWyxVgWLrn6k/NJ5+FA3n+x0Ols/MnQgm7rZdcoW/Q0bns+szC
         nBE9fGGQhUv+MYz7Oc3OFeDBUoB4Yd0yNYMmlbGZSscKQeZ2E6FvdpEuw0KzAlUSiXQZ
         BJqfYZC5w/CLngVcS5x1eNbTwv5g0vbLKSZQQjvVMXwAewzXct2SdGklfbqfk9GgTOwk
         OOhZIXhAsCp1Uz+er9ZTz8aPE16Nv6adQc86xMHameDH3+fxyXdi2p9wIhjeNeTE0RWS
         IWW73EkWqLql+/5pAFYsJyl3MPdmD4h6udnpoW29X78nRq4rc3oT7g0o7CYgPTiqFrwH
         4+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Dk1JpiJy7gpZrrgIE7T6CKQLb01ltccUvx3/3PuXm3g=;
        b=CdK6cA/WjL0oGeHj0Nn6fk3t0IMHZxbh3P3Q1bgZKLbN4/M+IMVXHlnGv2CzK/bC/E
         QuDSh8Zex+D2+apFWh3tJdv1sbWq6N+polwaptfzDEQadR464Ziw5n3Fm0nIvOtIFK8q
         WtsZdojyKzrWyUJaA1wsZ57KcIm9AIcB/iVYeVshmoIxPGnKjRliYYLHBYdDvZfbtui2
         Otzm8vssVebHS9wgbLWiGB9vQDPVhjyzQ0Q7HXfJDcVXUvkABwALZzjiSo7+yjOOSYxp
         YMXit0VfoDyuUf4WAEPqJHKaHKIPJdPVPmZQNMI9Bqxp1qy6xZGJMhrNVAJfye/b2Jls
         8JvQ==
X-Gm-Message-State: AOAM53107jOee/CYkLo7OYCkSpIx2Af6+6Ltqzc1FBLyRFciBrJg3SLR
        1j/+Tb8BuFTZ+fEsgcJBq2Q=
X-Google-Smtp-Source: ABdhPJyH+xrxtfsr5nzk+q2fBS0ZNABUlFZvIYzjOSI5+eFaBRvkkAuEagqAgax/emM5M3A0ULEhKQ==
X-Received: by 2002:a17:90a:4701:: with SMTP id h1mr14055276pjg.93.1596459780256;
        Mon, 03 Aug 2020 06:03:00 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id m24sm15316369pff.45.2020.08.03.06.02.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 06:02:59 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] mptcp: use mptcp_for_each_subflow in mptcp_stream_accept
Date:   Mon,  3 Aug 2020 21:00:44 +0800
Message-Id: <fe531e58a52eae5aa46dd93d30d623f8862c3d09.1596459430.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mptcp_for_each_subflow in mptcp_stream_accept instead of
open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d3fe7296e1c9..400824eabf73 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2249,7 +2249,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
 		__mptcp_flush_join_list(msk);
-		list_for_each_entry(subflow, &msk->conn_list, node) {
+		mptcp_for_each_subflow(msk, subflow) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 			if (!ssk->sk_socket)
-- 
2.17.1

