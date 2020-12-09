Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A0A2D45AE
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgLIPnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:43:15 -0500
Received: from thoth.sbs.de ([192.35.17.2]:55305 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgLIPnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 10:43:14 -0500
X-Greylist: delayed 3797 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 10:43:13 EST
Received: from mail1.siemens.de (mail1.siemens.de [139.23.33.14])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 0B9EbPmO022112
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 15:37:25 +0100
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.34])
        by mail1.siemens.de (8.15.2/8.15.2) with ESMTP id 0B9EbGp1002581;
        Wed, 9 Dec 2020 15:37:22 +0100
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Mao Wenan <maowenan@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Ines Molzahn <ines.molzahn@siemens.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: [PATCH 1/3] Add TX sending hardware timestamp.
Date:   Wed,  9 Dec 2020 15:37:04 +0100
Message-Id: <20201209143707.13503-2-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209143707.13503-1-erez.geva.ext@siemens.com>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure and send TX sending hardware timestamp from
 user space application to the socket layer,
 to provide to the TC ETC Qdisc, and pass it to
 the interface network driver.

 - New flag for the SO_TXTIME socket option.
 - New access auxiliary data header to pass the
   TX sending hardware timestamp.
 - Add the hardware timestamp to the socket cookie.
 - Copy the TX sending hardware timestamp to the socket cookie.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/net/sock.h                | 2 ++
 include/uapi/asm-generic/socket.h | 3 +++
 include/uapi/linux/net_tstamp.h   | 3 ++-
 net/core/sock.c                   | 9 +++++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77..dd5bfd42b4e2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -859,6 +859,7 @@ enum sock_flags {
 	SOCK_SELECT_ERR_QUEUE, /* Wake select on error queue */
 	SOCK_RCU_FREE, /* wait rcu grace period in sk_destruct() */
 	SOCK_TXTIME,
+	SOCK_HW_TXTIME,
 	SOCK_XDP, /* XDP is attached */
 	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
 };
@@ -1690,6 +1691,7 @@ void sk_send_sigurg(struct sock *sk);
 
 struct sockcm_cookie {
 	u64 transmit_time;
+	u64 transmit_hw_time;
 	u32 mark;
 	u16 tsflags;
 };
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..16265b00c25a 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,9 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_HW_TXTIME		69
+#define SCM_HW_TXTIME		SO_HW_TXTIME
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 7ed0b3d1c00a..dd51c9a99b1f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -162,8 +162,9 @@ struct scm_ts_pktinfo {
 enum txtime_flags {
 	SOF_TXTIME_DEADLINE_MODE = (1 << 0),
 	SOF_TXTIME_REPORT_ERRORS = (1 << 1),
+	SOF_TXTIME_USE_HW_TIMESTAMP = (1 << 2),
 
-	SOF_TXTIME_FLAGS_LAST = SOF_TXTIME_REPORT_ERRORS,
+	SOF_TXTIME_FLAGS_LAST = SOF_TXTIME_USE_HW_TIMESTAMP,
 	SOF_TXTIME_FLAGS_MASK = (SOF_TXTIME_FLAGS_LAST - 1) |
 				 SOF_TXTIME_FLAGS_LAST
 };
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..317dce54321b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1227,6 +1227,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 		sock_valbool_flag(sk, SOCK_TXTIME, true);
+		sock_valbool_flag(sk, SOCK_HW_TXTIME,
+				  sk_txtime.flags & SOF_TXTIME_USE_HW_TIMESTAMP);
 		sk->sk_clockid = sk_txtime.clockid;
 		sk->sk_txtime_deadline_mode =
 			!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
@@ -2378,6 +2380,13 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 			return -EINVAL;
 		sockc->transmit_time = get_unaligned((u64 *)CMSG_DATA(cmsg));
 		break;
+	case SCM_HW_TXTIME:
+		if (!sock_flag(sk, SOCK_HW_TXTIME))
+			return -EINVAL;
+		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u64)))
+			return -EINVAL;
+		sockc->transmit_hw_time = get_unaligned((u64 *)CMSG_DATA(cmsg));
+		break;
 	/* SCM_RIGHTS and SCM_CREDENTIALS are semantically in SOL_UNIX. */
 	case SCM_RIGHTS:
 	case SCM_CREDENTIALS:
-- 
2.20.1

