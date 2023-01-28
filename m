Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9B67F95B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbjA1P7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbjA1P65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:57 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C9936443
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:50 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id d3so6569314qte.8
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=iAJ50hgQTZGs0VeREuqjkOqZEH98eDTHJDIOF8jknqNFJRcBlAwMDMNK/xGD2Rf3SK
         xNz9wmqSXNZ3h9Y2r8YdDn7z/lQICJvnKiODW2/KbfsG+w+9skKZYvhVhqS3xQePxcin
         SzoHCd5E7cYJwX478zPubdZcCVGTexGmD9uvjdVOH7vMTW/poErywtFDQel5t9czsxBb
         thpGi7+Aw0h01JohOXl9vz6FrfmZd5odjqJF/OpzKNdhSpJLFeCrwKEksym2CwyMSIQk
         uLq05Sdra/RHG3p/nP49XdHJqgX0Gxa4uKRTB7okaiUMSKlnvtoihFswVuD6h/kK4Z8t
         3ABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaCBPY9taiJwDw7qkQaAo7rOjDTTF2XX5hJIsC+YZm4=;
        b=qtzqUZ1Yq9i03t7bsifpc64XiDmomtaOjx4pqHE7infRbVgW8h0gyifrUA6LxGEsr6
         0bwd92mgtFNrYgA0vCPHRydok2zx9jpIIgbGOIuWf/HLHrpS2k1stCg4hplf8sg9Y6/k
         02YMyUvV1OFIA8Qm9o8OHfjJJtMH8A1EJ6KGo5ZIkEZtX7yfPeK5B8uUPPdLZMzrmsVa
         iO3D1GsfbPOnomi34PGGODOwkBs7JVwUWjP985p7GOvIQFB/o+q8S1Ok+mecpoF6VR7Y
         aZmkjZ1FskKELsl/1N2jlNshEb59+OYP4noN2opgo264ALCBZIGOq4LEdsxZm1NSaX1P
         KMhQ==
X-Gm-Message-State: AO0yUKXhbCML8lSAIQbZTgsCAha5Mri7pUWxkm2BpQjCg85BWqWNbaa2
        /hxg4XtoD2hqfeY8zVpA9L2cZb5lzFMKkQ==
X-Google-Smtp-Source: AK7set8ozJfq8Zxq5D9uJVtEBL//Joc1Z8LZnYjGch/q5+U+azdfg+A57UF/VOOOsTVyo17dTz+slg==
X-Received: by 2002:a05:622a:95:b0:3b8:5aa8:7d7a with SMTP id o21-20020a05622a009500b003b85aa87d7amr425892qtw.68.1674921529274;
        Sat, 28 Jan 2023 07:58:49 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:49 -0800 (PST)
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
Subject: [PATCHv4 net-next 07/10] ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
Date:   Sat, 28 Jan 2023 10:58:36 -0500
Message-Id: <6d314a3fa799e50632e708d4cb31d636f3d21567.1674921359.git.lucien.xin@gmail.com>
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

