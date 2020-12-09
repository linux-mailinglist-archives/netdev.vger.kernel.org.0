Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159292D460F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgLIPze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:55:34 -0500
Received: from goliath.siemens.de ([192.35.17.28]:45088 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbgLIPz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:55:28 -0500
X-Greylist: delayed 4530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 10:55:21 EST
Received: from mail1.siemens.de (mail1.siemens.de [139.23.33.14])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 0B9EbVs3007322
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 15:37:31 +0100
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.34])
        by mail1.siemens.de (8.15.2/8.15.2) with ESMTP id 0B9EbGp3002581;
        Wed, 9 Dec 2020 15:37:28 +0100
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
Subject: [PATCH 3/3] The TC ETF Qdisc pass the hardware timestamp to the interface driver.
Date:   Wed,  9 Dec 2020 15:37:06 +0100
Message-Id: <20201209143707.13503-4-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209143707.13503-1-erez.geva.ext@siemens.com>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ETF pass the TX sending hardware timestamp to
 the network interface driver.

  - Add new flag to the ETF Qdisc setting that mandate
    the use of the hardware timestamp in a socket's buffer.
  - The ETF Qdisc pass the TX sending hardware timestamp to the
    network interface driver.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_etf.c            | 59 +++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 9e7c2c607845..51e2b57bfa81 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1056,6 +1056,7 @@ struct tc_etf_qopt {
 #define TC_ETF_DEADLINE_MODE_ON	_BITUL(0)
 #define TC_ETF_OFFLOAD_ON	_BITUL(1)
 #define TC_ETF_SKIP_SOCK_CHECK	_BITUL(2)
+#define TC_ETF_USE_HW_TIMESTAMP _BITUL(3)
 };
 
 enum {
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..67eace3e180f 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -23,11 +23,13 @@
 #define DEADLINE_MODE_IS_ON(x) ((x)->flags & TC_ETF_DEADLINE_MODE_ON)
 #define OFFLOAD_IS_ON(x) ((x)->flags & TC_ETF_OFFLOAD_ON)
 #define SKIP_SOCK_CHECK_IS_SET(x) ((x)->flags & TC_ETF_SKIP_SOCK_CHECK)
+#define USE_HW_TIMESTAMP(x) ((x)->flags & TC_ETF_USE_HW_TIMESTAMP)
 
 struct etf_sched_data {
 	bool offload;
 	bool deadline_mode;
 	bool skip_sock_check;
+	bool use_hw_timestamp;
 	int clockid;
 	int queue;
 	s32 delta; /* in ns */
@@ -75,7 +77,7 @@ static inline int validate_input_params(struct tc_etf_qopt *qopt,
 static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 {
 	struct etf_sched_data *q = qdisc_priv(sch);
-	ktime_t txtime = nskb->tstamp;
+	ktime_t hwtxtime, txtime = nskb->tstamp;
 	struct sock *sk = nskb->sk;
 	ktime_t now;
 
@@ -88,6 +90,9 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	if (!sock_flag(sk, SOCK_TXTIME))
 		return false;
 
+	if (!q->use_hw_timestamp != !sock_flag(sk, SOCK_HW_TXTIME))
+		return false;
+
 	/* We don't perform crosstimestamping.
 	 * Drop if packet's clockid differs from qdisc's.
 	 */
@@ -99,7 +104,11 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 
 skip:
 	now = q->get_time();
-	if (ktime_before(txtime, now) || ktime_before(txtime, q->last))
+	if (q->use_hw_timestamp)
+		hwtxtime = skb_hwtstamps(nskb)->hwtstamp;
+	else
+		hwtxtime = txtime;
+	if (ktime_before(txtime, now) || ktime_before(hwtxtime, q->last))
 		return false;
 
 	return true;
@@ -173,16 +182,33 @@ static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
 		return qdisc_drop(nskb, sch, to_free);
 	}
 
-	while (*p) {
-		struct sk_buff *skb;
+	if (q->use_hw_timestamp) {
+		ktime_t hwtxtime = skb_hwtstamps(nskb)->hwtstamp;
+
+		while (*p) {
+			struct sk_buff *skb;
 
-		parent = *p;
-		skb = rb_to_skb(parent);
-		if (ktime_compare(txtime, skb->tstamp) >= 0) {
-			p = &parent->rb_right;
-			leftmost = false;
-		} else {
-			p = &parent->rb_left;
+			parent = *p;
+			skb = rb_to_skb(parent);
+			if (ktime_compare(hwtxtime, skb_hwtstamps(skb)->hwtstamp) >= 0) {
+				p = &parent->rb_right;
+				leftmost = false;
+			} else {
+				p = &parent->rb_left;
+			}
+		}
+	} else {
+		while (*p) {
+			struct sk_buff *skb;
+
+			parent = *p;
+			skb = rb_to_skb(parent);
+			if (ktime_compare(txtime, skb->tstamp) >= 0) {
+				p = &parent->rb_right;
+				leftmost = false;
+			} else {
+				p = &parent->rb_left;
+			}
 		}
 	}
 	rb_link_node(&nskb->rbnode, parent, p);
@@ -245,6 +271,10 @@ static void timesortedlist_remove(struct Qdisc *sch, struct sk_buff *skb)
 
 	qdisc_bstats_update(sch, skb);
 
+	/* Pass hardware time to driver and to last */
+	if (q->use_hw_timestamp)
+		skb->tstamp = skb_hwtstamps(skb)->hwtstamp;
+
 	q->last = skb->tstamp;
 
 	sch->q.qlen--;
@@ -393,6 +423,10 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	q->offload = OFFLOAD_IS_ON(qopt);
 	q->deadline_mode = DEADLINE_MODE_IS_ON(qopt);
 	q->skip_sock_check = SKIP_SOCK_CHECK_IS_SET(qopt);
+	q->use_hw_timestamp = USE_HW_TIMESTAMP(qopt);
+	/* deadline mode can not coexist with using hardware time */
+	if (q->use_hw_timestamp && q->deadline_mode)
+		return -EOPNOTSUPP;
 
 	switch (q->clockid) {
 	case CLOCK_REALTIME:
@@ -484,6 +518,9 @@ static int etf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (q->skip_sock_check)
 		opt.flags |= TC_ETF_SKIP_SOCK_CHECK;
 
+	if (q->use_hw_timestamp)
+		opt.flags |= TC_ETF_USE_HW_TIMESTAMP;
+
 	if (nla_put(skb, TCA_ETF_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
-- 
2.20.1

