Return-Path: <netdev+bounces-1859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 419BB6FF564
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9F521C20F99
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCDC629;
	Thu, 11 May 2023 15:03:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B036D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC29AC433EF;
	Thu, 11 May 2023 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683817425;
	bh=5fcCng9Ex5exHfWQg/FPionQwKaKGTELGfgTA6uMmms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oGlqKk/INMbTtEIKZimuxSzkFZJB0MuD+/vGYgxkQGnka3Dp0alRoRpj1SnBIN6V7
	 6N7e24afUziO3HXzZfDG7003ycY+G//+4EWjc2x+woj19KmFM7kChHa4EeQFp4sdg6
	 3p0uyH7AmGgjc6lfXy69UItB7VxYEWTX6IEbg0qrTQVO5GGrJgdB7soTQ2flmCc4z8
	 OiO+fGwkzqGYNHRRDHiTzUHtFBgzhx8djKyCtwhWXQYMLT+EXtKmJXk6q+YW6n5UvQ
	 mYHPmwD9IvRFwUuLkO4S2tk/KxhOwtISM2v/N6ktVYgeIKiNreBUdMeWi1AhnfzNhZ
	 Idvu2rtsOagAw==
Message-ID: <40497aaa-ac1e-32c3-16ba-f61b22013e28@kernel.org>
Date: Thu, 11 May 2023 09:03:44 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 net-next 3/4] selftests: fcnal: Test SO_DONTROUTE on
 UDP sockets.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1683814269.git.gnault@redhat.com>
 <dbc62d5ea038e0fc7b0a59cedc1213d3ae6a59fe.1683814269.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <dbc62d5ea038e0fc7b0a59cedc1213d3ae6a59fe.1683814269.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/23 8:39 AM, Guillaume Nault wrote:
> Use nettest --client-dontroute to test the kernel behaviour with UDP
> sockets having the SO_DONTROUTE option. Sending packets to a neighbour
> (on link) host, should work. When the host is behind a router, sending
> should fail.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  v2: Use 'nettest -B' instead of invoking two nettest instances for
>      client and server.
> 
>  tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 3a1f3051321f..08b4b96cbd63 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1641,6 +1641,23 @@ ipv4_udp_novrf()
>  	log_start
>  	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
>  	log_test_addr ${a} $? 2 "No server, device client, local conn"
> +
> +	#
> +	# Link local connection tests (SO_DONTROUTE).
> +	# Connections should succeed only when the remote IP address is
> +	# on link (doesn't need to be routed through a gateway).
> +	#
> +
> +	a=${NSB_IP}
> +	log_start
> +	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
> +	log_test_addr ${a} $? 0 "SO_DONTROUTE client"
> +
> +	a=${NSB_LO_IP}
> +	log_start
> +	show_hint "Should fail 'Network is unreachable' since server is not on link"
> +	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
> +	log_test_addr ${a} $? 1 "SO_DONTROUTE client"
>  }
>  
>  ipv4_udp_vrf()

Reviewed-by: David Ahern <dsahern@kernel.org>

Have you looked at test cases with VRF - both UDP and TCP?



