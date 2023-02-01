Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC1686D20
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjBAReY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjBAReQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:34:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E028C171
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PM+cJWN8nqTtyXDobjfXnOOJBoI+UmCw0CJPEQIXEpA=;
        b=RY/RWFc5QKRnFpA8mXNKtP6sOzWCKk1eUDUETUPfMp5q4qJv/s1qcGXZHsjHoQYPMEa9hT
        afD1/lxY0X1g8C8FkYvumxMsyypQCmIiFDCY7/rc5CkJkD4z+B5vbCw1oXeD1YHZh2dOMP
        nJmC86GYfGhvb6BFKLRrtfB/v8GuFiA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-lsa-gwieOzaUruCJ6FDLnw-1; Wed, 01 Feb 2023 12:32:16 -0500
X-MC-Unique: lsa-gwieOzaUruCJ6FDLnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA804281DE77;
        Wed,  1 Feb 2023 17:32:06 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65EF12166B33;
        Wed,  1 Feb 2023 17:32:06 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 726083000061C;
        Wed,  1 Feb 2023 18:32:05 +0100 (CET)
Subject: [PATCH bpf-next V2 4/4] selftests/bpf: xdp_hw_metadata use strncpy
 for ifname
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 18:32:05 +0100
Message-ID: <167527272543.937063.16993147790832546209.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifname char pointer is taken directly from the command line
as input and the string is copied directly into struct ifreq
via strcpy. This makes it easy to corrupt other members of ifreq
and generally do stack overflows.

Most often the ioctl will fail with:
 ./xdp_hw_metadata: ioctl(SIOCETHTOOL): Bad address

As people will likely copy-paste code for getting NIC queue
channels (rxq_num) and enabling HW timestamping (hwtstamp_ioctl)
lets make this code a bit more secure by using strncpy.

Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/xdp_hw_metadata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 58fde35abad7..2a66bd3f2c9f 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -270,7 +270,7 @@ static int rxq_num(const char *ifname)
 	struct ifreq ifr = {
 		.ifr_data = (void *)&ch,
 	};
-	strcpy(ifr.ifr_name, ifname);
+	strncpy(ifr.ifr_name, ifname, IF_NAMESIZE - 1);
 	int fd, ret;
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
@@ -291,7 +291,7 @@ static void hwtstamp_ioctl(int op, const char *ifname, struct hwtstamp_config *c
 	struct ifreq ifr = {
 		.ifr_data = (void *)cfg,
 	};
-	strcpy(ifr.ifr_name, ifname);
+	strncpy(ifr.ifr_name, ifname, IF_NAMESIZE - 1);
 	int fd, ret;
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);


