Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF51BF549
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgD3KXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:23:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57420 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726777AbgD3KXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588242229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pGZ8YKX84O2C9ELQ3AtnmbGWiX9FZ6dQm7WK/H4lnHY=;
        b=fclid7y+5RR9TZLZdkIjxUXgTringarO/k8V0D6MgLr3MCs2RZNuq0dSJ6cqtArNvzyfL6
        P3cTtgJU/rUh/PKv4ctpdi2TqfHV7Qi3MUZrGF5ch0Nx/GnNWmMZDq4lc65bqUVUiGw2M+
        /dM9jwynXIdgT8hTRYTkALp9amc42/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-EW4dUmudMGWkKIgRfCbbvA-1; Thu, 30 Apr 2020 06:23:47 -0400
X-MC-Unique: EW4dUmudMGWkKIgRfCbbvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 060B4468;
        Thu, 30 Apr 2020 10:23:46 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B363728554;
        Thu, 30 Apr 2020 10:23:40 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next] libbpf: fix probe code to return EPERM if encountered
Date:   Thu, 30 Apr 2020 12:23:34 +0200
Message-Id: <158824221003.2338.9700507405752328930.stgit@ebuild>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the probe code was failing for any reason ENOTSUP was returned, even
if this was due to no having enough lock space. This patch fixes this by
returning EPERM to the user application, so it can respond and increase
the RLIMIT_MEMLOCK size.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/lib/bpf/libbpf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..a62388a151d4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3381,8 +3381,13 @@ bpf_object__probe_caps(struct bpf_object *obj)
=20
 	for (i =3D 0; i < ARRAY_SIZE(probe_fn); i++) {
 		ret =3D probe_fn[i](obj);
-		if (ret < 0)
+		if (ret < 0) {
 			pr_debug("Probe #%d failed with %d.\n", i, ret);
+			if (ret =3D=3D -EPERM) {
+				pr_perm_msg(ret);
+				return ret;
+			}
+		}
 	}
=20
 	return 0;

