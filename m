Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000656474BF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLHQ4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiLHQ4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:22 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E172976816
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:21 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id ay32so1493584qtb.11
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCSUkUl3qtx2Ug0vdO9kQ6Q3WtijYxxWczDbAdumJqo=;
        b=n0Ya8RcqfMU7o7wPi2E0YHiWclCqbgsYfeOHu85asflLhnFtnwewxrU7Gow+oIR12Q
         tnJFcnXG572kZlLwRVQHdIncSblkcaGIQxbG9KWWZf7U2bDRlSZJQd08KEb1FjmEi+HL
         8cSMJRhsbIFfsQIPbVqHqWGvVGhuKn27JbEEwVy9c7vSNPZPu0J4es2Hgt+zUPhijHwW
         EufXlDQrsujREDgvmBZlAIfUATOPNpmy/ZmTUemV8Qeew3PbqJMrI8xV+JQBF9G8lPoh
         t6HlfOV3Fmxf+MrXx+0ZoyOVZuSKOrmHtkE2ZFhRMiKAfWwINe0UZvp6aEknnc3f3wz8
         NcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCSUkUl3qtx2Ug0vdO9kQ6Q3WtijYxxWczDbAdumJqo=;
        b=W12eYOcfzi+K8C4lppZ8f1S5+0pX6SG8nGWyRkPnnHhhd0jtDKaEovbSRNIIv+p7cC
         L/QjerG+wuiXqIRR3PsJwCGE0Xfh+l1WvtNIolsWEIEwgqT4uTlKxe6z27NmyW6OmcHw
         SXzxWFaK8PAEDX3DjgSX75rOg5xbnWVu98ciKkiZ1ECJiUXDZVSjSdICc/OZ3YtBJhnU
         qsjbzi+MCi8u7BcxGxBV78UF48MIqi0exDDK5I2dyN8/i4ejG4UuHg5MPJHgz7/8twE+
         gur66Quikf5HxEQFX9xRCc1XwmpXSHrMENyUmerCpVpCiek2uVC2TYU3BBXGN/GRk0LJ
         gUjw==
X-Gm-Message-State: ANoB5pln57xCLiPRZrR1S6zC964JUu+xMHC/fiJ2QffaGuuYvO034FXU
        yDfWLPRckOXJajT/2y99y2CzdFJN7vjGSA==
X-Google-Smtp-Source: AA0mqf6z2jj3y/xOeUoNc37r3HQ23Pl21S5IvuAVg3KBxqu9HqgHHS4jNkznuEvEWe3gbESHVqQNQQ==
X-Received: by 2002:ac8:7598:0:b0:3a6:89b2:c69a with SMTP id s24-20020ac87598000000b003a689b2c69amr3869966qtq.0.1670518580854;
        Thu, 08 Dec 2022 08:56:20 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:20 -0800 (PST)
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
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv4 net-next 4/5] net: sched: update the nat flag for icmp error packets in ct_nat_execute
Date:   Thu,  8 Dec 2022 11:56:11 -0500
Message-Id: <5adc940d86aa78621478c8b98aed9354268daa2c.1670518439.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
References: <cover.1670518439.git.lucien.xin@gmail.com>
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
index dd5ae7551956..bb87d1e910ea 100644
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

