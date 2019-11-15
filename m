Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAA2FDBFE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 12:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfKOLKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 06:10:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59030 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727170AbfKOLKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 06:10:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573816245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kvdfBB/OL1RKqn5wB2rhib2iB+Se/LfSqEAPqgf8JXY=;
        b=N+2wgoJHug01IXQ89GbI50LnXppoTTrm7yEU+vaKzR6EvnjgruYbFhAWTnx/UQ0YM1G7XT
        WS/wwzLWLtB21tzHx6Os/0MdIDAazH+Ab7vGoBFfGpBI/sxn9Rxgi+D4saG4C6if+ghpS7
        CDMlCTI0mAlmHg/U7uHS8zVLLk57aSE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-rD-Ad0bRM0m_Ob8ECRhXqQ-1; Fri, 15 Nov 2019 06:10:42 -0500
Received: by mail-wm1-f72.google.com with SMTP id f16so5831972wmb.2
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 03:10:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjOGDwlR3plOhDtlved0KVpfk475OBTI+qZNZ+6nVyc=;
        b=tVFkaMt9syv5E2hrmvdH/BX3hOvHygH1UXZ5L8Bsz7Vlv2a9Epkb1JUEeXR34ND1dV
         WtQ2zvoQyOMNdksYFpZCri8pz5JLYC4r5xQNUlPzLsHhWVJlQ0o4MOMjpOS2JyyxFICe
         gMwy3zR7Dm6qeYc3CftAjudZuk3ULYlpBKw3RxphePKDD+++cLGx0UnyXn/DsIEYtR/5
         REILfZUtpZWZpL+G1n7ofCp2DphwtUi9VM3wIa0NrWMBNAt2qk4r40qHPwepwV5J5KWr
         Qg2MhUB3YMufnip5q6YdvpixN0RHEstGswbYiHmVoxhR4dsSeh6KuIHUHoLxsaDK2eh1
         QKyw==
X-Gm-Message-State: APjAAAWJ9flgZ2RHh0JKHPjyivZaSOeaT3MmPFKEQlBHaj8sAyJF3lt8
        xqhIc+yQQexQaBgbDHgbxrDtQRv/mydH8lAmIG4V+U9qRg564a16w+zRXTx6QUg7VagEvEdYAit
        SJu2sXLKsiaum2a/E
X-Received: by 2002:a5d:526f:: with SMTP id l15mr14215172wrc.169.1573816241375;
        Fri, 15 Nov 2019 03:10:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOPQptYPfONVLIR3kAUatC7HlUW850xwQBpIGGl+7G/miLNYFThsiuimFFWREf2We/4QDuJg==
X-Received: by 2002:a5d:526f:: with SMTP id l15mr14215138wrc.169.1573816241039;
        Fri, 15 Nov 2019 03:10:41 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v6sm11166971wrt.13.2019.11.15.03.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 03:10:40 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] bonding: symmetric ICMP transmit
Date:   Fri, 15 Nov 2019 12:10:37 +0100
Message-Id: <20191115111037.7843-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: rD-Ad0bRM0m_Ob8ECRhXqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bonding with layer2+3 or layer3+4 hashing uses the IP addresses and the p=
orts
to balance packets between slaves. With some network errors, we receive an =
ICMP
error packet by the remote host or a router. If sent by a router, the sourc=
e IP
can differ from the remote host one. Additionally the ICMP protocol has no =
port
numbers, so a layer3+4 bonding will get a different hash than the previous =
one.
These two conditions could let the packet go through a different interface =
than
the other packets of the same flow:

    # tcpdump -qltnni veth0 |sed 's/^/0: /' &
    # tcpdump -qltnni veth1 |sed 's/^/1: /' &
    # hping3 -2 192.168.0.2 -p 9
    0: IP 192.168.0.1.2251 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    1: IP 192.168.0.1.2252 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    1: IP 192.168.0.1.2253 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    0: IP 192.168.0.1.2254 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36

An ICMP error packet contains the header of the packet which caused the net=
work
error, so inspect it and match the flow against it, so we can send the ICMP=
 via
the same interface of the previous packet in the flow.
Move the IP and port dissect code into a generic function bond_flow_ip() an=
d if
we are dissecting an ICMP error packet, call it again with the adjusted off=
set.

    # hping3 -2 192.168.0.2 -p 9
    1: IP 192.168.0.1.1224 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    1: IP 192.168.0.1.1225 > 192.168.0.2.9: UDP, length 0
    1: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    0: IP 192.168.0.1.1226 > 192.168.0.2.9: UDP, length 0
    0: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36
    0: IP 192.168.0.1.1227 > 192.168.0.2.9: UDP, length 0
    0: IP 192.168.0.2 > 192.168.0.1: ICMP 192.168.0.2 udp port 9 unreachabl=
e, length 36

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/bonding/bond_main.c | 83 ++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 08b2b0d855af..fcb7c2f7f001 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -41,6 +41,8 @@
 #include <linux/in.h>
 #include <net/ip.h>
 #include <linux/ip.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/slab.h>
@@ -3297,12 +3299,42 @@ static inline u32 bond_eth_hash(struct sk_buff *skb=
)
 =09return 0;
 }
=20
+static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
+=09=09=09 int *noff, int *proto, bool l34)
+{
+=09const struct ipv6hdr *iph6;
+=09const struct iphdr *iph;
+
+=09if (skb->protocol =3D=3D htons(ETH_P_IP)) {
+=09=09if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph))))
+=09=09=09return false;
+=09=09iph =3D (const struct iphdr *)(skb->data + *noff);
+=09=09iph_to_flow_copy_v4addrs(fk, iph);
+=09=09*noff +=3D iph->ihl << 2;
+=09=09if (!ip_is_fragment(iph))
+=09=09=09*proto =3D iph->protocol;
+=09} else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
+=09=09if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph6))))
+=09=09=09return false;
+=09=09iph6 =3D (const struct ipv6hdr *)(skb->data + *noff);
+=09=09iph_to_flow_copy_v6addrs(fk, iph6);
+=09=09*noff +=3D sizeof(*iph6);
+=09=09*proto =3D iph6->nexthdr;
+=09} else {
+=09=09return false;
+=09}
+
+=09if (l34 && *proto >=3D 0)
+=09=09fk->ports.ports =3D skb_flow_get_ports(skb, *noff, *proto);
+
+=09return true;
+}
+
 /* Extract the appropriate headers based on bond's xmit policy */
 static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 =09=09=09      struct flow_keys *fk)
 {
-=09const struct ipv6hdr *iph6;
-=09const struct iphdr *iph;
+=09bool l34 =3D bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_LAYER34;
 =09int noff, proto =3D -1;
=20
 =09if (bond->params.xmit_policy > BOND_XMIT_POLICY_LAYER23) {
@@ -3314,31 +3346,30 @@ static bool bond_flow_dissect(struct bonding *bond,=
 struct sk_buff *skb,
 =09fk->ports.ports =3D 0;
 =09memset(&fk->icmp, 0, sizeof(fk->icmp));
 =09noff =3D skb_network_offset(skb);
-=09if (skb->protocol =3D=3D htons(ETH_P_IP)) {
-=09=09if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
-=09=09=09return false;
-=09=09iph =3D ip_hdr(skb);
-=09=09iph_to_flow_copy_v4addrs(fk, iph);
-=09=09noff +=3D iph->ihl << 2;
-=09=09if (!ip_is_fragment(iph))
-=09=09=09proto =3D iph->protocol;
-=09} else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
-=09=09if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph6))))
-=09=09=09return false;
-=09=09iph6 =3D ipv6_hdr(skb);
-=09=09iph_to_flow_copy_v6addrs(fk, iph6);
-=09=09noff +=3D sizeof(*iph6);
-=09=09proto =3D iph6->nexthdr;
-=09} else {
+=09if (!bond_flow_ip(skb, fk, &noff, &proto, l34))
 =09=09return false;
-=09}
-=09if (bond->params.xmit_policy =3D=3D BOND_XMIT_POLICY_LAYER34 && proto >=
=3D 0) {
-=09=09if (proto =3D=3D IPPROTO_ICMP || proto =3D=3D IPPROTO_ICMPV6)
-=09=09=09skb_flow_get_icmp_tci(skb, &fk->icmp, skb->data,
-=09=09=09=09=09      skb_transport_offset(skb),
-=09=09=09=09=09      skb_headlen(skb));
-=09=09else
-=09=09=09fk->ports.ports =3D skb_flow_get_ports(skb, noff, proto);
+
+=09/* ICMP error packets contains at least 8 bytes of the header
+=09 * of the packet which generated the error. Use this information
+=09 * to correlate ICMP error packets within the same flow which
+=09 * generated the error.
+=09 */
+=09if (proto =3D=3D IPPROTO_ICMP || proto =3D=3D IPPROTO_ICMPV6) {
+=09=09skb_flow_get_icmp_tci(skb, &fk->icmp, skb->data,
+=09=09=09=09      skb_transport_offset(skb),
+=09=09=09=09      skb_headlen(skb));
+=09=09if (proto =3D=3D IPPROTO_ICMP) {
+=09=09=09if (!icmp_is_err(fk->icmp.type))
+=09=09=09=09return true;
+
+=09=09=09noff +=3D sizeof(struct icmphdr);
+=09=09} else if (proto =3D=3D IPPROTO_ICMPV6) {
+=09=09=09if (!icmpv6_is_err(fk->icmp.type))
+=09=09=09=09return true;
+
+=09=09=09noff +=3D sizeof(struct icmp6hdr);
+=09=09}
+=09=09return bond_flow_ip(skb, fk, &noff, &proto, l34);
 =09}
=20
 =09return true;
--=20
2.23.0

