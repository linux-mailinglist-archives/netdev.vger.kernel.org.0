Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9701A54568A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiFIVhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiFIVht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:37:49 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434926523C;
        Thu,  9 Jun 2022 14:37:47 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzPqV-00023F-Uo; Thu, 09 Jun 2022 23:37:40 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzPqV-000Hf9-Hs; Thu, 09 Jun 2022 23:37:39 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: add lwt ip encap tests to
 test_progs
To:     Eyal Birger <eyal.birger@gmail.com>, shuah@kernel.org,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, posk@google.com
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220607133135.271788-1-eyal.birger@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f80edf4f-c795-1e1e-bac2-414189988156@iogearbox.net>
Date:   Thu, 9 Jun 2022 23:37:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220607133135.271788-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

On 6/7/22 3:31 PM, Eyal Birger wrote:
> Port test_lwt_ip_encap.sh tests onto test_progs.
> 
> In addition, this commit adds "egress_md" tests which test a similar
> flow as egress tests only they use gre devices in collect_md mode
> for encapsulation and set the tunnel key using bpf_set_tunnel_key().
> 
> This introduces minor changes to test_lwt_ip_encap.{sh,c} for consistency
> with the new tests:
> 
> - GRE key must exist as bpf_set_tunnel_key() explicitly sets the
>    TUNNEL_KEY flag
> 
> - Source address for GRE traffic is set to IP*_5 instead of IP*_1 since
>    GRE traffic is sent via veth5 so its address is selected when using
>    bpf_set_tunnel_key()
> 
> Note: currently these programs use the legacy section name convention
> as iproute2 lwt configuration does not support providing function names.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>   .../selftests/bpf/prog_tests/lwt_ip_encap.c   | 582 ++++++++++++++++++
>   .../selftests/bpf/progs/test_lwt_ip_encap.c   |  51 +-
>   .../selftests/bpf/test_lwt_ip_encap.sh        |   6 +-
>   3 files changed, 633 insertions(+), 6 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> new file mode 100644
> index 000000000000..e1b6f3ce6045
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
> @@ -0,0 +1,582 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +
> +/* Setup/topology:
> + *
> + *    NS1             NS2             NS3
> + *   veth1 <---> veth2   veth3 <---> veth4 (the top route)
> + *   veth5 <---> veth6   veth7 <---> veth8 (the bottom route)
> + *
> + *   each vethN gets IP[4|6]_N address
> + *
> + *   IP*_SRC = IP*_1
> + *   IP*_DST = IP*_4
> + *
> + *   all tests test pings from IP*_SRC to IP*_DST
> + *
> + *   by default, routes are configured to allow packets to go
> + *   IP*_1 <=> IP*_2 <=> IP*_3 <=> IP*_4 (the top route)
> + *
> + *   a GRE device is installed in NS3 with IP*_GRE, and
> + *   NS1/NS2 are configured to route packets to IP*_GRE via IP*_8
> + *   (the bottom route)
> + *
> + * Tests:
> + *
> + *   1. routes NS2->IP*_DST are brought down, so the only way a ping
> + *      from IP*_SRC to IP*_DST can work is via IP*_GRE
> + *
> + *   2a. in an egress test, a bpf LWT_XMIT program is installed on veth1
> + *       that encaps the packets with an IP/GRE header to route to IP*_GRE
> + *
> + *       ping: SRC->[encap at veth1:egress]->GRE:decap->DST
> + *       ping replies go DST->SRC directly
> + *
> + *   2b. in an ingress test, a bpf LWT_IN program is installed on veth2
> + *       that encaps the packets with an IP/GRE header to route to IP*_GRE
> + *
> + *       ping: SRC->[encap at veth2:ingress]->GRE:decap->DST
> + *       ping replies go DST->SRC directly
> + *
> + *   2c. in an egress_md test, a bpf LWT_XMIT program is installed on a
> + *       route towards collect_md gre{,6} devices in NS1 and sets the tunnel
> + *       key such that packets are encapsulated with an IP/GRE header to route
> + *       to IP*_GRE
> + *
> + *       ping: SRC->[encap at gre{,6}_md:xmit]->GRE:decap->DST
> + *       ping replies go DST->SRC directly
> + */
> +
[...]

Thanks a lot for porting the test into test_progs! Looks like the BPF CI currently
bails out here:

https://github.com/kernel-patches/bpf/runs/6812283921?check_suite_focus=true

Andrii, looks like we might be missing CONFIG_NET_VRF in vmtest config-latest.*?

[...]
   #98/1    lwt_ip_encap/lwt_ipv4_encap_egress:OK
   #98/2    lwt_ip_encap/lwt_ipv6_encap_egress:OK
   setup_namespaces:PASS:ip netns add ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_3 0 nsec
   lwt_ip_encap_test:PASS:setup namespaces 0 nsec
   setup_links_and_routes:PASS:ip link add veth1 netns ns_lwt_1 type veth peer name veth2 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth3 netns ns_lwt_2 type veth peer name veth4 netns ns_lwt_3 0 nsec
   setup_links_and_routes:PASS:ip link add veth5 netns ns_lwt_1 type veth peer name veth6 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth7 netns ns_lwt_2 type veth peer name veth8 netns ns_lwt_3 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_vrf:FAIL:ip link add red type vrf table 1001 unexpected error: 512 (errno 0)
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   lwt_ip_encap_test:FAIL:setup links and routes unexpected error: -1 (errno 0)
   setup_namespaces:PASS:ip netns delete ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_3 0 nsec
   #98/3    lwt_ip_encap/lwt_ipv4_encap_egress_vrf:FAIL
   setup_namespaces:PASS:ip netns add ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_3 0 nsec
   lwt_ip_encap_test:PASS:setup namespaces 0 nsec
   setup_links_and_routes:PASS:ip link add veth1 netns ns_lwt_1 type veth peer name veth2 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth3 netns ns_lwt_2 type veth peer name veth4 netns ns_lwt_3 0 nsec
   setup_links_and_routes:PASS:ip link add veth5 netns ns_lwt_1 type veth peer name veth6 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth7 netns ns_lwt_2 type veth peer name veth8 netns ns_lwt_3 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_vrf:FAIL:ip link add red type vrf table 1001 unexpected error: 512 (errno 0)
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   lwt_ip_encap_test:FAIL:setup links and routes unexpected error: -1 (errno 0)
   setup_namespaces:PASS:ip netns delete ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_3 0 nsec
   #98/4    lwt_ip_encap/lwt_ipv6_encap_egress_vrf:FAIL
   #98/5    lwt_ip_encap/lwt_ipv4_encap_ingress:OK
   #98/6    lwt_ip_encap/lwt_ipv6_encap_ingress:OK
   setup_namespaces:PASS:ip netns add ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_3 0 nsec
   lwt_ip_encap_test:PASS:setup namespaces 0 nsec
   setup_links_and_routes:PASS:ip link add veth1 netns ns_lwt_1 type veth peer name veth2 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth3 netns ns_lwt_2 type veth peer name veth4 netns ns_lwt_3 0 nsec
   setup_links_and_routes:PASS:ip link add veth5 netns ns_lwt_1 type veth peer name veth6 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth7 netns ns_lwt_2 type veth peer name veth8 netns ns_lwt_3 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_vrf:FAIL:ip link add red type vrf table 1001 unexpected error: 512 (errno 0)
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   lwt_ip_encap_test:FAIL:setup links and routes unexpected error: -1 (errno 0)
   setup_namespaces:PASS:ip netns delete ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_3 0 nsec
   #98/7    lwt_ip_encap/lwt_ipv4_encap_ingress_vrf:FAIL
   setup_namespaces:PASS:ip netns add ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns add ns_lwt_3 0 nsec
   lwt_ip_encap_test:PASS:setup namespaces 0 nsec
   setup_links_and_routes:PASS:ip link add veth1 netns ns_lwt_1 type veth peer name veth2 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth3 netns ns_lwt_2 type veth peer name veth4 netns ns_lwt_3 0 nsec
   setup_links_and_routes:PASS:ip link add veth5 netns ns_lwt_1 type veth peer name veth6 netns ns_lwt_2 0 nsec
   setup_links_and_routes:PASS:ip link add veth7 netns ns_lwt_2 type veth peer name veth8 netns ns_lwt_3 0 nsec
   open_netns:PASS:malloc token 0 nsec
   open_netns:PASS:open /proc/self/ns/net 0 nsec
   open_netns:PASS:open netns fd 0 nsec
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   open_netns:PASS:setns_by_fd 0 nsec
   setup_ns:PASS:setns 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   write_sysctl:PASS:open sysctl 0 nsec
   write_sysctl:PASS:write sysctl 0 nsec
   setup_vrf:FAIL:ip link add red type vrf table 1001 unexpected error: 512 (errno 0)
   setns_by_fd:PASS:setns 0 nsec
   setns_by_fd:PASS:unshare 0 nsec
   setns_by_fd:PASS:remount private /sys 0 nsec
   setns_by_fd:PASS:umount2 /sys 0 nsec
   setns_by_fd:PASS:mount /sys 0 nsec
   setns_by_fd:PASS:mount /sys/fs/bpf 0 nsec
   close_netns:PASS:setns_by_fd 0 nsec
   lwt_ip_encap_test:FAIL:setup links and routes unexpected error: -1 (errno 0)
   setup_namespaces:PASS:ip netns delete ns_lwt_1 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_2 0 nsec
   setup_namespaces:PASS:ip netns delete ns_lwt_3 0 nsec
   #98/8    lwt_ip_encap/lwt_ipv6_encap_ingress_vrf:FAIL
   #98/9    lwt_ip_encap/lwt_ipv4_encap_egress_md:OK
   #98/10   lwt_ip_encap/lwt_ipv6_encap_egress_md:OK
   #98      lwt_ip_encap:FAIL
   #99/1    map_init/pcpu_map_init:OK
   #99/2    map_init/pcpu_lru_map_init:OK
   #99      map_init:OK
[...]
