Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E841B72DF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 13:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXLPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 07:15:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40251 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726489AbgDXLPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 07:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587726946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HaP4TzM3lXjoIbaS/rheBHg159AnD4GjwtZjdM+bNw8=;
        b=bsMBjLPRZp3/r2zf+3ETQrEqqherx/IpE9B3AEeQXBGkFicrDUl+sSGvM3xFPy1uN/tmfD
        JG7pDt6tNx68fqlS1SjmYzpNuy+5ptB4zkK1WD7uB+Kskx2u+oszghsGWnvacbHpiG+Mwd
        6xk4oRp0+Vl/WdVwycIEzAgsKO9lu6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-_GUnr26JMF-Z-ZE7QXecmg-1; Fri, 24 Apr 2020 07:15:42 -0400
X-MC-Unique: _GUnr26JMF-Z-ZE7QXecmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15C51800D24;
        Fri, 24 Apr 2020 11:15:41 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-238.ams2.redhat.com [10.36.114.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65BE65D9CC;
        Fri, 24 Apr 2020 11:15:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix race in msk status update
Date:   Fri, 24 Apr 2020 13:15:21 +0200
Message-Id: <4d5e3c09ca38a0a3ec951fa4f5bfc65d5cd40129.1587725562.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently subflow_finish_connect() changes unconditionally
any msk socket status other than TCP_ESTABLISHED.

If an unblocking connect() races with close(), we can end-up
triggering:

IPv4: Attempt to release TCP socket in state 1 00000000e32b8b7e

when the msk socket is disposed.

Be sure to enter the established status only from SYN_SENT.

Fixes: c3c123d16c0e ("net: mptcp: don't hang in mptcp_sendmsg() after TCP=
 fallback")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: the issue is possibly older, but this fix applies only
on the mentioned commit
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 87c094702d63..2488e011048c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -225,7 +225,7 @@ static void subflow_finish_connect(struct sock *sk, c=
onst struct sk_buff *skb)
=20
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
=20
-	if (inet_sk_state_load(parent) !=3D TCP_ESTABLISHED) {
+	if (inet_sk_state_load(parent) =3D=3D TCP_SYN_SENT) {
 		inet_sk_state_store(parent, TCP_ESTABLISHED);
 		parent->sk_state_change(parent);
 	}
--=20
2.21.1

