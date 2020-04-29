Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA2E1BD9E7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgD2Kmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:42:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbgD2Kmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZSYzWnpdSUjgvb+PZUPSw5EN4jqbm6XTsncGcSBanM=;
        b=D43Oke706MWyLuk6wDuzBetYX0Ad6sFJqRvqw9JeQw8s7rOJTlvf0UbxndqzeV/DHbldMB
        tTBiqdMc5b2eOsVZbzQ3D8RfMErLtmVqPu9ji2F+RGA4GDLIySquKmobnI9Q5WkoaBf6Xz
        NfTVu9N4cI1QYDCOOTtcVLkCBFJlwpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-kNob6oGZOTK2iNs7g42IQg-1; Wed, 29 Apr 2020 06:42:33 -0400
X-MC-Unique: kNob6oGZOTK2iNs7g42IQg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81D00107ACCD;
        Wed, 29 Apr 2020 10:42:31 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E080599D6;
        Wed, 29 Apr 2020 10:42:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net 5/5] mptcp: initialize the data_fin field for mpc packets
Date:   Wed, 29 Apr 2020 12:41:49 +0200
Message-Id: <e3d30a7e0b7bcbb11f9efff76da4341143d90340.1588156257.git.pabeni@redhat.com>
In-Reply-To: <cover.1588156257.git.pabeni@redhat.com>
References: <cover.1588156257.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing MPC+data packets we set the dss field, so
we must also initialize the data_fin, or we can find stray
value there.

Fixes: 9a19371bf029 ("mptcp: fix data_fin handing in RX path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9486720c3256..45497af23906 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -858,6 +858,7 @@ void mptcp_incoming_options(struct sock *sk, struct s=
k_buff *skb,
 			mpext->subflow_seq =3D 1;
 			mpext->dsn64 =3D 1;
 			mpext->mpc_map =3D 1;
+			mpext->data_fin =3D 0;
 		} else {
 			mpext->data_seq =3D mp_opt.data_seq;
 			mpext->subflow_seq =3D mp_opt.subflow_seq;
--=20
2.21.1

