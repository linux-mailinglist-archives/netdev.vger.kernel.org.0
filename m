Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860351B4A6A
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDVQ0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:26:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725808AbgDVQ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587572772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0b34pJRmphJR/4h0IhGjR+Ai8ki4PQ/fRkb58O6DOwQ=;
        b=HbClDQFDzpbO2CgIWm7ZoPkMeZlrRzQDQXO6O7blUTZuY5EJ6WOy+W0XydCnYh0Z85OY8O
        FW3FaMaO1fDmHMooYqL7Q//CkF2sotL4gWbjMGAqQD3H/crLrEBVtn+M/upZLN5d2nqrSz
        SmTzjAvtiMBE0BbyNLV3QbhYniRCsXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-l8ASqlSiOa-Mu6TeYfN7KA-1; Wed, 22 Apr 2020 12:26:10 -0400
X-MC-Unique: l8ASqlSiOa-Mu6TeYfN7KA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AC74800FC7;
        Wed, 22 Apr 2020 16:26:09 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-173.ams2.redhat.com [10.36.114.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83DB5600DB;
        Wed, 22 Apr 2020 16:26:07 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix data_fin handing in RX path
Date:   Wed, 22 Apr 2020 18:24:56 +0200
Message-Id: <97c9e399060f81ed71ebfd446d9cf89bbb534142.1587572315.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data fin flag is set only via a DSS option, but
mptcp_incoming_options() copies it unconditionally from the
provided RX options.

Since we do not clear all the mptcp sock RX options in a
socket free/alloc cycle, we can end-up with a stray data_fin
value while parsing e.g. MPC packets.

That would lead to mapping data corruption and will trigger
a few WARN_ON() in the RX path.

Instead of adding a costly memset(), fetch the data_fin flag
only for DSS packets - when we always explicitly initialize
such bit at option parsing time.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index faf57585b892..4a7c467b99db 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -876,12 +876,11 @@ void mptcp_incoming_options(struct sock *sk, struct=
 sk_buff *skb,
 			mpext->data_seq =3D mp_opt->data_seq;
 			mpext->subflow_seq =3D mp_opt->subflow_seq;
 			mpext->dsn64 =3D mp_opt->dsn64;
+			mpext->data_fin =3D mp_opt->data_fin;
 		}
 		mpext->data_len =3D mp_opt->data_len;
 		mpext->use_map =3D 1;
 	}
-
-	mpext->data_fin =3D mp_opt->data_fin;
 }
=20
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
--=20
2.21.1

