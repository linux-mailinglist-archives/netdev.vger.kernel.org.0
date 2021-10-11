Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A377642938F
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhJKPjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242579AbhJKPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:39:09 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFE2C061767
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t12-20020a056a00138c00b0044d255ba434so1238083pfg.17
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cKM84Kg2taF4NtwIgfssFuwXo7kK4ZKsOMQ0te+fXUk=;
        b=HTlCSgChnnD9nLDvNVucowpDUexWyfso8cGI5c+ZwclSfmgCy3IHBli6go4eDPwRqj
         6lYZQEJ8DEIPkTb13M9r6H9//04V4LvrORrgPLDrEdIKpKI1eAkUJA+NqKCVPXxg9QYE
         obolTsw9W/iKlNQXPORPQL7q3m4yAD1irE3WNXD77iBueufL9LKXL+yKHYD3335ek5PY
         0roIczEyd/Is9lQwdaUJoSpEg848Ii2sXe/8JqnLX0x1a6wGAJwsNaeqpb5L7lBcigSm
         doLdFWZh3/rRSEFK10ZGhYvpcE135gJqYmKORAys2iyY8R9JZ8k5UAtMaC2BZ4K2BhHN
         gNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cKM84Kg2taF4NtwIgfssFuwXo7kK4ZKsOMQ0te+fXUk=;
        b=fs7r0pdpD3w0NEH9m91rjvsidUHAHgaDhtto371MTeBZFsCJ3x8R6l1qzztRi0GlMO
         aKTZqG3x4pb+QbLhbQE8n74taOqMGYoydLhkPdvrG99dimm2UNiCqnkVxTna6dgzDxDr
         EMgac1sRTB8zLhyam180MZu65kqTiZKQSsOOWyjx7COecvsgNUrUwclay2eEF9s07+4M
         Jy0Zs0E2BcQHxSiNEX5uXptM1cRC4eGi7NZBjqJqGufg2vIbcpqZ6fVsMpRuj6Dvx1ff
         tNCBJVg4Xqe8TC7eQKQlne813YtheeWFmyVehooEc/k6oewQG6RwvDnAof4pcX/HhHqh
         vEmw==
X-Gm-Message-State: AOAM530ByYhIpLN55y78kCv40FhW93IzxvJXCvdRlWhOnCrH8ff6/haL
        udm3CD6gXcxDrjBVljF5Pafz6urpfnXrMTLHUlhmVrPZdRTgwVSCv6vPDwl4w2kAWQ8dRW7gome
        R7hOVcqmJ3fk/wYaqK9m0feByCgIT/O0qkTQx4KBuBxZMB3s5zCm8L+mcRdzxBqZwIUM=
X-Google-Smtp-Source: ABdhPJzF+AeLVAXNIxRUwUF+5eFjJlJQAk6D5Jo5mF+GZiDiNbiUfEDhz7lYykXp2dVvTAY7t0Otpg6QdLo8VA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a62:1c52:0:b0:44c:f1c3:9cb5 with SMTP id
 c79-20020a621c52000000b0044cf1c39cb5mr14529242pfc.14.1633966624598; Mon, 11
 Oct 2021 08:37:04 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:49 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-7-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 6/7] gve: Allow pageflips on larger pages
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jordan Kim <jrkim@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jordan Kim <jrkim@google.com>

Half pages are just used for small enough packets. This change allows
this to also apply for systems with pages larger than 4 KB.

Fixes: 02b0e0c18ba75 ("gve: Rx Buffer Recycling")
Signed-off-by: Jordan Kim <jrkim@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 41b21b527470..98ba981cd534 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -302,7 +302,7 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 
 static bool gve_rx_can_flip_buffers(struct net_device *netdev)
 {
-	return PAGE_SIZE == 4096
+	return PAGE_SIZE >= 4096
 		? netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2 : false;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

v2: Unchanged
