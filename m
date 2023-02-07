Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3FB68E39F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBGWwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBGWwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:52:14 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBD66191
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:52:13 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id cr22so18705395qtb.10
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 14:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F7NxOg2Xg6gZQ++fJKUn3SihAmlLbXn/OIpyIBnMAyY=;
        b=XR5Ox3QwXr49p432rfVnOIUcUrKeCDpeef9qnbXpWKZ7k/VCaOnH7YsTDiNwZBjcVk
         fqOYVBJ7nDzVYjddyWhfaY1r1y6xFQ1LnXSTBQ0ftaJL6EjdXUCCptwh58hNRKOd1eCJ
         lHoQr7We6pk4KBpbuJiIlVI4/bQwGq7u586rTy4Dsw17E+z0XhA9n5FJh2heOSU9Gvf+
         dFryP1nci3SF+jgcpmP51DT1oj393ndEJt7iHU06p3mNcW5AWH1MVlrEEW9Kam0a88TX
         8RXVD/0fb/AbBCmpqboJfP4wkCkDq7TARhdHMGBGkPsaMjT+mKVkxIJXCRKGX+6TJ5uO
         Hr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F7NxOg2Xg6gZQ++fJKUn3SihAmlLbXn/OIpyIBnMAyY=;
        b=Kmh04CofQXtiA0BX/Zj6sJOuMqZsaqSH/4tqxxR1OCYAHKm1+6E9FvFP7GTZR2Njzo
         tr4bWB24Ih1FZmFrbVdDp/F/8HZyLxGYeOtKhVmJRxkfaH9LhfjeMGO3JaacCdo9W0Ou
         TkXOoZsPcebN/4ic6Wxq7g7PPmAKmmOUWOgs2aQm42zKH2uFKP8rd98hC4rD11NZXkbB
         qDw5ezHX+31qqXhYWME3XVgkkyi+jCMskzXq9ZRag/Xhj9OfVidCfCxdirzp+JfPB2bS
         kSLnbOoOz7yAqWJV9+Vr276d2pmj8I+F05N89bJQDa/N3qj5icPgHTgTVU/xGt3QpIGq
         PblA==
X-Gm-Message-State: AO0yUKUdaNAimIdIgFSwDRKgI4YolRSMJ/QHEOSUr0YxbTb1M6bv14TZ
        WdovAVWrcPQdl7bLC9qrhiR/PGu/+MlEEQ==
X-Google-Smtp-Source: AK7set+CnXjM0NINYHIky1ezu4H31udnVp5GzuKnZ9Wp5ZxhHa4j2MDSp9IAhVVbPJcpeoD/7pH03g==
X-Received: by 2002:a05:622a:450:b0:3b8:48e4:83b1 with SMTP id o16-20020a05622a045000b003b848e483b1mr8802842qtx.20.1675810331987;
        Tue, 07 Feb 2023 14:52:11 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a444f00b007296805f607sm10622037qkp.17.2023.02.07.14.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:52:11 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
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
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 0/5] net: move more duplicate code of ovs and tc conntrack into nf_conntrack_ovs
Date:   Tue,  7 Feb 2023 17:52:05 -0500
Message-Id: <cover.1675810210.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

We've moved some duplicate code into nf_nat_ovs in:

  "net: eliminate the duplicate code in the ct nat functions of ovs and tc"

This patchset addresses more code duplication in the conntrack of ovs
and tc then creates nf_conntrack_ovs for them, and four functions will
be extracted and moved into it:

  nf_ct_handle_fragments()
  nf_ct_skb_network_trim()
  nf_ct_helper()
  nf_ct_add_helper()

v1->v2:
  - In patch 1/5, fix the wrong option name 'NF_NF_CONNTRACK' used in
    net/openvswitch/Kconfig, found by kernel test robot.

Xin Long (5):
  net: create nf_conntrack_ovs for ovs and tc use
  net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
  openvswitch: move key and ovs_cb update out of handle_fragments
  net: sched: move frag check and tc_skb_cb update out of
    handle_fragments
  net: extract nf_ct_handle_fragments to nf_conntrack_ovs

 include/net/netfilter/nf_conntrack.h |   4 +
 net/netfilter/Kconfig                |   3 +
 net/netfilter/Makefile               |   1 +
 net/netfilter/nf_conntrack_helper.c  |  98 ---------------
 net/netfilter/nf_conntrack_ovs.c     | 178 +++++++++++++++++++++++++++
 net/openvswitch/Kconfig              |   1 +
 net/openvswitch/conntrack.c          |  80 ++----------
 net/sched/Kconfig                    |   1 +
 net/sched/act_ct.c                   |  76 ++----------
 9 files changed, 207 insertions(+), 235 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_ovs.c

-- 
2.31.1

