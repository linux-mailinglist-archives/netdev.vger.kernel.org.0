Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7500ACDA8C
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 05:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfJGDHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:07:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23064 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfJGDHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:07:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9734X4f031907
        for <netdev@vger.kernel.org>; Sun, 6 Oct 2019 20:07:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=sQzZqiVsWWx8mt232jHIaT+Sq9Umwfrh1Ya709GBndw=;
 b=I2PiC6pCCmgU+GPEmuRE7wvtFGiBSGkqfSnfh61Mc5weNLHFF4KzKW/758Qd87MmNdDU
 9XB5rDq0yo287M6pQpAex8TRzOfTf3fnZlR63o/+bc0ZYHXrqtYGcJny8J0kwS1zj0UU
 rTBsSOTexZiVp0NzxBF1dIa5zi/1RoYpFiE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2verpnx5ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:07:45 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 6 Oct 2019 20:07:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 393AA86190E; Sun,  6 Oct 2019 20:07:44 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <quentin.monnet@netronome.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 2/3] scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
Date:   Sun, 6 Oct 2019 20:07:37 -0700
Message-ID: <20191007030738.2627420-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007030738.2627420-1-andriin@fb.com>
References: <20191007030738.2627420-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_11:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=9 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=385 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enhance scripts/bpf_helpers_doc.py to emit C header with BPF helper
definitions (to be included from libbpf's bpf_helpers.h).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 scripts/bpf_helpers_doc.py | 155 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 894cc58c1a03..15d3d83d6297 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -391,6 +391,154 @@ SEE ALSO
 
         print('')
 
+class PrinterHelpers(Printer):
+    """
+    A printer for dumping collected information about helpers as C header to
+    be included from BPF program.
+    @helpers: array of Helper objects to print to standard output
+    """
+
+    type_fwds = [
+            'struct bpf_fib_lookup',
+            'struct bpf_perf_event_data',
+            'struct bpf_perf_event_value',
+            'struct bpf_sock',
+            'struct bpf_sock_addr',
+            'struct bpf_sock_ops',
+            'struct bpf_sock_tuple',
+            'struct bpf_spin_lock',
+            'struct bpf_sysctl',
+            'struct bpf_tcp_sock',
+            'struct bpf_tunnel_key',
+            'struct bpf_xfrm_state',
+            'struct pt_regs',
+            'struct sk_reuseport_md',
+            'struct sockaddr',
+            'struct tcphdr',
+
+            'struct __sk_buff',
+            'struct sk_msg_md',
+            'struct xpd_md',
+    ]
+    known_types = {
+            '...',
+            'void',
+            'const void',
+            'char',
+            'const char',
+            'int',
+            'long',
+            'unsigned long',
+
+            '__be16',
+            '__be32',
+            '__wsum',
+
+            'struct bpf_fib_lookup',
+            'struct bpf_perf_event_data',
+            'struct bpf_perf_event_value',
+            'struct bpf_sock',
+            'struct bpf_sock_addr',
+            'struct bpf_sock_ops',
+            'struct bpf_sock_tuple',
+            'struct bpf_spin_lock',
+            'struct bpf_sysctl',
+            'struct bpf_tcp_sock',
+            'struct bpf_tunnel_key',
+            'struct bpf_xfrm_state',
+            'struct pt_regs',
+            'struct sk_reuseport_md',
+            'struct sockaddr',
+            'struct tcphdr',
+    }
+    mapped_types = {
+            'u8': '__u8',
+            'u16': '__u16',
+            'u32': '__u32',
+            'u64': '__u64',
+            's8': '__s8',
+            's16': '__s16',
+            's32': '__s32',
+            's64': '__s64',
+            'size_t': 'unsigned long',
+            'struct bpf_map': 'void',
+            'struct sk_buff': 'struct __sk_buff',
+            'const struct sk_buff': 'const struct __sk_buff',
+            'struct sk_msg_buff': 'struct sk_msg_md',
+            'struct xdp_buff': 'struct xdp_md',
+    }
+
+    def print_header(self):
+        header = '''\
+/* This is auto-generated file. See bpf_helpers_doc.py for details. */
+
+/* Forward declarations of BPF structs */'''
+
+        print(header)
+        for fwd in self.type_fwds:
+            print('%s;' % fwd)
+        print('')
+
+    def print_footer(self):
+        footer = ''
+        print(footer)
+
+    def map_type(self, t):
+        if t in self.known_types:
+            return t
+        if t in self.mapped_types:
+            return self.mapped_types[t]
+        print("")
+        print("Unrecognized type '%s', please add it to known types!" % t)
+        sys.exit(1)
+
+    seen_helpers = set()
+
+    def print_one(self, helper):
+        proto = helper.proto_break_down()
+
+        if proto['name'] in self.seen_helpers:
+            return
+        self.seen_helpers.add(proto['name'])
+
+        print('/*')
+        print(" * %s" % proto['name'])
+        print(" *")
+        if (helper.desc):
+            # Do not strip all newline characters: formatted code at the end of
+            # a section must be followed by a blank line.
+            for line in re.sub('\n$', '', helper.desc, count=1).split('\n'):
+                print(' *{}{}'.format(' \t' if line else '', line))
+
+        if (helper.ret):
+            print(' *')
+            print(' * Returns')
+            for line in helper.ret.rstrip().split('\n'):
+                print(' *{}{}'.format(' \t' if line else '', line))
+
+        print(' */')
+        print('static %s %s(*%s)(' % (self.map_type(proto['ret_type']),
+                                      proto['ret_star'], proto['name']), end='')
+        comma = ''
+        for i, a in enumerate(proto['args']):
+            t = a['type']
+            n = a['name']
+            if proto['name'] == 'bpf_get_socket_cookie' and i == 0:
+                    t = 'void'
+                    n = 'ctx'
+            one_arg = '{}{}'.format(comma, self.map_type(t))
+            if n:
+                if a['star']:
+                    one_arg += ' {}'.format(a['star'])
+                else:
+                    one_arg += ' '
+                one_arg += '{}'.format(n)
+            comma = ', '
+            print(one_arg, end='')
+
+        print(') = (void *) %d;' % len(self.seen_helpers))
+        print('')
+
 ###############################################################################
 
 # If script is launched from scripts/ from kernel tree and can access
@@ -405,6 +553,8 @@ Parse eBPF header file and generate documentation for eBPF helper functions.
 The RST-formatted output produced can be turned into a manual page with the
 rst2man utility.
 """)
+argParser.add_argument('--header', action='store_true',
+                       help='generate C header file')
 if (os.path.isfile(bpfh)):
     argParser.add_argument('--filename', help='path to include/uapi/linux/bpf.h',
                            default=bpfh)
@@ -417,5 +567,8 @@ headerParser = HeaderParser(args.filename)
 headerParser.run()
 
 # Print formatted output to standard output.
-printer = PrinterRST(headerParser.helpers)
+if args.header:
+    printer = PrinterHelpers(headerParser.helpers)
+else:
+    printer = PrinterRST(headerParser.helpers)
 printer.print_all()
-- 
2.17.1

