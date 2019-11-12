Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D5DF8CC4
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 11:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKLKZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 05:25:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbfKLKZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 05:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573554325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FeJe2qKR4AroS5wb+VoFiHA+D8O79Hn1DkUHm8ygPhU=;
        b=OgWJcMhvszP8VVDpW+eP+Nd+MESudH5m51w98FV/jqLWNuDCAUtXaqOLQ2UQxLHcLGANmS
        GYAYIO8pol2KWz6CChKpn0huX+c/ZX8KZzGqPxmNPC5mPsZN6f7UIxI2MOrtqCMFASlora
        5T6RNkl2p2+LX3/cq1wjgKG/VgEiqnI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-zTGsW_W7NRKKCPQO8JnMig-1; Tue, 12 Nov 2019 05:25:24 -0500
Received: by mail-wm1-f69.google.com with SMTP id 199so1252196wmb.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 02:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BrR3QsKS92XMMhW8UwZv36u713+8n4HIqLr/ZFLbFHQ=;
        b=Z0EoAvWj0ML1Q+m4ExL6AlsSlj+Bw5JOuaTo7I/E7cdTOgkAotCjwIJYRDTDdyXdnA
         CxhMeSRXNbMrwac2zlGUgJ6rQFkpeOT6qt5KXYsLKSLzukyycgtSRFBfAooaQ3KPVmE2
         g+OWgBzigkx+tAJ36/WS7nuJNIAbwvgNGw6kGcsIONjTKQWczYakZ/DywV6M63WgoCvK
         GgrlPW8Wc0RUOrBpPDIZfBqGhzCfd1w53R/zI7XU+7mHq6BmyCrXYuV/fUKwpnQAhX4/
         kkez3dgO4W0d+RxoBybkIAalgVcLjGRkQgtfkRBNZZTi0KPLc7p+7/l7r+frv5qsOdMW
         3Cug==
X-Gm-Message-State: APjAAAWltDnZpbO0j13e2OX2FrojGyUj8xYsDVibD76lKs1RMDBvYLID
        JrqiLUh/S9KEEqYV6tQdYwkj/eDTQzc/M6nS/QAAOazadKWNj6mxn55e6+iB37xsqsyiN1qd4Iq
        Kjh07ZU9rLZYMNBPb
X-Received: by 2002:adf:fd84:: with SMTP id d4mr24416308wrr.152.1573554322639;
        Tue, 12 Nov 2019 02:25:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzd01lEO1dSmRM5lGpocQcsRID0AkIXa07bDyw/j7sqhyXEVhx1JHsIG70FQL413foyixXCg==
X-Received: by 2002:adf:fd84:: with SMTP id d4mr24416280wrr.152.1573554322325;
        Tue, 12 Nov 2019 02:25:22 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x5sm2290277wmj.7.2019.11.12.02.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 02:25:21 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>
Subject: [PATCH net-next] openvswitch: add TTL decrement action
Date:   Tue, 12 Nov 2019 11:25:18 +0100
Message-Id: <20191112102518.4406-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: zTGsW_W7NRKKCPQO8JnMig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New action to decrement TTL instead of setting it to a fixed value.
This action will decrement the TTL and, in case of expired TTL, send the
packet to userspace via output_userspace() to take care of it.

Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.

Tested with a corresponding change in the userspace:

    # ovs-dpctl dump-flows
    in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, acti=
ons:dec_ttl,1
    in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, acti=
ons:dec_ttl,2
    in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, acti=
ons:2
    in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, acti=
ons:1

    # ping -c1 192.168.0.2 -t 42
    IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), le=
ngth 84)
        192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length=
 64
    # ping -c1 192.168.0.2 -t 120
    IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), l=
ength 84)
        192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length=
 64
    # ping -c1 192.168.0.2 -t 1
    #

Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/uapi/linux/openvswitch.h |  2 ++
 net/openvswitch/actions.c        | 46 ++++++++++++++++++++++++++++++++
 net/openvswitch/flow_netlink.c   |  6 +++++
 3 files changed, 54 insertions(+)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswi=
tch.h
index 1887a451c388..a3bdb1ecd1e7 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -890,6 +890,7 @@ struct check_pkt_len_arg {
  * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a s=
et
  * of actions if greater than the specified packet length, else execute
  * another set of actions.
+ * @OVS_ACTION_ATTR_DEC_TTL: Decrement the IP TTL.
  *
  * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  No=
t all
  * fields within a header are modifiable, e.g. the IPv4 protocol and fragm=
ent
@@ -925,6 +926,7 @@ enum ovs_action_attr {
 =09OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
 =09OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
 =09OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
+=09OVS_ACTION_ATTR_DEC_TTL,      /* Decrement ttl action */
=20
 =09__OVS_ACTION_ATTR_MAX,=09      /* Nothing past this will be accepted
 =09=09=09=09       * from userspace. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 12936c151cc0..077b7f309c93 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1174,6 +1174,43 @@ static int execute_check_pkt_len(struct datapath *dp=
, struct sk_buff *skb,
 =09=09=09     nla_len(actions), last, clone_flow_key);
 }
=20
+static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
+{
+=09int err;
+
+=09if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
+=09=09struct ipv6hdr *nh =3D ipv6_hdr(skb);
+
+=09=09err =3D skb_ensure_writable(skb, skb_network_offset(skb) +
+=09=09=09=09=09  sizeof(*nh));
+=09=09if (unlikely(err))
+=09=09=09return err;
+
+=09=09if (nh->hop_limit <=3D 1)
+=09=09=09return -EHOSTUNREACH;
+
+=09=09key->ip.ttl =3D --nh->hop_limit;
+=09} else {
+=09=09struct iphdr *nh =3D ip_hdr(skb);
+=09=09u8 old_ttl;
+
+=09=09err =3D skb_ensure_writable(skb, skb_network_offset(skb) +
+=09=09=09=09=09  sizeof(*nh));
+=09=09if (unlikely(err))
+=09=09=09return err;
+
+=09=09if (nh->ttl <=3D 1)
+=09=09=09return -EHOSTUNREACH;
+
+=09=09old_ttl =3D nh->ttl--;
+=09=09csum_replace2(&nh->check, htons(old_ttl << 8),
+=09=09=09      htons(nh->ttl << 8));
+=09=09key->ip.ttl =3D nh->ttl;
+=09}
+
+=09return 0;
+}
+
 /* Execute a list of actions against 'skb'. */
 static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 =09=09=09      struct sw_flow_key *key,
@@ -1345,6 +1382,15 @@ static int do_execute_actions(struct datapath *dp, s=
truct sk_buff *skb,
=20
 =09=09=09break;
 =09=09}
+
+=09=09case OVS_ACTION_ATTR_DEC_TTL:
+=09=09=09err =3D execute_dec_ttl(skb, key);
+=09=09=09if (err =3D=3D -EHOSTUNREACH) {
+=09=09=09=09output_userspace(dp, skb, key, a, attr,
+=09=09=09=09=09=09 len, OVS_CB(skb)->cutlen);
+=09=09=09=09OVS_CB(skb)->cutlen =3D 0;
+=09=09=09}
+=09=09=09break;
 =09=09}
=20
 =09=09if (unlikely(err)) {
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.=
c
index 65c2e3458ff5..d17f2d4b420f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *=
actions)
 =09=09case OVS_ACTION_ATTR_SET_MASKED:
 =09=09case OVS_ACTION_ATTR_METER:
 =09=09case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+=09=09case OVS_ACTION_ATTR_DEC_TTL:
 =09=09default:
 =09=09=09return true;
 =09=09}
@@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, co=
nst struct nlattr *attr,
 =09=09=09[OVS_ACTION_ATTR_METER] =3D sizeof(u32),
 =09=09=09[OVS_ACTION_ATTR_CLONE] =3D (u32)-1,
 =09=09=09[OVS_ACTION_ATTR_CHECK_PKT_LEN] =3D (u32)-1,
+=09=09=09[OVS_ACTION_ATTR_DEC_TTL] =3D 0,
 =09=09};
 =09=09const struct ovs_action_push_vlan *vlan;
 =09=09int type =3D nla_type(a);
@@ -3233,6 +3235,10 @@ static int __ovs_nla_copy_actions(struct net *net, c=
onst struct nlattr *attr,
 =09=09=09break;
 =09=09}
=20
+=09=09case OVS_ACTION_ATTR_DEC_TTL:
+=09=09=09/* Nothing to do.  */
+=09=09=09break;
+
 =09=09default:
 =09=09=09OVS_NLERR(log, "Unknown Action type %d", type);
 =09=09=09return -EINVAL;
--=20
2.23.0

