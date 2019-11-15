Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7BFDE2D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfKOMoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:44:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727705AbfKOMni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573821818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=y0Lvf3FFeVl7Ch+iUCxxuA+JgpuW+5ri9xCUvF2JhQY=;
        b=Gt182gcnmWlX7M12emfp9mR+BNw5I5rxjr64zkH3CYp0E+ZDBLBSM7lC9gLnMJ8OzOpG6X
        PjkbjFgLqWCSc9PQTZ+p9LEsbKvPIyb1hI0EMhQy9eLkCKgGybEdmcDm4Cg98qCeEcMh6U
        9AHNFLvz0NoIYtoeIOmrP/VMS+/9oak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-T60az9SQMsadfBs_yVaQjg-1; Fri, 15 Nov 2019 07:43:33 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBF2D8026A1;
        Fri, 15 Nov 2019 12:43:32 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.206.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AB0E46475;
        Fri, 15 Nov 2019 12:43:31 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
Date:   Fri, 15 Nov 2019 13:43:23 +0100
Message-Id: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: T60az9SQMsadfBs_yVaQjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
starting it again every time it is expected to terminate. The exception is
the final client_connect: the server is not started anymore, which ensures
no process is kept running after the test is finished.

For a sit test, though, the script is terminated prematurely without the
final client_connect and the 'nc' process keeps running. This in turn cause=
s
the run_one function in kselftest/runner.sh to hang forever, waiting for th=
e
runaway process to finish.

Ensure a remaining server is terminated on cleanup.

Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/=
selftests/bpf/test_tc_tunnel.sh
index ff0d31d38061..7c76b841b17b 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -62,6 +62,10 @@ cleanup() {
 =09if [[ -f "${infile}" ]]; then
 =09=09rm "${infile}"
 =09fi
+
+=09if [[ -n $server_pid ]]; then
+=09=09kill $server_pid 2> /dev/null
+=09fi
 }
=20
 server_listen() {
@@ -77,6 +81,7 @@ client_connect() {
=20
 verify_data() {
 =09wait "${server_pid}"
+=09server_pid=3D
 =09# sha1sum returns two fields [sha1] [filepath]
 =09# convert to bash array and access first elem
 =09insum=3D($(sha1sum ${infile}))
--=20
2.18.1

