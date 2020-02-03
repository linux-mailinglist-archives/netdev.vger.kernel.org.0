Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7601509DB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBCPeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:34:24 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24479 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727201AbgBCPeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:34:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580744063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=592y981M3iebaRRWsq+12mogxXJF6Sly4cspD9Amr+M=;
        b=PUKN0hI8GpqDGA2YThm0oDvHqzBjV2qtMXbCk8zXb/YrMeyLDOSiRtDNrkXF2SfEYS/FwR
        qYop33OsmXczoFipkHRWR7hsI8wgG1Rl7HyfryqlHJr2bx/FP0c4aGtFKYI3XSIC9GFqIH
        Ije3NlYlnVC2eMigcMt1C73ZxderO8Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-47iuCdFTM1Coz6srdE5Z4A-1; Mon, 03 Feb 2020 10:34:19 -0500
X-MC-Unique: 47iuCdFTM1Coz6srdE5Z4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E2618A88D8;
        Mon,  3 Feb 2020 15:34:18 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB8760BE0;
        Mon,  3 Feb 2020 15:34:16 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Roman Mashak <mrv@mojatatu.com>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] tc-testing: fix eBPF tests failure on linux fresh clones
Date:   Mon,  3 Feb 2020 16:29:29 +0100
Message-Id: <32b2f2c31374b2d478fa1ac91e37a5b070d34d7c.1580740848.git.dcaratti@redhat.com>
In-Reply-To: <cover.1580740848.git.dcaratti@redhat.com>
References: <cover.1580740848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when the following command is done on a fresh clone of the kernel tree,

 [root@f31 tc-testing]# ./tdc.py -c bpf

test cases that need to build the eBPF sample program fail systematically=
,
because 'buildebpfPlugin' is unable to install the kernel headers (i.e, t=
he
'khdr' target fails). Pass the correct environment to 'make', in place of
ENVIR, to allow running these tests.

Fixes: 4c2d39bd40c1 ("tc-testing: use a plugin to build eBPF program")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugi=
n.py b/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
index e98c36750fae..d34fe06268d2 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
@@ -54,7 +54,7 @@ class SubPlugin(TdcPlugin):
             shell=3DTrue,
             stdout=3Dsubprocess.PIPE,
             stderr=3Dsubprocess.PIPE,
-            env=3DENVIR)
+            env=3Dos.environ.copy())
         (rawout, serr) =3D proc.communicate()
=20
         if proc.returncode !=3D 0 and len(serr) > 0:
--=20
2.24.1

