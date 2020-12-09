Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807E32D4103
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgLILXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:23:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730747AbgLILWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607512889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=djE+2D2zg9p7K3WnWwO0e5kEP4KLE3RaXpyUdHZT+eQ=;
        b=PCt4c/QrcNjDb+fu+dgr4xbOk9j1iA+ISIdG/8BhWsnmRWFc/BXEghXGb1lRTKQdTOB/A4
        RqxFoRYcHkGCdJ0Orx0HOufyh3R8/G4ErzbVtCxJNEfe23gzJbd3tFvI8q+vrEJtmMcX13
        /HE1FnoHG30cBzgDfUgvan6NFUQeFSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-6w4I4Fz2P9-J5uz_Ob68Lg-1; Wed, 09 Dec 2020 06:21:26 -0500
X-MC-Unique: 6w4I4Fz2P9-J5uz_Ob68Lg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96C62800D53;
        Wed,  9 Dec 2020 11:21:25 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2321C620DE;
        Wed,  9 Dec 2020 11:21:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net] selftests: fix poll error in udpgro.sh
Date:   Wed,  9 Dec 2020 12:21:13 +0100
Message-Id: <66cc4a0ccb845f1b236a388bae3bc2171398fa41.1607512428.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test program udpgso_bench_rx always invokes the poll()
syscall with a timeout of 10ms. If a larger timeout is specified
via the command line, udpgso_bench_rx is supposed to do multiple
poll() calls till the timeout is expired or an event is received.

Currently the poll() loop errors out after the first invocation with
no events, and may causes self-tests failure alike:

failed
 GRO with custom segment size            ./udpgso_bench_rx: poll: 0x0 expected 0x1

This change addresses the issue allowing the poll() loop to consume
all the configured timeout.

Fixes: ada641ff6ed3 ("selftests: fixes for UDP GRO")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index db3d4a8b5a4c..76a24052f4b4 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -113,6 +113,9 @@ static void do_poll(int fd, int timeout_ms)
 				interrupted = true;
 				break;
 			}
+
+			/* no events and more time to wait, do poll again */
+			continue;
 		}
 		if (pfd.revents != POLLIN)
 			error(1, errno, "poll: 0x%x expected 0x%x\n",
-- 
2.26.2

