Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343F8222BA9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgGPTNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgGPTNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:13:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5935C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:13:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so8259421ybf.13
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nFMCtn098IcULXSJHiBPEQBTf/ynF8gSOHqB6sVU7Ec=;
        b=Z5EocIjSzxivXninZfT/6zso67b3CcNqRo1nGJ1zMXmBfd7na9d48WtIQcqdrjYiaF
         mcJ+iZGt8Z8lPULQ+nJm8tPAC2eDw8rYG0qbiPmdcNLteZRTue07q5PsFfsX/SxUY2Ek
         YlKWl7GtXKB5HD/Ik9R3i0VsWAACrdGyPE1SfAtZFPCT6l42fQINlzjaVxNBP2gzJfW0
         PvRaJEC/CLp/scq+3IHmsY6Lg5a6zxfvIEFbcntap0FGzONUUbXNFDsjXpXkX/rNfXeK
         jeSFe2KFqew0al/ul3cMr/alWhoWFXG3n6rQdt6YlLUmxfEgHr1HO8NkaC1LAHLp2FjK
         +NOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nFMCtn098IcULXSJHiBPEQBTf/ynF8gSOHqB6sVU7Ec=;
        b=b8tgAO/WkkonBCWJkQkTb2yheC4YNeNeQggsnr3ml0lU0ERIj8ocpXe8iBdeRDE340
         5YUD0Jv7LIs20lr6o2TKK5Q/4aldXCpOXxHQyALNnOFe20mCbnFreab0hY/BIwHwkhDo
         kN94U+zt/+5ToxYoyjLzYxK9YkOcKR6tSDJYNXlJpMwIeTccmnHJJIa9cfNP5H8kpCpV
         0NAyAnVeq78OwcAZUTVxq+mG2dEgl4tLXCP5vqtql/3ZQCysI/RwvQaQNOBWfj/klA3d
         PGfao1xK17XjzM4JZO48rGtGsGK3Sdoe+x72Ofyn2/wE3L82cRsrodLqwKhTs6LMn9bN
         5AjQ==
X-Gm-Message-State: AOAM533cpM7jUhMTT5Oqg4S+ptkzzIoB45MhlT2fNYm93x2c8cxhyBUg
        LBYJc5Di65tW750zCEjGyzLX9+M8WVOFWp4=
X-Google-Smtp-Source: ABdhPJxNYHYJUe5n5Cn3L1TclMUTU0rRXPkxr3SK3C36S0lhL2s0Wxhg0vOP8cqmgDeV2oEqNFkZTmmM3Mfu/fQ=
X-Received: by 2002:a25:e812:: with SMTP id k18mr7987500ybd.62.1594926800980;
 Thu, 16 Jul 2020 12:13:20 -0700 (PDT)
Date:   Thu, 16 Jul 2020 12:12:35 -0700
In-Reply-To: <20200716191235.1556723-1-priyarjha@google.com>
Message-Id: <20200716191235.1556723-3-priyarjha@google.com>
Mime-Version: 1.0
References: <20200716191235.1556723-1-priyarjha@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH net-next 2/2] tcp: add SNMP counter for no. of duplicate
 segments reported by DSACK
From:   Priyaranjan Jha <priyarjha@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two existing SNMP counters, TCPDSACKRecv and TCPDSACKOfoRecv,
which are incremented depending on whether the DSACKed range is below
the cumulative ACK sequence number or not. Unfortunately, these both
implicitly assume each DSACK covers only one segment. This makes these
counters unusable for estimating spurious retransmit rates,
or real/non-spurious loss rate.

This patch introduces a new SNMP counter, TCPDSACKRecvSegs, which tracks
the estimated number of duplicate segments based on:
(DSACKed sequence range) / MSS. This counter is usable for estimating
spurious retransmit rates, or real/non-spurious loss rate.

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp_input.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 7d91f4debc48..cee9f8e6fce3 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -287,6 +287,7 @@ enum
 	LINUX_MIB_TCPFASTOPENPASSIVEALTKEY,	/* TCPFastOpenPassiveAltKey */
 	LINUX_MIB_TCPTIMEOUTREHASH,		/* TCPTimeoutRehash */
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
+	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 75545a829a2b..1074df726ec0 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -292,6 +292,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPFastOpenPassiveAltKey", LINUX_MIB_TCPFASTOPENPASSIVEALTKEY),
 	SNMP_MIB_ITEM("TcpTimeoutRehash", LINUX_MIB_TCPTIMEOUTREHASH),
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
+	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5d6bbcb1e570..82906deb7874 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1153,6 +1153,7 @@ static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 	}
 
 	dup_segs = tcp_dsack_seen(tp, start_seq_0, end_seq_0, state);
+	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPDSACKRECVSEGS, dup_segs);
 
 	/* D-SACK for already forgotten data... Do dumb counting. */
 	if (tp->undo_marker && tp->undo_retrans > 0 &&
-- 
2.27.0.389.gc38d7665816-goog

