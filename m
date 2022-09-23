Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC1F5E83DC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiIWUeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiIWUcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB86414A7A2
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t3so1188707ply.2
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=G7kCAYdmee+RZ/2FVUhmFmKba16DTFtB/qncTXfqL0g=;
        b=Y6E7L9J9UR374oBO9JTlj0UyLXz47O6O/vrwsT4xNx7MOToGuF3Haek94epLF2gKFc
         YHBgJXmOtfririgUsUdUJ7cJUEJhj34PvSPp7NewDy4HIxUbfstnz0HwtTKsvV+jUdM9
         ewYTBmIsL92mb0z3umh2K5ZPB3wBhsrYJr07w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=G7kCAYdmee+RZ/2FVUhmFmKba16DTFtB/qncTXfqL0g=;
        b=cFMu3Eho4PX3/9A8qqSOHUxbIQFb9FtkwQL47NPhjvDzRj2ApBPUoGMo4Kf/IKP0L5
         8ZHQToeKyttx3YBX80uX8JOeXImCOKLvtGhbm2WYJ+WZYi8uDaQwfSBTFZq2kjahDNHP
         X55FZUnRy/5M+JjBaSpnZT0MMBliSMH6xyslusLdnsziggV7wc/0nf98aBP6e2Aopw2N
         lM06XN9tfDjPpupwz/P6V3/0cthnsS49SI9WR6c2DhZkZ/eBVKUlUYHqO4D61eBSyGEm
         EXBp6SZhQSaFM2R0tXu5PA6rPbrVijdQLiZfISO8sDp9e2+DbJRsrJb1at0tPg2ZIU6R
         ZKFg==
X-Gm-Message-State: ACrzQf3SceozvDqoNpf8XXR1Cf2lFwOYKrnBsUMqASUQxUKGYZUCXfL2
        JgmG4O3SS4QjJSN7V32uczbSYQ==
X-Google-Smtp-Source: AMsMyM4OIH2Kbz3W/dS5nJOpu2wzufZOda+7SbBQGOF/tLPl7Mw1AUJglcwrNduXNP5ZLvyQaDEecg==
X-Received: by 2002:a17:90b:1942:b0:202:cf66:f37f with SMTP id nk2-20020a17090b194200b00202cf66f37fmr22638049pjb.15.1663964909318;
        Fri, 23 Sep 2022 13:28:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z12-20020a6553cc000000b0041d6d37deb5sm6016364pgr.81.2022.09.23.13.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 06/16] igb: Proactively round up to kmalloc bucket size
Date:   Fri, 23 Sep 2022 13:28:12 -0700
Message-Id: <20220923202822.2667581-7-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1691; h=from:subject; bh=laYkgTmsp2Dcg0WHHOT6ZPL9V6mSc2dOwctf45ZQYvY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbkDJzHnX+sI3Vo1Qv14V482wiYBuOHMxTmnIBU huucnceJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5AAKCRCJcvTf3G3AJiyLEA CGMES+fC6ye1bGeS3O38IPkN3IQzERShfic80XY4a30XyimxkLkJSmvXpj+ewPNbHKoiUJTxKgZb/K XnxJDpvuDtFtz8bmbN5m2Yd+S7u9U0FJix4D0Bjc65bO2BLZ1p4skZ00ujWbdyLS1BgmyosrJ9xVP9 Jeb1iFSNfgRZVKqrPKkicjNZr+6mjZxTYoH7c+LPVPfoyyMsulrIGhvF9VSVGvkUMxknLO8TmnWGGL YXw+DzIp3KOAD7McaSE+ctkuIt/4FqAoG9rJOaNF0THgqKo9qaiN3ta16/oNWQocOWuZiKKVTKaDQl ec8EwXmI83Hw0xcmg1Pk7Nyaa5u6CNYuOr6/QPIyHM/G9zTOgaQKJDjVdTfOWZueQU0z56sMQd76h2 EgoHovJDkExXKzaR3tSExdysEeji5cAz5MTF6B5PhevY//J2SrfmsF3Umuqd3PdQ8Z+4FkekBNeaIt Wpzdj496etMeazF2E/aottRll8HUp1QXtMIraqM7WAgkIUg557ze4RTKXXeQvpWrgT6a464S9QSBKF D28gqdBRRs+c1X8XxNNTSpIWgjw0U1bUDku7eV4GRnqprMwn16uXdgttSoB7bVSJibtA6uv2jYfhpW HJE8ECmRl+W/2kM5Fz/2+NW1rofopoBc5f5LUPED2ZPHjOI5nqOO7GaJaF1w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for removing the "silently change allocation size"
users of ksize(), explicitly round up all q_vector allocations so that
allocations can be correctly compared to ksize().

Additionally fix potential use-after-free in the case of new allocation
failure: only free memory if the replacement allocation succeeds.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2796e81d2726..eb51e531c096 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1195,15 +1195,16 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 		return -ENOMEM;
 
 	ring_count = txr_count + rxr_count;
-	size = struct_size(q_vector, ring, ring_count);
+	size = kmalloc_size_roundup(struct_size(q_vector, ring, ring_count));
 
 	/* allocate q_vector and rings */
 	q_vector = adapter->q_vector[v_idx];
 	if (!q_vector) {
 		q_vector = kzalloc(size, GFP_KERNEL);
 	} else if (size > ksize(q_vector)) {
-		kfree_rcu(q_vector, rcu);
 		q_vector = kzalloc(size, GFP_KERNEL);
+		if (q_vector)
+			kfree_rcu(q_vector, rcu);
 	} else {
 		memset(q_vector, 0, size);
 	}
-- 
2.34.1

