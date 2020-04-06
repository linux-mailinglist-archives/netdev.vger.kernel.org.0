Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801B019F2BD
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 11:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgDFJjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 05:39:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20197 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726675AbgDFJjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 05:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586165960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o7QUe55LDlS7vu95ZSOJID294mWSSyJ6ODdz33cAI3U=;
        b=cmddpFcRTh/um7rCmx2eG3hAzooq7hoxTt+LZ7Hw1r9Krvxh3zXLPixsnL0Kei+x080F8Q
        dxYDdo26EhG7fnvXtHGJhgzUn/6PN/LRRXoftiE6kE1j+EsVfFxZkAB3azWDr1GNay1Tho
        zYErcAsu0PyLqe4skuK0V5/pJPpJbAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-MUWyIXgUMjC0kLqx8nDXfQ-1; Mon, 06 Apr 2020 05:39:16 -0400
X-MC-Unique: MUWyIXgUMjC0kLqx8nDXfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C6CE801E57;
        Mon,  6 Apr 2020 09:39:15 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.195.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2A4027189;
        Mon,  6 Apr 2020 09:39:13 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] macsec: fix NULL dereference in macsec_upd_offload()
Date:   Mon,  6 Apr 2020 11:38:29 +0200
Message-Id: <74490212072a970d0b65114644f90b1c06c68402.1586165752.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macsec_upd_offload() gets the value of MACSEC_OFFLOAD_ATTR_TYPE
without checking its presence in the request message, and this causes
a NULL dereference. Fix it rejecting any configuration that does not
include this attribute.

Reported-and-tested-by: syzbot+7022ab7c383875c17eff@syzkaller.appspotmail=
.com
Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offlo=
ading selection")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 drivers/net/macsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index da82d7f16a09..0d580d81d910 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2594,6 +2594,9 @@ static int macsec_upd_offload(struct sk_buff *skb, =
struct genl_info *info)
 		return PTR_ERR(dev);
 	macsec =3D macsec_priv(dev);
=20
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
 	offload =3D nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload =3D=3D offload)
 		return 0;
--=20
2.25.1

