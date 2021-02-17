Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36B31D947
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhBQMTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:19:08 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:48061 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhBQMTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:19:06 -0500
Received: from orion.localdomain ([95.118.154.137]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MiJEc-1lpYdo0EI2-00fOZf; Wed, 17 Feb 2021 13:15:46 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] lib: vsprintf: check for NULL device_node name in device_node_string()
Date:   Wed, 17 Feb 2021 13:15:43 +0100
Message-Id: <20210217121543.13010-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:lX09z2OoKzZLBm5KCTp8eKEKKIAbQ3PWN5cSgh2b5SM7vTW9J6D
 Jx4o3WWQRKDWpASJZ/q/yX2rerpr7SfpJ7I5sPWZmLeWQqAyarPEgpIFmoSyLHSLGzYPFSr
 16ALY5ooHN2e9MphJmmIu6PqyqAM5bcpG49YSvKZiBiBmlkY8tdhrcI4ExKhkOkejFCHkB5
 iw9zZEYDEt26VPxwehKRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZUoFaR7AFa0=:RJFlRmGPAc7ycfOpmRAIle
 cMzNhDSuMu9TSlh8eCMHJ475rVdWbmpPVW1xcPE6IlT0SoceiQvBRj7wYCYXsgqFpb3dImzik
 8qP5jXIn/tVqg4mgxGVoykPaHYAFk2BHKOOcWHX2lcAFaTrKFbH78PEYEUyYvSoBOqDopaOLO
 rjYyktnUn1bYPXU4Zv3HsgIyxHT6TPqbkuF3xG8IgnxVjdnRLlBWIc15L50FU7b/yi6IPOZUn
 xeO5h+ZOMKki2tJRgzPgyTyIq9GyiD4rG4CdVn6flM0BHNetvOoxWg40lzilr+f35qMXduI5X
 U83RFBVO6chUdc0mhiamE+ELVsOZHXCGsRsnrH70dZ/Jkr4eEH68IPHlMuIIdXj+1OCnVdrTi
 EN3QsitbiWZeKcdMcgdmMcpW7q12dLuT3snZpB9XllaN1RBCjqRkWJcnhHW+h
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under rare circumstances it may happen that a device node's name is NULL
(most likely kernel bug in some other place). In such situations anything
but helpful, if the debug printout crashes, and nobody knows what actually
happened here.

Therefore protect it by an explicit NULL check and print out an extra
warning.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 lib/vsprintf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b53c73580c5..050a60b88073 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2013,6 +2013,10 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 			break;
 		case 'n':	/* name */
 			p = fwnode_get_name(of_fwnode_handle(dn));
+			if (!p) {
+				pr_warn("device_node without name. Kernel bug ?\n");
+				p = "<NULL>";
+			}
 			precision = str_spec.precision;
 			str_spec.precision = strchrnul(p, '@') - p;
 			buf = string(buf, end, p, str_spec);
-- 
2.11.0

