Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D4A1598B5
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgBKSeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:34:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727361AbgBKSeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581446048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEipwrlWKHZuCXC4PDl+2cRL+yfPqFAsgAPaqGSrzkQ=;
        b=bNhXxj0bah23XliroM/ft1THe6w3e48AVgowKnvbd1RLx3hcPqkuR9RcrRJSTToBMICWr6
        tagxQYH3tEAFpdYiL7ccy0HT7Mt112lpgniRimRpvpxbSuAPaC5ZR5vEbFs+n4OaqYWPVA
        8usiRGo8Nnf2TG7YsNje1uUdCVfwXDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-e5AbS5q5MimPA3hoZIS58w-1; Tue, 11 Feb 2020 13:34:04 -0500
X-MC-Unique: e5AbS5q5MimPA3hoZIS58w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FDAB800D41;
        Tue, 11 Feb 2020 18:34:03 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 384741000325;
        Tue, 11 Feb 2020 18:34:02 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Amir Vadai <amir@vadai.me>, Yotam Gigi <yotamg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
Date:   Tue, 11 Feb 2020 19:33:39 +0100
Message-Id: <7e829916e02af56770745c30cac8cb3fc9dfdc5c.1581444848.git.dcaratti@redhat.com>
In-Reply-To: <cover.1581444848.git.dcaratti@redhat.com>
References: <cover.1581444848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unlike other classifiers that can be offloaded (i.e. users can set flags
like 'skip_hw' and 'skip_sw'), 'cls_matchall' doesn't validate the size
of netlink attribute 'TCA_MATCHALL_FLAGS' provided by user: add a proper
entry to mall_policy.

Fixes: b87f7936a932 ("net/sched: Add match-all classifier hw offloading."=
)
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_matchall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 039cc86974f4..610a0b728161 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -157,6 +157,7 @@ static void *mall_get(struct tcf_proto *tp, u32 handl=
e)
 static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] =3D {
 	[TCA_MATCHALL_UNSPEC]		=3D { .type =3D NLA_UNSPEC },
 	[TCA_MATCHALL_CLASSID]		=3D { .type =3D NLA_U32 },
+	[TCA_MATCHALL_FLAGS]		=3D { .type =3D NLA_U32 },
 };
=20
 static int mall_set_parms(struct net *net, struct tcf_proto *tp,
--=20
2.24.1

