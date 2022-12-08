Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE566474BE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiLHQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiLHQ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:20 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BB076839
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:19 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c15so1500863qtw.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rll4DxwcXBCHbVSIxpnJnXVQqgF+A4qtdFp6rMMijg=;
        b=PZJ43jZScKSoZPIeM0tJGJqcYeTdI3FtjIGYTzmMh2c7WePzroTYpI51jXoc1Eirie
         MrYY/3DZ55Y9ZX0QcnNbp8FiDkmIgriaJTwOQLUbqbeqanCf9YnYSJHe+u6UuAnRU+DD
         JdSc7LVQmTVtO6q6zVJyV3gbOt7+Y/TaLxvxMxlOmOWxLNhaQgkcb+wXBtcWtyfwH/Q0
         cXdY5Z5C4EolCUwaGAvQZRHaEqQQh+HvGlQbXjUN+QjivFysyF5tuy59aoS7FYa3yyU0
         8N9z54Ex5q7JDkLl9uWQHVShgltgD4v+9m3nWVNvmjYORMe9kuaLEqmDQyRvu4tGCMaP
         FD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rll4DxwcXBCHbVSIxpnJnXVQqgF+A4qtdFp6rMMijg=;
        b=8JOHHaZorWxP/DD9gNg53toxdQPKbq38MetxCgRXFscdsgY0hi3Y6BlKZ6d9ki+uNo
         Mv0ch+zAgO4IiqMoU5P24HzGwAxUB8vT4j8Jx0/w35eZAPmF8D8fPdrWm8aBHhHuQToI
         Dr61bBOuKkgsF3jPY8X7K+NbeksXQpAKonSXCExcpCC581E9YCS4SzsgasL5QNctRT7P
         5bxTB+U+WdK1dtH9phA/IkV8VXr0Xh7tHY9F8sOzXu2am2SEPWRTHW5crq0MSg9PnSeu
         z6rk9JCVu3CtO5VwIQmCVF8D0lP+6vSFH/BreZ4FwqlRqbh1Exg2fyAJn2YV8D6j7EVp
         gHvQ==
X-Gm-Message-State: ANoB5pmX+AeKJMLje4TgPWoCSG+JfH9UnGB5rCp9ybvuGU59zH/WqWme
        WvOw33+RbcwIYqg15KjfZve3Ge0FZEoH8w==
X-Google-Smtp-Source: AA0mqf6SEDC/GgncndhohWMqI7Jk4BaPuANvEFdAWqjoug905x0xjIdANzyFkWyqLSU7bVFC3nNtrQ==
X-Received: by 2002:ac8:5992:0:b0:3a5:7848:4b7 with SMTP id e18-20020ac85992000000b003a5784804b7mr4724613qte.53.1670518579390;
        Thu, 08 Dec 2022 08:56:19 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:18 -0800 (PST)
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
Subject: [PATCHv4 net-next 3/5] openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
Date:   Thu,  8 Dec 2022 11:56:10 -0500
Message-Id: <41f1f2b95985ef29f5440d717dc9007b71495d42.1670518439.git.lucien.xin@gmail.com>
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

When it fails to allocate nat ext, the packet should be dropped, like
the memory allocation failures in other places in ovs_ct_nat().

This patch changes to return NF_DROP when fails to add nat ext before
doing NAT in ovs_ct_nat(), also it would keep consistent with tc
action ct' processing in tcf_ct_act_nat().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 5ea74270da46..58c9f0edc3c4 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -821,7 +821,7 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_ACCEPT;   /* Can't NAT. */
+		return NF_DROP;   /* Can't NAT. */
 
 	/* Determine NAT type.
 	 * Check if the NAT type can be deduced from the tracked connection.
-- 
2.31.1

