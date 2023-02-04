Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A6068ACC4
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBDWC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBDWCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:02:55 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64B316AF2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:54 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id m26so9283599qtp.9
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lQp4LVk/4b2FzptlpI9PWAg/BVnyMUI45zZl3tp4l5A=;
        b=K3pKILzhw+vY3oo0gTAWxymz8bau31+gxN0nYGpaaLSMiZHkAfKknM/F784gtToVzE
         iJN+D/QzHRU9SKnlc+Lc+7ll7uNSVrxFgKJZD+TV5ofXHK+pmtBkLKe6QbMUpUl9gYTf
         9qR1T+XjEGBZ0X/RhYbTpxyBNsLkSVAzHBm4T+7lBZVKPbIz9KUoWjr3T9x6+nT8BzSj
         Rh2rLy74/s/MHiPmmLM3P9Y0f31US3bXmeN+IJeF9lgQzkd5Ds+dBao/am7sWe2qGI2S
         gPOi7o2R6HXSRZyCcPTv39AuFRW3F+DVSyKaXLxe1C8ph10tjixaVG8Kjk+C6hGTKiku
         ZTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQp4LVk/4b2FzptlpI9PWAg/BVnyMUI45zZl3tp4l5A=;
        b=ByNGY0K+inttDS80zyMCIQyDtYYmbhSzvUFhclTVVV33/kNW9iOVo2J5X/ohOa1VQA
         VWNqwoZIzRE1YWYVK+0KPwqx9QE8wTUZbt+kaCiZQKnB7vY614/dKBljExiYXrPV3Zdx
         U+AoR/aBGYBvKgfr9zJbCa9w7dSi83Szv70NLhBpq8YphZ6/L2PkTyrPKZH5krkqyDJY
         bv20u3eJodY1usCChAoPFJtZjt9vGaW+4ufcr5tpnVz6CKcVWVRA1NA+Himc3bXPXX6/
         xgo3gwVBJb4vSGD52/wzTtR8/6nLmOuaaU8DXI9F6dFYLRO9jgA6cviHKCeB+0IM2pzS
         dR1Q==
X-Gm-Message-State: AO0yUKXUetaxk1R1VHvo43ZiN5DyuoQUaDFsqDupn+tIpjqiI5lmZZHo
        waoP57HFCYmwNTfRJ/mWpl3KEb/oYUE=
X-Google-Smtp-Source: AK7set/XQHV3FoniOuEqugGew4FFHp8L5z0VLitzNyzsMHCp16Z2MYRTSnvYGypb9bFd1BOJY2pQ0Q==
X-Received: by 2002:ac8:7e8f:0:b0:3a8:e35:258f with SMTP id w15-20020ac87e8f000000b003a80e35258fmr29559374qtj.31.1675548173169;
        Sat, 04 Feb 2023 14:02:53 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:52 -0800 (PST)
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
Subject: [PATCH net-next 0/5] net: move more duplicate code of ovs and tc conntrack into nf_conntrack_ovs
Date:   Sat,  4 Feb 2023 17:02:46 -0500
Message-Id: <cover.1675548023.git.lucien.xin@gmail.com>
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

Xin Long (5):
  net: create nf_conntrack_ovs for ovs and tc use
  net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
  openvswitch: move key and ovs_cb update out of handle_fragments
  net: sched: move frag check and tc_skb_cb update out of
    handle_fragments
  net: extract nf_ct_handle_fragments to nf_conntrack_ovs

 include/net/netfilter/nf_conntrack.h |   4 +
 net/netfilter/Kconfig                |   6 +
 net/netfilter/Makefile               |   1 +
 net/netfilter/nf_conntrack_helper.c  |  98 ---------------
 net/netfilter/nf_conntrack_ovs.c     | 178 +++++++++++++++++++++++++++
 net/openvswitch/Kconfig              |   1 +
 net/openvswitch/conntrack.c          |  80 ++----------
 net/sched/Kconfig                    |   1 +
 net/sched/act_ct.c                   |  76 ++----------
 9 files changed, 210 insertions(+), 235 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_ovs.c

-- 
2.31.1

