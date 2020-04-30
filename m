Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311ED1BF8BE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgD3NC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47385 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726852AbgD3NC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZSYzWnpdSUjgvb+PZUPSw5EN4jqbm6XTsncGcSBanM=;
        b=GUTd3tn0ApzPSYdCtVAyAXNcmOcBNLj8wxUV76kn0XNaqfS5Vk5wokZiyRJbB7RxVScjn3
        CN1xnFWjiu3nrhwkrn4B4g3yfPpyFcQpJooZccIOz87cenclDIEUGhyh2X9mig9GKc3C5D
        h/rFVgcSRCFq6TWW6dYTlN9i1f8Gt4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-l-eP2gtRMViHT3WtPXnkSw-1; Thu, 30 Apr 2020 09:02:24 -0400
X-MC-Unique: l-eP2gtRMViHT3WtPXnkSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAABB80B734;
        Thu, 30 Apr 2020 13:02:22 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC3D86606F;
        Thu, 30 Apr 2020 13:02:20 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 5/5] mptcp: initialize the data_fin field for mpc packets
Date:   Thu, 30 Apr 2020 15:01:55 +0200
Message-Id: <0701d07b1b9b94052fbb8f32b870a037e0f7d3ac.1588243786.git.pabeni@redhat.com>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

