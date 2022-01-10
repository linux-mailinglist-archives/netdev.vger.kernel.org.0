Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB2489A37
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiAJNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:43:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233088AbiAJNnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8GuX7GeQ6zIo2mKCOrt8PiFbMCuvejd1nRVIiaIwWs=;
        b=ivV/Gz3phwR+5mZ443uf3cr4LvT0jnHh0S6m9dOeRXRdy6LL+qZP63jHDCu1PTc+++0f9n
        I1MaTjwIW+gg1Lt5SdYK2QeDgK4+sH/fjoRywT08zuPOdFjySTHPDfaUAdd1WR97e6BrtL
        vwtXfBK0v3n8rAlsi8N1D86ctXiexYw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-tsnfRgtjNUabYjL6_6K2XA-1; Mon, 10 Jan 2022 08:43:14 -0500
X-MC-Unique: tsnfRgtjNUabYjL6_6K2XA-1
Received: by mail-wr1-f69.google.com with SMTP id e21-20020adf9bd5000000b001a472da8091so4186291wrc.17
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E8GuX7GeQ6zIo2mKCOrt8PiFbMCuvejd1nRVIiaIwWs=;
        b=cZxBpDeA7hYW03EDFjEXxh+CmtZyIwLfRVyk/+PmJUuHb17Ahizk2N2nhrOMO0ixG4
         GAaH9zJnzANVmsnLVWuylCS1k6ygs4+csh/1QOu6p33D+vsOIfRel4kwGyDVnybqUhxb
         0M+4Ts6sUmAebCUh+Bhc5hFAOGf43apIZiVYFjaxBSuNTc1A3+0yMs2oWlO8P75juKLa
         ae/iw9g8Z5nznuJFbgfUpUnAppOED0cNLEjCFTfO71y9THWtISbQzL6tItxnZR4E9bvT
         hvLsaDPUJbc9jOLDrRlOG/agKTq3c91RIa5YLxUt1qJpdhzVjN3qHLswAFihHvEfvCnV
         jfLw==
X-Gm-Message-State: AOAM533/MkaACwxVH4lgRvD86WdSzOHI2pjYjnY2kA3YecwpiMWDDVVm
        KrgbBThp6HUFstWQD7UK5j06SZn7m4kS/mLIFi7P4lMW6CqIkhukhhjG41ZtBvLDSy73pJ6WuMw
        71V7zmxfA/OsUEv7f
X-Received: by 2002:a05:600c:4111:: with SMTP id j17mr1319217wmi.7.1641822193446;
        Mon, 10 Jan 2022 05:43:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsXJct+7omDJzgv180JxuNQ74NA77CLLTorQxsAOeeVtFldqYIx6cW8pFeRhyQ9chBiUZ2fQ==
X-Received: by 2002:a05:600c:4111:: with SMTP id j17mr1319208wmi.7.1641822193315;
        Mon, 10 Jan 2022 05:43:13 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r19sm5820461wmh.42.2022.01.10.05.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:43:12 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:43:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 net 3/4] libcxgb: Don't accidentally set RTO_ONLINK in
 cxgb_find_route()
Message-ID: <d0cdbe7c7a62f6d24e34dba0d77048e5969365fe.1641821242.git.gnault@redhat.com>
References: <cover.1641821242.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641821242.git.gnault@redhat.com>
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

