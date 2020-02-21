Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853781686DA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgBUSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:42:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgBUSmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582310543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hO6DCUov61nuNJi2UdTFFY2KF/OCGZTqfhhOyJ35OXs=;
        b=b5MIIyOLyesGMb2F2UYUdaTQ4SA+J1CirmJKixORUD/1Iw+BPhJYAN71UqD8zSC+3o4KEe
        vumGz/A3z3nf0MNa8yUitxAdyel4m7S8VBcfXZJsEct4EPQXFuoKMLC5bzJx5s2cFql3j5
        gdZV+8wZXjBryYgKtLbLwyk8nPor/3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-pcAWIJAGMhyMvp_HYd5tew-1; Fri, 21 Feb 2020 13:42:21 -0500
X-MC-Unique: pcAWIJAGMhyMvp_HYd5tew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 077D3100DFC2;
        Fri, 21 Feb 2020 18:42:20 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-170.ams2.redhat.com [10.36.117.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4C4591826;
        Fri, 21 Feb 2020 18:42:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net] net: genetlink: return the error code when attribute parsing fails.
Date:   Fri, 21 Feb 2020 19:42:13 +0100
Message-Id: <933cec10232417777c5a214e25a31d1f299d1489.1582310461.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if attribute parsing fails and the genl family
does not support parallel operation, the error code returned
by __nlmsg_parse() is discarded by genl_family_rcv_msg_attrs_parse().

Be sure to report the error for all genl families.

Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing=
 to a separate function")
Fixes: ab5b526da048 ("net: genetlink: always allocate separate attrs for =
dumpit ops")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: the issue is really introduced by the first commit above,
but the fix applies cleanly only after the 2nd one
---
 net/netlink/genetlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 0522b2b1fd95..9f357aa22b94 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -497,8 +497,9 @@ genl_family_rcv_msg_attrs_parse(const struct genl_fam=
ily *family,
=20
 	err =3D __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
-	if (err && parallel) {
-		kfree(attrbuf);
+	if (err) {
+		if (parallel)
+			kfree(attrbuf);
 		return ERR_PTR(err);
 	}
 	return attrbuf;
--=20
2.21.1

