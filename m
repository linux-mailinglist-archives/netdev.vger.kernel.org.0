Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70EA643B7C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiLFCqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiLFCq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:27 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90C525C6B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:46:11 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y6-20020a17090322c600b00189892baa53so15055974plg.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZy6zkebzShtYgGpy5Q+YTSoYFTyeOrDSEuSxWCy75g=;
        b=gEkfVyQr2QEqHozM41NVEezWgDGZdZIBfvzgPcTfCPyceYMSkeXlrqRMw7zaQqL8MO
         hR4VBqJDzmJNJTWNgC4OYelhGM/7M08tKcdVxcsDaVNCfRuwn84eeRgZ5N9h7bUppixg
         u/wKNuKOdbQDs3QTNCcFvnVaZbdpoWt+rf6lu9cdhL5R45pNci/OjGriKv/hm0T3aQLz
         qrOU2ySKoSm0qcVAt2zhN5qnNQgRXsMgmqmwZ9HCid1BEk1J9PLO7OLO+WBg9VP84mOJ
         Q7/raNxMa+xuCB+3Em+2NMc10SDyX5PatQ1+Vjbt6yZ91S8Wzb0mItKwIE/JomAJyMl5
         /N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UZy6zkebzShtYgGpy5Q+YTSoYFTyeOrDSEuSxWCy75g=;
        b=0JnYEgMRf6bNf42gcJWiaiOR7zV7zG12Ols+oU1Uqa3IzKRsbRlsaJfO5LvRUO8rWQ
         3rQ46NrYbbdw/5rAEyHLfbsMtC3yuhyibblDqtaR+QnIhLoHUDklaIGLgEA+/CgB5EdI
         4xLGOOqKkCq5yfzQ0elHglD4o1D+qevy29mxYOW9vNNLaE8U3wjuWrZdaoTJqbrMwOA1
         vKuMTNTkgSdpzVo4LnqeXyzIbnyNx8Rs9vl6dDqNtubzdzrcTVSDP7SzR7TA1meyhK15
         4hs7iyB1IDHrdUqOqv7lgISqc1FflXDBFU2PJQhZd1P24eYEJgFHTiVCZi7m0Fi2Onm+
         UzQQ==
X-Gm-Message-State: ANoB5pk++2z4qWKtvqO6GzdEDVVLa9RBY+CPJtm2aA28RSwa9eeF0d5m
        IBOcpSLTxdls1twW0ciuEh5qV4M=
X-Google-Smtp-Source: AA0mqf4UnF9Fm2sPRgnEv5gKJQEmAPOG7F3MItD2A0LrJSE/fNUiN5si6iC2lnB4PRUxcUoxSy2nLOo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:22ca:b0:56e:64c8:f222 with SMTP id
 f10-20020a056a0022ca00b0056e64c8f222mr89232750pfj.71.1670294771338; Mon, 05
 Dec 2022 18:46:11 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:51 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-10-sdf@google.com>
Subject: [PATCH bpf-next v3 09/12] xsk: Add cb area to struct xdp_buff_xsk
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.39.0.rc0.267.gcb52ba06e7-goog

