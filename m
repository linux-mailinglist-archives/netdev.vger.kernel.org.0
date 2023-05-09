Return-Path: <netdev+bounces-1208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E26F26FCA4A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 171C91C20BE6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145C018011;
	Tue,  9 May 2023 15:32:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ABE17FE9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C18C433D2;
	Tue,  9 May 2023 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683646369;
	bh=X6yXFw1CeqpdA5QcI0/jDzzoq3aJvBYfo9K/pqgup8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LKZtA9eCEtbNFBMh9/Hm9uW9aMaMfI25U9P7o9feOOAtikcvn3oBoP3mDNDs+/OM9
	 cvog5Z+bJL56nau1l9y5UiaGYCGW8CJZwz3rNLp78vq1GEV6XK/iSeef58lhWw8Ff5
	 OFda8o69lHypG5v2baj3vTvjHJf1t//xwuu2OVCXGeeGTB4M+RQ6Zxq4T0n6AYKjk/
	 0nzEkMZOanuoBwz6qvYUQjNn91a5T8p0+PH8AsmAgzcz9aEAGF/8viDL9X0XlIx1+O
	 LpScs12bKpu4kd5msCArbEMj6C66TufigWvJ7hFJO/8HEWPCO/f/arzpIZ/fr5FASB
	 nKe10ppUoayQw==
Date: Tue, 9 May 2023 09:32:46 -0600
From: David Ahern <dsahern@kernel.org>
To: Guillaume Nault <gnault@redhat.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] selftests: fcnal: Test SO_DONTROUTE on TCP
 sockets.
Message-ID: <20230509153246.GA26485@u2004-local>
References: <cover.1683626501.git.gnault@redhat.com>
 <ac92940c6d2c17c7c8d476428cfa94c4ffa6bd8b.1683626501.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac92940c6d2c17c7c8d476428cfa94c4ffa6bd8b.1683626501.git.gnault@redhat.com>

On Tue, May 09, 2023 at 02:02:37PM +0200, Guillaume Nault wrote:
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 21ca91473c09..1f8939fbb021 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1098,6 +1098,73 @@ test_ipv4_md5_vrf__global_server__bind_ifindex0()
>  	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
>  }
>  
> +ipv4_tcp_dontroute()
> +{
> +	local syncookies=$1
> +	local nsa_syncookies
> +	local nsb_syncookies
> +	local a
> +
> +	#
> +	# Link local connection tests (SO_DONTROUTE).
> +	# Connections should succeed only when the remote IP address is
> +	# on link (doesn't need to be routed through a gateway).
> +	#
> +
> +	nsa_syncookies=$(ip netns exec "${NSA}" sysctl -n net.ipv4.tcp_syncookies)
> +	nsb_syncookies=$(ip netns exec "${NSB}" sysctl -n net.ipv4.tcp_syncookies)
> +	ip netns exec "${NSA}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
> +	ip netns exec "${NSB}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
> +
> +	# Test with eth1 address (on link).
> +
> +	a=${NSB_IP}
> +	log_start
> +	run_cmd_nsb nettest -s &
> +	sleep 1

rather than propagate the sleep for new tests, you try adding these
tests using a single nettest instance that takes both server and client
arguments and does the netns switch internally.

