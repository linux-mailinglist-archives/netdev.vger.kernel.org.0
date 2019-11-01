Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D901EBC38
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfKADHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:07:16 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38123 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfKADHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 23:07:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so8391123ljc.5
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 20:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfUkQyN3RzxIcav+D6x6sO0JAA435HHfSQWwlH7mKSk=;
        b=hIGuQSYAY5MsCPjjvvThdY49L9NfjgpTd3JVqTg+AJmx0KWteXXFmADNitM3mKRiv1
         Y0c2A+SzrqgNv9FP7+jIf0i2+4ghewv1RTge89FFa82eilStWkQGWc3tfnQipK90SPU4
         riRyVVVfvkU7XIv9E6mzayZVUNliJPMnFwvRH+SxjcAdAC55cZGcKJuZf4IGZ02CDqBH
         WzZYs44TS3a73d7m9ERCgXbpWDywU2ZxZWj1PlpDbevkN6cjXRNbNFU4o/5+7SvdUaSb
         f8d3sbIshP2ayeXSubJj35jrQ4Nqw3G30RfQsCH5RKxVZgM0x53XfkJD7U2SwyMiGn8z
         tidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfUkQyN3RzxIcav+D6x6sO0JAA435HHfSQWwlH7mKSk=;
        b=bU5J3rMVfcUMn4NSGMr8adA/ChUvIzUzDFVLLVj28T0/sz15WrrtUBaEJSSBJMay6o
         /MBzoME5X0ZDh1TAqvbi3o0PS9t+32BlKfuBqCXDmVVVRICMYGoq6NKXVJXcF2mE6dV3
         3dIjyBiJvucMIT3uNxIVMPM1vg4UM2OlPfV1NlEefFp+DiJOQbtPdncevWCHjFdgeAeY
         cKHRTg+cbAh5yTVJ6r0ew6n6qEQQsNK/iykX7jhXLEx8O7N7HLEaIfp9/9QyPSGV5zhR
         2L1dsj81EwUkFfbWMvPIPEPOzr2NxVqEjesD1U+Dkfvf3cX59xkuofgIZObz5l2uyOyw
         QeAQ==
X-Gm-Message-State: APjAAAWi7KVDqHADA5QBoAGSktknxG+wmnPzuMFbv4rgoA/BGQeyDKq7
        f5EJl2YVMsQ9mOswSOqa/lOZbw==
X-Google-Smtp-Source: APXvYqxjUH/6CaZ5DRifHl74F8b1rPWnLO1GAvxpWUy3jo9miYrMlg/RCd9tZJCFmPbc+jXFxHjxjQ==
X-Received: by 2002:a2e:898d:: with SMTP id c13mr2714610lji.54.1572577633777;
        Thu, 31 Oct 2019 20:07:13 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v6sm3926282ljd.15.2019.10.31.20.07.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 20:07:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net 1/3] selftests: bpf: Skip write only files in debugfs
Date:   Thu, 31 Oct 2019 20:06:58 -0700
Message-Id: <20191101030700.13080-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191101030700.13080-1-jakub.kicinski@netronome.com>
References: <20191101030700.13080-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DebugFS for netdevsim now contains some "action trigger" files
which are write only. Don't try to capture the contents of those.

Note that we can't use os.access() because the script requires
root.

Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
CC: Jiri Pirko <jiri@mellanox.com>

 tools/testing/selftests/bpf/test_offload.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 15a666329a34..1afa22c88e42 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -22,6 +22,7 @@ import os
 import pprint
 import random
 import re
+import stat
 import string
 import struct
 import subprocess
@@ -311,7 +312,11 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
         for f in out.split():
             if f == "ports":
                 continue
+
             p = os.path.join(path, f)
+            if not os.stat(p).st_mode & stat.S_IRUSR:
+                continue
+
             if os.path.isfile(p):
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
-- 
2.23.0

