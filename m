Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB8634284
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiKVRcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKVRch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:37 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB19BA3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:30 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id d18so7031516qvs.6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehYMZLUvktYqzKA34sv7SuHaatYQ6MJnVzzXpFPOn90=;
        b=Wxw0POML48rxxCfZhsB12TWOdfQVZsErlNcHgFS0s7/Gvw46wg5SWeBluWWCovvF2/
         X++fI5mIdwmXQFopsUcpg0SvQ3VxT54FELCHcD8mlQ7zAGAE0wBGXDfi2wcNdqcvraB4
         3OgbxSBo01mnjrD/WNh2iLUkjI7zDhJ2VszPhfPs3Xe9P2HtUmkexEmilFuKZDsXVJAV
         LKpIb3QNihdv/bfuuFD7szLKXEpFKH+nQLtja07rf9mNWx+EAEPkO6GU7FRyKNE5MeZH
         P0qNpetehD9fLP9KNo3tyw3w0Du9UCWZTiWuvgA233V+FYOwTxxNVMM+YqZAUZNZxTfm
         DbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehYMZLUvktYqzKA34sv7SuHaatYQ6MJnVzzXpFPOn90=;
        b=5QfE0TAJqCVH/20YuEN+m5Lx2qIPrd6fUlAnfuJ8AGbLAofRgGRIXhVK9vkA2MPuqd
         ge7o8Iu7h+Lh8HWiLR4WufP45xRUWUBCz8aDd/EY+OLuXBQxKF5pduaIbHZ0JZQeRHB/
         LdG8fP7KXBxNnWC/kj7V75gBghkBDMt5oF4aJsF+ZEI+wDB/7MArtr2TEK0ZxhH5/arr
         qs3z6m7So4twVQ1MBys5FFDZ4DM79E/XtXPx4QTV1sFY/myb8fVt1d5J9put71kAFLkW
         nj8LSxOXUYRtDFj4GTaBJfkaaV96+pu6Fridv0fE55+43uFvBbtoIun5i8htQTX64i2L
         5S4g==
X-Gm-Message-State: ANoB5pl2VIIs3zpvRQ6CJs0mqql7MBUH2rDUZ+7i35lUjgu5pd9qmdtt
        Ock34/0O0SU1priihD5DvGxYIkoHkXgcSQ==
X-Google-Smtp-Source: AA0mqf4K1BREno2zDFwDVF/74PCDBPw4jYxVFBZ2PHInrluIy3/nzY+7WtVxM6/yEy+6sjwaJVsBHw==
X-Received: by 2002:a0c:fa01:0:b0:4b4:6402:bc03 with SMTP id q1-20020a0cfa01000000b004b46402bc03mr4450970qvn.81.1669138349779;
        Tue, 22 Nov 2022 09:32:29 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 4/5] net: sched: update the nat flag for icmp error packets in ct_nat_execute
Date:   Tue, 22 Nov 2022 12:32:20 -0500
Message-Id: <dc9fc5ba4cb9036e52005b207c75cd56755db49d.1669138256.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1669138256.git.lucien.xin@gmail.com>
References: <cover.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ovs_ct_nat_execute(), the packet flow key nat flags are updated
when it processes ICMP(v6) error packets translation successfully.

In ct_nat_execute() when processing ICMP(v6) error packets translation
successfully, it should have done the same in ct_nat_execute() to set
post_ct_s/dnat flag, which will be used to update flow key nat flags
in OVS module later.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 8869b3ef6642..c7782c9a6ab6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -936,13 +936,13 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+out:
 	if (err == NF_ACCEPT) {
 		if (maniptype == NF_NAT_MANIP_SRC)
 			tc_skb_cb(skb)->post_ct_snat = 1;
 		if (maniptype == NF_NAT_MANIP_DST)
 			tc_skb_cb(skb)->post_ct_dnat = 1;
 	}
-out:
 	return err;
 }
 #endif /* CONFIG_NF_NAT */
-- 
2.31.1

