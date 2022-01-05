Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79590485999
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbiAET4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:56:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243778AbiAET4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641412590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8GuX7GeQ6zIo2mKCOrt8PiFbMCuvejd1nRVIiaIwWs=;
        b=V/rC5mPdoWI6/joi/BleHZon7BQN1hykeydrllsvQ79rM2GVn5twDKoV885qqHCrH1+g9A
        etKebJuyBQyMQL9OZm17gpQ2hIG9ix8zjeYs2jC2KYveRibff1u/DC9EbMb1zQbK64kguL
        CqQs2fBvFeHF/BoL33ebtm6d90f5+JA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-WGE9tSJVNqqoK4D0KoS1rQ-1; Wed, 05 Jan 2022 14:56:29 -0500
X-MC-Unique: WGE9tSJVNqqoK4D0KoS1rQ-1
Received: by mail-wr1-f71.google.com with SMTP id c16-20020adfa310000000b001a2349890e1so118028wrb.0
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:56:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E8GuX7GeQ6zIo2mKCOrt8PiFbMCuvejd1nRVIiaIwWs=;
        b=ziLjYeidKNy5ON5CSIAnZ4Tp/wGU3qQ+W+rPTPzRijgf+R86b2V2WMqDAoYzpI9rJ4
         ySeb9glrvNbIntkaOUjllIGE/9IggprWQt8RVrJY8ZNkOg2sFi0ENsKThjgWTmEOE1aW
         O8L2nA4G8xZdmN/r9RBL+l4f+iR74dlDSsnYB9HYUoFh8wJ47RRVU+FSXP48ATe5r4mj
         QjteRMlULmStRY7QJMSuG7GBURon4fDK1Yz0VrA6MeJQqnVsqMRUHDemt/USpG78e16C
         83Wwefv6KcCcD2AKxS86ppzqU9GmnMLo6idP60gn7WHdGGKMDSA5v/Zjd1NeFScHk5h9
         xjcA==
X-Gm-Message-State: AOAM530j96ZjCYmnRU7c7TYz0ObX3rHoqc8iEuApYoLEXNK2S8w/ZSu+
        Ye+zY/44xmuELgwtKD4gkxEH7Wd0OVyz/+QblC46iLg4Fn92w1brQu4NFEFeETkFmjeepAo+SaV
        pfUikCXjX/gO+T4A0
X-Received: by 2002:a1c:f718:: with SMTP id v24mr4275698wmh.186.1641412587834;
        Wed, 05 Jan 2022 11:56:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKLyMR7EWPMcMqUKLsv/SUK4yc9hw/dZwu0r1t3+PNTDFsALStrJ7HB9N+OaZG6WLmGMiQDQ==
X-Received: by 2002:a1c:f718:: with SMTP id v24mr4275692wmh.186.1641412587688;
        Wed, 05 Jan 2022 11:56:27 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id r1sm47880316wrz.30.2022.01.05.11.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:56:27 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:56:25 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Varun Prakash <varun@chelsio.com>
Subject: [PATCH net 3/4] libcxgb: Don't accidentally set RTO_ONLINK in
 cxgb_find_route()
Message-ID: <166c82b4961f0901398e4c1dfde4b9383adfa476.1641407336.git.gnault@redhat.com>
References: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641407336.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mask the ECN bits before calling ip_route_output_ports(). The tos
variable might be passed directly from an IPv4 header, so it may have
the last ECN bit set. This interferes with the route lookup process as
ip_route_output_key_hash() interpretes this bit specially (to restrict
the route scope).

Found by code inspection, compile tested only.

Fixes: 804c2f3e36ef ("libcxgb,iw_cxgb4,cxgbit: add cxgb_find_route()")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
index d04a6c163445..da8d10475a08 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
@@ -32,6 +32,7 @@
 
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
+#include <net/inet_ecn.h>
 #include <net/route.h>
 #include <net/ip6_route.h>
 
@@ -99,7 +100,7 @@ cxgb_find_route(struct cxgb4_lld_info *lldi,
 
 	rt = ip_route_output_ports(&init_net, &fl4, NULL, peer_ip, local_ip,
 				   peer_port, local_port, IPPROTO_TCP,
-				   tos, 0);
+				   tos & ~INET_ECN_MASK, 0);
 	if (IS_ERR(rt))
 		return NULL;
 	n = dst_neigh_lookup(&rt->dst, &peer_ip);
-- 
2.21.3

