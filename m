Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907906CC858
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjC1QqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjC1QqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F81498
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680021921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaNTUXIUVB13yPz/ZgTLN776jAKXplI/klOTGfSqkBE=;
        b=ThQ4mKH1kHoHc0GTieSAKpcwZarQcpfSbkmAaE58ddkkkDpQvHEiJNuBtuXvCJYyM7rKcE
        kwfxMo10wDfwBX1ADITJiyDWlWirA6RIGsbmszrhLk3UioM8BWzmWlePbpxY62iWz+Grdn
        TpiHX2Ouh+mC5ZVmosIhlStsmRtRfbE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47--50AG2OmMTG7C9tvDiIRqg-1; Tue, 28 Mar 2023 12:45:15 -0400
X-MC-Unique: -50AG2OmMTG7C9tvDiIRqg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45F9F811E7C;
        Tue, 28 Mar 2023 16:45:15 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.32.181.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4AC492C13;
        Tue, 28 Mar 2023 16:45:14 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 1/4] net/sched: act_tunnel_key: add support for "don't fragment"
Date:   Tue, 28 Mar 2023 18:45:02 +0200
Message-Id: <579a1d30c2d8b417dcc19784cc27b87bab631b27.1680021219.git.dcaratti@redhat.com>
In-Reply-To: <cover.1680021219.git.dcaratti@redhat.com>
References: <cover.1680021219.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

extend "act_tunnel_key" to allow specifying TUNNEL_DONT_FRAGMENT.

Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h | 1 +
 net/sched/act_tunnel_key.c                | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 49ad4033951b..37c6f612f161 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -34,6 +34,7 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_NO_FRAG,		/* flag */
 	__TCA_TUNNEL_KEY_MAX,
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2d12d2626415..0c8aa7e686ea 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -420,6 +420,9 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		    nla_get_u8(tb[TCA_TUNNEL_KEY_NO_CSUM]))
 			flags &= ~TUNNEL_CSUM;
 
+		if (nla_get_flag(tb[TCA_TUNNEL_KEY_NO_FRAG]))
+			flags |= TUNNEL_DONT_FRAGMENT;
+
 		if (tb[TCA_TUNNEL_KEY_ENC_DST_PORT])
 			dst_port = nla_get_be16(tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
 
@@ -747,6 +750,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 				   key->tp_dst)) ||
 		    nla_put_u8(skb, TCA_TUNNEL_KEY_NO_CSUM,
 			       !(key->tun_flags & TUNNEL_CSUM)) ||
+		    ((key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
+		     nla_put_flag(skb, TCA_TUNNEL_KEY_NO_FRAG)) ||
 		    tunnel_key_opts_dump(skb, info))
 			goto nla_put_failure;
 
-- 
2.39.2

