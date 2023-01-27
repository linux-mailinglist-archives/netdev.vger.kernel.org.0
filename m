Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12567EA39
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjA0QAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbjA0QAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:10 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB408661F
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:06 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v19so4329704qtq.13
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=AL7nrsM+AYnosEMDtBqwM7rbIGQMFuqdbmi9amDaGZF3vbX3jhCVR06DCGGWl2zRPn
         ghgV6n1AWI4K4Fe9ceVNVxI0D8vDXHhxrERD3F0rFIpR/B/9rOuEtwF+7581xl4p0/qw
         ej34/3y3SxN1WrtPwRgTGqbSnQZsvGHjIzstxGBcpRicyP5rVYLzyyf1UZ85zS3rxsGf
         nlXZqZglAJ134Uuk8KthtF2yBKagkvY3jhiAT0/ROtOBYexxAePD1BlxHh5mmzf9A55S
         CJu5MBBctvyibxPzL9EgSzvHFXNyvvRGoPhgQS1poiks+UumRpO4bDq9hnIcdoS6nR4n
         Bqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRncoLC16sCZcT7mVpILb/C22ea0oeFd+8wfM8ixo3g=;
        b=k3DJH7qb7Qk93ipTcqbMewDfl2qJ5kwod7rIz3juEaRdvjZwYGdE59xo+IKJSzFHzx
         HByBPqGvymkildvMzZoEazZWfagCC5IdY297YYij2o+DUgOkql+KcFAKSnXc7xevI1vn
         bIGQWgEyAk4rek0M+QXDxHeZ9gwfTDGWYQNyxqzz6ka58JSu27s2FDm63L2UFVNFJy60
         0tq+ggQXh1HrbCh1smPQ7InqbWNL3eb9tzg+f16U1V44fUPw5Vw2vnUHAoCmz7KiDxUn
         dUP+G/1Ae2HNSrQKUDu5sqaNfKsHkDJ+NYOZMkMEO+bxhEn9JcbaDhqU5LfEEn9wTpJ+
         6x5w==
X-Gm-Message-State: AFqh2kqamelQqvVjC3TI8CW9dXrInBRKGR6MvyzHsStgWldbMm3n4FPb
        okLS4xqRW1JKqKGH2xsD7pln+yL6Hut8Mw==
X-Google-Smtp-Source: AMrXdXtiMMY81LR0A0xRGRA727wc8gSbwRU7+hB4hYy6UbmmR3+p4sc3N8ShKQ+s8k5EpZJtgrvltA==
X-Received: by 2002:ac8:734d:0:b0:3a8:ef7:f29c with SMTP id q13-20020ac8734d000000b003a80ef7f29cmr53783683qtp.46.1674835205689;
        Fri, 27 Jan 2023 08:00:05 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:05 -0800 (PST)
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
Subject: [PATCHv3 net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
Date:   Fri, 27 Jan 2023 10:59:52 -0500
Message-Id: <7787b2075a69cd864f7b74244b041f8b12389ea2.1674835106.git.lucien.xin@gmail.com>
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

