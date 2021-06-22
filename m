Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8595E3B1008
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFVW1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhFVW1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 18:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E0BE60FF1;
        Tue, 22 Jun 2021 22:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624400692;
        bh=3bT3+tWBO4biTRfb812rpj7cpDTgOkkgaprFMj2f9ew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XF9jh73jtHatbF2hXw6KUEPQVlchSUDBrUWqrVCmS0+oKmOSk9dEtpnguPR+FvbnU
         2DuswPdBrL1azU3XvEm24tkl4pmyvF7ba6b7dmQ8tG4mlUAxYklr0UscTvJWREDIek
         CffoQ2QQhJq+BHpac868K8cqMTZGC22mSmOtjBETXfk3KosIJPstuVnSaB/v6dNd8j
         I6QaTqHzuKyn7QOXnLXr5NbLm+huzNltdhKI5w96WgWOwxiOHfmZMPUdBBBYSDVkHw
         W1X6sFCDhmyVv6lrwWjROEGfsBRUlPPmnBCz28N7qFmAVp0Mo+hUaoEZuLKJnnX/dr
         pTkZIbMp3v+xA==
Date:   Tue, 22 Jun 2021 15:24:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, vfedorenko@novek.ru
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
Message-ID: <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
References: <20210622015254.1967716-1-kuba@kernel.org>
        <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Jun 2021 22:28:05 -0600 David Ahern wrote:
> On 6/21/21 7:52 PM, Jakub Kicinski wrote:
> > Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> > moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
> > its callee ip6_tnl_xmit(). The latter is also used by GRE.
> > 
> > Since commit 38720352412a ("gre: Use inner_proto to obtain inner
> > header protocol") GRE had been depending on skb->inner_protocol
> > during segmentation. It sets it in gre_build_header() and reads
> > it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
> > the protocol, resulting in GSO skbs getting dropped.
> > 
> > Note that inner_protocol is a union with inner_ipproto,
> > GRE uses the former while the change switched it to the latter
> > (always setting it to just IPPROTO_GRE).
> > 
> > Restore the original location of skb_set_inner_ipproto(),
> > it is unclear why it was moved in the first place.
> > 
> > Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/ipv6/ip6_tunnel.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >   
> 
> would be good to capture the GRE use case that found the bug and the
> MPLS version as test cases under tools/testing/selftests/net. Both
> should be doable using namespaces.

I believe Vadim is working on MPLS side, how does this look for GRE?

#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

# This test is for checking GRE GSO.

ret=0
# Kselftest framework requirement - SKIP code is 4.
ksft_skip=4

# all tests in this script. Can be overridden with -t option
TESTS="gre_gso"

VERBOSE=0
PAUSE_ON_FAIL=no
PAUSE=no
IP="ip -netns ns1"
NS_EXEC="ip netns exec ns1"
TMPFILE=`mktemp`
PID=

log_test()
{
	local rc=$1
	local expected=$2
	local msg="$3"

	if [ ${rc} -eq ${expected} ]; then
		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
		nsuccess=$((nsuccess+1))
	else
		ret=1
		nfail=$((nfail+1))
		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
		echo
			echo "hit enter to continue, 'q' to quit"
			read a
			[ "$a" = "q" ] && exit 1
		fi
	fi

	if [ "${PAUSE}" = "yes" ]; then
		echo
		echo "hit enter to continue, 'q' to quit"
		read a
		[ "$a" = "q" ] && exit 1
	fi
}

setup()
{
	set -e
	ip netns add ns1
	ip netns set ns1 auto
	$IP link set dev lo up

	ip link add veth0 type veth peer name veth1
	ip link set veth0 up
	ip link set veth1 netns ns1
	$IP link set veth1 name veth0
	$IP link set veth0 up

	dd if=/dev/urandom of=$TMPFILE bs=1024 count=2048 &>/dev/null
	set +e
}

cleanup()
{
	rm -rf $TMPFILE
	[ -n "$PID" ] && kill $PID
	ip link del dev gre1 &> /dev/null
	ip link del dev veth0 &> /dev/null
	ip netns del ns1
}

get_linklocal()
{
	local dev=$1
	local ns=$2
	local addr

	[ -n "$ns" ] && ns="-netns $ns"

	addr=$(ip -6 -br $ns addr show dev ${dev} | \
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

gre_create_tun()
{
	local a1=$1
	local a2=$2
	local mode

	[[ $a1 =~ ^[0-9.]*$ ]] && mode=gre || mode=ip6gre

	ip tunnel add gre1 mode $mode local $a1 remote $a2 dev veth0
	ip link set gre1 up
	$IP tunnel add gre1 mode $mode local $a2 remote $a1 dev veth0
	$IP link set gre1 up
}

gre_gst_test_checks()
{
	local name=$1
	local addr=$2

	$NS_EXEC nc -kl $port >/dev/null &
	PID=$!

	cat $TMPFILE | timeout 1 nc $addr $port
	log_test $? 0 "$name - copy file w/ TSO"

	ethtool -K veth0 tso off

	cat $TMPFILE | timeout 1 nc $addr $port
	log_test $? 0 "$name - copy file w/ GSO"

	ethtool -K veth0 tso on

	kill $PID
	PID=
}

gre6_gso_test()
{
	local port=7777

	setup

	a1=$(get_linklocal veth0)
	a2=$(get_linklocal veth0 ns1)

	gre_create_tun $a1 $a2

	ip  addr add 172.16.2.1/24 dev gre1
	$IP addr add 172.16.2.2/24 dev gre1

	ip  -6 addr add 2001:db8:1::1/64 dev gre1 nodad
	$IP -6 addr add 2001:db8:1::2/64 dev gre1 nodad

	sleep 2

	gre_gst_test_checks GREv6/v4 172.16.2.2
	gre_gst_test_checks GREv6/v6 2001:db8:1::2

	cleanup
}

gre_gso_test()
{
	gre6_gso_test
}

################################################################################
# usage

usage()
{
	cat <<EOF
usage: ${0##*/} OPTS

        -t <test>   Test(s) to run (default: all)
                    (options: $TESTS)
        -p          Pause on fail
        -P          Pause after each test before cleanup
        -v          verbose mode (show commands and output)
EOF
}

################################################################################
# main

while getopts :t:pPhv o
do
	case $o in
		t) TESTS=$OPTARG;;
		p) PAUSE_ON_FAIL=yes;;
		P) PAUSE=yes;;
		v) VERBOSE=$(($VERBOSE + 1));;
		h) usage; exit 0;;
		*) usage; exit 1;;
	esac
done

PEER_CMD="ip netns exec ${PEER_NS}"

# make sure we don't pause twice
[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no

if [ "$(id -u)" -ne 0 ];then
	echo "SKIP: Need root privileges"
	exit $ksft_skip;
fi

if [ ! -x "$(command -v ip)" ]; then
	echo "SKIP: Could not run test without ip tool"
	exit $ksft_skip
fi

if [ ! -x "$(command -v nc)" ]; then
	echo "SKIP: Could not run test without nc tool"
	exit $ksft_skip
fi

# start clean
cleanup &> /dev/null

for t in $TESTS
do
	case $t in
	gre_gso)		gre_gso_test;;

	help) echo "Test names: $TESTS"; exit 0;;
	esac
done

if [ "$TESTS" != "none" ]; then
	printf "\nTests passed: %3d\n" ${nsuccess}
	printf "Tests failed: %3d\n"   ${nfail}
fi

exit $ret

