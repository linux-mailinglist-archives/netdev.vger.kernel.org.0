Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314BF1A3B77
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgDIUoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:44:02 -0400
Received: from nautica.notk.org ([91.121.71.147]:55462 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgDIUoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 16:44:02 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2020 16:44:00 EDT
Received: by nautica.notk.org (Postfix, from userid 1001)
        id B1889C009; Thu,  9 Apr 2020 22:38:58 +0200 (CEST)
Date:   Thu, 9 Apr 2020 22:38:43 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: ipv6 rpfilter and.. fw mark? problems with wireguard
Message-ID: <20200409203843.GA6881@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Some context first, I'm trying to use `wg-quick` to setup default routes
through a wireguard interface on a client.
It's easy enough to try but hopefully I'll give enough infos to get
by... descriptions on what wg-quick does at the end of this mail.


Problem:
--------

My problem is that wireguard sets up some nice routing table and adds ip
rules to use it so encrypted packets go through the underlying interface,
but when it comes back it gets caught in firewalld's default
IPv6_rpfilter rules.

I've turned firewalld off, and can reproduce with either of the
following single rules (nft or iptables version):

table inet test {
    chain raw_PREROUTING {
        type filter hook prerouting priority raw; policy accept;
        meta nfproto ipv6 fib saddr . iif oif missing log prefix "rpfilter_DROP: " drop
    }
}

or

ip6tables -t raw -A PREROUTING -m rpfilter --invert -j LOG --log-prefix "rpfilter_DROP: "
ip6tables -t raw -A PREROUTING -m rpfilter --invert -j DROP


In either case I get a log like the following:
[146484.816657] rpfilter_DROP: IN=wlp0s20f3 OUT= MAC=62:2f:57:8e:96:18:00:24:d4:ba:bf:96:86:dd SRC=<serveripv6> DST=<localclientipv6> LEN=140 TC=0 HOPLIMIT=56 FLOWLBL=0 PROTO=UDP SPT=51820 DPT=51820 LEN=100
which is the response from the server, so an initial packet went out
from my client and the response got blocked by the rp filter.

As a workaround, adding a /128 route like the following makes the reply
get accepted (because wireguard adds `suppress_prefixlength 0` on the
main table, default route is ignored but not a more specific one?):
ip -6 r add <serveripv6>/128 via <localgw> dev wlp0s20f3

Or, obviously whitelisting 'udp dport 51820' before the rpfilter drop
rule in raw prerouting chain works as well.


For reference, the same setup with an ipv4 server works just fine, with
the default of rp_filter=2 on all interfaces or even setting it to 1
seem ok.


Wireguard setup:
----------------

The script is nice enough to say what it does, which is nice:
# cat wg0.conf
[Interface]
ListenPort = 51820
PrivateKey = privatekey
Address = fe80::2/64
PostUp = ping -c 1 fe80::1%wg0

[Peer]
PublicKey = serverpublickey
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = serveripv6:51820
# wg-quick up wg0
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip -6 address add fe80::2/64 dev wg0
[#] ip link set mtu 1420 up dev wg0
[#] wg set wg0 fwmark 51820
[#] ip -6 route add ::/0 dev wg0 table 51820
[#] ip -6 rule add not fwmark 51820 table 51820
[#] ip -6 rule add table main suppress_prefixlength 0
[#] nft -f /dev/fd/63
[#] ip -4 route add 0.0.0.0/0 dev wg0 table 51820
[#] ip -4 rule add not fwmark 51820 table 51820
[#] ip -4 rule add table main suppress_prefixlength 0
[#] sysctl -q net.ipv4.conf.all.src_valid_mark=1
[#] nft -f /dev/fd/63
[#] ping -c 1 fe80::1%wg0
PING fe80::%wg0(fe80::%wg0) 56 data bytes

--- fe80::%wg0 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

[#] nft -f /dev/fd/63
[#] ip -4 rule delete table 51820
[#] ip -4 rule delete table main suppress_prefixlength 0
[#] ip -6 rule delete table 51820
[#] ip -6 rule delete table main suppress_prefixlength 0
[#] ip link delete dev wg0
(the last part here after ping is teardown, if I use an ipv4
server the ping works and things stop here, and `wg-quick down wg0` will
run the last few commands on teardown)

For completeness, the two nft commands there contain the following
tables:
table ip6 wg-quick-wg0 {
    chain preraw {
        type filter hook prerouting priority raw; policy accept;
        iifname != "wg0" ip6 daddr fe80::2 fib saddr type != local drop
    }

    chain premangle {
        type filter hook prerouting priority mangle; policy accept;
        meta l4proto udp meta mark set ct mark
    }

    chain postmangle {
        type filter hook postrouting priority mangle; policy accept;
        meta l4proto udp meta mark 0x0000ca6c ct mark set meta mark
    }
}

table ip wg-quick-wg0 {
    chain preraw {
        type filter hook prerouting priority raw; policy accept;
    }

    chain premangle {
        type filter hook prerouting priority mangle; policy accept;
        meta l4proto udp meta mark set ct mark
    }

    chain postmangle {
        type filter hook postrouting priority mangle; policy accept;
        meta l4proto udp meta mark 0x0000ca6c ct mark set meta mark
    }
}


My main routing table before setting up wg is trivial (e.g. local
interface ip address subnet + one single default route)

Rambling:
---------

So, why does it work in v4 but not v6?
If `suppress_prefixlength 0` really does what I think it does, then it
should be the same for v4 and also v4 default route so v4 rp_filter
should refuse incoming packets ?
... So I tried running the setup manually without this rule without a
difference.

erig on #firewalld@freenode suggested adjusting the fib match to:
  meta nfproto ipv6 fib saddr . iif . mark  oif missing log prefix "rpfilter_DROP: " drop
that doesn't seem to make a difference.



Anyway, happy to test anything that comes to mind, input welcome.

Thanks !
-- 
Dominique Martinet | Asmadeus
