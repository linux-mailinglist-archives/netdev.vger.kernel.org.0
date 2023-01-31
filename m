Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4F682FC0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjAaOwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjAaOwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:52:12 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA3B4859F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:11 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e12-20020a0568301e4c00b0068bc93e7e34so2443118otj.4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOmJliGf2ySSHazuxoyfvIco+BBvOMUZm0DJ8H0hh+U=;
        b=bKj0w1Kc4Yc5+nwgUS0ljl6vB3QyFXu5wMKW6XDi8ZO5wuN+uonHLtNX2r9njtpqSD
         cWaGR1k/W2EjK8+Ei+bYdro7KV6HT97vQoEu01oCqagtrQEtjc/5bLDurMbZt9Pn1Fi2
         WtcKvZmqO/nt8I+iq5pLFpHibz6+ebgmDIZQCAS/tpCPTPpOkz1FjpmgxB+Cxr9KiOTn
         qVSYV0XE9YOPd8AL1MNWa+40kjHG0qh1gZ1Sa7Isx/RkWay0ovlq9Dg7MzWtEoIjPgs4
         UKtSVJzdAYjzm2VLeM8sXMfAeP9BfSAnmSIEiTQYG21TtvbD+MetQkrMVBZTgmQEvKf8
         ASoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOmJliGf2ySSHazuxoyfvIco+BBvOMUZm0DJ8H0hh+U=;
        b=ne0l3QmIONQ51RlXTvvL+qeRVlUpV6SEkGXAyEsDLcE5I31a906Q+yuI/Ey5nojBLv
         wh9CZJKabW6+rov2qgimBG8JfzET7HrZ3shrnnmoT0y1/WiTpdjMOpFtlg+e28+zSpOA
         3KOpElotMxISuycD+9yAR5o4H1NcYJsFHcIuQmxcIBkdbhDM3J+JJvdDirhHjQ2p412J
         jJx8wMVIMuQlkRvTW1jE3We9/mROFbyWdW6bM47aS4QdzRkqh1XhHeUKgCSHBoYoJVPO
         pCFN0LI3VjX/XgcWeOGGvHLp9ZT3PRvM3WkPvKTwcsjer9UqkpDgque1rImguqtlmNLB
         Bn+A==
X-Gm-Message-State: AO0yUKXkCAgM8UtDnNpWx2e4zMrVrMzccp7QKOOr7pJMuaoV84L0Kx8h
        N5CvC1xm9+CFfWpdbipctcRR57WagR2dMjwi
X-Google-Smtp-Source: AK7set8kMSG5bDR5GkjOYv9OEF2jUwBCZPKx8HBQreNMSbtIc4y3wHN2/DL5uav4JWiVzIg7Ur0HeA==
X-Received: by 2002:a05:6830:418e:b0:68b:e2a3:8ef1 with SMTP id r14-20020a056830418e00b0068be2a38ef1mr1024936otu.35.1675176730794;
        Tue, 31 Jan 2023 06:52:10 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id e4-20020a0568301e4400b00670461b8be4sm6639371otj.33.2023.01.31.06.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:52:10 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 2/2] net/sched: simplify tcf_pedit_act
Date:   Tue, 31 Jan 2023 11:51:49 -0300
Message-Id: <20230131145149.3776656-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131145149.3776656-1-pctammela@mojatatu.com>
References: <20230131145149.3776656-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the check for a negative number of keys as
this cannot ever happen

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 137 +++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 70 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 674b534be46e..73cab860f42d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -344,8 +344,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 				    const struct tc_action *a,
 				    struct tcf_result *res)
 {
+	enum pedit_header_type htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_key_ex *tkey_ex;
 	struct tcf_pedit_parms *parms;
+	struct tc_pedit_key *tkey;
 	u32 max_offset;
 	int i;
 
@@ -361,88 +365,81 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 	tcf_lastuse_update(&p->tcf_tm);
 	tcf_action_update_bstats(&p->common, skb);
 
-	if (parms->tcfp_nkeys > 0) {
-		struct tc_pedit_key *tkey = parms->tcfp_keys;
-		struct tcf_pedit_key_ex *tkey_ex = parms->tcfp_keys_ex;
-		enum pedit_header_type htype =
-			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
-		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
-
-		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
-			u32 *ptr, hdata;
-			int offset = tkey->off;
-			int hoffset;
-			u32 val;
-			int rc;
-
-			if (tkey_ex) {
-				htype = tkey_ex->htype;
-				cmd = tkey_ex->cmd;
-
-				tkey_ex++;
-			}
+	tkey = parms->tcfp_keys;
+	tkey_ex = parms->tcfp_keys_ex;
 
-			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-			if (rc) {
-				pr_info("tc action pedit bad header type specified (0x%x)\n",
-					htype);
-				goto bad;
-			}
+	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
+		int offset = tkey->off;
+		u32 *ptr, hdata;
+		int hoffset;
+		u32 val;
+		int rc;
 
-			if (tkey->offmask) {
-				u8 *d, _d;
-
-				if (!offset_valid(skb, hoffset + tkey->at)) {
-					pr_info("tc action pedit 'at' offset %d out of bounds\n",
-						hoffset + tkey->at);
-					goto bad;
-				}
-				d = skb_header_pointer(skb, hoffset + tkey->at,
-						       sizeof(_d), &_d);
-				if (!d)
-					goto bad;
-				offset += (*d & tkey->offmask) >> tkey->shift;
-			}
+		if (tkey_ex) {
+			htype = tkey_ex->htype;
+			cmd = tkey_ex->cmd;
 
-			if (offset % 4) {
-				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-				goto bad;
-			}
+			tkey_ex++;
+		}
 
-			if (!offset_valid(skb, hoffset + offset)) {
-				pr_info("tc action pedit offset %d out of bounds\n",
-					hoffset + offset);
-				goto bad;
-			}
+		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
+		if (rc) {
+			pr_info("tc action pedit bad header type specified (0x%x)\n",
+				htype);
+			goto bad;
+		}
 
-			ptr = skb_header_pointer(skb, hoffset + offset,
-						 sizeof(hdata), &hdata);
-			if (!ptr)
-				goto bad;
-			/* just do it, baby */
-			switch (cmd) {
-			case TCA_PEDIT_KEY_EX_CMD_SET:
-				val = tkey->val;
-				break;
-			case TCA_PEDIT_KEY_EX_CMD_ADD:
-				val = (*ptr + tkey->val) & ~tkey->mask;
-				break;
-			default:
-				pr_info("tc action pedit bad command (%d)\n",
-					cmd);
+		if (tkey->offmask) {
+			u8 *d, _d;
+
+			if (!offset_valid(skb, hoffset + tkey->at)) {
+				pr_info("tc action pedit 'at' offset %d out of bounds\n",
+					hoffset + tkey->at);
 				goto bad;
 			}
+			d = skb_header_pointer(skb, hoffset + tkey->at,
+					       sizeof(_d), &_d);
+			if (!d)
+				goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+		}
 
-			*ptr = ((*ptr & tkey->mask) ^ val);
-			if (ptr == &hdata)
-				skb_store_bits(skb, hoffset + offset, ptr, 4);
+		if (offset % 4) {
+			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+			goto bad;
 		}
 
-		goto done;
-	} else {
-		WARN(1, "pedit BUG: index %d\n", p->tcf_index);
+		if (!offset_valid(skb, hoffset + offset)) {
+			pr_info("tc action pedit offset %d out of bounds\n",
+				hoffset + offset);
+			goto bad;
+		}
+
+		ptr = skb_header_pointer(skb, hoffset + offset,
+					 sizeof(hdata), &hdata);
+		if (!ptr)
+			goto bad;
+		/* just do it, baby */
+		switch (cmd) {
+		case TCA_PEDIT_KEY_EX_CMD_SET:
+			val = tkey->val;
+			break;
+		case TCA_PEDIT_KEY_EX_CMD_ADD:
+			val = (*ptr + tkey->val) & ~tkey->mask;
+			break;
+		default:
+			pr_info("tc action pedit bad command (%d)\n",
+				cmd);
+			goto bad;
+		}
+
+		*ptr = ((*ptr & tkey->mask) ^ val);
+		if (ptr == &hdata)
+			skb_store_bits(skb, hoffset + offset, ptr, 4);
 	}
 
+	goto done;
+
 bad:
 	spin_lock(&p->tcf_lock);
 	p->tcf_qstats.overlimits++;
-- 
2.34.1

