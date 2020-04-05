Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576C119EB31
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDEMXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 08:23:48 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:33483 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgDEMXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 08:23:48 -0400
Received: by mail-io1-f48.google.com with SMTP id o127so12728795iof.0
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 05:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=abnjMmnMDiwMphQbTz/4wuuchLQegCNhe2ZkXpG2llA=;
        b=HsXqIpZKV+t0Dsy/yEPTWe13OC4gC2q3zkwC1rpmUBSODEgzGacyuQrBCibJZkxUi9
         vNwO17GA+v+0531PBq9pUqIHJWP0uju5nTuJ3cCOZa1Cj/ZgX8TK/cOKnrFXS6JQH8T5
         kSVIK1JQp5pxx9ocmHT9UZwjwo/Vnw/nMKglxMl28ks/fbyvY5MHQvhHF1kGP1i+uQ/7
         5pe8KH7e3L+tZSNGKLQcp/9Dr9RryGmhXYFnfiV9vh6GXEvB3z9Kw7DWasr+8CRpc7lJ
         s12UNezF/x8iAoyZ3wRIKHZ4a6TUdMW5j5S8QaBF5+Du6pXwcw6LJIzRYEmirOiEjPl/
         wIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=abnjMmnMDiwMphQbTz/4wuuchLQegCNhe2ZkXpG2llA=;
        b=t2AGC+0pVEOXDefJ1dPKsvp4/5l4TLZwEZpCWeB+lF+IvLnkgn1O59rbcg+UTjt09r
         mjlLeE2oSgpGngfR+tcYnVwQV6pSFlr5LL2CGG5IFqkAr5f7HBc/7GirJ2AGBgyskRXz
         f0yY6cOFryh2dD7xHOLt02MZv0RfXVhRtsOiRE3b4ucRI0/2HcqBsGlNATU+rKfru58L
         zJuCtNEZQ+9sRjtXD4JjKhUqBR+A80QroWwkH+UqMKW7em9xrCtePI/hUdXQGs7eVkqP
         O55u2kYnQ6lPQ4ugHlk+mJdoZzjIJYxt5kq5yA+L3EqBCA4C/afjaGvz1EV63QKe42Y3
         UVWA==
X-Gm-Message-State: AGi0Pub3A5HJRrNc/ERuoeixXvWuHs2dHti+OJ/X9gDBsBwqTi84T5AZ
        sGyvsUUjKBplTOnzpImQgGswBd8NpafoQdIIybrUB/RT71Zrmg==
X-Google-Smtp-Source: APiQypKUNIvLHKpfIhjuw6bVFBgxaVdnwdSdGF2V4S0tuD4gOOCER5Wly6PjGn9CS9kaOQ+Gwt46tPvTol8YIXOnhDM=
X-Received: by 2002:a02:70c7:: with SMTP id f190mr9321315jac.60.1586089427013;
 Sun, 05 Apr 2020 05:23:47 -0700 (PDT)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 5 Apr 2020 20:23:36 +0800
Message-ID: <CALW65jY8vvent1KmAnv2a9BTbmW5C8CHK0DpRRs73yk3L1RXLQ@mail.gmail.com>
Subject: DSA breaks clients' roaming between switch port and host interfaces
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I found a bug of DSA that breaks WiFi clients roaming.

I set up 2 WiFi routers as AP, both of them run kernel 5.4.30 and use DSA.

        +-------------------------+
+-----------------------------+
        |                         |                            |
                      |
        |                         |                            |
                      |
        |       AP1               |                            |
AP2                   |
        |                     LAN2+--------------------------->|LAN1
                      |
        |       10.0.0.1/24       |                            |
10.0.0.2/24           |
        |                         |                            |
                      |
        |       MV88E6XXX DSA     |                            |
MT7530 DSA            |
        |                         |                            |
                      |
        |                         |                            |
                      |
        |                         |                            |
                      |
        +-------------------------+
+-----------------------------+
                     ^                                              ^
                     |                                              |
                     |                      Roams                   |
                     |                     -------------------------+
                     |
                     +------------    +-------------------+
                                      |     Wi-Fi         |
                                      |     Client        |
                                      |                   |
                                      |     10.0.0.3/24   |
                                      |                   |
                                      |                   |
                                      +-------------------+

When the client roams from AP1 to AP2, it cannot ping AP1 anymore for
a few minutes, and vice versa.

With bridge fdb I found out the part that caused the problem.
When the client is connected to AP1, bridge fdb on AP2 shows:

<client's mac> dev lan1 master br-lan
<client's mac> dev lan1 vlan 1 self

It means AP2 should talk to the client via lan1, which is correct.

After the client roams to AP2, the problem comes:

<client's mac>  dev wlan0 master br-lan
<client's mac>  dev lan1 vlan 1 self

From iproute2 man page: "self" means the address is associated with
the port drivers fdb. Usually hardware.

The lan1 is still there, which means the kernel has updated the
forwarding table in br-lan, but forgot to delete the one in the switch
hardware.

What happens when the client now tries to talk to AP1, such as ping
10.0.0.1? I debugged with tcpdump:

1. The client sends ARP request: who-has 10.0.0.1?
2. The software part of the bridge of AP2 receives the ARP request,
updates fdb, and sends it to the CPU port
3. The switch receives the client's ARP request from the CPU port, and
floods it out of the LAN1 port. Although the source MAC address of the
request is the client's, _auto learning of the CPU port is disabled in
DSA_, so the switch does not update the MAC table.
4. AP1 receives the ARP request, then responds: 10.0.0.1 is-at <AP1's MAC>.
5. AP2's switch receives the response from LAN1, then looks it up in
the MAC table, the egress port is the same as the ingress port (LAN1).
To avoid loop, the ARP response is discarded.

If I manually delete the leftover fdb entry in the hardware via
"bridge fdb del <client's MAC> dev lan1 vlan 1", the client can talk
to AP1 immediately.
And vice versa, the mv88e6xxx has the same bug, so I think it's with
the general DSA part.

Does anyone know how to fix it?

Thanks.
Qingfang
