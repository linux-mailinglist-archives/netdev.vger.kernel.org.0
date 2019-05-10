Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CBD19F90
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 16:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfEJOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 10:51:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55839 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfEJOvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 10:51:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id y2so7883859wmi.5
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sFayAsAGf9VfwymfHZYrt+EvnDpFNJyqNOOqTKNinDY=;
        b=axjeq/DmGcwHC+prSMZ5p2ro9yzkT090J+5ZDGhWHWl1doFGZjOhUi+wGU5h4VQ2/M
         P8TOw1uPTKBEJyGSaiiDVM0kzq33CZlGVd42bWjkDcVvqwngfDx4TKKqkfCMkjkfeg79
         KpYJz7elWCwahLeot+u9DD7Ue6bD7hhmoP7fRQDDMLO0gucRqZpfKEYodhl7kL3E4TJf
         dS3kpSO2r8XhI6wXQA/h6iRppGrwi7tNNSLNP3TcO9Io6NzC2FvaFa/NThkeE240lw1Z
         HWhHQbc5lnFwEAx3E6J7iJL9hA9Kv+NXzscSYY4j6ZwwSr4v7OCitPp6oiJRbVn6zzhi
         NlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sFayAsAGf9VfwymfHZYrt+EvnDpFNJyqNOOqTKNinDY=;
        b=RTmx0BJOra6LhNgfcjrMpM/LR/SFIV1+oqrVXuJFPNnMQaFK0OxIK4dorfAqsM35hz
         74YnOpNeEbvdfaZBFwAYdes0xzyNGFYJwiObBdFsweVhufOgzeZ229bGDYM5ZIgcCAFY
         Ey8ni1s6WdZq7hha5oYGhZkEYOTj+zTx4gE1/GKYkWGU1KNtmVEgRbfZxDbbu145SqGN
         kqWLYDKwakrnK1cyI3BoGY7gAPTxXDzT72KbJNfX1yv2gwb3xcNKrAS8ggPICEVHiNT5
         5xTTkUKJ8eHVG9klZBhULPPLVkgzziFDENJc9T/nWQiqHtdB3beIcVMlAFDiMPgPEioI
         BvjA==
X-Gm-Message-State: APjAAAW1WryvpRYHu2SKycTtMzBgtPM4QNpkRDFUB4RXERupCcvWE+tv
        EuByWSiOkmLBJTT0Ti7TWMFOdw==
X-Google-Smtp-Source: APXvYqxyKJFfZd2QebbBAK7a0ff0YcuGtyosnk7HHMqMRICsrWNO4/quStQuxj8OC4hHk1Elk5cTgA==
X-Received: by 2002:a1c:f504:: with SMTP id t4mr7208723wmh.121.1557499899612;
        Fri, 10 May 2019 07:51:39 -0700 (PDT)
Received: from reblochon.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p17sm7561027wrg.92.2019.05.10.07.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 07:51:38 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 1/4] bpf: fix script for generating man page on BPF helpers
Date:   Fri, 10 May 2019 15:51:22 +0100
Message-Id: <20190510145125.8416-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20190510145125.8416-1-quentin.monnet@netronome.com>
References: <20190510145125.8416-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The script broke on parsing function prototype for bpf_strtoul(). This
is because the last argument for the function is a pointer to an
"unsigned long". The current version of the script only accepts "const"
and "struct", but not "unsigned", at the beginning of argument types
made of several words.

One solution could be to add "unsigned" to the list, but the issue could
come up again in the future (what about "long int"?). It turns out we do
not need to have such restrictions on the words: so let's simply accept
any series of words instead.

Reported-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 scripts/bpf_helpers_doc.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 5010a4d5bfba..894cc58c1a03 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -1,7 +1,7 @@
 #!/usr/bin/python3
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Copyright (C) 2018 Netronome Systems, Inc.
+# Copyright (C) 2018-2019 Netronome Systems, Inc.
 
 # In case user attempts to run with Python 2.
 from __future__ import print_function
@@ -39,7 +39,7 @@ class Helper(object):
         Break down helper function protocol into smaller chunks: return type,
         name, distincts arguments.
         """
-        arg_re = re.compile('((const )?(struct )?(\w+|...))( (\**)(\w+))?$')
+        arg_re = re.compile('((\w+ )*?(\w+|...))( (\**)(\w+))?$')
         res = {}
         proto_re = re.compile('(.+) (\**)(\w+)\(((([^,]+)(, )?){1,5})\)$')
 
@@ -54,8 +54,8 @@ class Helper(object):
             capture = arg_re.match(a)
             res['args'].append({
                 'type' : capture.group(1),
-                'star' : capture.group(6),
-                'name' : capture.group(7)
+                'star' : capture.group(5),
+                'name' : capture.group(6)
             })
 
         return res
-- 
2.14.1

