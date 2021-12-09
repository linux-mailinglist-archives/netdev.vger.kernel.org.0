Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D395846E4CD
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhLIJGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:06:37 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39022 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhLIJGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:06:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V-29fuO_1639040579;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V-29fuO_1639040579)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Dec 2021 17:02:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/2] bpf: Introduce TCP_ULP option for bpf_{set,get}sockopt
Date:   Thu,  9 Dec 2021 17:02:51 +0800
Message-Id: <20211209090250.73927-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209090250.73927-1-tonylu@linux.alibaba.com>
References: <20211209090250.73927-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new option TCP_ULP for bpf_{set,get}sockopt helper. It
helps prog to change TCP_ULP sockopt on demand.

People who want to set ULP based on strategies when socket create or
other's hook point, they can attach to BPF_CGROUP_INET_SOCK_CREATE or
other types, and judge based on user-defined rules to trigger
bpf_set_sockopt(.., IPPROTO_TCP, TCP_ULP) and set socket ULP. For
example, the bpf prog can control which socket should use tls ULP
modules without intrusively modifying the applications.

With this, it makes flexible to control ULP strategies with BPF prog.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Qiao Ma <mqaio@linux.alibaba.com>
---
 include/uapi/linux/bpf.h       |  3 ++-
 net/core/filter.c              | 16 ++++++++++++++++
 tools/include/uapi/linux/bpf.h |  3 ++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..7372283f92be 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2505,7 +2505,8 @@ union bpf_attr {
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
  * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
  * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
- *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**.
+ *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**,
+ *		  **TCP_ULP**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
diff --git a/net/core/filter.c b/net/core/filter.c
index 1e6b68ff13db..88d7f047f9c0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4870,6 +4870,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			name[TCP_CA_NAME_MAX-1] = 0;
 			return tcp_set_congestion_control(sk, name, false, true);
 		}
+		case TCP_ULP: {
+			char name[TCP_ULP_NAME_MAX];
+
+			strncpy(name, optval, min_t(long, optlen,
+						    TCP_ULP_NAME_MAX - 1));
+			name[TCP_ULP_NAME_MAX - 1] = 0;
+			return tcp_set_ulp(sk, name);
+		}
 		default:
 			break;
 		}
@@ -5000,6 +5008,14 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 			strncpy(optval, icsk->icsk_ca_ops->name, optlen);
 			optval[optlen - 1] = 0;
 			break;
+		case TCP_ULP:
+			icsk = inet_csk(sk);
+
+			if (!icsk->icsk_ulp_ops || optlen <= 1)
+				goto err_clear;
+			strncpy(optval, icsk->icsk_ulp_ops->name, optlen);
+			optval[optlen - 1] = 0;
+			break;
 		case TCP_SAVED_SYN:
 			tp = tcp_sk(sk);
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c26871263f1f..7372283f92be 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2505,7 +2505,8 @@ union bpf_attr {
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
  * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
  * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
- *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**.
+ *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**,
+ *		  **TCP_ULP**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
-- 
2.32.0.3.g01195cf9f

