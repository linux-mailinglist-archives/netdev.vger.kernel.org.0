Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4368355E12E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiF0IyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiF0IyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:54:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8E3631C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:54:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o16so12010951wra.4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2onYRytGIFvM9NoxQjUrWQxCLEb6uftzK2XpNXum2pU=;
        b=YM06AwfNK1fKbtl8FgBj/HQ8kZhHTv53oD2fObJplHd072rG4ODRAa2L5qOigZHY3i
         n7E5tlme3he3ZmXT5P+K44APuzORuuDZgmskALJLBb+IZ7/V8eCBzsrJxM+u1xccf8+e
         lSPdW/OJQrzrk/DX43RbyHc+Qt9FykkzKGcQKEJynJiVQuqgXs1JPyHNCqCh2omysxia
         3OO1BDYr5IYIpognGATzZor7M37XchetaZUPGTQYobBSjRRy8DgYqzDe+CAD30YVf875
         rdW8J7eMC2A9mYrVD6v1UGOd16lP5WzC5mKnSOGwVL0JhDRi83HXzFWpI2OVDdqPAtUg
         j2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2onYRytGIFvM9NoxQjUrWQxCLEb6uftzK2XpNXum2pU=;
        b=oOG50hdQKWzE0d/g2xE3J9okHIVgDz0eVhQsBY82NxrcIdQm4iS6HEeMgJoyBx6uCD
         wLM+llaJO1ywU/NkJoG4Efsh7JVjz9+5U10FBavVtAe4h4ka9TmX+bD+hL8sTIF0hic3
         7rsG+J9TxbnNj0sEcWHbh4LBDMwLQA/SBQR/Cq4DgOHYB+b+rQnJOiqQmYJg4Yst5XDR
         CY2I2NS/KuIw5gKaghrrU2pGcDJ5GCrQS25E11aeAHpwQUUMuKUU0rvxTQ0MVXFYCZuR
         9pVOdQABNHkH/u06e0ZYf/dpsRPxBvTJ4tp8sbkIZ1/KFVBNoLKKk1wSEDS2w+6BB47v
         OPuQ==
X-Gm-Message-State: AJIora/ITbwcqGT6p+yVRNctVituJrGmtzBLcSgO4OOcZBpwwfb2KA9E
        2Hm8nTJYF8BD9c1yQnx07fA=
X-Google-Smtp-Source: AGRyM1urHgw3hYwILDV5wO6era5LpXeHVu3NBtjyzRBAwjrTpWtFyxGiOGHB3ospsYRYfwdyVpLEGA==
X-Received: by 2002:adf:dcc9:0:b0:21a:39dc:f875 with SMTP id x9-20020adfdcc9000000b0021a39dcf875mr10877292wrm.285.1656320040812;
        Mon, 27 Jun 2022 01:54:00 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm9780640wrt.19.2022.06.27.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 01:54:00 -0700 (PDT)
Date:   Mon, 27 Jun 2022 10:52:33 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected sockets
Message-ID: <20220627085219.GA9597@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP_UNICAST_IF socket option is used to set the outgoing interface for
outbound packets.
The IP_UNICAST_IF socket option was added as it was needed by the Wine
project, since no other existing option (SO_BINDTODEVICE socket option,
IP_PKTINFO socket option or the bind function) provided the needed
characteristics needed by the IP_UNICAST_IF socket option. [1]
The IP_UNICAST_IF socket option works well for unconnected sockets, that
is, the interface specified by the IP_UNICAST_IF socket option is taken
into consideration in the route lookup process when a packet is being
sent.
However, for connected sockets, the outbound interface is chosen when
connecting the socket, and in the route lookup process which is done when
a packet is being sent, the interface specified by the IP_UNICAST_IF
socket option is being ignored.

This inconsistent behavior was reported and discussed in an issue opened
on systemd's GitHub project [2]. Also, a bug report was submitted in the
kernel's bugzilla [3].

To understand the problem in more detail, we can look at what happens
for UDP packets over IPv4 (The same analysis was done separately in
the referenced systemd issue).
When a UDP packet is sent the udp_sendmsg function gets called and the
following happens:

1. The oif member of the struct ipcm_cookie ipc (which stores the output
interface of the packet) is initialized by the ipcm_init_sk function to
inet->sk.sk_bound_dev_if (the device set by the SO_BINDTODEVICE socket
option).

2. If the IP_PKTINFO socket option was set, the oif member gets overridden
by the call to the ip_cmsg_send function.

3. If no output interface was selected yet, the interface specified by the
IP_UNICAST_IF socket option is used.

4. If the socket is connected and no destination address is specified in
the send function, the struct ipcm_cookie ipc is not taken into
consideration and the cached route, that was calculated in the connect
function is being used.

Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken into
consideration.

This patch corrects the behavior of the IP_UNICAST_IF socket option for
connect()ed sockets by taking into consideration the IP_UNICAST_IF sockopt
when connecting the socket.

In order to avoid reconnecting the socket, this option is still ignored 
when applied on an already connected socket until connect() is called
again by the user.

Change the __ip4_datagram_connect function, which is called during socket
connection, to take into consideration the interface set by the
IP_UNICAST_IF socket option, in a similar way to what is done in the
udp_sendmsg function.

[1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
[2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
[3] https://bugzilla.kernel.org/show_bug.cgi?id=210255

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv4/datagram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index ffd57523331f..405a8c2aea64 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -42,6 +42,8 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 			oif = inet->mc_index;
 		if (!saddr)
 			saddr = inet->mc_addr;
+	} else if (!oif) {
+		oif = inet->uc_index;
 	}
 	fl4 = &inet->cork.fl.u.ip4;
 	rt = ip_route_connect(fl4, usin->sin_addr.s_addr, saddr,
-- 
2.36.1

