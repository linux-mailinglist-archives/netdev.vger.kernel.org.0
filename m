Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD6E5984
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 11:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJZJx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 05:53:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbfJZJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 05:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572083637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=esglW9VvaMYDb8USCDJSehOzdbrr2VhCQxqKk8rc+vQ=;
        b=brciXjzRNqchZIYu6jYVcqN3LJukBkAlYFCq7DaTp9pSQ9f0aTpzH/BhAsT+DiDv7c6AOw
        AO5SDUDpbKEGZKvmhXmgNhNY1rN9GJ+vVqW7qebbPvgaURyU+Og63A/vBOnvfPGmNT42+1
        rKlgjHw7rn6AzshNnTuGpRlHscNQu24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-9rZtOzzGO-mc6_RhiExW7g-1; Sat, 26 Oct 2019 05:53:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 938251800DCB;
        Sat, 26 Oct 2019 09:53:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 815A75C1B5;
        Sat, 26 Oct 2019 09:53:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 2/2] selftests: fib_tests: add more tests for metric update
Date:   Sat, 26 Oct 2019 11:53:40 +0200
Message-Id: <8dd671ca9cdf27d8b06998c1686b42d83681d352.1572083332.git.pabeni@redhat.com>
In-Reply-To: <cover.1572083332.git.pabeni@redhat.com>
References: <cover.1572083332.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 9rZtOzzGO-mc6_RhiExW7g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two more tests to ipv4_addr_metric_test() to
explicitly cover the scenarios fixed by the previous patch.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/fib_tests.sh | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selft=
ests/net/fib_tests.sh
index c4ba0ff4a53f..76c1897e6352 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1438,6 +1438,27 @@ ipv4_addr_metric_test()
 =09fi
 =09log_test $rc 0 "Prefix route with metric on link up"
=20
+=09# explicitly check for metric changes on edge scenarios
+=09run_cmd "$IP addr flush dev dummy2"
+=09run_cmd "$IP addr add dev dummy2 172.16.104.0/24 metric 259"
+=09run_cmd "$IP addr change dev dummy2 172.16.104.0/24 metric 260"
+=09rc=3D$?
+=09if [ $rc -eq 0 ]; then
+=09=09check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src =
172.16.104.0 metric 260"
+=09=09rc=3D$?
+=09fi
+=09log_test $rc 0 "Modify metric of .0/24 address"
+
+=09run_cmd "$IP addr flush dev dummy2"
+=09run_cmd "$IP addr add dev dummy2 172.16.104.1/32 peer 172.16.104.2 metr=
ic 260"
+=09run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.2 m=
etric 261"
+=09rc=3D$?
+=09if [ $rc -eq 0 ]; then
+=09=09check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172=
.16.104.1 metric 261"
+=09=09rc=3D$?
+=09fi
+=09log_test $rc 0 "Modify metric of address with peer route"
+
 =09$IP li del dummy1
 =09$IP li del dummy2
 =09cleanup
--=20
2.21.0

