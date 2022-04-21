Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7050A5CC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiDUQ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390508AbiDUQKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:10:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18CE4739D;
        Thu, 21 Apr 2022 09:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650557274; x=1682093274;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KQxlSh7y7Ioxngv76mOQ0Wat/WwN5UNp4E4vSzos96M=;
  b=QNcFA8UcTE/3DXsK0ex4HS/LseHG4yotonKqpa5KElZclX7Ep9Jpgjw/
   fKoEnHJUdIcRwlwSB5Ocri7Ao6N8nAkOOGFD6S4FHR3tspR70GleoFjsm
   1zyWVOcziRLog4PR7brXPxF2+pE9Qryyv4siOoYA6mzxu85tKVDVaYNDu
   MT6Nkh8swHSc7P2ZyPLg6HO3xcTpXQt0Tb0d/DGiOV08VZfwLL79IFsY0
   0e+cM6/rgSbe7yWzbAxrmTktoTOpuOTXivbf5lOrlHNQqmyqtk06YaA7z
   eu7j7+KNsgF/qYkTUCtMQdn+3SQ3jGcIQULOR0MzhVjMo9j/XsP11K5+8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="327306972"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="327306972"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 09:05:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="658590992"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2022 09:04:58 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23LG4uCp031724;
        Thu, 21 Apr 2022 17:04:57 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Accessing XDP packet memory from the end
Date:   Thu, 21 Apr 2022 17:56:20 +0200
Message-Id: <20220421155620.81048-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear all,
Our team has encountered a need of accessing data_meta in a following way:

int xdp_meta_prog(struct xdp_md *ctx)
{
	void *data_meta_ptr = (void *)(long)ctx->data_meta;
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	u64 data_size = sizeof(u32);
	u32 magic_meta;
	u8 offset;

	offset = (u8)((s64)data - (s64)data_meta_ptr);
	if (offset < data_size) {
		bpf_printk("invalid offset: %ld\n", offset);
		return XDP_DROP;
	}

	data_meta_ptr += offset;
	data_meta_ptr -= data_size;

	if (data_meta_ptr + data_size > data) {
		return XDP_DROP;
	}
		
	magic_meta = *((u32 *)data);
	bpf_printk("Magic: %d\n", magic_meta);
	return XDP_PASS;
}

Unfortunately, verifier claims this code attempts to access packet with
an offset of -2 (a constant part) and negative offset is generally forbidden.

For now we have 2 solutions, one is using bpf_xdp_adjust_meta(),
which is pretty good, but not ideal for the hot path.
The second one is the patch at the end.

Do you see any other way of accessing memory from the end of data_meta/data?
What do you think about both suggested solutions?

Best regards,
Larysa Zaremba

---

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3576,8 +3576,11 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 	}
 
 	err = reg->range < 0 ? -EINVAL :
-	      __check_mem_access(env, regno, off, size, reg->range,
-				 zero_size_allowed);
+	      __check_mem_access(env, regno, off + reg->smin_value, size,
+				 reg->range + reg->smin_value, zero_size_allowed);
+	err = err ? :
+	      __check_mem_access(env, regno, off + reg->umax_value, size,
+				 reg->range + reg->umax_value, zero_size_allowed);
 	if (err) {
 		verbose(env, "R%d offset is outside of the packet\n", regno);
 		return err;
