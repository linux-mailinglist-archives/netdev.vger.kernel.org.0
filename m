Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD1A89B0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfIDPt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbfIDPt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:49:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A6D5301A3E3;
        Wed,  4 Sep 2019 15:49:56 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C09DB5C219;
        Wed,  4 Sep 2019 15:49:55 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next] bpf: fix snprintf truncation warning
Date:   Wed,  4 Sep 2019 17:50:24 +0200
Message-Id: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 04 Sep 2019 15:49:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc v9.2.1 produces the following warning compiling iproute2:

bpf.c: In function ‘bpf_get_work_dir’:
bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |                                                 ^
bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 7d2a322ffbaec..95de7894a93ce 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
 static const char *bpf_get_work_dir(enum bpf_prog_type type)
 {
 	static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
-	static char bpf_wrk_dir[PATH_MAX];
+	static char bpf_wrk_dir[PATH_MAX + 1];
 	static const char *mnt;
 	static bool bpf_mnt_cached;
 	const char *mnt_env = getenv(BPF_ENV_MNT);
-- 
2.21.0

