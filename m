Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74344D54EB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiCJW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiCJW5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:57:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EED241986FF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646952996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SfOk1zwO0CCu7UnUHNMnpLnqee7NGxIZY+rGqvasiEM=;
        b=GAqmDUB26yf7Y+Ejht+Elkv3Jo1GJYT4bmDe9D1oCNiBx/YhV+hj0EhWT0+QNmLSIpE7K7
        xBCOjMXO2et1FbrcR7merV+y439dAWlfM8FE0CS2qIxWhVUsBhBsb9POWlDi94s8fahOhi
        hTnNETs6QpcfIxdX/m79Wnw4ICYQHoQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-CRm2qFAbNbadXoM61G_S_Q-1; Thu, 10 Mar 2022 17:56:34 -0500
X-MC-Unique: CRm2qFAbNbadXoM61G_S_Q-1
Received: by mail-ed1-f71.google.com with SMTP id da28-20020a056402177c00b00415ce4b20baso3879365edb.17
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:56:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SfOk1zwO0CCu7UnUHNMnpLnqee7NGxIZY+rGqvasiEM=;
        b=ruKBEgtGa8caEDV6H9VnO2ffYkCilI0pchtTy4ravODHBm8aXo8bMDBsT+3me+Io9q
         f1/1jXvtDC9ggfR4WBLsazH/C1GMWLCFUJ0xksgSpVfYxnL2KXcvD5G5KY41LZwhJmi/
         rWcg4LoLGTelj6C0RaV+aLFaquG9lmEbK6oQr8GGMUSn2U97Ba9STld2sxCK2t6tcwW+
         +FEaQGW07VtW6VpVRne2r6jua+REhxhR8n9uus/VHV5ht43vhUcjdE5am8NK9E5fTTVu
         2OsdNqi0QxaFKf9UwXnKKcHW+HWQMTudTrb10xwfLJ20NZ3tmTXqQIF3cMjRkAFFTXpq
         xyvQ==
X-Gm-Message-State: AOAM530q5IdEpUiCY5warnyKk4MhLsx6Oyny3Xla4Lst+R9x4T79+IKz
        C/JT8J+FRLYzLu3mDhnnEovao+YqBqAuq82VoYoONgf6lmkXaJcmeN9+ACiJYHtp8rnm58ORl2Z
        U1JvhxIjP3oJmOlVr
X-Received: by 2002:a17:906:1e42:b0:6d6:df12:7f8d with SMTP id i2-20020a1709061e4200b006d6df127f8dmr6385694ejj.15.1646952993105;
        Thu, 10 Mar 2022 14:56:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx33hGechmaR55dBTCvCwglt6UpEpp4eC/uQzhRk4p0Bukj3NBZ9jh5bzbm2BhY8X2MykqW1w==
X-Received: by 2002:a17:906:1e42:b0:6d6:df12:7f8d with SMTP id i2-20020a1709061e4200b006d6df127f8dmr6385662ejj.15.1646952992672;
        Thu, 10 Mar 2022 14:56:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y18-20020a056402271200b0041697d1a691sm2501142edd.33.2022.03.10.14.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 14:56:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8B5DF1A89A1; Thu, 10 Mar 2022 23:56:31 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf, test_run: Fix packet size check for live packet mode
Date:   Thu, 10 Mar 2022 23:56:20 +0100
Message-Id: <20220310225621.53374-1-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The live packet mode uses some extra space at the start of each page to
cache data structures so they don't have to be rebuilt at every repetition.
This space wasn't correctly accounted for in the size checking of the
arguments supplied to userspace. In addition, the definition of the frame
size should include the size of the skb_shared_info (as there is other
logic that subtracts the size of this).

Together, these mistakes resulted in userspace being able to trip the
XDP_WARN() in xdp_update_frame_from_buff(), which syzbot discovered in
short order. Fix this by changing the frame size define and adding the
extra headroom to the bpf_prog_test_run_xdp() function. Also drop the
max_len parameter to the page_pool init, since this is related to DMA which
is not used for the page pool instance in PROG_TEST_RUN.

Reported-by: syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com
Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/bpf/test_run.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 24405a280a9b..e7b9c2636d10 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -112,8 +112,7 @@ struct xdp_test_data {
 	u32 frame_cnt;
 };
 
-#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head)	\
-			     - sizeof(struct skb_shared_info))
+#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
 static void xdp_test_run_init_page(struct page *page, void *arg)
@@ -156,7 +155,6 @@ static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_c
 		.flags = 0,
 		.pool_size = xdp->batch_size,
 		.nid = NUMA_NO_NODE,
-		.max_len = TEST_XDP_FRAME_SIZE,
 		.init_callback = xdp_test_run_init_page,
 		.init_arg = xdp,
 	};
@@ -1230,6 +1228,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			batch_size = NAPI_POLL_WEIGHT;
 		else if (batch_size > TEST_XDP_MAX_BATCH)
 			return -E2BIG;
+
+		headroom += sizeof(struct xdp_page_head);
 	} else if (batch_size) {
 		return -EINVAL;
 	}
-- 
2.35.1

