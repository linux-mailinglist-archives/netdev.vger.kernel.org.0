Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E294916FB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344771AbiARCh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245407AbiARCdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:33:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052C8C0613E5;
        Mon, 17 Jan 2022 18:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B60B2B81243;
        Tue, 18 Jan 2022 02:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80406C36AF4;
        Tue, 18 Jan 2022 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473127;
        bh=xSjM7sQ/q68pyXWnObsGO6CNownTJ0gLgJiruFyMyig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfE+eNaxxDTiLpnNkUd624XK2awAfpgu5nUpBb4+Qyfr88JK/8oBNyANPEMOna+UZ
         2tsn3ZdDfXa/DHRi8C656Re5P4sgFVLi9e4YWG7EEJlxNyENHOd0mop/uTDxnfa4VV
         fjwX5IhYzmGB1vDAMCdX9k1C6vISzru4wjUz11WDUc+CTmp7m04mbme6jhQjSi78ly
         wrtn4i0a6thyKdv7WZxHIlQSAeuT9Vk5gPi6lrq/A95G2KBKK1a51pEmQHzU6lQ85k
         fwscyOoPEojDaotlDs0BYenKy58ti5PX+xZy6Kj00apDALvEbGuANf2OQ/51SNwrhV
         cprOt5iDDaNew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 008/188] selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
Date:   Mon, 17 Jan 2022 21:28:52 -0500
Message-Id: <20220118023152.1948105-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8ba285874913da21ca39a46376e9cc5ce0f45f94 ]

Free up memory and resources used by temporary allocated memstream and
btf_dump instance.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211107165521.9240-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/btf_helpers.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/btf_helpers.c b/tools/testing/selftests/bpf/btf_helpers.c
index b692e6ead9b55..0a4ad7cb2c200 100644
--- a/tools/testing/selftests/bpf/btf_helpers.c
+++ b/tools/testing/selftests/bpf/btf_helpers.c
@@ -246,18 +246,23 @@ const char *btf_type_c_dump(const struct btf *btf)
 	d = btf_dump__new(btf, NULL, &opts, btf_dump_printf);
 	if (libbpf_get_error(d)) {
 		fprintf(stderr, "Failed to create btf_dump instance: %ld\n", libbpf_get_error(d));
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		err = btf_dump__dump_type(d, i);
 		if (err) {
 			fprintf(stderr, "Failed to dump type [%d]: %d\n", i, err);
-			return NULL;
+			goto err_out;
 		}
 	}
 
+	btf_dump__free(d);
 	fflush(buf_file);
 	fclose(buf_file);
 	return buf;
+err_out:
+	btf_dump__free(d);
+	fclose(buf_file);
+	return NULL;
 }
-- 
2.34.1

