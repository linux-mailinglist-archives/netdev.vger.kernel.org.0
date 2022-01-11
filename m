Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB53F48B75B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiAKT35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiAKT3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:29:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07525C061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:29:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q14so338965plx.4
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xzVuATJi0a8u1tXW7Evjch4xTueZKS94YDE36TE9HHo=;
        b=OxayUWxYOARiQlDidsYe1/FVFLBC7u7reVNeilSP1QhK7zZDv4/rX2rCOKdPWJUFKW
         KNmI0ToQeAZay960YHed+dTXgIcw/xhAFP0beVo5OQ55IdhQXGGNDyBcbvQSrJKjUSUu
         Df46CgsM0X7wnKS096QWeVpCyc7E9fWsiGhPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xzVuATJi0a8u1tXW7Evjch4xTueZKS94YDE36TE9HHo=;
        b=ucPDt95U100OyKHctd552vY8ePdhq6wOmWCD02xIWmt1ZUGWbjooZ0u2uHZQdh+RcM
         LJCjN6sJRALCsBq05w5TMqTx8YmdAHQ0vKa9BHmwQunnd6GMdp96nKOpBDi1WfAbEsoM
         XWh55NC6pPSWvHVjE19MIdd4jy8mWNKdpsyk5J4vNoenOMj5F0pzza18LeC1h7LvhCGx
         xz2dw8wxkJ6GB2HEiBbJaPEVKhD2iBHAGhrTiGeEPrpRxwhApx2avFh/pCnLeaisHpO/
         JU79HM+uw3qFE1pmrybHtEm87nwWje7wxZl/bAFfkCCBg0VcsYfKhhxdlPUXLgFeE/2u
         YgvA==
X-Gm-Message-State: AOAM533s6k2ZLgQMUJ6dxbTHFraBocLxBOILU0F68bYPkkaqtnPoiNWi
        1ExTwBE7pjpqqc2/WvFwYFYqUQ==
X-Google-Smtp-Source: ABdhPJx8UoJ4wIeExZ0+899Y+0oGQn2SzH4M3hBPj7bBdLfUHpD24v9QuJInPBBYgyvLkNWdoc/0jg==
X-Received: by 2002:a63:7257:: with SMTP id c23mr5405701pgn.573.1641929394529;
        Tue, 11 Jan 2022 11:29:54 -0800 (PST)
Received: from localhost ([2600:1700:2434:285f:b8b9:866f:ece3:8a5b])
        by smtp.gmail.com with ESMTPSA id p1sm128333pgj.46.2022.01.11.11.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:29:54 -0800 (PST)
From:   Ivan Babrou <ivan@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Ivan Babrou <ivan@cloudflare.com>
Subject: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
Date:   Tue, 11 Jan 2022 11:29:52 -0800
Message-Id: <20220111192952.49040-1-ivan@cloudflare.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds bpf_setsockopt(TCP_BPF_RCV_SSTHRESH) to allow setting
rcv_ssthresh value for TCP connections. Combined with increased
window_clamp via tcp_rmem[1], it allows to advertise initial scaled
TCP window larger than 64k. This is useful for high BDP connections,
where it allows to push data with fewer roundtrips, reducing latency.

For active connections the larger window is advertised in the first
non-SYN ACK packet as the part of the 3 way handshake.

For passive connections the larger window is advertised whenever
there's any packet to send after the 3 way handshake.

See: https://lkml.org/lkml/2021/12/22/652

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
---
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 6 ++++++
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 791f31dd0abe..36ebf87278bd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5978,6 +5978,7 @@ enum {
 	TCP_BPF_SYN		= 1005, /* Copy the TCP header */
 	TCP_BPF_SYN_IP		= 1006, /* Copy the IP[46] and TCP header */
 	TCP_BPF_SYN_MAC         = 1007, /* Copy the MAC, IP[46], and TCP header */
+	TCP_BPF_RCV_SSTHRESH	= 1008, /* Set rcv_ssthresh */
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..aafb6066b1a6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4904,6 +4904,12 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 					return -EINVAL;
 				inet_csk(sk)->icsk_rto_min = timeout;
 				break;
+			case TCP_BPF_RCV_SSTHRESH:
+				if (val <= 0)
+					ret = -EINVAL;
+				else
+					tp->rcv_ssthresh = min_t(u32, val, tp->window_clamp);
+				break;
 			case TCP_SAVE_SYN:
 				if (val < 0 || val > 1)
 					ret = -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 791f31dd0abe..36ebf87278bd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5978,6 +5978,7 @@ enum {
 	TCP_BPF_SYN		= 1005, /* Copy the TCP header */
 	TCP_BPF_SYN_IP		= 1006, /* Copy the IP[46] and TCP header */
 	TCP_BPF_SYN_MAC         = 1007, /* Copy the MAC, IP[46], and TCP header */
+	TCP_BPF_RCV_SSTHRESH	= 1008, /* Set rcv_ssthresh */
 };
 
 enum {
-- 
2.34.1

