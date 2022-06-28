Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2958055EEBB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiF1Txf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiF1Tu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB8E2DD78;
        Tue, 28 Jun 2022 12:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445796; x=1687981796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ht3UfTVIR3bDx+pf/6oyHp02PGIIQJZ5QLXufKfdPmY=;
  b=IfKOPtkyuqHWDCMOUAHZUPZrJUwZHn089HW50CTQ6lgSkjU6uTeoEimT
   7b6ahgE79FxFAGVq13uGEyJqfN5QvTA3md4TQUboSIg/QJ9wu/QP205Vm
   M6HsD+zUeLUSOB5vyx/Nlbwp58aLCkGa3hQ04FGOKD+luP6Pq+q9X0AD5
   y+jtZvE8mVvrnw5zfRyVgWWc8I1Tu1OB3XhC8IyJjRg4M9w/B/YyBOaMy
   htIblI4JbrfK9PdmGSMEUe8tdao8AwnS/uEf0QHX+7WasXQiljHPR+Dbt
   XnnqlJIy6Uena6/vrm/anv/Hfh4Zq68krycShv3mGnQrErg6ZvGg0ce7Z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523339"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523339"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658257552"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2022 12:49:47 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9d022013;
        Tue, 28 Jun 2022 20:49:45 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 39/52] net, xdp: make &xdp_attachment_info a bit more useful in drivers
Date:   Tue, 28 Jun 2022 21:47:59 +0200
Message-Id: <20220628194812.1453059-40-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new field which will store an arbitrary 'driver cookie', the
closest usage is to store enum there corresponding to the metadata
types supported by a driver to shortcut them on hotpath.
In fact, it's just reusing the 4-byte padding at the end.
Also, make it possible to store BTF ID in LE rather than CPU
byteorder, so that drivers could save some cycles on [potential]
byteswapping on hotpath.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/xdp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index d1fd809655be..5762ce18885f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -380,8 +380,12 @@ void xdp_unreg_mem_model(struct xdp_mem_info *mem);
 
 struct xdp_attachment_info {
 	struct bpf_prog *prog;
-	u64 btf_id;
+	union {
+		__le64 btf_id_le;
+		u64 btf_id;
+	};
 	u32 meta_thresh;
+	u32 drv_cookie;
 };
 
 struct netdev_bpf;
-- 
2.36.1

