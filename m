Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60F1640608
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiLBLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiLBLrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:47:12 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B20D584F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 03:47:10 -0800 (PST)
Date:   Fri, 02 Dec 2022 11:47:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=industrialdiscipline.com; s=protonmail3; t=1669981628;
        x=1670240828; bh=34f55ETXeWR9gstPboEDhFjx4HdRa9dhuPUbOzATjfo=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=Tw8FAa+xoa5tKjrPco4LJnhIb0RezFaqvUDSwDkOtSjL+Ao3MvR+yOKCQlRWZsrvU
         PpzcZTiKMaPHPx8jEyMNw35jxvDYS6pdaRHWeMs8HIgdvpqiPdbrEhajG72kJ2sLqV
         D1BKIV2oRT5dMELzIUPRT99XKAyPyaHmXpn/q/6U4VDWtt8aaJnBtPHT0XPmFCIuNg
         SJ9n2CytgFtDnlbRJb5ILOR/bnZb1sfs+BKqIeOzMp6vlV0Wnrcasko9YYSgYy3XjI
         BhUxPjPLWpvyQ6gNEBqoYxqpRe6Mq9sT0pZbgf2fZmOkQV72ZY33u+4K5Aut+J5xvS
         LozKz9uj6gsLg==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
From:   Sahid Orentino Ferdjaoui 
        <sahid.ferdjaoui@industrialdiscipline.com>
Subject: [Q/A][ICMP Unreach need-to-frag] Forwarded packets and IP fragmentation
Message-ID: <Y4nlslrmQBa6Lqf3@system76-pc.localdomain>
Feedback-ID: 39921202:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have question regarding design. The point is to handle ICMP Error
Unreach need-to-fragment.

Specifically and to share a bit more of context. The idea is to make
Cilium handling ICMP Error Unreach need-to-fragment with service
NodePort.

I understand that Cilium is not Linux but for that particular case we
are in the middle of both.

Initially the question that I had was, does Linux do packet
fragmentation from a host that is forwarding traffic. That when it has
a route for that traffic which indicates a smaller MTU than the
traffic comming from. Will the traffic be fragmented during egressing?

But then I was considering to discuss what I have experienced and
ideas since I may be wrong on my way to implement it.

Also that I have noticed the option `ip_forward_use_pmtu` But probably
not for thise case, I have enabled it but no luck.


Pod-X      : 172.10.0.10
NodePort-X : 192.168.39.23
Router-X   : 192.168.39.1
Client-X   : 10.1.0.100


                                  +------------+
                                  | Pod-X      |
                                  +------+-----+
   Cilium Host-Y                         |
            ------+-------------+--------+-------------------
                  ||
                  || VxLan
                  ||
                  ||               +------------+
                  ||               | NodePort-X |  192.168.39.0/24 dev eth0
                  ||               +------+-----+
   Cilium Host-X  ||                      |
            ------++------------+---------+-------------------
                                |
   World                        |
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   |  ^
                   |  | ICMP Error Router-Y to NodePort
                   |  |   192.168.39.1/192.168.39.23
                   |  |      with in Payload 192.168.39.23/10.1.0.100
            +-------------+
            | Router-X    |
            +-------------+
                   |
   ----------------+-------+--------
                           |
                         Client-X


Routes
------
10.1.0.100 via 192.168.39.1 MTU 800


For a given Pod behind a service Nodeport delivery contents that is
exceeding MTU of one of the networking equipment in the path between
cluster and client. In that situation the networking equipment will
return to Cluster (NodePort) an ICMP Error Unreach need-to-fragment.

* Forwarding the packet to the Pod would not work since the Pod only
  has a view of the path between the node that is hosting the service
  NodePort and the backend node that is hosting the Pod, and we don=
=E2=80=99t
  want to reduce the MTU for that path.

Saying all of that I=E2=80=99m struggling to find the right approach.

I have experimented some:

1/ Having the host that is hosting the service Nodeport handling (as
   opposite to forward it to Pod) the ICMP Error message (currently
   dropped). The expected state would be to have the route table of
   the host that is hosting service NodePort be updated accordingly
   the ICMP Error.  But that does not look possible at that point in
   Linux since there are some checks to validate that the ICMP Error
   has been received for a response of a packet emit [0]. In context
   of Cilium we bypass netfilter during egressing, right?

=09sk =3D __inet_lookup_established(net, net->ipv4.tcp_death_row.hashinfo,
=09=09=09=09       iph->daddr, th->dest, iph->saddr,
=09=09=09=09       ntohs(th->source), inet_iif(skb), 0);
=09if (!sk) {
=09=09__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
=09=09return -ENOENT;
=09}

[0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/n=
et/ipv4/tcp_ipv4.c#n487


2/ Having service NodePort itself updating the route table of the host
   to instruct the new route with MTU based on the ICMP Error Unreach
   need-to-frag.  In that situation It may be expect that the packets
   get fragmented by the host during egressing. But based on my tests
   that does not look to work, I'm nore sure if Linux handle that case
   of forwarding/fragmenting?

3/ Having service NodePort handling the full implementation of ICMP
   Error Unreach need-to-fragement;
   - For a ICMP Error received the service would maintaining a MAP
     with routes and MTU.
   - For a packet leaving, the service would fragment packets if
     needed.


s.

