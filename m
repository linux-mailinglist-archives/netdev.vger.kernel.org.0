Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303CA686D1F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjBAReO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjBAReF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:34:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02B37D996
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihveDuzFC606cHuK0CWhFmOw3Dtun6pRSQ7Ol4lcUhM=;
        b=TflfSMCHN4xhHkqMziGJogY+6gLkxVYYQnBosiWQc28Hc2lTX8/zGSTMSdgxiSI8VPkiY4
        iDLWbbKu2fgZIaXhBBCoevpwUFOl5+bQttZLnaiuQ3gZ0JjJC6ufi8zAz942ZMv+nwcvgd
        xbO1lp9d/R33zoFyf01eef2SEYnVMBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-NVDNiMaPPeiuR9-M_IBZlA-1; Wed, 01 Feb 2023 12:32:02 -0500
X-MC-Unique: NVDNiMaPPeiuR9-M_IBZlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEFA7857F4F;
        Wed,  1 Feb 2023 17:32:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55E64140EBF4;
        Wed,  1 Feb 2023 17:32:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 66580300005EE;
        Wed,  1 Feb 2023 18:32:00 +0100 (CET)
Subject: [PATCH bpf-next V2 3/4] selftests/bpf: xdp_hw_metadata correct status
 value in error(3)
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 18:32:00 +0100
Message-ID: <167527272038.937063.9137108142012298120.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The glibc error reporting function error():
 void error(int status, int errnum, const char *format, ...);

The status argument should be a positive value between 0-255 as it
is passed over to the exit(3) function as the value as the shell exit
status. The least significant byte of status (i.e., status & 0xFF) is
returned to the shell parent.

Fix this by using 1 instead of -1. As 1 corresponds to C standard
constant EXIT_FAILURE.

Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/xdp_hw_metadata.c |   28 +++++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 438083e34cce..58fde35abad7 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -165,7 +165,7 @@ static void verify_skb_metadata(int fd)
 	hdr.msg_controllen = sizeof(cmsg_buf);
 
 	if (recvmsg(fd, &hdr, 0) < 0)
-		error(-1, errno, "recvmsg");
+		error(1, errno, "recvmsg");
 
 	for (cmsg = CMSG_FIRSTHDR(&hdr); cmsg != NULL;
 	     cmsg = CMSG_NXTHDR(&hdr, cmsg)) {
@@ -275,11 +275,11 @@ static int rxq_num(const char *ifname)
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0)
-		error(-1, errno, "socket");
+		error(1, errno, "socket");
 
 	ret = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (ret < 0)
-		error(-1, errno, "ioctl(SIOCETHTOOL)");
+		error(1, errno, "ioctl(SIOCETHTOOL)");
 
 	close(fd);
 
@@ -296,11 +296,11 @@ static void hwtstamp_ioctl(int op, const char *ifname, struct hwtstamp_config *c
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if (fd < 0)
-		error(-1, errno, "socket");
+		error(1, errno, "socket");
 
 	ret = ioctl(fd, op, &ifr);
 	if (ret < 0)
-		error(-1, errno, "ioctl(%d)", op);
+		error(1, errno, "ioctl(%d)", op);
 
 	close(fd);
 }
@@ -360,7 +360,7 @@ static void timestamping_enable(int fd, int val)
 
 	ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
 	if (ret < 0)
-		error(-1, errno, "setsockopt(SO_TIMESTAMPING)");
+		error(1, errno, "setsockopt(SO_TIMESTAMPING)");
 }
 
 int main(int argc, char *argv[])
@@ -386,13 +386,13 @@ int main(int argc, char *argv[])
 
 	rx_xsk = malloc(sizeof(struct xsk) * rxq);
 	if (!rx_xsk)
-		error(-1, ENOMEM, "malloc");
+		error(1, ENOMEM, "malloc");
 
 	for (i = 0; i < rxq; i++) {
 		printf("open_xsk(%s, %p, %d)\n", ifname, &rx_xsk[i], i);
 		ret = open_xsk(ifindex, &rx_xsk[i], i);
 		if (ret)
-			error(-1, -ret, "open_xsk");
+			error(1, -ret, "open_xsk");
 
 		printf("xsk_socket__fd() -> %d\n", xsk_socket__fd(rx_xsk[i].socket));
 	}
@@ -400,7 +400,7 @@ int main(int argc, char *argv[])
 	printf("open bpf program...\n");
 	bpf_obj = xdp_hw_metadata__open();
 	if (libbpf_get_error(bpf_obj))
-		error(-1, libbpf_get_error(bpf_obj), "xdp_hw_metadata__open");
+		error(1, libbpf_get_error(bpf_obj), "xdp_hw_metadata__open");
 
 	prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
 	bpf_program__set_ifindex(prog, ifindex);
@@ -409,12 +409,12 @@ int main(int argc, char *argv[])
 	printf("load bpf program...\n");
 	ret = xdp_hw_metadata__load(bpf_obj);
 	if (ret)
-		error(-1, -ret, "xdp_hw_metadata__load");
+		error(1, -ret, "xdp_hw_metadata__load");
 
 	printf("prepare skb endpoint...\n");
 	server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092, 1000);
 	if (server_fd < 0)
-		error(-1, errno, "start_server");
+		error(1, errno, "start_server");
 	timestamping_enable(server_fd,
 			    SOF_TIMESTAMPING_SOFTWARE |
 			    SOF_TIMESTAMPING_RAW_HARDWARE);
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 		printf("map[%d] = %d\n", queue_id, sock_fd);
 		ret = bpf_map_update_elem(bpf_map__fd(bpf_obj->maps.xsk), &queue_id, &sock_fd, 0);
 		if (ret)
-			error(-1, -ret, "bpf_map_update_elem");
+			error(1, -ret, "bpf_map_update_elem");
 	}
 
 	printf("attach bpf program...\n");
@@ -435,12 +435,12 @@ int main(int argc, char *argv[])
 			     bpf_program__fd(bpf_obj->progs.rx),
 			     XDP_FLAGS, NULL);
 	if (ret)
-		error(-1, -ret, "bpf_xdp_attach");
+		error(1, -ret, "bpf_xdp_attach");
 
 	signal(SIGINT, handle_signal);
 	ret = verify_metadata(rx_xsk, rxq, server_fd);
 	close(server_fd);
 	cleanup();
 	if (ret)
-		error(-1, -ret, "verify_metadata");
+		error(1, -ret, "verify_metadata");
 }


