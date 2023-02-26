Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ADE6A32DC
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 17:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjBZQf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 11:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBZQfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 11:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8909F16335
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 08:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677429274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AORosMQj3A7DS3Nk/fBRbnzvD4PblGqGAWvsizAa8P8=;
        b=YGm/6kgWz96USy3U4u6R1DAy+r5k4X5KptyHlfg4RMRhII/dzqs6SNm0VR/B/Rki6vnul2
        qCi+AHD8bAncyzpTn1FLa4qEv0Y3iBZQD6zPvf86/7qXdYfebqb7uyIvP+pZuGUUkkubLb
        sciEHqg04dMuTm2T8ZrM+IBrw3mVO0Y=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-pEJgx40UPhaCRjHtfXrS8Q-1; Sun, 26 Feb 2023 11:34:33 -0500
X-MC-Unique: pEJgx40UPhaCRjHtfXrS8Q-1
Received: by mail-qv1-f71.google.com with SMTP id lt7-20020a056214570700b0057290f3623eso2174078qvb.3
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 08:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AORosMQj3A7DS3Nk/fBRbnzvD4PblGqGAWvsizAa8P8=;
        b=i+N6ti9FUGDsrOeOe0ZPK/Z52z9XaefMlUbiu7U9OUHo782dL09D6G5i8lgeAmC0C5
         MJ/fWIr+CiBoyLr5Qe+ivEoR7eo/g2sCE4j243Zfw7UQiYX6muE26cb9zCZUYiz/MHDL
         E9vn+eSaF4hVHZ8kGoE5HZgbaF+tzGZ38ncwGekgVRUfaHodZ5mCSEdCkq/0TMJwsy98
         hFhYIeIvCfVwfxjqkziXuiaTImV6lTQ0cA0QPnNBdIM+uUXV/kRDO06KJrzDou62GSWr
         7l7p1KInU2gU8Qea3Ks9/wfyqBHJbsifFyUnxYk4cft68Lha5L074e3/LGFVTtLXcLDX
         ZU0w==
X-Gm-Message-State: AO0yUKXWfRZ9lG9SQQhv9iJ4O8/PMkpg5FxFrpQLANffP2wtL56L39e8
        X6o8onyaIM9jKXYdqOwaY/D6B8kRCzl+9gOZce48KcYnhANGXKd8qwp3ImScVfIt6CZMSpSK/FJ
        mEbjIwZxgA2Ztdnsj
X-Received: by 2002:ac8:4e84:0:b0:3bf:d9a9:25fb with SMTP id 4-20020ac84e84000000b003bfd9a925fbmr876273qtp.10.1677429272648;
        Sun, 26 Feb 2023 08:34:32 -0800 (PST)
X-Google-Smtp-Source: AK7set87gS29lQpRvxFPSHfdfKAfctYcKloYbTI3zUudY16bh9F5kOGQv9rhoki2m/9HRW6el0/hNQ==
X-Received: by 2002:ac8:4e84:0:b0:3bf:d9a9:25fb with SMTP id 4-20020ac84e84000000b003bfd9a925fbmr876253qtp.10.1677429272361;
        Sun, 26 Feb 2023 08:34:32 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g2-20020ac870c2000000b003b868cdc689sm3171728qtp.5.2023.02.26.08.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 08:34:31 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] xen-netback: remove unused variables pending_idx and index
Date:   Sun, 26 Feb 2023 11:34:29 -0500
Message-Id: <20230226163429.2351600-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

building with gcc and W=1 reports
drivers/net/xen-netback/netback.c:886:21: error: variable
  ‘pending_idx’ set but not used [-Werror=unused-but-set-variable]
  886 |                 u16 pending_idx;
      |                     ^~~~~~~~~~~

pending_idx is not used so remove it.  Since index was only
used to set pending_idx, remove index as well.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/xen-netback/netback.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index bf627af723bf..1b42676ca141 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -883,11 +883,9 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		struct xen_netif_tx_request txfrags[XEN_NETBK_LEGACY_SLOTS_MAX];
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		unsigned int extra_count;
-		u16 pending_idx;
 		RING_IDX idx;
 		int work_to_do;
 		unsigned int data_len;
-		pending_ring_idx_t index;
 
 		if (queue->tx.sring->req_prod - queue->tx.req_cons >
 		    XEN_NETIF_TX_RING_SIZE) {
@@ -983,9 +981,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			break;
 		}
 
-		index = pending_index(queue->pending_cons);
-		pending_idx = queue->pending_ring[index];
-
 		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
 			data_len = txreq.size;
 
-- 
2.27.0

