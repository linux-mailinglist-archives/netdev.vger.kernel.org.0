Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E974C8C91
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiCAN1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiCAN1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:27:20 -0500
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DEDF9D0C1;
        Tue,  1 Mar 2022 05:26:39 -0800 (PST)
HMM_SOURCE_IP: 172.18.0.218:56246.1658835715
HMM_ATTACHE_NUM: 0001
HMM_SOURCE_TYPE: SMTP
Received: from clientip-222.210.155.146 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D6D50280029;
        Tue,  1 Mar 2022 21:26:25 +0800 (CST)
X-189-SAVE-TO-SEND: +lic121@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 06415c6c8f124d04b2344848f72223f3 for bpf@vger.kernel.org;
        Tue, 01 Mar 2022 21:26:35 CST
X-Transaction-ID: 06415c6c8f124d04b2344848f72223f3
X-Real-From: lic121@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: lic121@chinatelecom.cn
Date:   Tue, 1 Mar 2022 13:26:23 +0000
From:   lic121 <lic121@chinatelecom.cn>
To:     bpf@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lic121@chinatelecom.cn
Subject: [PATCH bpf] libbpf: unmap rings when umem deleted
Message-ID: <20220301132623.GA19995@vscode.7~>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_umem__create() does mmap for fill/comp rings, but xsk_umem__delete()
doesn't do the unmap. This works fine for regular cases, because
xsk_socket__delete() does unmap for the rings. But for the case that
xsk_socket__create_shared() fails, umem rings are not unmapped.

fill_save/comp_save are checked to determine if rings have already be
unmapped by xsk. If fill_save and comp_save are NULL, it means that the
rings have already been used by xsk. Then they are supposed to be
unmapped by xsk_socket__delete(). Otherwise, xsk_umem__delete() does the
unmap.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: lic121 <lic121@chinatelecom.cn>
---
 tools/lib/bpf/xsk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index edafe56..32a2f57 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -1193,12 +1193,23 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 
 int xsk_umem__delete(struct xsk_umem *umem)
 {
+	struct xdp_mmap_offsets off;
+	int err;
+
 	if (!umem)
 		return 0;
 
 	if (umem->refcount)
 		return -EBUSY;
 
+	err = xsk_get_mmap_offsets(umem->fd, &off);
+	if (!err && umem->fill_save && umem->comp_save) {
+		munmap(umem->fill_save->ring - off.fr.desc,
+		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
+		munmap(umem->comp_save->ring - off.cr.desc,
+		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
+	}
+
 	close(umem->fd);
 	free(umem);
 
-- 
1.8.3.1

