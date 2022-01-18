Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B907C491425
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbiARCUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244483AbiARCUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:20:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449F1C06174E;
        Mon, 17 Jan 2022 18:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC825B81233;
        Tue, 18 Jan 2022 02:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6CFC36AE3;
        Tue, 18 Jan 2022 02:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472400;
        bh=RCAXm/IjT3B6yE8K0IDp6JIGWscVB0c2c/ZLJ90b314=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dw1CEwFR2ddLfnn+SpKOCWEaGUgHO65Wr9fQgpsXZ2ek9NQfVytQpwROpffnzi+BD
         RVaS84tXwNjCaDqrxfHiI2YkmklDCy9kb97/FktUjYcq5ZQqqvfyyRIts3f6cO2N6J
         zGwEfz00jI17jqTeh5DxEb680gxMbiqK0A8uuiumKhOwmi6ZjMVX9qA2ToMlGo2u2P
         RYpogKJR7UTFKEzo/3XlVwS++t5fLyfyBu4FkkgpNpRtZXg66IdCGbs+OGTQrMlHhp
         Hw2rWi2tR0aW51Tv1rrz4F3Yo7ymd6PB2YDooTSTBItvV8KpiHly6GrJ26ozL4j8/2
         tNkrMw21QGIPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 012/217] selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
Date:   Mon, 17 Jan 2022 21:16:15 -0500
Message-Id: <20220118021940.1942199-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index b5b6b013a245e..3d1a748d09d81 100644
--- a/tools/testing/selftests/bpf/btf_helpers.c
+++ b/tools/testing/selftests/bpf/btf_helpers.c
@@ -251,18 +251,23 @@ const char *btf_type_c_dump(const struct btf *btf)
 	d = btf_dump__new(btf, NULL, &opts, btf_dump_printf);
 	if (libbpf_get_error(d)) {
 		fprintf(stderr, "Failed to create btf_dump instance: %ld\n", libbpf_get_error(d));
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 1; i < btf__type_cnt(btf); i++) {
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

