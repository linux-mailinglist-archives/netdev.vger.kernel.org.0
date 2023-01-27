Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424EA67EA3A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjA0QAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbjA0QAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:13 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B08D86607
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:08 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h24so4332233qta.12
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=RHDOGWFskTH+S695hRndHW/elYN/db6W6kAiWVKEsv3iFmjZXKiZOrHDQ0NKrlYLoJ
         0pPNApzJllulZZ5hNJ6C7rBF8w+Ex5Cfoe7S8vXwqsr5NcDAKhuLqAHcPJu5jiBxKZ22
         +zq5vVNe0142/o3/WSefe7+TuFdXp1PYnO7VJIXucRFAzKc4afXwxwHn9raxT3FBRE23
         mL4CyFaVMcRHuHRX+FjA4WqejXE6s3VB+pHfNdia6LjiBGTangLy0PHI2aX9RpN1NGg7
         QaPhSwz5kRp0o9T+pc9AAzVWvATC3CyW9G8Xo7pustMv1+g+DS1/bp0Ojeg/zFIZSQ2u
         HnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=bEGTeSN7BFw2wkID0sZccPeuYky5CG6H2lTL8e8gSoq4l/u3NMxOpbqqpTIW8d+1et
         a+EG957eCvTyEam++Tn7a00PtTy2hNosJkIhRK/UaEiVSS6wdjBCU7iOisOTXviGR7zu
         CBF4kNJHXC6B7L/tZQzpuYwd9uBkhuAB/yphuPJz5b7foJFmWwxEg6MH/mQ32CJ3Y4yn
         TxACG/7HMR10WTch86hZ/BOeZq4zIj4kZDJTjCmBRkhk/dI58riqY40gnDww4M99o4fd
         6Kcfcq9txsUFRJlx0OpkAoUnRDKi8ani6kbbinQrf3hIZ9b9+jXaWtHes+ZIJ8K4rjDg
         mNdA==
X-Gm-Message-State: AFqh2krPZZKE4wvGOH8EUsoH1128hupTf1XQVn+dmfbNZ7uCxBbvIsx4
        AIFim5MeOA4pRwF3uG+vtusfLM5wdrZjnQ==
X-Google-Smtp-Source: AMrXdXvExk28WbcYqmo1lKpad+57SdzJrWD36dTxKq31v4fcOiBldkzRwnXhgf+sOaXEgr+aYTlsEw==
X-Received: by 2002:ac8:4703:0:b0:3a5:4064:9fd3 with SMTP id f3-20020ac84703000000b003a540649fd3mr58503529qtp.24.1674835206903;
        Fri, 27 Jan 2023 08:00:06 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:06 -0800 (PST)
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
Subject: [PATCHv3 net-next 07/10] ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
Date:   Fri, 27 Jan 2023 10:59:53 -0500
Message-Id: <ae91f43b6c7d5da24fa74f18daa765adb053e25a.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

ipvlan devices calls netif_inherit_tso_max() to get the tso_max_size/segs
from the lower device, so when lower device supports BIG TCP, the ipvlan
devices support it too. We also should consider its iph tot_len accessing.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index bb1c298c1e78..460b3d4f2245 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -157,7 +157,7 @@ void *ipvlan_get_L3_hdr(struct ipvl_port *port, struct sk_buff *skb, int *type)
 			return NULL;
 
 		ip4h = ip_hdr(skb);
-		pktlen = ntohs(ip4h->tot_len);
+		pktlen = skb_ip_totlen(skb);
 		if (ip4h->ihl < 5 || ip4h->version != 4)
 			return NULL;
 		if (skb->len < pktlen || pktlen < (ip4h->ihl * 4))
-- 
2.31.1

