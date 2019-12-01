Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0710510E2C8
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 18:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfLARlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 12:41:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52557 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727167AbfLARle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 12:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575222093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bMZJX+ILiy6MEo/AhuOf05KKYd7ICUgeXedkbDs5FuE=;
        b=XkRxvX31ZUHHVj+93UgIuVudGEYJNJl2uO9Wk2QFzQ867OfLm5g7HLezQ6CwBYNaZL6glB
        KAIAcf6yO0xzNiu5Ha7Gt7thitvLxa7A6kgmGOMbk1fkJm9s0jgEbhHPEJijQnRN1j3bbC
        H+uPOTyr1Knoxm/0IsFOIhDy39NRbcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-fAI2dWmaMICN0wFLgSPvwg-1; Sun, 01 Dec 2019 12:41:32 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1338C10054E3;
        Sun,  1 Dec 2019 17:41:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-204-56.brq.redhat.com [10.40.204.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0ABE600C8;
        Sun,  1 Dec 2019 17:41:29 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH net v2 1/2] openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
Date:   Sun,  1 Dec 2019 18:41:24 +0100
Message-Id: <ec6d2374cbeb4f59001399a3925b669ba9538ac9.1575221237.git.pabeni@redhat.com>
In-Reply-To: <cover.1575221237.git.pabeni@redhat.com>
References: <cover.1575221237.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: fAI2dWmaMICN0wFLgSPvwg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the callers of ovs_flow_cmd_build_info() already deal with
error return code correctly, so we can handle the error condition
in a more gracefull way. Still dump a warning to preserve
debuggability.

v1 -> v2:
 - clarify the commit message
 - clean the skb and report the error (DaveM)

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/openvswitch/datapath.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 293d5289c4a1..8cab3435d8da 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -905,7 +905,10 @@ static struct sk_buff *ovs_flow_cmd_build_info(const s=
truct sw_flow *flow,
 =09retval =3D ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
 =09=09=09=09=09info->snd_portid, info->snd_seq, 0,
 =09=09=09=09=09cmd, ufid_flags);
-=09BUG_ON(retval < 0);
+=09if (WARN_ON_ONCE(retval < 0)) {
+=09=09kfree_skb(skb);
+=09=09skb =3D ERR_PTR(retval);
+=09}
 =09return skb;
 }
=20
--=20
2.21.0

