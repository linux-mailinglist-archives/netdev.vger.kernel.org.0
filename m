Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD210A87
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfEAQDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 12:03:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfEAQDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 12:03:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41Fs6wf014367;
        Wed, 1 May 2019 16:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=SvevWYQqArFCVAQWHS3XKeDwFNiH/7TuOMJhCZOPJws=;
 b=w1V5ovnn2XVs2j/LJ4mSuss0gAzYJv3+Bdg9J9+V3BRDTzqUFrGJTSIDc5bCEMfJAgfx
 B6yacGXqhWcasjV+cyHqPkkpaPtNhXI/wATXIWBVrghtYOsku1nHvk5tC4glWye4KxK2
 JQzv/FPFI9lai4q1ddmmojjUZwtRVdmM5xAbqtFVkoIcYkE6VjqO0RmJ/eqBAn/VOTFE
 W0O/SyzgTJab0Dr8QgFBFuQXJtfHLzdCR5mPeeTsFi6Wu0wx/NXd4nsMfB/5ggM36/jY
 KHsAq+y5Fp9iZsVgG/ETu/dci1bM9AZ7KHmCLwMZpSe1M/WtpUxptdfvFcdPDe1yu2RX 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s6xhybh6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 16:03:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41G2ov2170939;
        Wed, 1 May 2019 16:03:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2s6xhgb4hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 16:03:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x41G3Kqa030952;
        Wed, 1 May 2019 16:03:20 GMT
Received: from dhcp-10-175-212-223.vpn.oracle.com (/10.175.212.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 09:03:19 -0700
Date:   Wed, 1 May 2019 17:03:08 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-212-223.vpn.oracle.com
To:     netdev@vger.kernel.org
cc:     daniel@iogearbox.net, dsahern@gmail.com
Subject: MPLS encapsulation and arp table overflow
Message-ID: <alpine.LRH.2.20.1905011655100.1124@dhcp-10-175-212-223.vpn.oracle.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010101
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9243 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm seeing the following repeated error

[  130.821362] neighbour: arp_cache: neighbor table overflow!

when using MPLSoverGRE or MPLSoverUDP tunnels on bits synced
with bpf-next as of this morning. The test script below reliably
reproduces the problem, while working fine on a 4.14 (I haven't
bisected yet). It can be run with no arguments, or specifying
gre or udp for the specific encap type.

It seems that every MPLS-encapsulated outbound packet is attempting
to add  a neighbor entry, and as a result we hit the 
net.ipv4.neigh.default.gc_thresh3 limit quickly.

When this failure occurs, the arp table doesn't show any of
these additional entries. Existing arp table entries are
disappearing too, so perhaps they are being recycled when the
table becomes full?

It's entirely possible that the way I'm setting up the MPLS
tunnels is incorrect, though the fact that the test works fine on
4.14 might suggest otherwise.

An extract from the ftrace function graph when the error is
hit is below:

            ping-17611 [039]  6197.507706: funcgraph_entry:                   
|                          lwtunnel_xmit() {
            ping-17611 [039]  6197.507706: funcgraph_entry:                   
|                            mpls_xmit() {
            ping-17611 [039]  6197.507706: funcgraph_entry:                   
|                              sock_wfree() {
            ping-17611 [039]  6197.507706: funcgraph_entry:        0.137 
us   |                                sock_def_write_space();
            ping-17611 [039]  6197.507707: funcgraph_exit:         0.429 
us   |                              }
            ping-17611 [039]  6197.507707: funcgraph_entry:        0.126 
us   |                              mpls_output_possible();
            ping-17611 [039]  6197.507707: funcgraph_entry:        0.109 
us   |                              mpls_dev_mtu();
            ping-17611 [039]  6197.507708: funcgraph_entry:        0.197 
us   |                              mpls_pkt_too_big();
            ping-17611 [039]  6197.507708: funcgraph_entry:        0.118 
us   |                              skb_push();
            ping-17611 [039]  6197.507708: funcgraph_entry:        0.165 
us   |                              mpls_stats_inc_outucastpkts();
            ping-17611 [039]  6197.507708: funcgraph_entry:                   
|                              neigh_xmit() {
            ping-17611 [039]  6197.507709: funcgraph_entry:        0.115 
us   |                                arp_hash();
            ping-17611 [039]  6197.507709: funcgraph_entry:                   
|                                ___neigh_create() {
            ping-17611 [039]  6197.507709: funcgraph_entry:        0.123 
us   |                                  _raw_write_lock_bh();
            ping-17611 [039]  6197.507709: funcgraph_entry:                   
|                                  _raw_write_unlock_bh() {
            ping-17611 [039]  6197.507709: funcgraph_entry:        0.128 
us   |                                    __local_bh_enable_ip();
            ping-17611 [039]  6197.507710: funcgraph_exit:         0.335 
us   |                                  }
            ping-17611 [039]  6197.507710: funcgraph_entry:                   
|                                  net_ratelimit() {


If there's any additional data I can collect to help narrow
this down, do let me know (I'll try bisecting in the meantime).

Thanks!

Alan

#!/usr/bin/bash

# Test MPLSoverUDP and MPLSoverGRE tunnels.

readonly ns_prefix="ns-$$"
readonly ns1="${ns_prefix}1"
readonly ns2="${ns_prefix}2"

readonly ns1_v4="192.168.1.1"
readonly ns2_v4="192.168.1.2"
readonly tun_prefix="192.168.2"
readonly ns1_tunv4="${tun_prefix}.1"
readonly ns2_tunv4="${tun_prefix}.2"
readonly tun_route="${tun_prefix}.0/24"
readonly label="1000"

cleanup()
{
	ip netns delete $ns1
	ip netns delete $ns2
}

tun_setup()
{
	ns=$1
	encap=$2
	veth=$3
	local_ip=$4
	local_tun=$5
	remote_ip=$6
	remote_tun=$7

	case $encap in
	"udp")
		ip netns exec $ns modprobe fou
		ip netns exec $ns ip fou add port 6635 ipproto 137
		ip netns exec $ns ip link add name tun0 type ipip mode any \
			remote $remote_ip local $local_ip \
			encap fou encap-sport auto encap-dport 6635
		;;
	"gre")
		ip netns exec $ns ip link add tun0 type gre \
			remote $remote_ip local $local_ip	
		;;
	esac

	ip netns exec $ns ip link set lo up
	ip netns exec $ns modprobe mpls_iptunnel
	ip netns exec $ns modprobe mpls_gso
	ip netns exec $ns ip link set tun0 up arp on
	ip netns exec $ns sysctl -qw net.mpls.platform_labels=65536
	ip netns exec $ns ip -f mpls route replace $label dev lo
	ip netns exec $ns sysctl -qw net.ipv4.conf.lo.rp_filter=0
	ip netns exec $ns sysctl -qw net.ipv4.conf.all.rp_filter=0
	ip netns exec $ns sysctl -qw net.mpls.conf.tun0.input=1
	ip netns exec $ns sysctl -qw net.ipv4.conf.tun0.rp_filter=0
	ip netns exec $ns sysctl -qw net.ipv4.conf.${veth}.rp_filter=0
	ip netns exec $ns ip addr add ${local_tun}/24 dev tun0
	ip netns exec $ns ip route change \
		$tun_route encap mpls $label via inet $remote_tun dev tun0
}

setup()
{
	encap=$1
	ip netns add $ns1
	ip netns add $ns2

	ip link add dev veth1 netns $ns1 type veth peer name veth2 netns $ns2

	ip -netns $ns1 link set veth1 up
	ip -netns $ns2 link set veth2 up

	ip -netns $ns1 -4 addr add ${ns1_v4}/24 dev veth1
	ip -netns $ns2 -4 addr add ${ns2_v4}/24 dev veth2

	tun_setup $ns1 $encap veth1 $ns1_v4 $ns1_tunv4 $ns2_v4 $ns2_tunv4
	tun_setup $ns2 $encap veth2 $ns2_v4 $ns2_tunv4 $ns1_v4 $ns1_tunv4
}

set -o errexit

case "$#" in
0)
	encap_types="gre udp"
	;;
1)
	case $1 in
	"gre"|"udp")
		encap_types=$1
		;;
	*)
		echo "unsupported encap type $1"
		exit 1
		;;
	esac
	;;
*)
	echo "Usage: $0"
	echo "   or: $0 <gre|udp>"
	exit 1
	;;
esac


# This is the garbage collection threshold which triggers warnings.
thresh=$(sysctl -qn net.ipv4.neigh.default.gc_thresh3)
thresh=$(expr $thresh + 100)

for encap in $encap_types ; do
	echo "Testing MPLS-over-${encap} tunnel..."
	trap cleanup EXIT
	setup $encap

	echo "Verifying basic connectivity between ${ns1}, ${ns2}"
	ip netns exec $ns1 ping -q -c 1 $ns2_v4
	ip netns exec $ns2 ping -q -c 1 $ns1_v4
	echo "Testing tunnel encap/decap"
	timeout 60 ip netns exec $ns1 ping -q -c $thresh -i 0.01 $ns2_tunv4
	trap - EXIT
	cleanup
	echo "MPLS-over-${encap} tunnel OK"
done

