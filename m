Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA114EA903
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiC2IMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiC2IMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:12:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1463325C64
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 01:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648541466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X90O0KMU6UscdyhiWc2/dl9YEQfIncEUdXcssr5AopY=;
        b=FkSH70ORXB/2BMl5bUw7zzCEoxvMCSXObU98uniK+OrKrZ2JDQwS6iPtZc788NEh5wQlPw
        Nsbgga7AK1HxZmvA7RKRAZ5Ci0AtJSlF6r7MGc486fr6jHS1S32aH0jVw+zPuwV5OcXu2P
        ynN2842Bsd6qwdaSdbtXfYTkT8PMhgM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-xdy0N1zHOPWgSOw0cHkbog-1; Tue, 29 Mar 2022 04:11:03 -0400
X-MC-Unique: xdy0N1zHOPWgSOw0cHkbog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9597A3817487;
        Tue, 29 Mar 2022 08:11:03 +0000 (UTC)
Received: from astarta.redhat.com (unknown [10.39.194.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74FAD141DEC7;
        Tue, 29 Mar 2022 08:11:02 +0000 (UTC)
From:   Yauheni Kaliuta <ykaliuta@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, jolsa@kernel.org,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: [PATCH bpf-next] bpf: test_offload.py: skip base maps without names
Date:   Tue, 29 Mar 2022 11:11:00 +0300
Message-Id: <20220329081100.9705-1-ykaliuta@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test fails:

  # ./test_offload.py
  ...
  Test bpftool bound info reporting (own ns)...
  FAIL: 3 BPF maps loaded, expected 2
    File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1177, in <module>
      check_dev_info(False, "")
    File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 645, in check_dev_info
      maps = bpftool_map_list(expected=2, ns=ns)
    File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 190, in bpftool_map_list
      fail(True, "%d BPF maps loaded, expected %d" %
    File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 86, in fail
      tb = "".join(traceback.extract_stack().format())

Some base maps do not have names and they cannot be added due to
compatibility with older kernels, see
https://lore.kernel.org/bpf/CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com/

So, just skip the unnamed maps.

Signed-off-by: Yauheni Kaliuta <ykaliuta@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index edaffd43da83..6cd6ef9fc20b 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -184,7 +184,7 @@ def bpftool_prog_list(expected=None, ns=""):
 def bpftool_map_list(expected=None, ns=""):
     _, maps = bpftool("map show", JSON=True, ns=ns, fail=True)
     # Remove the base maps
-    maps = [m for m in maps if m not in base_maps and m.get('name') not in base_map_names]
+    maps = [m for m in maps if m not in base_maps and m.get('name') and m.get('name') not in base_map_names]
     if expected is not None:
         if len(maps) != expected:
             fail(True, "%d BPF maps loaded, expected %d" %
-- 
2.34.1

