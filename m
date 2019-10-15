Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3BD72B1
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbfJOKBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:01:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38010 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfJOKBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:01:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id y18so13609402wrn.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 03:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DiaupeIJrwROvIGxYvgmIUTrsEMw9ejA5J0MWI+y7Yw=;
        b=dfHJBSasQVHb2X3Ev8SiMMWZVx5jF6306hqzzk9+MYSE5z0y5yYTL6ieZiIPXQN5Cv
         wNEfUyIsilko4hRO5wsZNgBtDC2XlvDuIKeM5mnUCfy+imp8ocGSbN5eI/gDqOdvfCxc
         frjG3XfJ1UfopGpdq7hMYsTMuPt64VeoxwINI+BymLzeKVyBiBgJFdYnZf71tzI42CXH
         XwcwM/+fgLC2oy868Vqcdp4vxLe9tZHuNuU39z9TlpRPEsl6HuebZP7ShGvkfk7nMOIa
         afwHvhSvUZC+siC57uGlJtLqht7wjDJEsCctR3AtQkx6JEcYselS4avlbeniRMVneBnU
         8EiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DiaupeIJrwROvIGxYvgmIUTrsEMw9ejA5J0MWI+y7Yw=;
        b=p4mJ+9uPc9VGlKUZ7tkqZ3wNsYWzvVtJMoUzyRnRTnVPxC9zjCmLEIBWV8pkioTnmH
         PLKCQLnSVggorkrsU/EIu5ep9a5wWuw36y6HPjfCP/aYztTnTQ2wbbjqtPOfr9J9Uj+7
         M1M4rSYF2g3w5QxhtkObMiankz5D0ewaNo864UdAvY/CF0bZB4K1iR/RBh1PUuGEJ996
         W3vjnyime6rZOHfWpUjJo6a8MiFEQmGGWQlkJDjAZX6XeHnpqTpUP5NSa3sDPMVQNFXY
         gZw8/z/F88oN30hamBSkuOF5L/URWyacDZ1Gqrxtfq84m2VLfS6gYf4s35ezkLiBd9R8
         HInw==
X-Gm-Message-State: APjAAAWA7fDMy7GUZDjRf8BSKKn3/OnyJ6+7ODUkLmzPJ0FHrgb+UsP9
        2pNM4pM4GkPkjVxzs1EWXowABAsV9qs=
X-Google-Smtp-Source: APXvYqyPIhZMgdkrN5oDahA1Gj6R6SzOXcOzLy1CsGGt6HfvJFuiJFON6M2piJ/yK5lA1XuuzIuw2Q==
X-Received: by 2002:adf:f547:: with SMTP id j7mr31653765wrp.26.1571133658276;
        Tue, 15 Oct 2019 03:00:58 -0700 (PDT)
Received: from localhost (ip-89-177-225-135.net.upcbroadband.cz. [89.177.225.135])
        by smtp.gmail.com with ESMTPSA id e9sm3513336wme.3.2019.10.15.03.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 03:00:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        rong.a.chen@intel.com, mlxsw@mellanox.com
Subject: [patch net-next] selftests: bpf: don't try to read files without read permission
Date:   Tue, 15 Oct 2019 12:00:56 +0200
Message-Id: <20191015100057.19199-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Recently couple of files that are write only were added to netdevsim
debugfs. Don't read these files and avoid error.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/bpf/test_offload.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 15a666329a34..c44c650bde3a 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -312,7 +312,7 @@ class DebugfsDir:
             if f == "ports":
                 continue
             p = os.path.join(path, f)
-            if os.path.isfile(p):
+            if os.path.isfile(p) and os.access(p, os.R_OK):
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
             elif os.path.isdir(p):
-- 
2.21.0

