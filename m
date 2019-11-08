Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0CF592F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfKHVHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:07:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55987 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732061AbfKHVHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573247242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MBWevgYefE/oENuuV+xMUbOS2g9VAZuCifeLUildEZE=;
        b=AjXxWqX/xWcGQ7uIncyNikrExrRSaVJVdayi8CqKPofhhOxq39D5E2Q1oTbie3qHzMqXgS
        V5MD7Gm0VuiW53UekzWHCTkeuCNzcPKSMJvQTv5PN7+BRAHoOHKwl449XbaSl65xc2NK7z
        PyTbe+kHRaGx37Z/TcC9hlJXi6HJtQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-IRg7_hqAPOSlzW8cZognoA-1; Fri, 08 Nov 2019 16:07:18 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19EFB800686;
        Fri,  8 Nov 2019 21:07:17 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (ovpn-123-109.rdu2.redhat.com [10.10.123.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 719D03DA3;
        Fri,  8 Nov 2019 21:07:15 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] openvswitch: support asymmetric conntrack
Date:   Fri,  8 Nov 2019 16:07:13 -0500
Message-Id: <20191108210714.12426-1-aconole@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: IRg7_hqAPOSlzW8cZognoA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch module shares a common conntrack and NAT infrastructure
exposed via netfilter.  It's possible that a packet needs both SNAT and
DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
this because it runs through the NAT table twice - once on ingress and
again after egress.  The openvswitch module doesn't have such capability.

Like netfilter hook infrastructure, we should run through NAT twice to
keep the symmetry.

Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 net/openvswitch/conntrack.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 05249eb45082..283e8f9a5fd2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -903,6 +903,17 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_=
key *key,
 =09}
 =09err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);
=20
+=09if (err =3D=3D NF_ACCEPT &&
+=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
+=09=09if (maniptype =3D=3D NF_NAT_MANIP_SRC)
+=09=09=09maniptype =3D NF_NAT_MANIP_DST;
+=09=09else
+=09=09=09maniptype =3D NF_NAT_MANIP_SRC;
+
+=09=09err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
+=09=09=09=09=09 maniptype);
+=09}
+
 =09/* Mark NAT done if successful and update the flow key. */
 =09if (err =3D=3D NF_ACCEPT)
 =09=09ovs_nat_update_key(key, skb, maniptype);
--=20
2.21.0

