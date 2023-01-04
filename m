Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEA65DF80
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbjADWBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbjADWAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:00:39 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DDD41D77
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:00:14 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 24-20020aa79118000000b00580476432deso16573250pfh.23
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 14:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfJO+GQYze9TOg5vw18ss4rmZmF2LBjdqaB1j+Nx9Ls=;
        b=UgN+5U7AwdFy3wokiMPqJj/3rNQgM6rvQldU9Tt3xkUhVJtG9QQSI/KXwWNUZQhsUh
         p2ReVJKVGsvUbq9CY076DBiojhMMBzlGzc/dKnpStfAKWsZpDUZq6IvevSxzjjKpflq3
         qptZ+jCRCpZQUtYPiWSiLrwSLksWamrIIuQv4x0XN3nD5AqR1B/w1JieR023nUH/EsvG
         Y19AJkmB0bGeJiOqrVceZvUwMx/MP89Np1kCP2+rIK82be9+FGW3+1qXBBJ7wv+bv6xf
         EodrnF5G0ybZAyYmtS/ueMSCVd9NWThnMpDiA7UBYekYT3LK6vY0JiXmLmkjbJmjn+p/
         oP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rfJO+GQYze9TOg5vw18ss4rmZmF2LBjdqaB1j+Nx9Ls=;
        b=RdRGZa8P2yijZLdBRgeafvEETq/IY43dwwvMDUz+hKq9+NaLaKgGKUpMFxeSWbh9zn
         SO63nWY6Ny65Ea9ps9arhHj8tgbCpRPuokB2NsbYiLihSJwn3NX4GtHmY1AXAvAVR1r4
         u7CR1B6wDU3CjNgbZ6syfgEQdAJuglwXY/gSFN+2spp14j/OaWaOm3BfL0mtoFd/t6Pa
         zkmBP3vT9wtCuSo4ZQzgLV+i1BfhEek9rxXhkdo9/FGz3mDHWGOiaFzc3ysRmtKjRZgh
         ieubDCyc6bWUoNWcihf1Q0qmIoxepCcN39HI3uQUjzTo4TVS5nuSYb85yN5+QgRzH8I5
         hiXg==
X-Gm-Message-State: AFqh2koa6qmDtJ+ZfPDlnUf67xbRVkHJamYDtXSnGa4aIwPaceoCWHO4
        wRUU7wAwvQ0M0C4c1myxly42Ms8=
X-Google-Smtp-Source: AMrXdXsNC3IVgkpL/uKDWGz/ihEARird1EJTq8ulZNnDQhJD9yhVjeTzP3t4jP0aU+IWL/EwWYE+MQs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:d585:b0:189:af2b:ebb1 with SMTP id
 k5-20020a170902d58500b00189af2bebb1mr2847509plh.35.1672869614304; Wed, 04 Jan
 2023 14:00:14 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:46 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-15-sdf@google.com>
Subject: [PATCH bpf-next v6 14/17] xsk: Add cb area to struct xdp_buff_xsk
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
2.39.0.314.g84b9a713c41-goog

