Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7C5F4C7F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJDXMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiJDXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:12 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81181543DE;
        Tue,  4 Oct 2022 16:12:09 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr56-000AJC-1N; Wed, 05 Oct 2022 01:12:08 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 03/10] bpf: Implement link update for tc BPF link programs
Date:   Wed,  5 Oct 2022 01:11:36 +0200
Message-Id: <20221004231143.19190-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221004231143.19190-1-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for LINK_UPDATE command for tc BPF link to allow for a reliable
replacement of the underlying BPF program.

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/net.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
index 22b7a9b05483..c50bcf656b3f 100644
--- a/kernel/bpf/net.c
+++ b/kernel/bpf/net.c
@@ -303,6 +303,39 @@ static int __xtc_link_attach(struct bpf_link *l, u32 id)
 	return ret;
 }
 
+static int xtc_link_update(struct bpf_link *l, struct bpf_prog *nprog,
+			   struct bpf_prog *oprog)
+{
+	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
+	int ret = 0;
+
+	rtnl_lock();
+	if (!link->dev) {
+		ret = -ENOLINK;
+		goto out;
+	}
+	if (oprog && l->prog != oprog) {
+		ret = -EPERM;
+		goto out;
+	}
+	oprog = l->prog;
+	if (oprog == nprog) {
+		bpf_prog_put(nprog);
+		goto out;
+	}
+	ret = __xtc_prog_attach(link->dev, link->location == BPF_NET_INGRESS,
+				XTC_MAX_ENTRIES, l->id, nprog, link->priority,
+				BPF_F_REPLACE);
+	if (ret == link->priority) {
+		oprog = xchg(&l->prog, nprog);
+		bpf_prog_put(oprog);
+		ret = 0;
+	}
+out:
+	rtnl_unlock();
+	return ret;
+}
+
 static void xtc_link_release(struct bpf_link *l)
 {
 	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
@@ -327,6 +360,7 @@ static void xtc_link_dealloc(struct bpf_link *l)
 static const struct bpf_link_ops bpf_tc_link_lops = {
 	.release	= xtc_link_release,
 	.dealloc	= xtc_link_dealloc,
+	.update_prog	= xtc_link_update,
 };
 
 int xtc_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
-- 
2.34.1

