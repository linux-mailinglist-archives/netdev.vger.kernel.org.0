Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63953629E16
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiKOPvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbiKOPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:06 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901CBFCF9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:03 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id d7so7339346qkk.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/dJp6pSaSk5bNOXFhDmrwekhhFvo9MHRRYBq5+AfmM=;
        b=jt6QXj5gwR3opj8iee51o11UD97ecuRcHdt1YVE15Jpx160A3ZSASTH6NrMfkkFn3p
         kj/N9ZWBQJZdQAPuFBnGVfY2/v3lxE8XwSdzdRzAN57eAetqjGyoKqIu0vBjI5AWTbsT
         onUfX160n2vGu1QfJ+gBRZCPNq/a9kmhIjW9L+LOXkJuZNWF2c4MN+Q/Da2/o1MzGMax
         djJLnr80TdPYDLs0VcWfXRYm84y00YyLEB3rD6N3PsxNd4dMjFCbCtxf3n6GTyxJYvuW
         J36F+O8L2eSBQD/7SbZD4OjxSXBmY0eSn014H3ssubqIQSGMkwqSglEYELhCetI/I0bb
         WMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/dJp6pSaSk5bNOXFhDmrwekhhFvo9MHRRYBq5+AfmM=;
        b=gZ0chv/rJTC329uIVppkGADSJRtMpVB2B0dw7sAglwx+o8NpgIWmJ7byP/mexQGmXR
         bcIv9SRoXxU9mk2UFTwaUphrsJ5/PY9Igs70xC6FCVlLmw/Wo87NyWvj6iNiAna1GU6r
         wwndrgXJHg2akf6K1FXAGKyIOKta7kidCIw1L1kI+CbrbPNi82wYP5WBin3/qjWCrio0
         HsgUGDiqJV0IHxxXOKbyjb/w4u6hNNYApdxjZ0H193UIn9xF2xvLUMem+foD//Oovaf6
         9MLY6V4GwLGwJzlRZHmPz6skgiYfxfKppp/m73Oeg5WZizQiJjUtvo9czj9O2igU4ta2
         XgKQ==
X-Gm-Message-State: ANoB5pnYyqHxoR49JekKMY4CvxC/4SK8bHs4WGjdrNHwcEKuJqw9rUhq
        8YZ/rKt+QCcs9CY33w3S7VM2fxvZS0/bDA==
X-Google-Smtp-Source: AA0mqf6YdHh8yeXMotR7DG+Ykw1OGaZLc/1j79CbtfIR7//DUjUq6QTa2bOZrEW0znhAbcFoTpLCYw==
X-Received: by 2002:a05:620a:11a9:b0:6fa:1c1:26de with SMTP id c9-20020a05620a11a900b006fa01c126demr16005941qkk.511.1668527462520;
        Tue, 15 Nov 2022 07:51:02 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006eeb3165554sm8244351qkp.19.2022.11.15.07.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:51:02 -0800 (PST)
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
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 3/5] net: sched: return NF_ACCEPT when fails to add nat ext in tcf_ct_act_nat
Date:   Tue, 15 Nov 2022 10:50:55 -0500
Message-Id: <236f51919c3f1a8322a88ec0e9d4e179a70658ce.1668527318.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668527318.git.lucien.xin@gmail.com>
References: <cover.1668527318.git.lucien.xin@gmail.com>
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

This patch changes to return NF_ACCEPT when fails to add nat
ext before doing NAT in tcf_ct_act_nat(), to keep consistent
with OVS' processing in ovs_ct_nat().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index da0b7f665277..8869b3ef6642 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -994,7 +994,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_DROP;   /* Can't NAT. */
+		return NF_ACCEPT;   /* Can't NAT. */
 
 	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
 	    (ctinfo != IP_CT_RELATED || commit)) {
-- 
2.31.1

