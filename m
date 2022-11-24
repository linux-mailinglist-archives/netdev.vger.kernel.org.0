Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87276637CA7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiKXPSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiKXPSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:18:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1367715B4C1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAJYIVS7w3VHw6GPJCxv8d/p+6Nx7C8D/UTcdk+DlLc=;
        b=E72kW2PkeKR4fI+wL689/nMls4h0qvTzspRPJJ3lpzXAy0BEOW+YMrMkxeIWYDkwMx4RKV
        pjKMbOLDlLZXOulA9rvn+TCs0tC4pLFvJXyeMlpOKn2jMYXKx36UFxWj7l9DAgLmqQcse6
        ubtVQaC9nYzlu1XZdyqMkyhUDNyqC8c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-HPzI6D8PNnm5Bc0Sqkuylw-1; Thu, 24 Nov 2022 10:16:12 -0500
X-MC-Unique: HPzI6D8PNnm5Bc0Sqkuylw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C61E29AB3F2;
        Thu, 24 Nov 2022 15:16:11 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE91640C2064;
        Thu, 24 Nov 2022 15:16:09 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 01/10] bpftool: generate json output of skeletons
Date:   Thu, 24 Nov 2022 16:15:54 +0100
Message-Id: <20221124151603.807536-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So we can then build light skeletons with loaders in any language.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/bpf/bpftool/gen.c | 95 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cf8b4e525c88..818a5209b3ac 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -904,6 +904,96 @@ codegen_progs_skeleton(struct bpf_object *obj, size_t prog_cnt, bool populate_li
 	}
 }
 
+static int gen_json(struct bpf_object *obj, const char *obj_name, size_t file_sz, uint8_t *obj_data)
+{
+	struct bpf_program *prog;
+	struct bpf_map *map;
+	char ident[256];
+
+	jsonw_start_object(json_wtr);	/* root object */
+
+	jsonw_string_field(json_wtr, "name", obj_name);
+
+	jsonw_bool_field(json_wtr, "use_loader", use_loader);
+
+	/* print all maps */
+	jsonw_name(json_wtr, "maps");
+	jsonw_start_array(json_wtr);
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident))) {
+			p_err("ignoring unrecognized internal map '%s'...",
+			      bpf_map__name(map));
+			continue;
+		}
+
+		jsonw_start_object(json_wtr);	/* map object */
+		jsonw_string_field(json_wtr, "ident", ident);
+		jsonw_string_field(json_wtr, "name", bpf_map__name(map));
+
+		/* print mmap data value */
+		if (is_internal_mmapable_map(map, ident, sizeof(ident))) {
+			const void *mmap_data = NULL;
+			size_t mmap_size = 0;
+
+			mmap_data = bpf_map__initial_value(map, &mmap_size);
+
+			jsonw_uint_field(json_wtr, "size", mmap_size);
+			jsonw_uint_field(json_wtr, "mmap_sz", bpf_map_mmap_sz(map));
+			jsonw_name(json_wtr, "data");
+			print_hex_data_json((uint8_t *)mmap_data, mmap_size);
+
+		}
+		jsonw_end_object(json_wtr);	/* map object */
+	}
+	jsonw_end_array(json_wtr);
+
+	/* print all progs */
+	jsonw_name(json_wtr, "progs");
+	jsonw_start_array(json_wtr);
+	bpf_object__for_each_program(prog, obj) {
+		jsonw_start_object(json_wtr);	/* prog object */
+		jsonw_string_field(json_wtr, "name", bpf_program__name(prog));
+		jsonw_string_field(json_wtr, "sec", bpf_program__section_name(prog));
+		jsonw_end_object(json_wtr);	/* prog object */
+	}
+	jsonw_end_array(json_wtr);
+
+	/* print object data */
+	if (use_loader) {
+		DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
+		int err = 0;
+
+		err = bpf_object__gen_loader(obj, &opts);
+		if (err)
+			return err;
+
+		err = bpf_object__load(obj);
+		if (err) {
+			p_err("failed to load object file");
+			return err;
+		}
+		/* If there was no error during load then gen_loader_opts
+		 * are populated with the loader program.
+		 */
+
+		jsonw_uint_field(json_wtr, "data_sz", opts.data_sz);
+		jsonw_name(json_wtr, "data");
+		print_hex_data_json((uint8_t *)opts.data, opts.data_sz);
+
+		jsonw_uint_field(json_wtr, "insns_sz", opts.insns_sz);
+		jsonw_name(json_wtr, "insns");
+		print_hex_data_json((uint8_t *)opts.insns, opts.insns_sz);
+
+	} else {
+		jsonw_name(json_wtr, "data");
+		print_hex_data_json(obj_data, file_sz);
+	}
+
+	jsonw_end_object(json_wtr);	/* root object */
+
+	return 0;
+}
+
 static int do_skeleton(int argc, char **argv)
 {
 	char header_guard[MAX_OBJ_NAME_LEN + sizeof("__SKEL_H__")];
@@ -986,6 +1076,11 @@ static int do_skeleton(int argc, char **argv)
 		goto out;
 	}
 
+	if (json_output) {
+		err = gen_json(obj, obj_name, file_sz, (uint8_t *)obj_data);
+		goto out;
+	}
+
 	bpf_object__for_each_map(map, obj) {
 		if (!get_map_ident(map, ident, sizeof(ident))) {
 			p_err("ignoring unrecognized internal map '%s'...",
-- 
2.38.1

