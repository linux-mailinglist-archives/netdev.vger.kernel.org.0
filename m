Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7340610EA28
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 13:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfLBMhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 07:37:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfLBMhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 07:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575290259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yKdovxrcS0kfPyHRtLPGUT9M9ZoTTuzziE5WyqUZ19Q=;
        b=ZfOrxrbuKjCI7dIyE4FYXo4NK9WrZ49ct3CU9T1O2t3ToKcsn0kpQd/TAJZsRA/7I2dTCo
        DOkdI/tDFZujrJkn2SotdgM1+BG8FBkeBF1JrcXVJPWF4u1pgZHQcAdjFLonNMwvN/1ubu
        cxRyIPFMY5V5xCPIexreBTgms2YvgGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-UFqDkaEXMeytyetN9qZbxA-1; Mon, 02 Dec 2019 07:37:36 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86C5FDB20;
        Mon,  2 Dec 2019 12:37:35 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-58.brq.redhat.com [10.40.200.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2F75C290;
        Mon,  2 Dec 2019 12:37:32 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 566DD319D2A0B;
        Mon,  2 Dec 2019 13:37:31 +0100 (CET)
Subject: [bpf PATCH] samples/bpf: fix broken xdp_rxq_info due to map order
 assumptions
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        danieltimlee@gmail.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 02 Dec 2019 13:37:31 +0100
Message-ID: <157529025128.29832.5953245340679936909.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: UFqDkaEXMeytyetN9qZbxA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the days of using bpf_load.c the order in which the 'maps' sections
were defines in BPF side (*_kern.c) file, were used by userspace side
to identify the map via using the map order as an index. In effect the
order-index is created based on the order the maps sections are stored
in the ELF-object file, by the LLVM compiler.

This have also carried over in libbpf via API bpf_map__next(NULL, obj)
to extract maps in the order libbpf parsed the ELF-object file.

When BTF based maps were introduced a new section type ".maps" were
created. I found that the LLVM compiler doesn't create the ".maps"
sections in the order they are defined in the C-file. The order in the
ELF file is based on the order the map pointer is referenced in the code.

This combination of changes lead to xdp_rxq_info mixing up the map
file-descriptors in userspace, resulting in very broken behaviour, but
without warning the user.

This patch fix issue by instead using bpf_object__find_map_by_name()
to find maps via their names. (Note, this is the ELF name, which can
be longer than the name the kernel retains).

Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_load to libbpf")
Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax BTF-defined map")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_rxq_info_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 51e0d810e070..8fc3ad01de72 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -489,9 +489,9 @@ int main(int argc, char **argv)
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return EXIT_FAIL;
 
-	map = bpf_map__next(NULL, obj);
-	stats_global_map = bpf_map__next(map, obj);
-	rx_queue_index_map = bpf_map__next(stats_global_map, obj);
+	map =  bpf_object__find_map_by_name(obj, "config_map");
+	stats_global_map = bpf_object__find_map_by_name(obj, "stats_global_map");
+	rx_queue_index_map = bpf_object__find_map_by_name(obj, "rx_queue_index_map");
 	if (!map || !stats_global_map || !rx_queue_index_map) {
 		printf("finding a map in obj file failed\n");
 		return EXIT_FAIL;

