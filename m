Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507AAF5931
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbfKHVH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:07:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732196AbfKHVHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573247243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+C4Ygst36NalU5H7g0gFh5wyAlvafm4eB3mjWDqmsI=;
        b=ZubWkVXLIc1hO+zFPaEZqM8r4l6Jf/ooYL1GAv2tv9m1CUGC90PoqI6XkYRRRoTIktl3uQ
        nUuUQmA1NFg13sUCBeWPIiYFAjA7FYRmfWEVsM5Oud+CLo7xJPI1ASXrMtidii+gt5O8nl
        7rtm/eHZcxwkfufiq39vkrMkZBKcSB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-MIR5xOepMjK9mOApVWCbAQ-1; Fri, 08 Nov 2019 16:07:19 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39C388017DD;
        Fri,  8 Nov 2019 21:07:18 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (ovpn-123-109.rdu2.redhat.com [10.10.123.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40BED19757;
        Fri,  8 Nov 2019 21:07:17 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] act_ct: support asymmetric conntrack
Date:   Fri,  8 Nov 2019 16:07:14 -0500
Message-Id: <20191108210714.12426-2-aconole@redhat.com>
In-Reply-To: <20191108210714.12426-1-aconole@redhat.com>
References: <20191108210714.12426-1-aconole@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: MIR5xOepMjK9mOApVWCbAQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The act_ct TC module shares a common conntrack and NAT infrastructure
exposed via netfilter.  It's possible that a packet needs both SNAT and
DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
this because it runs through the NAT table twice - once on ingress and
again after egress.  The act_ct action doesn't have such capability.

Like netfilter hook infrastructure, we should run through NAT twice to
keep the symmetry.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 net/sched/act_ct.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fcc46025e790..f3232a00970f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 =09=09=09  bool commit)
 {
 #if IS_ENABLED(CONFIG_NF_NAT)
+=09int err;
 =09enum nf_nat_manip_type maniptype;
=20
 =09if (!(ct_action & TCA_CT_ACT_NAT))
@@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 =09=09return NF_ACCEPT;
 =09}
=20
-=09return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+=09if (err =3D=3D NF_ACCEPT &&
+=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
+=09=09if (maniptype =3D=3D NF_NAT_MANIP_SRC)
+=09=09=09maniptype =3D NF_NAT_MANIP_DST;
+=09=09else
+=09=09=09maniptype =3D NF_NAT_MANIP_SRC;
+
+=09=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+=09}
+=09return err;
 #else
 =09return NF_ACCEPT;
 #endif
--=20
2.21.0

