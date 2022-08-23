Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92459EFC5
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiHWXiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:38:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0437FE5B;
        Tue, 23 Aug 2022 16:38:53 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 1so7708366pfu.0;
        Tue, 23 Aug 2022 16:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=dgqyYvviQjpsfTJVS3GG24ubuNi7nwd7tAU/o+oo66E=;
        b=TqXZb6kLGi5qgtLkLV2jArhPbNbHe4dgF+I/qHR21nblqVlqqtWh0NqlxyWt+scT0g
         F0GAcjBXIcFIpxpS6k7YGASRY2WkApkHi5plRPjlRTQobgvBifBPPTC7h1m7a56GgcLW
         nVK1hruGa39GdzSDMGvyQkq90z+sKb/92v0bxOQAZ+jXY0ypfZSyJepHWPDaWMqx0kg9
         Z9x7Jd4AVT66uWpSGyJqmhcTwV3+vW5E3zGAeY1iQT4wOTJqL8iRZyCwRdSeSnXB73L6
         30SkAYr4hpZEx1hxSFBnnEmzwNRON5G2C3fhXFuUZvuErIDsaoU3B+v+n7ofPKS/dYfB
         0lPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=dgqyYvviQjpsfTJVS3GG24ubuNi7nwd7tAU/o+oo66E=;
        b=7VVDYhqGKb5mQ5UqorG1AdE7U1TAc8h98PEK7g3Qkc2t3OXlByTLjfFpqQSUMyEBG5
         zbOPTECB5v4g+ZgXhJ9HSFlehTvAr5oSn/hmWt378YH6kyNGftHTJiU7k8DpEw8RDcaw
         Y7HMM4xaz1IRtmyRes8t4CYavSRG+bdLRnIt8EudHlXPmm+RQWRrwwICtbEPqK4+YpMw
         Oz424qiRmnKO7QYOX8PSNgHWsPlAB1EjpVt9w9YFitvMmlmkLLFHUURH6Ai7NwQyRgHf
         iXPrZ33/ftQsnkWQryQMcxLrsx3uMVdhtxlgGHLF7rSHZ6EqZa+OxQFp9wMIc5234aeV
         YyLQ==
X-Gm-Message-State: ACgBeo3WMHRMClM+CtUs4EyI9yeV806KxQOgu79TE27pbz6LvVduSWRh
        1IMFBees5C4QZtcAMGTG5zA=
X-Google-Smtp-Source: AA6agR6AN5ISQrLcWfS1x/aQ5VI8oc2zUIQFzQkhG4a4bBmdx3vho/fnNzUh7V228EEkguEp+c+lyg==
X-Received: by 2002:a63:9044:0:b0:422:b8b2:d019 with SMTP id a65-20020a639044000000b00422b8b2d019mr21981311pge.362.1661297932896;
        Tue, 23 Aug 2022 16:38:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:16d5:d05c:f6b7:f6b9])
        by smtp.gmail.com with ESMTPSA id y9-20020a62ce09000000b0052e987c64efsm11669535pfg.174.2022.08.23.16.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 16:38:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf] netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases
Date:   Tue, 23 Aug 2022 16:38:48 -0700
Message-Id: <20220823233848.2759487-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Currently, net.netfilter.nf_conntrack_frag6_high_thresh can only be lowered.

I found this issue while investigating a probable kernel issue
causing flakes in tools/testing/selftests/net/ip_defrag.sh

In particular, these sysctl changes were ignored:
	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_high_thresh=9000000 >/dev/null 2>&1
	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_low_thresh=7000000  >/dev/null 2>&1

This change is inline with commit 836196239298 ("net/ipfrag: let ip[6]frag_high_thresh
in ns be higher than in init_net")

Fixes: 8db3d41569bb ("netfilter: nf_defrag_ipv6: use net_generic infra")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 7dd3629dd19e71a6db2add2265ca49ab9cceaf63..38db0064d6613a8472ec2835afdbf80071c1fcc2 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -86,7 +86,6 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	table[1].extra2	= &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
 	table[2].extra1	= &nf_frag->fqdir->low_thresh;
-	table[2].extra2	= &nf_frag->fqdir->high_thresh;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
-- 
2.37.1.595.g718a3a8f04-goog

