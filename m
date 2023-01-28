Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360E667F95A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbjA1P7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbjA1P65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:57 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3334337
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d3so6569275qte.8
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=lb0ABjRc6TlYm3pppuqizqvL55M/wwY0zRBlnx+IGJq7n2j2STa0rsQm6yv/4LXePr
         BHfTO6Swb7N3AqqBLm5R6jN7rkOlOFLsuogIVhcGGVEUi4lEpCtGKd+5FztdyWtln+aU
         /8nax5s+oQsot0nQ0gxsUd0i6Q0Vd5KfFVbMSwQpzk7jkj6yfW4MAmA4Qcg92Gx/WyNK
         1yvYghNMpF0RDW31Y2VE7aV0WD0aebVBr27LGBXWg1AGSpZ28YBaCfMrI0YoUpbf6CLQ
         c/uv0FPZmZBlYBLBs6Yam2ZMNTJBdh5XF4U63V5lgTbM2nVqVVQTCrxt5NQxegsqvTy7
         3kIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=XNIeoE699XA29etbZgN6cDAJqLHVMa2s5jVrENjXOLtc8d2fnCmzyTvEljsdUy9vkK
         zoPL1EGGUjByzwaa5JLEAMQ9DsLbIQppZupjPXquUR0EKx6yPxxOkCm0J99M1qyz13NI
         I3nIxxMMU72NFG+H3p+wLUCqatEDq5WUASuZX3MYPuuOmN1knBhrQUuRq4ocarLemRcL
         wlHCIRU3Df2zLuvvsXCWhqo1l97KVTobdLjtKaD2XCFhMw4dxKVbGEYZRiLYNrTWQRef
         N1vyeMIAXxWbExTAMWqRgQEVNa/iZnH+AcMCX6XpibPm+XTnMFUK2fB4OPkrPEL5I7YH
         tIsA==
X-Gm-Message-State: AO0yUKV3H/qimjjEKIxBHAE1MAe0K+lha2kYBbg94DiAkHFyxEI05B+1
        /n/cv5CZWyOFznaXksa7XM05YanDu5zXBA==
X-Google-Smtp-Source: AK7set+rC8aMBZhTTGZ6t6ZBn5bOYEhWl5fHgt48bFiwN28/gey9r+q4pSOYokUX6V6nnPPJK9i+LA==
X-Received: by 2002:a05:622a:1207:b0:3b8:2ea9:a09c with SMTP id y7-20020a05622a120700b003b82ea9a09cmr7231199qtx.1.1674921528105;
        Sat, 28 Jan 2023 07:58:48 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:47 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv4 net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
Date:   Sat, 28 Jan 2023 10:58:35 -0500
Message-Id: <9518ab1e4124466c1bb9e026b5923d3562eef394.1674921359.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
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

It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
the iph->tot_len update should use iph_set_totlen().

Note that for these non GSO packets, the new iph tot_len with extra
iph option len added may become greater than 65535, the old process
will cast it and set iph->tot_len to it, which is a bug. In theory,
iph options shouldn't be added for these big packets in here, a fix
may be needed here in the future. For now this patch is only to set
iph->tot_len to 0 when it happens.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 6cd3b6c559f0..79ae7204e8ed 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2222,7 +2222,7 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
 		memset((char *)(iph + 1) + buf_len, 0, opt_len - buf_len);
 	if (len_delta != 0) {
 		iph->ihl = 5 + (opt_len >> 2);
-		iph->tot_len = htons(skb->len);
+		iph_set_totlen(iph, skb->len);
 	}
 	ip_send_check(iph);
 
-- 
2.31.1

