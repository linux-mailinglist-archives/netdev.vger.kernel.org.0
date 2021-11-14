Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E7044F63B
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhKNCnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 21:43:12 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:45845 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbhKNCnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 21:43:11 -0500
Received: by mail-ot1-f49.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso13498029otf.12
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 18:40:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=w0ldbUxajuGjEx9WRRPX7QIuMHj0mypfimFHmo7Ocqw=;
        b=nfh88YqVqf3Vcv1QwPuUUMdN8sZOPrIDU9latbWDovPwYMHYgg5UzstlMp72p4svrJ
         noxXjnbcBY58xslyRsvNV25SOLckcyVCXrR4+QQmuDtWlHDQ9/8KCckIXm7b7vlyBB5p
         6c3UVEEfma4tBWj6YQCURatixypmbge9kjKuwUqyfwxhdtPGQPwKvYlQjMbYNQHMW7sd
         xaFe6QnbnquoilWoD9NDabARHUFB4wpd6f7UK5NZKIP6lGHOc9vwDDJwOOPL8ebETE1M
         JztJi6m4kUnfcpEGpJ7TbY32wQwM+XD8jIfHyBq6LmfzUlhxqM8LiNZsBF5x5M+LQ/38
         NeFg==
X-Gm-Message-State: AOAM533Ui/QKP0ieDoOkYI6tHZX60bapM7jJxz4qzmNG0S0LZX37nOlZ
        h8ukzcm7qWUZcHaiGKAdHcTWJd4Dn2Txba5bQp5fWeOV23o=
X-Google-Smtp-Source: ABdhPJx1uobqdZ74yQJWy4nJ0AzGePdiK/M47fMmA5ub1JO7VBj918etm9DgB18Dgv9AtCTima4m8psHIedmhO7xjPg=
X-Received: by 2002:a9d:2628:: with SMTP id a37mr22930200otb.61.1636857618108;
 Sat, 13 Nov 2021 18:40:18 -0800 (PST)
MIME-Version: 1.0
From:   Paul Tagliamonte <paultag@debian.org>
Date:   Sat, 13 Nov 2021 21:40:07 -0500
Message-ID: <CAO6P2QTXwKKgh6PHXxM4cN3YOAEmdbCTD8RMHtR+rgHcUs03Pw@mail.gmail.com>
Subject: creating a vxlan interface with a `dev` param appears to bind to all interfaces
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, all!

Please keep me on CC, I'm not subscribed to this list and would love to
see followups.


I'm not quite sure if this should be reported here, or if there's a better
venue to work though this. I think this falls through enough cracks and is
generally confusing enough to a plain user such as myself that it's maybe
worth flagging as a documentation issue, at minimum.

I'm attempting to set up a localhost VXLAN interface to play with VXLAN
locally. This has seemingly cascaded into a number of curious bugs -- most
of which I don't think this list cares to hear about (namely, vxlan interfaces
can't send to a different IP that they listen to, making it hard to have two
vxlan interfaces on the same host).

Right, enough setup, here's the bug that's driven me to write today:

Given the following interfaces that exist (my "A" and "Z" end)

  $ ip link add vevx0a type veth peer name vevx0z
  $ ip addr add 169.254.0.2/31 dev vevx0a
  $ ip addr add 169.254.0.3/31 dev vevx0z

And the following VXLAN interface:

$ ip link add vxlan0 type vxlan id 42 \
    local 169.254.0.2 dev vevx0a dstport 4789
$ ip addr add 10.10.10.1/24 dev vxlan0

I would expect the following:

  - My vxlan interface is only listening on the provided device (vevx0a). The
    documentation is pretty clear when it says "specifies the physical device
    to use for tunnel endpoint communication.".

  - A moderate confidence that my vxlan is listening on the provided
    IP (169.254.0.2) -- although that could go either way since it's
    documented as "specifies the source IP address to use in outgoing packets."


However, it appears to listen on *ALL* interfaces, and forward any packet
it recieves. To prove this to myself, I started a Docker container, and
sent VXLAN packets from a container to the host bridge IP -- which is
*not* bound to vxlan0, vevx0a nor vevx0z. This seems like it would allow for
sending packets to another VLAN -- which seems maybe not ideal.

Given a standard install of Docker (using the docker0 default network
interface[1] as is our custom), and a small go program to stuff some packets
that look enough like valid packets to relay them[2], my vxlan appears to
process and forward them(!)

$ docker run -it --rm -v $(pwd):/mnt debian:unstable /mnt/spam 172.17.0.1:4789
$

When I watch the vxlan0 interface for ethernet packets, I get the following:

$ sudo tcpdump -e -i vxlan0
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on vxlan0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
21:30:15.746754 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746773 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746787 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746801 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746815 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746827 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746870 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746885 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746899 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
21:30:15.746913 de:ad:be:ef:00:01 (oui Unknown) > Broadcast, ethertype
IPv4 (0x0800), length 64: truncated-ip - 27706 bytes missing! 33.0.0.0
> localhost: ip-proto-114
10 packets captured
10 packets received by filter
0 packets dropped by kernel


I guess my questions are:

  1) Is this a bug in vxlan that is worth reporting beyond what I've sent here?
  2) Am I using the vxlan interface wrong?
  3) Is this a systemic problem that may impact other uses / deployments?
  4) Are there places where doc changes would be welcome?

[1]: ip addr show docker0:
  4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
     UP group default
      link/ether 02:42:5e:ef:b7:a1 brd ff:ff:ff:ff:ff:ff
      inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
         valid_lft forever preferred_lft forever

[2]:
  ```spam.go
  // Apologies for formatting, I left it a mess to reduce screen size
  package main

  import (
      "net"
      "os"
      "github.com/mdlayher/ethernet"
      "github.com/mdlayher/vxlan"
  )
  func main() {
      conn, err := net.Dial("udp", os.Args[1])
      if err != nil { panic(err) }
      for i := 0; i < 10; i++ {
          vxf := &vxlan.Frame{
              VNI: vxlan.VNI(42),
              Ethernet: &ethernet.Frame{
                  Source:      net.HardwareAddr{0xDE, 0xAD, 0xBE,
0xEF, 0x00, 0x01},
                  Destination: net.HardwareAddr{0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF},
                  EtherType:   ethernet.EtherTypeIPv4,
                  Payload:     []byte("Hello, World!"),
              },
          }
          frb, err := vxf.MarshalBinary()
          if err != nil { panic(err) }
          _, err = conn.Write(frb)
          if err != nil { panic(err) }
      }
  }
  ```
