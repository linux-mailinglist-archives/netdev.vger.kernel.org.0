Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D106A1DE8
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjBXPBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjBXPBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:01:38 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0646F658FC
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:35 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso2531764oti.8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vr8HUnK9ZYpB3p3q28yDk07xjKSLv6VjHPmveMV+ncw=;
        b=EFgCyM1oc3bevQB5/asphnLsK062lVcdn50v4uvVdoeY3ku2PXlst1hfw02xiVTLXC
         MpPxhbS8X51e2jN7FWhzDgR6DDHf3pUc9db4mbYJvE03t13FyrOHKOSSkQrlsMX2H9rT
         5VjWY0EUJjaC4xz6DM7JvqzZZ2PH1S3BhvhaC6tZp6ZpeegkE78BJmoi9JL3clGzdMse
         /K3vKLlYaAVJVNJoVJDa0bLyfcl0wl+l+xrtmm2RzS4QrAr8ShRiX1kShgvkRa4RMDNu
         BJCmrRDd2q+0T11IFVx7stl9cq5z15C+OSmIJU/RAt0QywEMXlwCRhUQAHgfMiDcSgAI
         x5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vr8HUnK9ZYpB3p3q28yDk07xjKSLv6VjHPmveMV+ncw=;
        b=Igq2xVH8r1AfaJJjH5H2x2UQj5//9MznQrFUv1oFHmQDW2zJQ1/GwB8y6wk8wlgTW/
         yDEmKW8wbQF3Vc2FOm3qSyCYOEQsMkG2u0/JfL5qY17rt34fBBKILbAw92ezMG6I9XZR
         teO71vBVg5Z9bkhDobMw3HqOvmyV9Hv8++E6FIOHvsAFdplFQjsZFrnYhfw/s/J2F5QE
         qhNivwsHLG0SzJHHcXBBbGhrGusKl9kEYm+xtIk03e6TfxasO5P2GGjiqgAmz3ocSDUB
         6X1bfqjPkhX5KODCtLpZvSX8rVs7Hn4Klyk8EaxRYuhWIRNAUjarUKPWMga6SZWYrYv9
         TJKA==
X-Gm-Message-State: AO0yUKVifv7ZLdTHci0z4Un8oW1KtshGaDAx/XtSTOA94wju/MkkYAB3
        tjbyjod9JXcpY3U2utix8yFIkdooCVSi7nS/
X-Google-Smtp-Source: AK7set8W2JEqhFnvhv60dGxAVTawvWZhT1AjmGbzazFDC14YGXSmYs0xAHrJe31KJocurqFOZq8Yew==
X-Received: by 2002:a9d:4a99:0:b0:684:e31a:79fa with SMTP id i25-20020a9d4a99000000b00684e31a79famr4201529otf.5.1677250893406;
        Fri, 24 Feb 2023 07:01:33 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id r28-20020a05683002fc00b00686a19ffef1sm3237636ote.80.2023.02.24.07.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:01:33 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, yotamg@mellanox.com, ozsh@nvidia.com,
        paulb@nvidia.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Date:   Fri, 24 Feb 2023 12:00:56 -0300
Message-Id: <20230224150058.149505-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224150058.149505-1-pctammela@mojatatu.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
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

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action pedit ... index 1
tc filter add ... action pedit index 1

In the current code for act_pedit this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..69
ok 1 319a - Add pedit action that mangles IP TTL
ok 2 7e67 - Replace pedit action with invalid goto chain
ok 3 377e - Add pedit action with RAW_OP offset u32
ok 4 a0ca - Add pedit action with RAW_OP offset u32 (INVALID)
ok 5 dd8a - Add pedit action with RAW_OP offset u16 u16
ok 6 53db - Add pedit action with RAW_OP offset u16 (INVALID)
ok 7 5c7e - Add pedit action with RAW_OP offset u8 add value
ok 8 2893 - Add pedit action with RAW_OP offset u8 quad
ok 9 3a07 - Add pedit action with RAW_OP offset u8-u16-u8
ok 10 ab0f - Add pedit action with RAW_OP offset u16-u8-u8
ok 11 9d12 - Add pedit action with RAW_OP offset u32 set u16 clear u8 invert
ok 12 ebfa - Add pedit action with RAW_OP offset overflow u32 (INVALID)
ok 13 f512 - Add pedit action with RAW_OP offset u16 at offmask shift set
ok 14 c2cb - Add pedit action with RAW_OP offset u32 retain value
ok 15 1762 - Add pedit action with RAW_OP offset u8 clear value
ok 16 bcee - Add pedit action with RAW_OP offset u8 retain value
ok 17 e89f - Add pedit action with RAW_OP offset u16 retain value
ok 18 c282 - Add pedit action with RAW_OP offset u32 clear value
ok 19 c422 - Add pedit action with RAW_OP offset u16 invert value
ok 20 d3d3 - Add pedit action with RAW_OP offset u32 invert value
ok 21 57e5 - Add pedit action with RAW_OP offset u8 preserve value
ok 22 99e0 - Add pedit action with RAW_OP offset u16 preserve value
ok 23 1892 - Add pedit action with RAW_OP offset u32 preserve value
ok 24 4b60 - Add pedit action with RAW_OP negative offset u16/u32 set value
ok 25 a5a7 - Add pedit action with LAYERED_OP eth set src
ok 26 86d4 - Add pedit action with LAYERED_OP eth set src & dst
ok 27 f8a9 - Add pedit action with LAYERED_OP eth set dst
ok 28 c715 - Add pedit action with LAYERED_OP eth set src (INVALID)
ok 29 8131 - Add pedit action with LAYERED_OP eth set dst (INVALID)
ok 30 ba22 - Add pedit action with LAYERED_OP eth type set/clear sequence
ok 31 dec4 - Add pedit action with LAYERED_OP eth set type (INVALID)
ok 32 ab06 - Add pedit action with LAYERED_OP eth add type
ok 33 918d - Add pedit action with LAYERED_OP eth invert src
ok 34 a8d4 - Add pedit action with LAYERED_OP eth invert dst
ok 35 ee13 - Add pedit action with LAYERED_OP eth invert type
ok 36 7588 - Add pedit action with LAYERED_OP ip set src
ok 37 0fa7 - Add pedit action with LAYERED_OP ip set dst
ok 38 5810 - Add pedit action with LAYERED_OP ip set src & dst
ok 39 1092 - Add pedit action with LAYERED_OP ip set ihl & dsfield
ok 40 02d8 - Add pedit action with LAYERED_OP ip set ttl & protocol
ok 41 3e2d - Add pedit action with LAYERED_OP ip set ttl (INVALID)
ok 42 31ae - Add pedit action with LAYERED_OP ip ttl clear/set
ok 43 486f - Add pedit action with LAYERED_OP ip set duplicate fields
ok 44 e790 - Add pedit action with LAYERED_OP ip set ce, df, mf, firstfrag, nofrag fields
ok 45 cc8a - Add pedit action with LAYERED_OP ip set tos
ok 46 7a17 - Add pedit action with LAYERED_OP ip set precedence
ok 47 c3b6 - Add pedit action with LAYERED_OP ip add tos
ok 48 43d3 - Add pedit action with LAYERED_OP ip add precedence
ok 49 438e - Add pedit action with LAYERED_OP ip clear tos
ok 50 6b1b - Add pedit action with LAYERED_OP ip clear precedence
ok 51 824a - Add pedit action with LAYERED_OP ip invert tos
ok 52 106f - Add pedit action with LAYERED_OP ip invert precedence
ok 53 6829 - Add pedit action with LAYERED_OP beyond ip set dport & sport
ok 54 afd8 - Add pedit action with LAYERED_OP beyond ip set icmp_type & icmp_code
ok 55 3143 - Add pedit action with LAYERED_OP beyond ip set dport (INVALID)
ok 56 815c - Add pedit action with LAYERED_OP ip6 set src
ok 57 4dae - Add pedit action with LAYERED_OP ip6 set dst
ok 58 fc1f - Add pedit action with LAYERED_OP ip6 set src & dst
ok 59 6d34 - Add pedit action with LAYERED_OP ip6 dst retain value (INVALID)
ok 60 94bb - Add pedit action with LAYERED_OP ip6 traffic_class
ok 61 6f5e - Add pedit action with LAYERED_OP ip6 flow_lbl
ok 62 6795 - Add pedit action with LAYERED_OP ip6 set payload_len, nexthdr, hoplimit
ok 63 1442 - Add pedit action with LAYERED_OP tcp set dport & sport
ok 64 b7ac - Add pedit action with LAYERED_OP tcp sport set (INVALID)
ok 65 cfcc - Add pedit action with LAYERED_OP tcp flags set
ok 66 3bc4 - Add pedit action with LAYERED_OP tcp set dport, sport & flags fields
ok 67 f1c8 - Add pedit action with LAYERED_OP udp set dport & sport
ok 68 d784 - Add pedit action with mixed RAW/LAYERED_OP #1
ok 69 70ca - Add pedit action with mixed RAW/LAYERED_OP #2

Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
Fixes: f67169fef8db ("net/sched: act_pedit: fix WARN() in the traffic path")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 58 +++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 77d288d384ae..4559a1507ea5 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -181,26 +181,6 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(pattr);
-	if (!parm->nkeys) {
-		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
-		return -EINVAL;
-	}
-	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
-	if (nla_len(pattr) < sizeof(*parm) + ksize) {
-		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
-		return -EINVAL;
-	}
-
-	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
-	if (!nparms)
-		return -ENOMEM;
-
-	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
-	if (IS_ERR(nparms->tcfp_keys_ex)) {
-		ret = PTR_ERR(nparms->tcfp_keys_ex);
-		goto out_free;
-	}
 
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
@@ -209,25 +189,49 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 						&act_pedit_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			goto out_free_ex;
+			return ret;
 		}
 		ret = ACT_P_CREATED;
 	} else if (err > 0) {
 		if (bind)
-			goto out_free;
+			return 0;
 		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
 			ret = -EEXIST;
 			goto out_release;
 		}
 	} else {
-		ret = err;
-		goto out_free_ex;
+		return err;
+	}
+
+	if (!parm->nkeys) {
+		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
+		ret = -EINVAL;
+		goto out_release;
+	}
+	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
+	if (nla_len(pattr) < sizeof(*parm) + ksize) {
+		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
+		ret = -EINVAL;
+		goto out_release;
+	}
+
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
+	nparms->tcfp_keys_ex =
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+	if (IS_ERR(nparms->tcfp_keys_ex)) {
+		ret = PTR_ERR(nparms->tcfp_keys_ex);
+		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0) {
 		ret = err;
-		goto out_release;
+		goto out_free_ex;
 	}
 
 	nparms->tcfp_off_max_hint = 0;
@@ -278,12 +282,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 put_chain:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-out_release:
-	tcf_idr_release(*a, bind);
 out_free_ex:
 	kfree(nparms->tcfp_keys_ex);
 out_free:
 	kfree(nparms);
+out_release:
+	tcf_idr_release(*a, bind);
 	return ret;
 }
 
-- 
2.34.1

