Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789DE3B447E
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhFYNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhFYNf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624627987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BG5/tC6RNX9gL3Dxu0UwfHRG1H2K8zRjKTUW+uiKmBs=;
        b=MH+3r2pjHT7jerFUCuXO3CB2IGxhEJ0xb3XbIWUZNfkme4+ddAnJlqycMvje8EY27kQtR7
        upkL3t4+/IYm+FmUxFGxuNh1co9Hesb7P1/ZS+nT/2uqcsM8uGCmDRlEw24EpUWDsCB4V2
        ek0gvm4v5RtFn4Ri3G7s/X94y6RjDOg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-CZpZ_mj8MMusExK_m1RauA-1; Fri, 25 Jun 2021 09:33:06 -0400
X-MC-Unique: CZpZ_mj8MMusExK_m1RauA-1
Received: by mail-wr1-f72.google.com with SMTP id l6-20020a0560000226b029011a80413b4fso3484293wrz.23
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BG5/tC6RNX9gL3Dxu0UwfHRG1H2K8zRjKTUW+uiKmBs=;
        b=NTpZWxEwtLxcd8Lvxcu5jOpEUwtblqJO6Qp87Hrqpq528wHKiQRdrK2upuj2HxAelO
         cfiCFecfsVaZfWxp6bqeqb1wv2PjO5meYGW82lbTGuw4PP7CBwhiGns7slqn1MP87web
         1utcd5vsH5qVFC8xxamUOVbPAvS488aR46WNNoSNhntFJSpPWuhkeTn6nBfmFJN9E0Nc
         0YRQgReRQd3gmT4rOXGk8rfQVN7n/q8mmhn3CarfL+mX9n5uYRY9fV2H81M0msD4c76W
         rICEAeyrbRP1DVTiKtAetHtFB8CcnHeYJzgC+og6PEMr+E2QY9wLetDO5xgJRYKvYzhl
         sgyA==
X-Gm-Message-State: AOAM5305+wtXNnc4FqKutL2Hat/J1ZylVpsrtiVYRO9uT+DMcjv/tYZq
        Ey6/fTdAtbONVmQ5Gr7P1VTRNqt/vWvidJqcHTt+by/i9tkT41gv4Ow6gpXC2o0tuVJVoFDgPTM
        xg29cEjwiE6wHahVq
X-Received: by 2002:adf:f711:: with SMTP id r17mr6611990wrp.136.1624627985099;
        Fri, 25 Jun 2021 06:33:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMrbIzVtrzLn06xRbHzTIzAuoiwmLHluMUh9tdNBxa8JBTmBJEkqhQLTqlhtlPtNLNg0sa6A==
X-Received: by 2002:adf:f711:: with SMTP id r17mr6611969wrp.136.1624627984948;
        Fri, 25 Jun 2021 06:33:04 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b5sm5416298wmj.7.2021.06.25.06.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:03 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:01 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH net-next 1/6] bareudp: allow redirecting bareudp packets to
 eth devices
Message-ID: <0aafb805b5a6a845375b5332f07c96c0d43b08e3.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though bareudp transports L3 data (typically IP or MPLS), it needs
to reset the mac_header pointer, so that other parts of the stack don't
mistakenly access the outer header after the packet has been
decapsulated.

This allows to push an Ethernet header to bareudp packets and redirect
them to an Ethernet device:

  $ tc filter add dev bareudp0 ingress matchall      \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Without this patch, push_eth refuses to add an ethernet header because
the skb appears to already have a MAC header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index edfad93e7b68..a7ee0af1af90 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -133,6 +133,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	skb->dev = bareudp->dev;
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 
 	if (!IS_ENABLED(CONFIG_IPV6) || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
-- 
2.21.3

