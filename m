Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851B53B4483
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhFYNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhFYNft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624628007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hKk8ehhPwsaZmv01FKLGHWWpwSjV54lb50ZYmD/4jjE=;
        b=NWm2JQXIFxlZs9jGCvBDlC8BrRnwbeYBegCxiLgtcHKo7cv9tEVqzJD8d9wckvtMeTB4IH
        WNFiXDdcy/3yLrDjr8W132u51VE/EAkmxtIhOfva6oZm4+i1OPYWB+bxcNBIpC7Tsav3rn
        5FxZBNDcc8QjuwBz1ZQRhRH20GmqGkI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-TCao6h9WOWWxjsFBFCZ-Jw-1; Fri, 25 Jun 2021 09:33:26 -0400
X-MC-Unique: TCao6h9WOWWxjsFBFCZ-Jw-1
Received: by mail-wr1-f71.google.com with SMTP id b3-20020a05600018a3b029011a84f85e1cso3508866wri.10
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hKk8ehhPwsaZmv01FKLGHWWpwSjV54lb50ZYmD/4jjE=;
        b=EJHlOGAwaN2+frsNILIvDgaHC6BV/FO6iFyT7SquHHppZ9Ic5sOU9RoNB31CSHd4/p
         5eonyNCmgn8vByKd/8nc4QCk9WSmmM2iqa/3jy1a/WbwFufs1zdp72moKdNF6W5J0RlF
         4IxnKSon7zBG4SHEGDT5bq9icm9yjn1q0uy04QPTL5IQSOw1DuWttmxTcDuPM0NiGY4h
         gt7bOda6GMo3cD0XeXKNIdrSJCIUvgxx3m0ai1nqPcLyIPGr+0fZfVDg32WjAeMuwnEL
         lXz++32fKBIk6oIbZerB3J1bSpmVKeBogx7aKOKFLlRXMZEXA52oKVGFsvZfqxqPXIn+
         r3og==
X-Gm-Message-State: AOAM532AqaSKgC6+oOGyWVnMaZKiRfBePrfacYna24HlcvxT1uavr39A
        J+St30gic6aATeaLKLR45rMtTPB7cgCF3uvJbATzo2Q5hde5n75515HFrcQXq3FESjRjDp9TcdS
        N5OZZXXrfkR0EhN7h
X-Received: by 2002:a05:6000:1367:: with SMTP id q7mr11177908wrz.306.1624628005319;
        Fri, 25 Jun 2021 06:33:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0/UMU51nxm/oAWHLm16J4e4QO9vcW9LsS6LpQ2bpb79Y+DM5sQxDiNSnoEECUX0I6t9AhyA==
X-Received: by 2002:a05:6000:1367:: with SMTP id q7mr11177893wrz.306.1624628005212;
        Fri, 25 Jun 2021 06:33:25 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c12sm7104288wrr.90.2021.06.25.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:24 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:23 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Andreas Schultz <aschultz@tpip.net>,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 6/6] gtp: reset mac_header after decap
Message-ID: <0afd995463a3a2b4811b0b15f55deccbe0eaf5a1.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For consistency with other L3 tunnel devices, reset the mac_header
pointer after decapsulation. This makes the mac_header 0 bytes long,
thus making it clear that this skb has no mac_header.

Compile tested only.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/gtp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 1c9023d47e00..30e0a10595a1 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -201,6 +201,7 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 	 * calculate the transport header.
 	 */
 	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 
 	skb->dev = pctx->dev;
 
-- 
2.21.3

