Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899B23DCCD5
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 19:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhHARMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 13:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhHARMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 13:12:14 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27254C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 10:12:06 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so15269279ota.11
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 10:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=O7M3z7PVITYLlroRbCvbX7AiAY8iMk76ql3cs/76qQY=;
        b=FoRgAHPlY6RO2zH4Crgavxa3qCehzS2CwVC3irVC1cIzcpiAk5/d4UVFkcV0Dtp0sK
         phhO7HrrQP8D4uzN5+mvmNMW2jrqz5xrD7btkGPErKQ+S9ISIqCFsthZI/Rdp0IpHDZV
         e1Nr4HA3WTPI44bIQdy2jez8VUe9A3Av88/EfMGvkcJ/nLnfVpYRiUYdCPQKyWfSm2S3
         ygUWjjXjBwC29VHnLvYXOAAA3S3cx6wdXqQjaoSHH2TVD6355NdX7QtgnG87g1sIoups
         e/7VMa8TZFrNWEOklak25ZNS2fgCBn7inod+hw90GG8kpGY64mg962FxivgtSpgy82xp
         H2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=O7M3z7PVITYLlroRbCvbX7AiAY8iMk76ql3cs/76qQY=;
        b=jOqeuZsvTraPovQCLeyX64jUYC6sNb2kxbdJCYij1potKGQbdSYV2DxidURLtPCF+W
         RkwUdlRxNd5P5exakrg9m3mj38vr5mdNSPdymrXBN7zW2JNhhSiLUZM7KIWZWIwbVW8z
         YrY/0dOAmpcYizpgX1mDJE/DUXOqxmEFZ4Sq3JKp9WUrAn8sQLlT3ZnzGIwItCuh3eh2
         TnXrrFQpyWqPcDM8N+QqXqNngytjEnWCADKs8kA/Dn4kEyOUXLTvVPuVby0y0x17HQnB
         HAU2+kts9EVIH7l3LVZNJ15Nz1AqglfRWUr0vf7XNbCi4pLE4Tqkuy4UbUN8ONVHN/GF
         stfA==
X-Gm-Message-State: AOAM5317Q1faA8QjEDVwQxgsXziHcJOfW/sTr/Zg70yni9KyaZh+9hU4
        nL+LE0xB46jVvYHimAHDOz+eOVV0404=
X-Google-Smtp-Source: ABdhPJzmHJ02fFen46VN/MEgDGottya+oaaUjScgp1XDd9q4us4lCjQ9Y6Yw0VB9o0T/jULUHLe6Gw==
X-Received: by 2002:a9d:2ce:: with SMTP id 72mr7179677otl.116.1627837925060;
        Sun, 01 Aug 2021 10:12:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id i20sm1291565ook.12.2021.08.01.10.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 10:12:03 -0700 (PDT)
Subject: Re: [PATCH net] net: ipv4: fix path MTU for multi path routes
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210731011729.4357-1-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dc6aafb6-cd1f-2006-6f45-55a4f224e319@gmail.com>
Date:   Sun, 1 Aug 2021 11:12:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210731011729.4357-1-vfedorenko@novek.ru>
Content-Type: multipart/mixed;
 boundary="------------245FDDE63D34C91357A79561"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------245FDDE63D34C91357A79561
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 7/30/21 7:17 PM, Vadim Fedorenko wrote:
> Bug 213729 showed that MTU check could be used against route that
> will not be used in actual transmit if source ip is not specified.
> But path MTU update is always done on route with defined source ip.
> Fix route selection by updating flow info in case when source ip
> is not explicitly defined in raw and udp sockets.
> 
>

There is more to it than just setting the source address and doing a
second lookup.

Attached is a test script I started last summer which shows the problem
at hand and is setup to cover various permutations of routing (legacy
routing, nexthop objects, and vrf), network protocols (v4 and v6) and
should cover tcp, udp and icmp:

# PMTU handling with multipath routing.
#
#          .-- sw1 --.
#   h1 ----|-- sw2 --|---- h2 -------- h3
#          |   ...   |       reduced mtu
#          .-- swN --.
#
# h2-h3 segment has reduced mtu.
# Exceptions created in h1 for h3.

N=8 (8-way multipath) seems to always demonstrate it; N=2 is a 50-50 chance.

Snippet from a run this morning:

# ip netns exec h1 ping -s 1450 10.100.2.254
PING 10.100.2.254 (10.100.2.254) 1450(1478) bytes of data.
From 10.2.22.254 icmp_seq=1 Frag needed and DF set (mtu = 1420)
From 10.2.22.254 icmp_seq=2 Frag needed and DF set (mtu = 1420)
From 10.2.22.254 icmp_seq=3 Frag needed and DF set (mtu = 1420)
From 10.2.22.254 icmp_seq=4 Frag needed and DF set (mtu = 1420)

ok, an MTU message makes it back to h1, but that it continues shows the
exception is not created on the right interface:

# ip -netns h1 ro ls cache
10.100.2.254 via 10.1.15.5 dev eth5
    cache expires 580sec mtu 1420

But the selected path is:
# ip -netns h1 ro get 10.100.2.254
10.100.2.254 via 10.1.12.2 dev eth2 src 10.1.12.254 uid 0
    cache

Adding in the source address does not fix it but it does change the
selected path. .e.g,

# ip -netns h1 ro get 10.100.2.254 from 10.1.16.254
10.100.2.254 from 10.1.16.254 via 10.1.14.4 dev eth4 uid 0
    cache

If 10.1.16.254 is the set source address then egress should be eth6, not
eth4, since that is an address on eth6.

--------------245FDDE63D34C91357A79561
Content-Type: application/x-sh; x-mac-type="0"; x-mac-creator="0";
 name="pmtu-mpath.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pmtu-mpath.sh"

#!/bin/bash
#
# PMTU handling with multipath routing.
#
#          .-- sw1 --.
#   h1 ----|-- sw2 --|---- h2 -------- h3
#          |   ...   |       reduced mtu
#          .-- swN --.
#
# h2-h3 segment has reduced mtu.
# Exceptions created in h1 for h3.

# number of paths - 8 exaggerates the problem
NUMPATHS=8

PAUSE_ON_FAIL=no

VRF=red
VRF_TABLE=1111
H1_IP=10.100.1.1
H1_IP6=2001:db8:100:1::64
H3_IP=10.100.2.254
H3_IP6=2001:db8:100:2::64
H3_MTU=1420

which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)

################################################################################
#
log_test()
{
	local rc=$1
	local expected=$2
	local msg="$3"

	if [ ${rc} -eq ${expected} ]; then
		printf "TEST: %-60s  [ OK ]\n" "${msg}"
		nsuccess=$((nsuccess+1))
	else
		ret=1
		nfail=$((nfail+1))
		printf "TEST: %-60s  [FAIL]\n" "${msg}"
		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
			echo
			echo "hit enter to continue, 'q' to quit"
			read a
			[ "$a" = "q" ] && exit 1
		fi
	fi
read ans
}

log_debug()
{
	if [ "$VERBOSE" = "1" ]; then
		echo "$*"
	fi
}

run_cmd()
{
	local cmd="$*"
	local out
	local rc

	if [ "$VERBOSE" = "1" ]; then
		printf "    COMMAND: $cmd\n"
	fi

	out=$(eval $cmd 2>&1)
	rc=$?
	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
		echo "    $out"
	fi

	[ "$VERBOSE" = "1" ] && echo

	return $rc
}

check_exception_v4()
{
	local mtu="$1"
	local ret=0
	local j

	if [ "$VERBOSE" = "1" ]; then
		echo "COMMAND: ip -netns h1 ro get ${VRF_ARG} ${H3_IP} oif eth{j}"
	fi

	for j in $(seq 1 $NUMPATHS)
	do
		ip -netns h1 ro get ${VRF_ARG} ${H3_IP} oif eth${j} |\
		grep -q "cache expires [0-9]*sec mtu ${mtu}"
		if [ $? -ne 0 ]; then
			log_debug "ERROR: mtu exception not created for path ${j}"
			ret=1
		fi
	done

	return $ret
}

check_exception_v6()
{
	local mtu="$1"
	local ret=0
	local j

	if [ "$VERBOSE" = "1" ]; then
		echo "COMMAND: ip -netns h1 -6 ro get ${VRF_ARG} ${H3_IP6} oif eth{j}"
	fi

	for j in $(seq 1 $NUMPATHS)
	do
		ip -netns h1 -6 ro get ${VRF_ARG} ${H3_IP6} oif eth${j} |\
		grep -q "${mtu}"
		if [ $? -ne 0 ]; then
			log_debug "ERROR: mtu exception not created for path ${j}"
			ret=1
		fi
	done

	return $ret
}

do_test()
{
	local desc="$1"
	local ret

	# check connectivity
	run_cmd ip netns exec h1 ${PING_PFX} ping -c1 -w1 -I ${H1_IP} ${H3_IP}
	ret=$?
	if [ $ret -eq 0 ]; then
		run_cmd ip netns exec h1 ${PING_PFX} ping -s 1450 -c5 -w5 -Mdo -I ${H1_IP} ${H3_IP}
		check_exception_v4 ${H3_MTU}
		ret=$?
	else
		log_debug "Basic connectivity broken"
	fi
	log_test $ret 0 "IPv4 multipath ${desc}"

	run_cmd ip netns exec h1 ${PING_PFX} ${ping6} -c1 -w1 -I ${H1_IP6} ${H3_IP6}
	ret=$?
	if [ $ret -eq 0 ]; then
		run_cmd ip netns exec h1 ${PING_PFX} ${ping6} -s 1450 -c5 -w5 -Mdo -I ${H1_IP6} ${H3_IP6}
		check_exception_v6 ${H3_MTU}
		ret=$?
	else
		log_debug "Basic connectivity broken"
	fi
	log_test $ret 0 "IPv6 multipath ${desc}"
}

################################################################################
# create namespaces for hosts and sws

create_vrf()
{
	local ns=$1

	ip -netns ${ns} link add ${VRF} type vrf table ${VRF_TABLE}
	ip -netns ${ns} link set ${VRF} up
	ip -netns ${ns} route add vrf ${VRF} unreachable default metric 8192
	ip -netns ${ns} -6 route add vrf ${VRF} unreachable default metric 8192

	ip -netns ${ns} addr add 127.0.0.1/8 dev ${VRF}
	ip -netns ${ns} -6 addr add ::1 dev ${VRF} nodad

	ip -netns ${ns} ru del pref 0
	ip -netns ${ns} ru add pref 32765 from all lookup local
	ip -netns ${ns} -6 ru del pref 0
	ip -netns ${ns} -6 ru add pref 32765 from all lookup local
}

create_ns()
{
	local ns=$1

	ip netns add ${ns}

	ip -netns ${ns} link set lo up

	ip netns exec ${ns} sysctl -qw net.ipv4.ip_forward=1
	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
}

get_linklocal()
{
	local ns=$1
	local dev=$2
	local addr

	addr=$(ip -netns $ns -6 -br addr show dev ${dev} | \
	awk '{
		for (i = 3; i <= NF; ++i) {
			if ($i ~ /^fe80/)
				print $i
		}
	}'
	)
	addr=${addr/\/*}

	[ -z "$addr" ] && return 1

	echo $addr

	return 0
}

setup_hosts()
{
	local lo_dev="lo"

	[ "${WITH_VRF}" = "yes" ] && lo_dev=${VRF}
	ip -netns h1 addr add dev ${lo_dev} ${H1_IP}/32
	ip -netns h1 addr add dev ${lo_dev} ${H1_IP6}/128

	ip -netns h2 link add eth0 type veth peer name eth0-h3
	ip -netns h2 link set eth0 up
	ip -netns h2 addr add dev eth0 10.100.2.2/24
	ip -netns h2 -6 addr add dev eth0 2001:db8:100:2::2/64 nodad

	ip -netns h2 link set eth0-h3 netns h3
	ip -netns h3 link set eth0-h3 name eth0 up
	ip -netns h3 addr add dev eth0 10.100.2.254/24
	ip -netns h3 -6 addr add dev eth0 2001:db8:100:2::64/64 nodad
}

setup_path()
{
	local i=$1
	local j=$2
	local us=h${i}
	local peer=sw${j}

	ip -netns ${us} link add eth${j} type veth peer name eth${i}-sw
	ip -netns ${us} link set eth${j} up
	ip -netns ${us} addr add dev eth${j} 10.${i}.${i}${j}.254/24
	ip -netns ${us} -6 addr add dev eth${j} 2001:db8:${i}:${i}${j}::64/64 nodad

	ip -netns ${us} link set eth${i}-sw netns ${peer}
	ip -netns ${peer} link set eth${i}-sw name eth${i} up
	ip -netns ${peer} addr add dev eth${i} 10.${i}.${i}${j}.${j}/24
	ip -netns ${peer} -6 addr add dev eth${i} 2001:db8:${i}:${i}${j}::${j}/64 nodad
}

setup()
{
	local ns

	for ns in h1 h2 h3; do
		create_ns ${ns}
	done

	for j in $(seq 1 $NUMPATHS); do
		create_ns sw${j}
	done

	# host 1 setup by sws below
	if [ "${WITH_VRF}" = "yes" ]; then
		create_vrf h1
	fi
	setup_hosts

	# drop the MTU on segment between h2 and h3
	ip -netns h2 li set eth0 mtu ${H3_MTU}
	ip -netns h3 li set eth0 mtu ${H3_MTU}

	# i is the host number; j the sw
	for i in 1 2
	do
		for j in $(seq 1 $NUMPATHS)
		do
			setup_path ${i} ${j}
		done
	done

	sleep 2
}

cleanup()
{
	local j

	for j in 1 2 3; do
		ip netns del h${j} 2>/dev/null
	done
	for j in $(seq 1 $NUMPATHS)
	do
		ip netns del sw${j} 2>/dev/null
	done
}

################################################################################
# Configure routing

setup_routing_legacy()
{
	local j

	NS1_MPATH=""
	NS1_MPATH6=""
	NS2_MPATH=""
	NS2_MPATH6=""

	for j in $(seq 1 $NUMPATHS); do
		if [ "${WITH_VRF}" = "yes" ]; then
			ip -netns h1 li set dev eth${j} vrf ${VRF}
		fi
		ip -netns sw${j} ro add 10.100.1.0/24 via 10.1.1${j}.254
		ip -netns sw${j} -6 ro add 2001:db8:100:1::/64 via 2001:db8:1:1${j}::64
		ip -netns sw${j} ro add 10.100.2.0/24 via 10.2.2${j}.254
		ip -netns sw${j} -6 ro add 2001:db8:100:2::/64 via 2001:db8:2:2${j}::64

		# tell h2 which leg to use for return path
		ip -netns h2 ro add 10.1.1${j}.0/24 via 10.2.2${j}.${j}
		ip -netns h2 -6 ro add 2001:db8:1:1${j}::/64 via 2001:db8:2:2${j}::${j}

		NS1_MPATH="${NS1_MPATH} nexthop via 10.1.1${j}.${j}"
		NS1_MPATH6="${NS1_MPATH6} nexthop via 2001:db8:1:1${j}::${j}"

		NS2_MPATH="${NS2_MPATH} nexthop via 10.2.2${j}.${j}"
		NS2_MPATH6="${NS2_MPATH6} nexthop via 2001:db8:2:2${j}::${j}"
	done

	ip -netns h1 ro add ${VRF_ARG} default ${NS1_MPATH}
	ip -netns h1 -6 ro add ${VRF_ARG} default ${NS1_MPATH6}

	ip -netns h2 ro add default ${NS2_MPATH}
	ip -netns h2 -6 ro add default ${NS2_MPATH6}

	ip -netns h3 ro add default via 10.100.2.2
	ip -netns h3 -6 ro add default via 2001:db8:100:2::2
}

setup_routing_new()
{
	local j

	for j in $(seq 1 $NUMPATHS); do
		if [ "${WITH_VRF}" = "yes" ]; then
			ip -netns h1 li set dev eth${j} vrf ${VRF}
		fi

		ip -netns h1 -4 nexthop add id 41${j} via 10.1.1${j}.${j} dev eth${j}
		ip -netns h1 -6 nexthop add id 61${j} via 2001:db8:1:1${j}::${j} dev eth${j}

		ip -netns h2 -4 nexthop add id 42${j} via 10.2.2${j}.${j} dev eth${j}
		ip -netns h2 -6 nexthop add id 62${j} via 2001:db8:2:2${j}::${j} dev eth${j}

		if [ $j -eq 1 ]; then
			NS1_MPATH="411"
			NS1_MPATH6="611"
			NS2_MPATH="421"
			NS2_MPATH6="621"
		else
			NS1_MPATH="${NS1_MPATH}/41${j}"
			NS1_MPATH6="${NS1_MPATH6}/61${j}"
			NS2_MPATH="${NS2_MPATH}/42${j}"
			NS2_MPATH6="${NS2_MPATH6}/62${j}"
		fi
	done

	ip -netns h1 nexthop add id 499 group ${NS1_MPATH}
	ip -netns h1 nexthop add id 699 group ${NS1_MPATH6}
	ip -netns h1 ro add 10.100.2.0/24 ${VRF_ARG} nhid 499
	ip -netns h1 -6 ro add 2001:db8:100:2::/64 ${VRF_ARG} nhid 699

	ip -netns h2 nexthop add id 499 group ${NS2_MPATH}
	ip -netns h2 nexthop add id 699 group ${NS2_MPATH6}
	ip -netns h2 ro add default nhid 499
	ip -netns h2 -6 ro add default nhid 699

	ip -netns h3 ro add default via 10.100.2.2
	ip -netns h3 -6 ro add default via 2001:db8:100:2::2
}

################################################################################
# usage

usage()
{
        cat <<EOF
usage: ${0##*/} OPTS

        -n <num>    Number of nexthops (default: $NUMPATHS)
        -p          Pause on fail
	-v          verbose mode (show commands and output)
EOF
}

################################################################################
# main

while getopts :n:pv o
do
	case $o in
	n) NUMPATHS=$OPTARG;;
	p) PAUSE_ON_FAIL=yes;;
	v) VERBOSE=1;;
	*) usage; exit 1;;
	esac
done

WITH_VRF="no"
VRF_ARG=
PING_PFX=
cleanup
setup
setup_routing_legacy

do_test

WITH_VRF="yes"
VRF_ARG="vrf ${VRF}"
PING_PFX="ip vrf exec ${VRF}"
cleanup
setup
setup_routing_legacy
do_test "- VRF"

ip nexthop ls >/dev/null 2>&1
if [ $? -eq 0 ]; then
	WITH_VRF="no"
	VRF_ARG=
	PING_PFX=
	cleanup
	setup
	setup_routing_new
	do_test "- nexthop objects"

	WITH_VRF="yes"
	VRF_ARG="vrf ${VRF}"
	PING_PFX="ip vrf exec ${VRF}"
	cleanup
	setup
	setup_routing_new
	do_test "- nexthop objects and VRF"
fi

cleanup

--------------245FDDE63D34C91357A79561--
