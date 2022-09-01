Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3025A8B74
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiIAC3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiIAC3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBDE10B94A;
        Wed, 31 Aug 2022 19:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 713A861DAE;
        Thu,  1 Sep 2022 02:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54430C433D6;
        Thu,  1 Sep 2022 02:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999370;
        bh=ockhivr1Jx53VJ/N0iNnirDjvf7MnbtYS9hiup9hTVA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=cc4v6MkQstXGIwcXOpwGaD/sUHTf8ctC+FtTR33dxlsltQdRHrKk4GqW2OojGi/pv
         hhfUDUK0oDBvsCJ0/dVGru1iLnIL405pClBEJeOeN8l0SKCOJ/BcaYAVwnTtbR9yaQ
         gCXHzuW5NEcvSwmO3OJuwBRRN69RUp9SxooZwHKsIy2/zAugK4rt6quGW5kMu+A+I8
         WJYmJx7G99KY2MPfRb9AWqyyv4Ge40kBjdG5wtagEGu/rbaVJYUE5jANKvoesjKI/K
         SXm/IGz/xoz736bjXufyfITb1QJapCOMUkQ6pPf3bVtvaYNYxL0cP6KRMPmwNCd/RW
         CUxRmZ071kTBA==
Message-ID: <ba243807-02b3-a59b-8e7b-c397e28dfdda@kernel.org>
Date:   Wed, 31 Aug 2022 20:29:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] net-next: Fix IP_UNICAST_IF option behavior for
 connected sockets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220829111554.GA1771@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220829111554.GA1771@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/22 5:18 AM, Richard Gobert wrote:
> The IP_UNICAST_IF socket option is used to set the outgoing interface
> for outbound packets.
> 
> The IP_UNICAST_IF socket option was added as it was needed by the
> Wine project, since no other existing option (SO_BINDTODEVICE socket
> option, IP_PKTINFO socket option or the bind function) provided the
> needed characteristics needed by the IP_UNICAST_IF socket option. [1]
> The IP_UNICAST_IF socket option works well for unconnected sockets,
> that is, the interface specified by the IP_UNICAST_IF socket option
> is taken into consideration in the route lookup process when a packet
> is being sent. However, for connected sockets, the outbound interface
> is chosen when connecting the socket, and in the route lookup process
> which is done when a packet is being sent, the interface specified by
> the IP_UNICAST_IF socket option is being ignored.
> 
> This inconsistent behavior was reported and discussed in an issue
> opened on systemd's GitHub project [2]. Also, a bug report was
> submitted in the kernel's bugzilla [3].
> 
> To understand the problem in more detail, we can look at what happens
> for UDP packets over IPv4 (The same analysis was done separately in
> the referenced systemd issue).
> When a UDP packet is sent the udp_sendmsg function gets called and
> the following happens:
> 
> 1. The oif member of the struct ipcm_cookie ipc (which stores the
> output interface of the packet) is initialized by the ipcm_init_sk
> function to inet->sk.sk_bound_dev_if (the device set by the
> SO_BINDTODEVICE socket option).
> 
> 2. If the IP_PKTINFO socket option was set, the oif member gets
> overridden by the call to the ip_cmsg_send function.
> 
> 3. If no output interface was selected yet, the interface specified
> by the IP_UNICAST_IF socket option is used.
> 
> 4. If the socket is connected and no destination address is
> specified in the send function, the struct ipcm_cookie ipc is not
> taken into consideration and the cached route, that was calculated in
> the connect function is being used.
> 
> Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken
> into consideration.
> 
> This patch corrects the behavior of the IP_UNICAST_IF socket option
> for connect()ed sockets by taking into consideration the
> IP_UNICAST_IF sockopt when connecting the socket.
> 
> In order to avoid reconnecting the socket, this option is still
> ignored when applied on an already connected socket until connect()
> is called again by the Richard Gobert.
> 
> Change the __ip4_datagram_connect function, which is called during
> socket connection, to take into consideration the interface set by
> the IP_UNICAST_IF socket option, in a similar way to what is done in
> the udp_sendmsg function.
> 
> [1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
> [2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=210255
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
> v1 -> v2: Added self-tests and targeted to net-next.
> 
>  net/ipv4/datagram.c                       |  2 ++
>  tools/testing/selftests/net/fcnal-test.sh | 30 +++++++++++++++++++++++
>  tools/testing/selftests/net/nettest.c     | 16 ++++++++++--
>  3 files changed, 46 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 03b586760164..31c3b6ebd388 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1466,6 +1466,13 @@ ipv4_udp_novrf()
>  		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP}
>  		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF"
>  
> +		log_start
> +		run_cmd_nsb nettest -D -s &
> +		sleep 1
> +		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP} -U
> +		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF, with connect()"
> +
> +
>  		log_start
>  		show_hint "Should fail 'Connection refused'"
>  		run_cmd nettest -D -r ${a}
> @@ -1525,6 +1532,13 @@ ipv4_udp_novrf()
>  	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a}
>  	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection"
>  
> +	log_start
> +	run_cmd nettest -s -D &
> +	sleep 1
> +	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a} -U
> +	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
> +
> +
>  	# IPv4 with device bind has really weird behavior - it overrides the
>  	# fib lookup, generates an rtable and tries to send the packet. This
>  	# causes failures for local traffic at different places
> @@ -1550,6 +1564,15 @@ ipv4_udp_novrf()
>  		sleep 1
>  		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S
>  		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
> +
> +		log_start
> +		show_hint "Should fail since addresses on loopback are out of device scope"
> +		run_cmd nettest -D -s &
> +		sleep 1
> +		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -U
> +		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
> +
> +
>  	done
>  
>  	a=${NSA_IP}
> @@ -3157,6 +3180,13 @@ ipv6_udp_novrf()
>  		sleep 1
>  		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S
>  		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
> +
> +		log_start
> +		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
> +		run_cmd nettest -6 -D -s &
> +		sleep 1
> +		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S -U
> +		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection, with connect()"
>  	done
>  
>  	a=${NSA_IP6}

All of the tests are 'novrf' but this should work with VRF too. The
device is in a VRF, so binding it to should. Please add these tests
again for the VRF cases. It can be a followup patch.
