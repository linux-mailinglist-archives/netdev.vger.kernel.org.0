Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25F75533F5
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351153AbiFUNs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351189AbiFUNsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:48:23 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C85EE4B
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:48:21 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 8so1472664vkg.10
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=zYicksjCEd3T7Trd6WJ08toM3gnyE4VOhSugj5FjpP4=;
        b=XNhlvLgMf+PkQWxlquFQhX43Vl4X+loaSKv+9KsODJyjhU+C6waAmYsBwis8V7JoIN
         qoWUja3KsrAyJqVKWifOSMNa44KDJrluTPdQclRX7Zg6XyC7etOA+UCIawytmbjgPPjR
         zVLehqe9hE4nWIj6Ppmj7xx2cVys0X4AaItnYkGkBnIipIaXg3ZmccgmUud68ynfAodP
         UE5fiXSQgntqnqnfGjmS0JmACfj+ka0zb9qnxbMNN0Ix4S3p7+cxc5qcnZ/rYl96A/Lr
         AAs7MjSVaK6wT6AovVsghBD2e5XAOrgf98+oAUOXC8AYVykdHl4oVof6ey+sWTgh1le6
         2XEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zYicksjCEd3T7Trd6WJ08toM3gnyE4VOhSugj5FjpP4=;
        b=Hu5xReLPpNumPy3JXghJHz4Rr3XORKR37k0PJKWQfU+Vi8CGC1soM6+u9WxU/JtIWg
         SKjTcvx2vpLMBRCH8qHOr9/XLYGEqEZFNKYMV//0RRqNn2VbURd/tnFZc1Y8FRw2bpRz
         LNZ1wffWhBQjnapyhzp377DVFQ80RV5H3A561Xv2DMSzceUVDYoURE75gc5nIfq3lI66
         7ii4lC0G9McyBkoOnap891ZlMVBWO7uoKp/0+X4M6Yzru5H2zwKmS1XJ21Cy08ADmtL5
         SvPEHiIVX9qNtofVo/mPxxGhvdOVr4aGxVWHWZBfIXF9QVfQaES9cDTd5i/lye9Kn6aX
         9B1g==
X-Gm-Message-State: AJIora/H9gSRh9M11LH+ddCS7HuhNzAQyFZzbjH0SMsGsALdM6VLoJVa
        6R/i8pELgzesYVufqUYKHnhyWyox/3KdKQYB35DJwolkZvjdzA==
X-Google-Smtp-Source: AGRyM1vrOKbU9vW7xq/8C4hBP5N/SiF9Xe66T8ptny2zd3qNJLa009wyvCeDmNcVs/cXtXbGxtzkhl5pGSZnDLSPyqk=
X-Received: by 2002:a1f:1d82:0:b0:35d:e310:b03b with SMTP id
 d124-20020a1f1d82000000b0035de310b03bmr11791856vkd.39.1655819300110; Tue, 21
 Jun 2022 06:48:20 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Tue, 21 Jun 2022 16:48:09 +0300
Message-ID: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
Subject: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header are
 recorded twice
To:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainers,

I tried to ping IPv6 hub address on the mGRE interface from the spok
and found some problem:
I caught packets and saw that there are 2 identical IP and GRE headers
(when use IPv4 there is no duplication)
Below is the package structure:
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| eth | iph (1) | greh (1) | iph (1) | greh (1) | iph (2) | greh (2) |  icmp  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

I found cause of the problem, in ip_gre.c and ip6_gre.c IP and GRE
headers created twice, first time in ip gre_header() and
ip6gre_header() and second time in __gre_xmit(), so I deleted
unnecessary creation of headers and everything started working as it
should.
Below is a patch to eliminate the problem of duplicate headers:

diff -c a/net/inv6/ip6_gre.c b/net/inv6/ip6_gre.c
*** net/inv6/ip6_gre.c
--- net/inv6/ip6_gre.c
***************
*** 1356,1400 ****
  return err;
  }

- static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
- unsigned short type, const void *daddr,
- const void *saddr, unsigned int len)
- {
- struct ip6_tnl *t = netdev_priv(dev);
- struct ipv6hdr *ipv6h;
- __be16 *p;
-
- ipv6h = skb_push(skb, t->hlen + sizeof(*ipv6h));
- ip6_flow_hdr(ipv6h, 0, ip6_make_flowlabel(dev_net(dev), skb,
-   t->fl.u.ip6.flowlabel,
-   true, &t->fl.u.ip6));
- ipv6h->hop_limit = t->parms.hop_limit;
- ipv6h->nexthdr = NEXTHDR_GRE;
- ipv6h->saddr = t->parms.laddr;
- ipv6h->daddr = t->parms.raddr;
-
- p = (__be16 *)(ipv6h + 1);
- p[0] = t->parms.o_flags;
- p[1] = htons(type);
-
- /*
- * Set the source hardware address.
- */
-
- if (saddr)
- memcpy(&ipv6h->saddr, saddr, sizeof(struct in6_addr));
- if (daddr)
- memcpy(&ipv6h->daddr, daddr, sizeof(struct in6_addr));
- if (!ipv6_addr_any(&ipv6h->daddr))
- return t->hlen;
-
- return -t->hlen;
- }
-
- static const struct header_ops ip6gre_header_ops = {
- .create = ip6gre_header,
- };
-
  static const struct net_device_ops ip6gre_netdev_ops = {
  .ndo_init = ip6gre_tunnel_init,
  .ndo_uninit = ip6gre_tunnel_uninit,
--- 1356,1361 ----
diff -c a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
*** net/ipv4/ip_gre.c
--- net/ipv4/ip_gre.c
***************
*** 831,873 ****
     ftp fec0:6666:6666::193.233.7.65
     ...
   */
- static int ipgre_header(struct sk_buff *skb, struct net_device *dev,
- unsigned short type,
- const void *daddr, const void *saddr, unsigned int len)
- {
- struct ip_tunnel *t = netdev_priv(dev);
- struct iphdr *iph;
- struct gre_base_hdr *greh;
-
- iph = skb_push(skb, t->hlen + sizeof(*iph));
- greh = (struct gre_base_hdr *)(iph+1);
- greh->flags = gre_tnl_flags_to_gre_flags(t->parms.o_flags);
- greh->protocol = htons(type);
-
- memcpy(iph, &t->parms.iph, sizeof(struct iphdr));
-
- /* Set the source hardware address. */
- if (saddr)
- memcpy(&iph->saddr, saddr, 4);
- if (daddr)
- memcpy(&iph->daddr, daddr, 4);
- if (iph->daddr)
- return t->hlen + sizeof(*iph);
-
- return -(t->hlen + sizeof(*iph));
- }
-
- static int ipgre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
- {
- const struct iphdr *iph = (const struct iphdr *) skb_mac_header(skb);
- memcpy(haddr, &iph->saddr, 4);
- return 4;
- }
-
- static const struct header_ops ipgre_header_ops = {
- .create = ipgre_header,
- .parse = ipgre_header_parse,
- };

  #ifdef CONFIG_NET_IPGRE_BROADCAST
  static int ipgre_open(struct net_device *dev)
--- 831,836 ----

--
Aleksey Shumnik
