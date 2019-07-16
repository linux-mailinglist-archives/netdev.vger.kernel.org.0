Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8546A9E9
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfGPN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 09:56:49 -0400
Received: from E.TopQuark.net ([168.235.66.66]:59898 "EHLO E.TopQuark.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfGPN4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 09:56:49 -0400
Received: from Mail1.TopQuark.net (pool-108-28-144-167.washdc.fios.verizon.net [108.28.144.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "Mail1.TopQuark.net", Issuer "TopQuark Mail Relay CA" (verified OK))
        by Mail2.TopQuark.net (Postfix) with ESMTPS id E7A383040002;
        Tue, 16 Jul 2019 09:56:46 -0400 (EDT)
Received: from Mail1.TopQuark.net (unknown [127.0.0.1])
        by Mail1.TopQuark.net (Postfix) with ESMTP id 658C427EE061;
        Tue, 16 Jul 2019 09:56:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=PaulSD.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=95npihLf9Hb2h9IkeA1/ZR7d5m0=; b=nrMgld2
        3LTj9xMZ4/o5E87IvFkPjliklsZr+LpYw+J2UNNMx/6iTSesSvse23ZGPH0jsGmT
        c6fLOdQC65vrbcvTHq+0u3FBrdXTr1cnXlES/UU6jIK/KTHBTgiWPEzx37o7LWXi
        t/Hg7ZmUZbqoCdm8s524S3O54w+DLNnCxuvw=
Received: by Mail1.TopQuark.net (Postfix, from userid 1000)
        id 44BB027EE172; Tue, 16 Jul 2019 09:56:46 -0400 (EDT)
Date:   Tue, 16 Jul 2019 09:56:46 -0400
From:   Paul Donohue <linux-kernel@PaulSD.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: IPv6 L2TP issues related to 93531c67
Message-ID: <20190716135646.GE2622@TopQuark.net>
References: <20190715161827.GB2622@TopQuark.net>
 <d6db74f5-5add-7500-1b7a-fa62302a455f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <d6db74f5-5add-7500-1b7a-fa62302a455f@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2019 at 12:55:48PM -0600, David Ahern wrote:
> As an FYI, gmail thinks your emails are spam.
Ugh.  Thanks for letting me know.  I'll look into it.

> On 7/15/19 10:18 AM, Paul Donohue wrote:
> > Reverting commit 93531c6743157d7e8c5792f8ed1a57641149d62c (identified by bisection) fixes this issue.
> That commit can not be reverted. It is a foundational piece for a lot of
> other changes. Did you mean the commit before it works and this commit
> fails?
Sorry, yes, I meant the commit before it works, and this one fails.  I did not try reverting this commit on a more recent kernel.

> > It is not obvious to me how commit 93531c6743157d7e8c5792f8ed1a57641149d62c causes this issue, or how it should be fixed.  Could someone take a look and point me in the right direction for further troubleshooting?
> Let's get a complete example that demonstrates the problem, and I can go
> from there. Can you take the attached script and update it so that it
> reflects the problem you are reporting? That script works on latest
> kernel as well as 4.14.133. It uses network namespaces for 2 hosts with
> a router between them.
> 
> Also, check the return of the fib lookups using:
>     perf record -e fib6:* -a
>     <run test, ctrl-c on the record>
>     perf script
> 
> Checkout the fib lookup parameters and result. Do they look correct to
> you for your setup?

Unfortunately, I have a fairly complicated setup, so it took me a while to figure out which pieces were relevant ... But I think I've finally got it.  The missing piece was IPsec.

After establishing an IPsec tunnel to carry the L2TP traffic, the first L2TP packet through the IPsec tunnel permanently breaks the associated L2TP tunnel.  Tearing down the IPsec tunnel does not restore functionality of the L2TP tunnel - I have to tear down and re-create the L2TP tunnel before it will work again.  In my real-world use case, I have two L2TP tunnels running over the same IPsec tunnel, and the first L2TP tunnel to send a packet after IPsec is established gets permanently broken, while the other L2TP tunnel works fine.

I've attached a modified version of the script which demonstrates this issue.

Thank you!
-Paul

--HcAYCG3uE/tztfnV
Content-Type: application/x-sh
Content-Disposition: attachment; filename="l2tp.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A#=0A# L2TPv3 tunnel between 2 hosts=0A#=0A#            host-1=
          |   router   |     host-2=0A#                            |       =
     |=0A#      lo          l2tp      |            |      l2tp           lo=
=0A#  fc00:101::1   fc00:1::1   |            |   fc00:1::2    fc00:101::2=
=0A#                  eth0      |            |     eth0=0A#              20=
01:db8:1::1 |            | 2001:db8:2::1=0A=0Awhich ping6 > /dev/null 2>&1 =
&& ping6=3D$(which ping6) || ping6=3D$(which ping)=0A=0A###################=
#############################################################=0A# create na=
mespaces and interconnects=0A=0Acreate_ns()=0A{=0A	local ns=3D$1=0A	local a=
ddr=3D$2=0A	local addr6=3D$3=0A=0A	[ -z "${addr}" ] && addr=3D"-"=0A	[ -z "=
${addr6}" ] && addr6=3D"-"=0A=0A	ip netns add ${ns}=0A=0A	ip -netns ${ns} l=
ink set lo up=0A	if [ "${addr}" !=3D "-" ]; then=0A		ip -netns ${ns} addr a=
dd dev lo ${addr}=0A	fi=0A	if [ "${addr6}" !=3D "-" ]; then=0A		ip -netns $=
{ns} -6 addr add dev lo ${addr6}=0A	fi=0A=0A	# Eliminate the need for sleep=
 after configuring IPs=0A	# Has no effect on this test case=0A	ip netns exe=
c ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=3D0=0A=0A	ip -netns ${n=
s} ro add unreachable default metric 8192=0A	ip -netns ${ns} -6 ro add unre=
achable default metric 8192=0A=0A	ip netns exec ${ns} sysctl -qw net.ipv4.i=
p_forward=3D1=0A	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr=
_on_down=3D1=0A	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=
=3D1=0A	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=3D1=
=0A}=0A=0A# create veth pair to connect namespaces and apply addresses.=0Ac=
onnect_ns()=0A{=0A	local ns1=3D$1=0A	local ns1_dev=3D$2=0A	local ns1_addr=
=3D$3=0A	local ns1_addr6=3D$4=0A	local ns2=3D$5=0A	local ns2_dev=3D$6=0A	lo=
cal ns2_addr=3D$7=0A	local ns2_addr6=3D$8=0A=0A	ip -netns ${ns1} li add ${n=
s1_dev} type veth peer name tmp=0A	ip -netns ${ns1} li set ${ns1_dev} up=0A=
	ip -netns ${ns1} li set tmp netns ${ns2} name ${ns2_dev}=0A	ip -netns ${ns=
2} li set ${ns2_dev} up=0A=0A	if [ "${ns1_addr}" !=3D "-" ]; then=0A		ip -n=
etns ${ns1} addr add dev ${ns1_dev} ${ns1_addr}=0A		ip -netns ${ns2} addr a=
dd dev ${ns2_dev} ${ns2_addr}=0A	fi=0A=0A	if [ "${ns1_addr6}" !=3D "-" ]; t=
hen=0A		ip -netns ${ns1} addr add dev ${ns1_dev} ${ns1_addr6}=0A		ip -netns=
 ${ns2} addr add dev ${ns2_dev} ${ns2_addr6}=0A	fi=0A}=0A=0A###############=
#################################################################=0A# test =
setup=0Asetup()=0A{=0A	create_ns host-1=0A	create_ns host-2=0A	create_ns ro=
uter=0A=0A	connect_ns host-1 eth0 10.1.1.1/24 2001:db8:1::1/64 \=0A	       =
    router eth1 10.1.1.2/24 2001:db8:1::2/64=0A=0A	connect_ns host-2 eth0 1=
0.1.2.1/24 2001:db8:2::1/64 \=0A	           router eth2 10.1.2.2/24 2001:db=
8:2::2/64=0A=0A	ip -netns host-1 addr add dev lo fc00:101::1/128=0A	ip -net=
ns host-2 addr add dev lo fc00:101::2/128=0A	#sleep 5=0A=0A	ip -netns host-=
1 -6 ro add 2001:db8:2::/64 via 2001:db8:1::2=0A	ip -netns host-2 -6 ro add=
 2001:db8:1::/64 via 2001:db8:2::2=0A=0A	#=0A	# configure l2tpv3 tunnel on =
host-1=0A	#=0A	ip -netns host-1 l2tp add tunnel tunnel_id 1234 peer_tunnel_=
id 1235 \=0A			 encap ip local 2001:db8:1::1 remote 2001:db8:2::1=0A	ip -ne=
tns host-1 l2tp add session name l2tp1 tunnel_id 1234 \=0A			 session_id 12=
34 peer_session_id 1235=0A	ip -netns host-1 link set dev l2tp1 up=0A	ip -ne=
tns host-1 addr add dev l2tp1 fc00:1::1 peer fc00:1::2=0A=0A	#=0A	# configu=
re l2tpv3 tunnel on host-2=0A	#=0A	ip -netns host-2 l2tp add tunnel tunnel_=
id 1235 peer_tunnel_id 1234 \=0A			 encap ip local 2001:db8:2::1 remote 200=
1:db8:1::1=0A	ip -netns host-2 l2tp add session name l2tp2 tunnel_id 1235 \=
=0A			 session_id 1235 peer_session_id 1234=0A	ip -netns host-2 link set de=
v l2tp2 up=0A	ip -netns host-2 addr add dev l2tp2 fc00:1::2 peer fc00:1::1=
=0A=0A	#sleep 5=0A=0A	#=0A	# add routes to loopback addresses=0A	#=0A	ip -n=
etns host-1 -6 ro add fc00:101::2/128 via fc00:1::2=0A	ip -netns host-2 -6 =
ro add fc00:101::1/128 via fc00:1::1=0A}=0A=0A#############################=
###################################################=0A# main=0A=0Asetup=0A=
=0A# L2TP tunnel works fine here=0Aip netns exec host-1 ${ping6} -c1 -w1 fc=
00:1::2 >/dev/null || echo "L2TP tunnel not working"=0Aip netns exec host-1=
 ${ping6} -c1 -w1 fc00:101::2 >/dev/null || echo "L2TP tunnel not working"=
=0A=0A# Configure IPsec=0Aip netns exec host-1 ip xfrm policy add src 2001:=
db8:1::1/128 dst 2001:db8:2::1/128 dir out tmpl proto esp mode transport=0A=
=0A# Expected to fail in this test case because the remote side doesn't hav=
e ipsec=0A# configured, but actually fails to send any packets from 2001:db=
8:1::1=0A# regardless of whether the remote side is configured=0Aip netns e=
xec host-1 ${ping6} -c1 -w1 fc00:1::2 >/dev/null && echo "L2TP w/ IPsec une=
xpectedly working???"=0A=0A# Deconfigure IPsec=0Aip netns exec host-1 ip xf=
rm policy del src 2001:db8:1::1/128 dst 2001:db8:2::1/128 dir out=0A=0A# L2=
TP tunnel should work since IPsec has been deconfigured,=0A# but the l2tp1 =
device in host-1 is permanently broken=0Aip netns exec host-1 ${ping6} -c1 =
-w1 fc00:1::2=0A=0Aip netns del host-1=0Aip netns del host-2=0Aip netns del=
 router=0A
--HcAYCG3uE/tztfnV--
