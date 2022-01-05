Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254884855CE
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiAEPZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:25:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241448AbiAEPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:25:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641396312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=COh4UeC2bqXHmXhCc7ECa97usAk8YBt4hAgkTrp6kr4=;
        b=NM9vtoHrrbTEDBduFPVPtAQYYjZ2wHpQ4wUF0/5W1je6yVoj1xnFdIPD4kmUJq2t8rheVK
        XmKMdPKaSQJVUlgVIgwfVAjBGkypCTlXYxzJ3Ro0auho30de2s9zm2i+JUcordL+q86gzw
        pc2qdOVyv7bbuVDHZe8wHCuNOQpyxhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-xic4Smq2Mm6ArKOaV7kzoQ-1; Wed, 05 Jan 2022 10:25:09 -0500
X-MC-Unique: xic4Smq2Mm6ArKOaV7kzoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DF14192CC40;
        Wed,  5 Jan 2022 15:25:08 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 831D27A3FE;
        Wed,  5 Jan 2022 15:25:07 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] testptp: set pin function before other requests
Date:   Wed,  5 Jan 2022 16:25:06 +0100
Message-Id: <20220105152506.3256026-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the -L option of the testptp utility is specified with other
options (e.g. -p to enable PPS output), the user probably wants to
apply it to the pin configured by the -L option.

Reorder the code to set the pin function before other function requests
to avoid confusing users.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
---
 tools/testing/selftests/ptp/testptp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index f7911aaeb007..c0f6a062364d 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -354,6 +354,18 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (pin_index >= 0) {
+		memset(&desc, 0, sizeof(desc));
+		desc.index = pin_index;
+		desc.func = pin_func;
+		desc.chan = index;
+		if (ioctl(fd, PTP_PIN_SETFUNC, &desc)) {
+			perror("PTP_PIN_SETFUNC");
+		} else {
+			puts("set pin function okay");
+		}
+	}
+
 	if (extts) {
 		memset(&extts_request, 0, sizeof(extts_request));
 		extts_request.index = index;
@@ -444,18 +456,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (pin_index >= 0) {
-		memset(&desc, 0, sizeof(desc));
-		desc.index = pin_index;
-		desc.func = pin_func;
-		desc.chan = index;
-		if (ioctl(fd, PTP_PIN_SETFUNC, &desc)) {
-			perror("PTP_PIN_SETFUNC");
-		} else {
-			puts("set pin function okay");
-		}
-	}
-
 	if (pps != -1) {
 		int enable = pps ? 1 : 0;
 		if (ioctl(fd, PTP_ENABLE_PPS, enable)) {
-- 
2.33.1

