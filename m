Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635F25F4C78
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJDXMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJDXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:12 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881C9564E4;
        Tue,  4 Oct 2022 16:12:10 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr57-000AJT-31; Wed, 05 Oct 2022 01:12:09 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 05/10] bpf: Implement link detach for tc BPF link programs
Date:   Wed,  5 Oct 2022 01:11:38 +0200
Message-Id: <20221004231143.19190-6-daniel@iogearbox.net>
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

Add support for forced detach operation of tc BPF link. This detaches the link
but without destroying it. It has the same semantics as auto-detaching of BPF
link due to e.g. net device being destroyed for tc or XDP BPF link. Meaning,
in this case the BPF link is still a valid kernel object, but is defunct given
it is not attached anywhere anymore. It still holds a reference to the BPF
program, though. This functionality allows users with enough access rights to
manually force-detach attached tc BPF link without killing respective owner
process and to then introspect/debug the BPF assets. Similar LINK_DETACH exists
also for other BPF link types.

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/net.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
index a74b86bb60a9..5650f62c1315 100644
--- a/kernel/bpf/net.c
+++ b/kernel/bpf/net.c
@@ -350,6 +350,12 @@ static void xtc_link_release(struct bpf_link *l)
 	rtnl_unlock();
 }
 
+static int xtc_link_detach(struct bpf_link *l)
+{
+	xtc_link_release(l);
+	return 0;
+}
+
 static void xtc_link_dealloc(struct bpf_link *l)
 {
 	struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
@@ -393,6 +399,7 @@ static int xtc_link_fill_info(const struct bpf_link *l,
 
 static const struct bpf_link_ops bpf_tc_link_lops = {
 	.release	= xtc_link_release,
+	.detach		= xtc_link_detach,
 	.dealloc	= xtc_link_dealloc,
 	.update_prog	= xtc_link_update,
 	.show_fdinfo	= xtc_link_fdinfo,
-- 
2.34.1

