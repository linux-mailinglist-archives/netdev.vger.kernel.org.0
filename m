Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4651674631
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjASWeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjASWc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:26 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85645AED93
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:16:02 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id v23-20020aa78097000000b005748c087db1so1500204pff.2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5PUb7Bdy4BSrYUAvE8+8Zaz9Ehc/dbC7IUiLA9SLDnE=;
        b=W4fB6P6lN1r3lPzei+yCuB62E3KrdiijlYkvb4L9JN6SyNkYDMgrGeynrzRZqO8Te9
         BMBP8jLTHiysg4wSKQnx0GJdOJMHh0RZjqlXX5lC8osu9nMMm1bl+xBZ0aKvd4oZ41Fi
         IQasLfiHoiw6QKzaz1o0yJCbg3US/U+gG9529yIpr8LolfisMP2UXRLHyUNlbndwAmk9
         svNxkr+QPpUlBtshsZQhqMSkHFhYt91Lb9FQIjCa+7yCbBTWxj0HQRpgynlYSGr3yfuh
         CYB/slRlGtROXA36BIsDanh+QJ3u9m3UK37IcbdtN2XaUYlkcH4+2k3n+qLY/p/omMiJ
         zFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5PUb7Bdy4BSrYUAvE8+8Zaz9Ehc/dbC7IUiLA9SLDnE=;
        b=EEmwYcSfBApERFhqBs/Fw7gTIpwnI8kZNFGW1u+x4D5pxgoH/1o5L3RDm7xVVACeE9
         EoU06Yr2d6FdhnU2cwC54JVD+m51Zfd36AsN87GFvOSfooe1HrjCqx+894cxtQPXChNA
         kHNxTIJ17FW2yxRHDflo9sQbZBxWvK7IgIeMHWrQGH5w+KMJmipAtXaBBojz0hjFT2IX
         82547q2h0fZa8jc8xymniUD7ObbKznUaVNTIvp8cMj3ZtO1+srWQaVcL0+u/adure1/O
         tARes1XYV91T/GHZQ+v3eXmGIzXgIpBAQEC20+0xb/pRH+Jtq2hZRiS3CC5JQgaAwThK
         eCpQ==
X-Gm-Message-State: AFqh2kqPditFEMkN0kuWPqUGT4Gmpxy77FcPHodngAbRdpr/WaBjJ9kK
        APQ8fpjmcohBT+XoCSugbuWdQmI=
X-Google-Smtp-Source: AMrXdXtqqFlIs8RhTd2XTMrIxTA9lU1ZrKN8mQajhbBRloIC00jTX+bF1n85HCoMwM+umw6U2ODcQgA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ce8f:b0:194:8938:c2a6 with SMTP id
 f15-20020a170902ce8f00b001948938c2a6mr1309816plg.7.1674166561994; Thu, 19 Jan
 2023 14:16:01 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:33 -0800
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-15-sdf@google.com>
Subject: [PATCH bpf-next v8 14/17] xsk: Add cb area to struct xdp_buff_xsk
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
2.39.0.246.g2a6d74b583-goog

