Return-Path: <netdev+bounces-354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C36376F73D8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090E11C21150
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6559BC13B;
	Thu,  4 May 2023 19:43:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C7C132
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC4C4339C;
	Thu,  4 May 2023 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229391;
	bh=FJKz7GuFKFBOzfkNFgYGuEfZN2BQnBKG66ivIzIIz98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNbGylv1s04VU+xSwv6hqPjPsBYIYJjkiFXm98/Ztv3eqD3SG3evad0PlTpPXNBg+
	 CoMjAdZ4ZfxfIZeUOp4hAWDBcLKj/eTUvZGjKpQpN6XdEG2bOpB1jw6BsUKqsbEQbv
	 p46aYoB4IAq3s/9DKn2/9npkXG7oykD3bIyUduW4qb2N42aN5qc2os77VDLJeyJU+k
	 SElefQ3Y4tS4l1HetxdSwwrbW5PRRpsbXuC40jCwao5xW5V72PV3oG2Qyhid1+ErRx
	 l3nK21+6NcqtkabnjGJejtHiklQ+VltvJm8ZPpGhiNS3sYEL/XrTAebo7JHkRfB8Qb
	 aYxojB3psqYrw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	vinicius.gomes@intel.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 34/59] net/sched: pass netlink extack to mqprio and taprio offload
Date: Thu,  4 May 2023 15:41:17 -0400
Message-Id: <20230504194142.3805425-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c54876cd5961ce0f8e74807f79a6739cd6b35ddf ]

With the multiplexed ndo_setup_tc() model which lacks a first-class
struct netlink_ext_ack * argument, the only way to pass the netlink
extended ACK message down to the device driver is to embed it within the
offload structure.

Do this for struct tc_mqprio_qopt_offload and struct tc_taprio_qopt_offload.

Since struct tc_taprio_qopt_offload also contains a tc_mqprio_qopt_offload
structure, and since device drivers might effectively reuse their mqprio
implementation for the mqprio portion of taprio, we make taprio set the
extack in both offload structures to point at the same netlink extack
message.

In fact, the taprio handling is a bit more tricky, for 2 reasons.

First is because the offload structure has a longer lifetime than the
extack structure. The driver is supposed to populate the extack
synchronously from ndo_setup_tc() and leave it alone afterwards.
To not have any use-after-free surprises, we zero out the extack pointer
when we leave taprio_enable_offload().

The second reason is because taprio does overwrite the extack message on
ndo_setup_tc() error. We need to switch to the weak form of setting an
extack message, which preserves a potential message set by the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h |  2 ++
 net/sched/sch_mqprio.c  |  5 ++++-
 net/sched/sch_taprio.c  | 12 ++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2016839991a42..fc688c7e95951 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -167,6 +167,7 @@ struct tc_mqprio_caps {
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
+	struct netlink_ext_ack *extack;
 	u16 mode;
 	u16 shaper;
 	u32 flags;
@@ -194,6 +195,7 @@ struct tc_taprio_sched_entry {
 
 struct tc_taprio_qopt_offload {
 	struct tc_mqprio_qopt_offload mqprio;
+	struct netlink_ext_ack *extack;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 48ed87b91086e..fc6225f15fcdb 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -33,9 +33,12 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_qopt_offload mqprio = {
+		.qopt = *qopt,
+		.extack = extack,
+	};
 	int err, i;
 
 	switch (priv->mode) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1f469861eae32..cbad430191721 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1520,7 +1520,9 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	offload->extack = extack;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
+	offload->mqprio.extack = extack;
 	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
@@ -1528,14 +1530,20 @@ static int taprio_enable_offload(struct net_device *dev,
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
-		NL_SET_ERR_MSG(extack,
-			       "Device failed to setup taprio offload");
+		NL_SET_ERR_MSG_WEAK(extack,
+				    "Device failed to setup taprio offload");
 		goto done;
 	}
 
 	q->offloaded = true;
 
 done:
+	/* The offload structure may linger around via a reference taken by the
+	 * device driver, so clear up the netlink extack pointer so that the
+	 * driver isn't tempted to dereference data which stopped being valid
+	 */
+	offload->extack = NULL;
+	offload->mqprio.extack = NULL;
 	taprio_offload_free(offload);
 
 	return err;
-- 
2.39.2


