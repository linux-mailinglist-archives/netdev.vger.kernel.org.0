Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C63C3A2106
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFIXwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFIXwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:52:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C8AC061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 16:50:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c10so41002621eja.11
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ewtbyMO1XUNMxZjV6CzjLCyRumlc6WZSqowgdOD9EGA=;
        b=C4opsXdszvs7FE1EXON1rlLEqSkh7g0L4kSZ+8e+qqoeZWD+n8PGUhmlSqJ3BzsC5k
         dH0fCuPPwl4sQSOFwqsm+mDXKLKYWNQbc7PP/bj1fcYfb+QZ/kgqCXrZ4XYOJq/QvXlM
         MbKQOknJL9irbmGESO2eYLdKJKKwiYxoza0MV43+jKPEJ/8ekbrQIe+tvdb3cN2cCg06
         378IvSZL5KySET9mI21BR8axc5ORkAD2pMEf05DWonFxim8SbtWpK939Fqh/rRmvIppg
         1JK2JYVlg4fvc4hFs2Q1sfXRjELWAkfY5Tddg/gUM/kcyykm+G2uAgkhIiD/DahpEwDr
         n0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ewtbyMO1XUNMxZjV6CzjLCyRumlc6WZSqowgdOD9EGA=;
        b=ptHg7FDJXaLOsVcf/N03rxX4q3tCz1HafIY1kYn8DZWkWSN+6LrehU0+oL9lqpnkY9
         45bdhhSMXNxtjjLUiBB4tnvNYq4j4McuZfb9///wIMfjBt6cwy81cPdmI6omjySV1DfX
         yytnm0snVJTfoXbUjZ5XB4dKk5nXO/ZvfBP8VI4QdFZqSYHtvAyORXlVYmhkSm397Ct0
         PaadDNjruj6CYCcj1V2m5WOPbieJKDRl9XrwyxbMfdQTkLRAiye/oVRw6wG+y5djt1PS
         I3KmXHW2nYbayvAD75IvWkZshPV8RehoMSmOwWtYKyc798W1EgY2h+PcCUmmwG8uRYzY
         yDZw==
X-Gm-Message-State: AOAM531S7v2HUv67EYGDF4+OKVLghD1XnZS9+I691zWDufXqKwHW/Urh
        MtallLe+VE5YWe/4I0gQZB799PzsgTF8IqHHVY3ARZEaS4U=
X-Google-Smtp-Source: ABdhPJxbsxDYq7+QcN0IYrcIEucdgHZLnlOwmEC4ZLD0hkFuod63eLJabNgLJEPM7FeX9jBju05a2ocFkMNzoKPaId4=
X-Received: by 2002:a17:906:2bcc:: with SMTP id n12mr1907783ejg.430.1623282630210;
 Wed, 09 Jun 2021 16:50:30 -0700 (PDT)
MIME-Version: 1.0
From:   Vincent Li <vincent.mc.li@gmail.com>
Date:   Wed, 9 Jun 2021 16:50:18 -0700
Message-ID: <CAK3+h2x2pxbU0BS=mxCZPJxy702BXFjJrQfvt4q9Ls=sijCo=w@mail.gmail.com>
Subject: packet seems disappeared after vxlan_rcv/gro_cells_receive/napi_schedule(&cell->napi)
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Experts,

I am doing a tunnel communication  test between Cilium eBPF tunnel and
Linux VXLAN vni key based tunnel device (to simulate BIG-IP VXLAN vni
key based device), https://github.com/cilium/cilium/issues/16462

I came across a problem when packet is handled by
vxlan_rcv->gro_cells_receive->napi_schedule(&cell->napi),  the packet
seems getting dropped somewhere after that. I suspect I might have
done something wrong to setup the VXLAN device.

Here is how I setup the vxlan device  test on my Centos 8 with most
recent mainline git kernel build (5.13.0-rc4+ )

====start of the script====
#!/bin/bash


ip link add vxlan666 type vxlan id 666 dstport 8472 local
10.169.72.236 dev ens192 nolearning l2miss l3miss proxy

ip link set vxlan666 up

ip a add 10.0.4.236/24 dev vxlan666

ip route add 10.0.1.0/24 dev vxlan666  proto kernel  scope link  src 10.0.4.236

arp -i vxlan666 -s 10.0.1.17 6a:29:d2:78:63:7d

bridge fdb append 6a:29:d2:78:63:7d dst 10.169.72.238 dev vxlan666

====end of the script====

then I run tcpdump in the background

#tcpdump -nn -e -i vxlan666 &

and start to ping the IP 10.0.1.17 which is a POD IP in Cilium managed
K8S cluster

#ping -c 1 10.0.1.17


PING 10.0.1.17 (10.0.1.17) 56(84) bytes of data.

19:06:44.452994 d6:04:7c:b2:93:54 > 6a:29:d2:78:63:7d, ethertype IPv4
(0x0800), length 98: 10.0.4.236 > 10.0.1.17: ICMP echo request, id
1522, seq 1, length 64

19:06:44.454515 56:3d:9c:3a:09:78 > b2:1c:3c:57:9e:97, ethertype IPv4
(0x0800), length 98: 10.0.1.17 > 10.0.4.236: ICMP echo reply, id 1522,
seq 1, length 64


^C

--- 10.0.1.17 ping statistics ---

1 packets transmitted, 0 received, 100% packet loss, time 0ms

You can see the tcpdump shows ICMP echo reply, but ping did not get
the ICMP echo reply  and shows 100% packet loss.

I added netdev_info log below and I can see the kernel log:

@@ -35,13 +39,17 @@ int gro_cells_receive(struct gro_cells *gcells,
struct sk_buff *skb)

        }


        __skb_queue_tail(&cell->napi_skbs, skb);
-       if (skb_queue_len(&cell->napi_skbs) == 1)
+       if (skb_queue_len(&cell->napi_skbs) == 1) {
+               netdev_info(skb->dev, "gro_cells_receive: napi_schedule\n");
                napi_schedule(&cell->napi);
+       }
+       netdev_info(skb->dev, "gro_cells_receive: NET_RX_SUCCESS\n");
        res = NET_RX_SUCCESS;

Jun  9 19:06:44 kernel-dev kernel: vxlan666: gro_cells_receive: napi_schedule

Jun  9 19:06:44 kernel-dev kernel: vxlan666: gro_cells_receive: NET_RX_SUCCESS


 I don't know where I have done wrong, any help is appreciated ! :)
