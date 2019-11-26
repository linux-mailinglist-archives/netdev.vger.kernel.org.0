Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E26E109D5C
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 12:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKZL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 06:56:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57048 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727250AbfKZL4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 06:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574769365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7DIBBOBL4U2n7PHwWr63gDhfeAONuO8XB+pT4vPnSDc=;
        b=O0hQ0XjZhLR0f6odTe5pLDy8+AoPQ9j5q2FFvufuBOeK+dhfpB/ZvCfUZIbCABe2sl2Ghf
        kuSI1fGBlgb2zFouxxAle41YNxkghKXMOUe645E6d3aNzVD97MAja5/0KnX7C/VPgS5a3n
        L326d4gW1V1F0lps9/eiTlkG65/2WbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-a_JN0NySOrGxZovsr50ZxQ-1; Tue, 26 Nov 2019 06:56:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 771D1800D5B;
        Tue, 26 Nov 2019 11:56:00 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-191.ams2.redhat.com [10.36.116.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E790E60BEC;
        Tue, 26 Nov 2019 11:55:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joestringer@nicira.com>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net] openvswitch: fix flow command message size
Date:   Tue, 26 Nov 2019 12:55:50 +0100
Message-Id: <7df4df3b89d405b3f01b6e637a52321bf36d37d4.1574769169.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: a_JN0NySOrGxZovsr50ZxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user-space sets the OVS_UFID_F_OMIT_* flags, and the relevant
flow has no UFID, we can exceed the computed size, as
ovs_nla_put_identifier() will always dump an OVS_FLOW_ATTR_KEY
attribute.
Take the above in account when computing the flow command message
size.

Reported-by: Qi Jun Ding <qding@redhat.com>
Fixes: 74ed7ab9264c ("openvswitch: Add support for unique flow IDs.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/openvswitch/datapath.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 50656e807c8c..928e580c8cc9 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -704,9 +704,13 @@ static size_t ovs_flow_cmd_msg_size(const struct sw_fl=
ow_actions *acts,
 {
 =09size_t len =3D NLMSG_ALIGN(sizeof(struct ovs_header));
=20
-=09/* OVS_FLOW_ATTR_UFID */
+=09/* OVS_FLOW_ATTR_UFID, or unmasked flow key as fallback
+=09 * see ovs_nla_put_identifier()
+=09 */
 =09if (sfid && ovs_identifier_is_ufid(sfid))
 =09=09len +=3D nla_total_size(sfid->ufid_len);
+=09else
+=09=09len +=3D nla_total_size(ovs_key_attr_size());
=20
 =09/* OVS_FLOW_ATTR_KEY */
 =09if (!sfid || should_fill_key(sfid, ufid_flags))
--=20
2.21.0

