Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102D817E9CD
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 21:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgCIUQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 16:16:59 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:36805 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgCIUQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 16:16:59 -0400
Received: by mail-pf1-f201.google.com with SMTP id h125so1273541pfg.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 13:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E6Lnq3XcqpdoJp7F69G18Srf2jjiIOlEf8Q/17M5TaA=;
        b=U7h2f6ti/VR4KuORMy6/ZIiK4xOAOmQk8VAeHLIsffC7OrfUTXioT3ao2JE15JwUNL
         63iE5FGsC/vPgact9RZzY0b4uMacfRs22rURAJ8Td1bOo5RHPLYJA8Suq6AZNwEqU4lv
         t6tLnH4w4bFXRtzBuYuuBULGYJMAJzlvi4AA7A6GkOSGtFOsQcWYZhy1XUBiTHX1M6ky
         w6FNA32JIFSDEu+iB2vmCad99mV3YDnM+rszf+RAeC43Cjey9DZTMjEeEEhsWYJshO0Q
         ie6FSN9Ystg6WAez/0He+lFGTkV0GCgWh42L964gGDYngAbI3WvlVo5rsDBo/gpzYn+a
         q0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E6Lnq3XcqpdoJp7F69G18Srf2jjiIOlEf8Q/17M5TaA=;
        b=A9ETmR0vUOKdWVEvBjgoApEcpCLtyQ3NdkHkoDrEMzJXQNyTncY1EdBfhboGOobmGu
         0fUDZGck3eR0sqkwXDTJQMc2EHn/gvnECkkp3ayY1Twp2Ce7Znoavq7rrAugX887EKgP
         jFF55Dh8vaUdADzUCRdo6tbgb+tQxXGkjK7fEE9483LwJIzsxHclJ3z3BMtM+lt0w+jc
         mg8w55jgL0YozYTP8Rs29eOpCSFsosE0g7BnsZfmjQ3VqsZRb0CWfBtdNaeoomShO15O
         AWfWuFwH8yrCAcOHdO25I98WO+m8Coqoulzu0/vqoovPBCsg/8xJx/uckH/LPamKOE+a
         SY2g==
X-Gm-Message-State: ANhLgQ2Bfqw15fpEpX/WVQL/oibJSxrZCHmyOMKh5IbJoApiHA3aTFCe
        L5hjkYTsnV/1N0QDNspVat0B1g1Xrn+q
X-Google-Smtp-Source: ADFU+vs2cfUGkuBYsJmTTxVjulW9jQ+h6sRiM+Q0/yIB3EBrhP4YnoIU2W9vgkquVzzZb2CFbcvg/rg+cags
X-Received: by 2002:a17:90a:f496:: with SMTP id bx22mr1082677pjb.115.1583785016488;
 Mon, 09 Mar 2020 13:16:56 -0700 (PDT)
Date:   Mon,  9 Mar 2020 13:16:40 -0700
Message-Id: <20200309201640.84244-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net-next] tcp: add bytes not sent to SCM_TIMESTAMPING_OPT_STATS
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TCP_NLA_BYTES_NOTSENT to SCM_TIMESTAMPING_OPT_STATS that reports
bytes in the write queue but not sent. This is the same metric as
what is exported with tcp_info.tcpi_notsent_bytes.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
---
 include/uapi/linux/tcp.h | 1 +
 net/ipv4/tcp.c           | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 1a7fc856e2371..f2acb25663334 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -312,6 +312,7 @@ enum {
 	TCP_NLA_REORD_SEEN,	/* reordering events seen */
 	TCP_NLA_SRTT,		/* smoothed RTT in usecs */
 	TCP_NLA_TIMEOUT_REHASH, /* Timeout-triggered rehash attempts */
+	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 48aa457a95161..b7134f76f8405 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3344,6 +3344,7 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_REORD_SEEN */
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_SRTT */
 		nla_total_size(sizeof(u16)) + /* TCP_NLA_TIMEOUT_REHASH */
+		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
 		0;
 }
 
@@ -3399,6 +3400,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk)
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
+	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
+		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
 
 	return stats;
 }
-- 
2.25.1.481.gfbce0eb801-goog

