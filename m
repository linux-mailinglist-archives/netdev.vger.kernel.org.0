Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A44580173
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiGYPPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiGYPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:15:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CB21DA7B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 08:12:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v13so8643977wru.12
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 08:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ws+JKfNUgbZgFxIYFxXeNUzBvnzeat6x5ExGR6dVHqk=;
        b=I9YLGzvcVrXLxc2w6KeyzffEp7yo1jMOUMpSV12WqBdPhKym6b7vLHVG/HCvEtbiAB
         ovQjHS9zwrYOwZgviKdSA6Hovb8RsmsrTS6tUt6eQuJs8AWKv9GIWHqCVq93u0AAC6yD
         isQtP2wRA0gkCDntYLacq/BkQ+7BKuzLt72mR0PTHO5z10ndintVLdwFa0RDEhTszhMs
         MZU2LB5eCExpzHEYJB9qk13QPMXKNArT68johB04AYjfczw/Axu0TokFdKZGlLHmgTbh
         k6LWC0W3F+LEGrn9MPTysn048+HXaO4OYhNT+lXnZQQ3YAj7MeFz3GcRAc59NMdV78xk
         yHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ws+JKfNUgbZgFxIYFxXeNUzBvnzeat6x5ExGR6dVHqk=;
        b=hDz1bUmX/eu3dSKw7lxKBY7zsNHSiw+jp8NteKfhVt1POaY1HEQHQTXNP88RsP/Sxo
         M1XSQTsrlpI8l7S/3H8bVIR5aqTTxkd33j2QVT52nvnNrXhFGjafldGo0UiqlAHvAzuL
         gVTebnPm1cRO2zcxvAaPbDLWmXTdTB4FMaqdZl/IRHUSEfJnoCM5LPlIyW09o4Wx7LOx
         Ni1yyjzm/KVUsdipHr3+cZuyg1fWpfgdLi5FyQj2DMmYRd5qNJNLzpBM8Ute4ULIfwZO
         inDU38Peg2rZqH3K9OM50wn2gfWSakFc9seZrJl1elKyWAILN3xGalF8b0FzNldRn59H
         mFFw==
X-Gm-Message-State: AJIora9l64pG1/PyMOxY428ekigWWjGbrrFiRHgk+f74wEBHh0rU6VnJ
        2eBkniZXIleeZHU2lfG4IAcvF4ZigGvFJ5lrXeElrxLdIvI=
X-Google-Smtp-Source: AGRyM1sJc1JZWAbvG2zjZgCDtHiKdctWnkeXNKBwA5QtKluMH0Q52HySuODU6Qy+xiVJzXBkSsOOEr+wL86DFBqYovg=
X-Received: by 2002:a5d:4608:0:b0:21e:5755:98a3 with SMTP id
 t8-20020a5d4608000000b0021e575598a3mr8039367wrq.240.1658761965589; Mon, 25
 Jul 2022 08:12:45 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Hutchinson <b.hutchman@gmail.com>
Date:   Mon, 25 Jul 2022 11:12:34 -0400
Message-ID: <CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com>
Subject: Bonded multicast traffic causing packet loss when using DSA with
 Microchip KSZ9567 switch
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm experiencing large packet loss when using multicast with bonded
DSA interfaces.

I have the first two ports of a ksz9567 setup as individual network
interfaces in device tree that shows up in the system as lan1 and lan2
and I have those two interfaces bonded in an "active-backup" bond with
the intent of having each slave interface go to redundant switches.
I've tried connecting both interfaces to the same switch and also to
separate switches that are then connected together.  In the latter
setup, if I disconnect the two switches I don't see the problem.

The kernel bonding documentation says "active-backup" will work with
any layer2 switch and doesn't need smart/managed switches configured
in any particular way.  I'm currently using dumb switches.

I can readily reproduce the packet loss issue running iperf to
generate multicast traffic.

If I ping my board with the ksz9567 from a PC while iperf is
generating multicast packets, I get tons of packet loss.  If I run
heavily loaded iperf tests that are not multicast I don't notice the
packet loss problem.

Here is ifconfig view of interfaces:

bond1: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500  metric 1
       inet 192.168.1.6  netmask 255.255.255.0  broadcast 0.0.0.0
       inet6 fd1c:a799:6054:0:60e2:5ff:fe75:6716  prefixlen 64
scopeid 0x0<global>
       inet6 fe80::60e2:5ff:fe75:6716  prefixlen 64  scopeid 0x20<link>
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 1264782  bytes 84198600 (80.2 MiB)
       RX errors 0  dropped 40  overruns 0  frame 0
       TX packets 2466062  bytes 3705565532 (3.4 GiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1506  metric 1
       inet6 fe80::f21f:afff:fe6b:b218  prefixlen 64  scopeid 0x20<link>
       ether f0:1f:af:6b:b2:18  txqueuelen 1000  (Ethernet)
       RX packets 1264782  bytes 110759022 (105.6 MiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 2466097  bytes 3710503019 (3.4 GiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan1: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 543771  bytes 37195218 (35.4 MiB)
       RX errors 0  dropped 20  overruns 0  frame 0
       TX packets 1058336  bytes 1593030865 (1.4 GiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lan2: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500  metric 1
       ether 62:e2:05:75:67:16  txqueuelen 1000  (Ethernet)
       RX packets 721011  bytes 47003382 (44.8 MiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 1407726  bytes 2112534667 (1.9 GiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
       inet 127.0.0.1  netmask 255.0.0.0
       inet6 ::1  prefixlen 128  scopeid 0x10<host>
       loop  txqueuelen 1000  (Local Loopback)
       RX packets 394  bytes 52052 (50.8 KiB)
       RX errors 0  dropped 0  overruns 0  frame 0
       TX packets 394  bytes 52052 (50.8 KiB)
       TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Is what I'm trying to do even valid with dumb switches or is the
bonding documentation wrong/outdated regarding active-backup bonds not
needing smart switches?

I know there's probably not going to be anyone out there that can
reproduce my setup to look at this problem but I'm willing to run
whatever tests and provide all the info/feedback I can.

I'm running 5.10.69 on iMX8MM with custom Linux OS based on Yocto
Dunfell release.

I know that DSA master interface eth0 is not to be accessed directly
yet I see eth0 is getting an ipv6 address and I'm wondering if that
could cause a scenario where networking stack could attempt to use
eth0 directly for traffic.

Regards,

Brian
