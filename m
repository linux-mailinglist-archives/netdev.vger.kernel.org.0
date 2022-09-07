Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B25B08F2
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIGPpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIGPpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC101705E
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfnpNVOn8bVeC3t2vM1lmC87z9StKK7QVfzUjHELd7M=;
        b=XnKGPbzVvTT+4J1dn0uLjBKdQxdsZFbQ0Wy3tM3khtycn15FMC7twSOzhS+VBCErDrZtGD
        kUVpvsiLXjwtgONM2+7js5m0raT34KBYG4lb2Aswk97S8rs4qqnxrScl+Lt4QzDgfAgDhu
        AqeInseJI3BNWWRUFbdiwudE+IkZYMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-uTG5rkmhOmSngS_6zY5Nxw-1; Wed, 07 Sep 2022 11:45:12 -0400
X-MC-Unique: uTG5rkmhOmSngS_6zY5Nxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0102B801231;
        Wed,  7 Sep 2022 15:45:12 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B623290A04;
        Wed,  7 Sep 2022 15:45:11 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BC87230721A6C;
        Wed,  7 Sep 2022 17:45:10 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 02/18] libbpf: try to load vmlinux BTF from the
 kernel first
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:10 +0200
Message-ID: <166256551073.1434226.11702276674514019182.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

Try to acquire vmlinux BTF the same way it's being done for module
BTFs. Use btf_load_next_with_info() and resort to the filesystem
lookup only if it fails.

Also, adjust debug messages in btf__load_vmlinux_btf() to reflect
that it actually tries to load vmlinux BTF.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/btf.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index cad11c56cf1f..1fd12a2e1b08 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4744,6 +4744,25 @@ struct btf *btf_load_next_with_info(__u32 start_id, struct bpf_btf_info *info,
 	}
 }
 
+static struct btf *btf_load_vmlinux_from_kernel(void)
+{
+	char name[BTF_NAME_BUF_LEN] = { };
+	struct bpf_btf_info info;
+	struct btf *btf;
+
+	memset(&info, 0, sizeof(info));
+	info.name = ptr_to_u64(name);
+	info.name_len = sizeof(name);
+
+	btf = btf_load_next_with_info(0, &info, NULL, true);
+	if (!libbpf_get_error(btf)) {
+		close(btf->fd);
+		btf__set_fd(btf, -1);
+	}
+
+	return btf;
+}
+
 /*
  * Probe few well-known locations for vmlinux kernel image and try to load BTF
  * data out of it to use for target BTF.
@@ -4770,6 +4789,15 @@ struct btf *btf__load_vmlinux_btf(void)
 	struct btf *btf;
 	int i, err;
 
+	btf = btf_load_vmlinux_from_kernel();
+	err = libbpf_get_error(btf);
+	pr_debug("loading vmlinux BTF from kernel: %d\n", err);
+	if (!err)
+		return btf;
+
+	pr_info("failed to load vmlinux BTF from kernel: %d, will look through filesystem\n",
+		err);
+
 	uname(&buf);
 
 	for (i = 0; i < ARRAY_SIZE(locations); i++) {
@@ -4783,14 +4811,14 @@ struct btf *btf__load_vmlinux_btf(void)
 		else
 			btf = btf__parse_elf(path, NULL);
 		err = libbpf_get_error(btf);
-		pr_debug("loading kernel BTF '%s': %d\n", path, err);
+		pr_debug("loading vmlinux BTF '%s': %d\n", path, err);
 		if (err)
 			continue;
 
 		return btf;
 	}
 
-	pr_warn("failed to find valid kernel BTF\n");
+	pr_warn("failed to find valid vmlinux BTF\n");
 	return libbpf_err_ptr(-ESRCH);
 }
 


