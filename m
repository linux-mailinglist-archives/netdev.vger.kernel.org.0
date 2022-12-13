Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464F164ADC1
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiLMChb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiLMCg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:59 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF081E3CA
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mn20-20020a17090b189400b0021941492f66so404679pjb.0
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EOrvK1gw9vfZIaV6escFweupEfR/SySrD3QD5/GqZUQ=;
        b=Hjf6Mn54lrEHFalZ3MDUKajTGcbTWEGqXALxq9bDY7Gk6dNlUM5uQOS8qPVZ6M632t
         Vz/mm9XBf1PYnBL9Omy7BnGiTrY9vhEt7wcMEqs3UQ8M/BWrjYMtMpc01WG55TO7TAUX
         qSkPhYqWK/Gq4xY/S4JOrrlAZA4rpl3gxDQasKBc2HVc2jXH2gFV2AMIHb28en5KtRfh
         PYTXf4HA7+xg9H0NU7bPGlfxS3nH9nxSIWDJAxpOzxepGt5N93GNvuUGnYBCreqiTAeg
         zzrcegDY83gyx/EYtTosPB5+lmPFNVX9wiAYDtjZyFaUU0XY9D1z0VUpp9qLoV6oCOIy
         3tQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EOrvK1gw9vfZIaV6escFweupEfR/SySrD3QD5/GqZUQ=;
        b=ktly3JoJ+xALNRpgaBa9i2aIwh2UcLmeWnBM3WG0sSzDNPd1dgdXGtCUHHa36+l9Gi
         nkA+k/DOGjeWXmFufrNXWw4cSre0MMmd/1XvL6+tQTcMZCdicey2D2h4Pzn2HdtA1lNE
         /SXX3UMZEQy+J/ePEryZGDWi3Rgs2gCMDZjo1W6GFwDaes3j9TyDAZhahRs553g5IDMw
         vHxyCBS4CTBKt0A8FptLxQPeiV/O6S88sQR5TEiDkDm0JgSJqPMxnYHYebqT5PiHMtuG
         S/OwqIZI0ffsxS0zSYd6nY8L+2mMea2saBOPUkZ8Q4qib41aIi3yU1ca6mcslpeidCII
         /aEw==
X-Gm-Message-State: ANoB5pnl/8eKgUoG3EwZ6VLIEHRh9S5Cyd/L/iKbRlIJ/DDkoz8oOCWQ
        2TiYVuc4qEX3db9XfBV6AVuIC7k=
X-Google-Smtp-Source: AA0mqf5Yezl460xdj2mhHHtqGgfZz/ZzIk5c7VQN31jyGdgaoqi+dk4UuU0g3JO+ktli9sB56GKm2Eo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr11500pjb.1.1670898987095; Mon, 12 Dec
 2022 18:36:27 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:36:02 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-13-sdf@google.com>
Subject: [PATCH bpf-next v4 12/15] xsk: Add cb area to struct xdp_buff_xsk
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Add an area after the xdp_buff in struct xdp_buff_xsk that drivers can use
to stash extra information to use in metadata kfuncs. The maximum size of
24 bytes means the full xdp_buff_xsk structure will take up exactly two
cache lines (with the cb field spanning both). Also add a macro drivers can
use to check their own wrapping structs against the available size.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/xsk_buff_pool.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index f787c3f524b0..3e952e569418 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -19,8 +19,11 @@ struct xdp_sock;
 struct device;
 struct page;
=20
+#define XSK_PRIV_MAX 24
+
 struct xdp_buff_xsk {
 	struct xdp_buff xdp;
+	u8 cb[XSK_PRIV_MAX];
 	dma_addr_t dma;
 	dma_addr_t frame_dma;
 	struct xsk_buff_pool *pool;
@@ -28,6 +31,8 @@ struct xdp_buff_xsk {
 	struct list_head free_list_node;
 };
=20
+#define XSK_CHECK_PRIV_TYPE(t) BUILD_BUG_ON(sizeof(t) > offsetofend(struct=
 xdp_buff_xsk, cb))
+
 struct xsk_dma_map {
 	dma_addr_t *dma_pages;
 	struct device *dev;
--=20
2.39.0.rc1.256.g54fd8350bd-goog

