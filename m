Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B12183A6A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCLUM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:12:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40565 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726824AbgCLUMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 16:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584043972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oFtA5foZqJcNjK+k5pElAYPfBCovM+fS0F+WtgscESA=;
        b=PDmku7CcJ/E6F8AWBdA38RTR8Gd0/VlzcLMzGjma1t8I3anp4q12qolrKrQuILt4sueN5j
        lazacH9A748UTVOg301gtbwk6oV9377mT6sZLLZOZ7OlMufBkZGw25ErAQYqR9yYwLrr/Z
        nxCPSBuO8tfDmJEiGL3NIYMibmzshZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-G3yM9eTeOEa5m1elEuDA0g-1; Thu, 12 Mar 2020 16:12:50 -0400
X-MC-Unique: G3yM9eTeOEa5m1elEuDA0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1736801E66;
        Thu, 12 Mar 2020 20:12:46 +0000 (UTC)
Received: from localhost (ovpn-121-102.rdu2.redhat.com [10.10.121.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92C8073880;
        Thu, 12 Mar 2020 20:12:43 +0000 (UTC)
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     GLin@suse.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, Bruno Meneguele <bmeneg@redhat.com>
Subject: [PATCH] net/bpfilter: fix dprintf usage for logging into /dev/kmsg
Date:   Thu, 12 Mar 2020 17:12:40 -0300
Message-Id: <20200312201240.1960367-1-bmeneg@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpfilter UMH code was recently changed to log its informative message=
s to
/dev/kmsg, however this interface doesn't support SEEK_CUR yet, used by
dprintf(). As result dprintf() returns -EINVAL and doesn't log anything.

Although there already had some discussions about supporting SEEK_CUR int=
o
/dev/kmsg in the past, it wasn't concluded. Considering the only
user of that interface from userspace perspective inside the kernel is th=
e
bpfilter UMH (userspace) module it's better to correct it here instead of
waiting a conclusion on the interface changes.

Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
---
 net/bpfilter/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 77396a098fbe..efea4874743e 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -10,7 +10,7 @@
 #include <asm/unistd.h>
 #include "msgfmt.h"
=20
-int debug_fd;
+FILE *debug_f;
=20
 static int handle_get_cmd(struct mbox_request *cmd)
 {
@@ -35,9 +35,10 @@ static void loop(void)
 		struct mbox_reply reply;
 		int n;
=20
+		fprintf(debug_f, "testing the buffer\n");
 		n =3D read(0, &req, sizeof(req));
 		if (n !=3D sizeof(req)) {
-			dprintf(debug_fd, "invalid request %d\n", n);
+			fprintf(debug_f, "invalid request %d\n", n);
 			return;
 		}
=20
@@ -47,7 +48,7 @@ static void loop(void)
=20
 		n =3D write(1, &reply, sizeof(reply));
 		if (n !=3D sizeof(reply)) {
-			dprintf(debug_fd, "reply failed %d\n", n);
+			fprintf(debug_f, "reply failed %d\n", n);
 			return;
 		}
 	}
@@ -55,9 +56,10 @@ static void loop(void)
=20
 int main(void)
 {
-	debug_fd =3D open("/dev/kmsg", 00000002);
-	dprintf(debug_fd, "Started bpfilter\n");
+	debug_f =3D fopen("/dev/kmsg", "w");
+	setvbuf(debug_f, 0, _IOLBF, 0);
+	fprintf(debug_f, "Started bpfilter\n");
 	loop();
-	close(debug_fd);
+	fclose(debug_f);
 	return 0;
 }
--=20
2.24.1

