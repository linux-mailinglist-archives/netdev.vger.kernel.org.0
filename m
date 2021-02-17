Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAED731D3A4
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBQBLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhBQBJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:26 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C6C061794;
        Tue, 16 Feb 2021 17:08:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b145so7355790pfb.4;
        Tue, 16 Feb 2021 17:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dv8MkLcOtY2EeZNXcDWE1hLwVEjep3x1oeuEfehCxV8=;
        b=QJk/AXrEZD0nnTG+SBuG0PXQqRRTtcvl/el5ihhrL+Vp+k27B1cYx+izpy/t6TxRrY
         /0UftaLwyjUqsf0yNOG0GKzewUroeBxE7G4SezmXsCwNTqCdX9HMjdQaEtLTUyCsZKQT
         FAgLsujgCMbu+7Y8KEefMzpiskvsixQKbsuk9JDgy4o2Uk5AUeGcBlJl+IWiqrdq9dZi
         wCgWOj9u4Jk1tsEsrOceJBp0KIGRI7Wl+i3uTkZ86XwlhalyMRxzTtilL2hWCYg3/ixF
         atbN84cmfiYM3kvy1/GOqNQethwhRFrxs89gAh87B3zOc3IBxZApnw+ddvU1fKyts09Z
         x9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dv8MkLcOtY2EeZNXcDWE1hLwVEjep3x1oeuEfehCxV8=;
        b=lttzFdTDvUTmiYC1/vssI280TQwNHZUNSLU5jB/AxMWGgVUNNUZU3ArUCMpRGmpy4g
         ++bN6Jdnmh9/zwFM9NacBaXxR6sU9A/aflqtRrOnW/UQ0eYui8HULd7pvKip1/DRT/vE
         JzJKcL5JD0CuHmtQGaE6l1W2FsoBrykjxW5Nu5npfcPSDThhuyg6hDtRVUuFpCfCAWHg
         ZhdzC7C3YedW0SwuIRWUBAoY3b3xUWtm+BMNPhobxoyiu3GhSBr/KM/VZVfaWhLRtRto
         6Zs/c8usIv0nq1AEXPo34rpq0jJauouOAMCs4iDFZXCU+YTzj77sdf/oowty5W8v3NlL
         EFvQ==
X-Gm-Message-State: AOAM530ULATPpZKj2MO43KBYKxYrRSZZ7B1Q5bouZbhGlnvLyxw8MdRv
        RlJggX+lkWJ2Ch71FmFqu6Psc/eDrATtXw==
X-Google-Smtp-Source: ABdhPJwyTPjZaCWLnMiC3snH3GqI4Sb2IRUhCLx4Iu4/+x0u9NejvQ1GU78eSglp9EA0KPbKmCHCMQ==
X-Received: by 2002:a05:6a00:8f:b029:1e8:6975:395e with SMTP id c15-20020a056a00008fb02901e86975395emr22066650pfj.55.1613524123354;
        Tue, 16 Feb 2021 17:08:43 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:42 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 10/17] scripts/bpf: Abstract eBPF API target parameter
Date:   Tue, 16 Feb 2021 17:08:14 -0800
Message-Id: <20210217010821.1810741-11-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Abstract out the target parameter so that upcoming commits, more than
just the existing "helpers" target can be called to generate specific
portions of docs from the eBPF UAPI headers.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 scripts/bpf_doc.py | 87 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 26 deletions(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index ca6e7559d696..5a4f68aab335 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -2,6 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
 # Copyright (C) 2018-2019 Netronome Systems, Inc.
+# Copyright (C) 2021 Isovalent, Inc.
 
 # In case user attempts to run with Python 2.
 from __future__ import print_function
@@ -165,10 +166,11 @@ class Printer(object):
     """
     A generic class for printers. Printers should be created with an array of
     Helper objects, and implement a way to print them in the desired fashion.
-    @helpers: array of Helper objects to print to standard output
+    @parser: A HeaderParser with objects to print to standard output
     """
-    def __init__(self, helpers):
-        self.helpers = helpers
+    def __init__(self, parser):
+        self.parser = parser
+        self.elements = []
 
     def print_header(self):
         pass
@@ -181,19 +183,23 @@ class Printer(object):
 
     def print_all(self):
         self.print_header()
-        for helper in self.helpers:
-            self.print_one(helper)
+        for elem in self.elements:
+            self.print_one(elem)
         self.print_footer()
 
+
 class PrinterRST(Printer):
     """
-    A printer for dumping collected information about helpers as a ReStructured
-    Text page compatible with the rst2man program, which can be used to
-    generate a manual page for the helpers.
-    @helpers: array of Helper objects to print to standard output
+    A generic class for printers that print ReStructured Text. Printers should
+    be created with a HeaderParser object, and implement a way to print API
+    elements in the desired fashion.
+    @parser: A HeaderParser with objects to print to standard output
     """
-    def print_header(self):
-        header = '''\
+    def __init__(self, parser):
+        self.parser = parser
+
+    def print_license(self):
+        license = '''\
 .. Copyright (C) All BPF authors and contributors from 2014 to present.
 .. See git log include/uapi/linux/bpf.h in kernel tree for details.
 .. 
@@ -223,7 +229,37 @@ class PrinterRST(Printer):
 .. located in file include/uapi/linux/bpf.h of the Linux kernel sources
 .. (helpers description), and from scripts/bpf_doc.py in the same
 .. repository (header and footer).
+'''
+        print(license)
+
+    def print_elem(self, elem):
+        if (elem.desc):
+            print('\tDescription')
+            # Do not strip all newline characters: formatted code at the end of
+            # a section must be followed by a blank line.
+            for line in re.sub('\n$', '', elem.desc, count=1).split('\n'):
+                print('{}{}'.format('\t\t' if line else '', line))
+
+        if (elem.ret):
+            print('\tReturn')
+            for line in elem.ret.rstrip().split('\n'):
+                print('{}{}'.format('\t\t' if line else '', line))
+
+        print('')
 
+
+class PrinterHelpersRST(PrinterRST):
+    """
+    A printer for dumping collected information about helpers as a ReStructured
+    Text page compatible with the rst2man program, which can be used to
+    generate a manual page for the helpers.
+    @parser: A HeaderParser with Helper objects to print to standard output
+    """
+    def __init__(self, parser):
+        self.elements = parser.helpers
+
+    def print_header(self):
+        header = '''\
 ===========
 BPF-HELPERS
 ===========
@@ -264,6 +300,7 @@ kernel at the top).
 HELPERS
 =======
 '''
+        PrinterRST.print_license(self)
         print(header)
 
     def print_footer(self):
@@ -380,27 +417,19 @@ SEE ALSO
 
     def print_one(self, helper):
         self.print_proto(helper)
+        self.print_elem(helper)
 
-        if (helper.desc):
-            print('\tDescription')
-            # Do not strip all newline characters: formatted code at the end of
-            # a section must be followed by a blank line.
-            for line in re.sub('\n$', '', helper.desc, count=1).split('\n'):
-                print('{}{}'.format('\t\t' if line else '', line))
 
-        if (helper.ret):
-            print('\tReturn')
-            for line in helper.ret.rstrip().split('\n'):
-                print('{}{}'.format('\t\t' if line else '', line))
 
-        print('')
 
 class PrinterHelpers(Printer):
     """
     A printer for dumping collected information about helpers as C header to
     be included from BPF program.
-    @helpers: array of Helper objects to print to standard output
+    @parser: A HeaderParser with Helper objects to print to standard output
     """
+    def __init__(self, parser):
+        self.elements = parser.helpers
 
     type_fwds = [
             'struct bpf_fib_lookup',
@@ -589,8 +618,12 @@ script = os.path.abspath(sys.argv[0])
 linuxRoot = os.path.dirname(os.path.dirname(script))
 bpfh = os.path.join(linuxRoot, 'include/uapi/linux/bpf.h')
 
+printers = {
+        'helpers': PrinterHelpersRST,
+}
+
 argParser = argparse.ArgumentParser(description="""
-Parse eBPF header file and generate documentation for eBPF helper functions.
+Parse eBPF header file and generate documentation for the eBPF API.
 The RST-formatted output produced can be turned into a manual page with the
 rst2man utility.
 """)
@@ -601,6 +634,8 @@ if (os.path.isfile(bpfh)):
                            default=bpfh)
 else:
     argParser.add_argument('--filename', help='path to include/uapi/linux/bpf.h')
+argParser.add_argument('target', nargs='?', default='helpers',
+                       choices=printers.keys(), help='eBPF API target')
 args = argParser.parse_args()
 
 # Parse file.
@@ -609,7 +644,7 @@ headerParser.run()
 
 # Print formatted output to standard output.
 if args.header:
-    printer = PrinterHelpers(headerParser.helpers)
+    printer = PrinterHelpers(headerParser)
 else:
-    printer = PrinterRST(headerParser.helpers)
+    printer = printers[args.target](headerParser)
 printer.print_all()
-- 
2.27.0

