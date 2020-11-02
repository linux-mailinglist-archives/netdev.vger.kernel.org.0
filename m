Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A002A36F0
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgKBXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:08:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:57012 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgKBXI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 18:08:27 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kZiw4-0006ru-Gj; Tue, 03 Nov 2020 00:08:24 +0100
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kZiw4-000Dwv-8f; Tue, 03 Nov 2020 00:08:24 +0100
Subject: Re: [PATCH bpf-next 0/5] selftests/xsk: xsk selftests
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com,
        andrii.nakryiko@gmail.com
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0fef6ce4-86cd-ae3a-0a29-953d87402afe@iogearbox.net>
Date:   Tue, 3 Nov 2020 00:08:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25976/Mon Nov  2 14:23:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 1:13 PM, Weqaar Janjua wrote:
> This patch set adds AF_XDP selftests based on veth to selftests/xsk/.
> 
> # Topology:
> # ---------
> #                 -----------
> #               _ | Process | _
> #              /  -----------  \
> #             /        |        \
> #            /         |         \
> #      -----------     |     -----------
> #      | Thread1 |     |     | Thread2 |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     -----------
> #      |  xskX   |     |     |  xskY   |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     ----------
> #      |  vethX  | --------- |  vethY |
> #      -----------   peer    ----------
> #           |          |          |
> #      namespaceX      |     namespaceY
> 
> These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
> Ethernet interfaces.
> 
> The test program contains two threads, each thread is single socket with
> a unique UMEM. It validates in-order packet delivery and packet content
> by sending packets to each other.
> 
> Prerequisites setup by script TEST_PREREQUISITES.sh:
> 
>     Set up veth interfaces as per the topology shown ^^:
>     * setup two veth interfaces and one namespace
>     ** veth<xxxx> in root namespace
>     ** veth<yyyy> in af_xdp<xxxx> namespace
>     ** namespace af_xdp<xxxx>
>     * create a spec file veth.spec that includes this run-time configuration
>       that is read by test scripts - filenames prefixed with TEST_XSK
>     *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
>         conflict with any existing interface.
> 
> The following tests are provided:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
>     c. Socket Teardown
>        Create a Tx and a Rx socket, Tx from one socket, Rx on another.
>        Destroy both sockets, then repeat multiple times. Only nopoll mode
> 	  is used
>     d. Bi-directional Sockets
>        Configure sockets as bi-directional tx/rx sockets, sets up fill
> 	  and completion rings on each socket, tx/rx in both directions.
> 	  Only nopoll mode is used
> 
> 2. AF_XDP DRV/Native mode
>     Works on any netdevice with XDP_REDIRECT support, driver dependent.
>     Processes packets before SKB allocation. Provides better performance
>     than SKB. Driver hook available just after DMA of buffer descriptor.
>     a. nopoll
>     b. poll
>     c. Socket Teardown
>     d. Bi-directional Sockets
>     * Only copy mode is supported because veth does not currently support
>       zero-copy mode
> 
> Total tests: 8.
> 
> Flow:
> * Single process spawns two threads: Tx and Rx
> * Each of these two threads attach to a veth interface within their
>    assigned namespaces
> * Each thread creates one AF_XDP socket connected to a unique umem
>    for each veth interface
> * Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
> * Rx thread verifies if all 10k packets were received and delivered
>    in-order, and have the right content
> 
> Structure of the patch set:
> 
> Patch 1: This patch adds XSK Selftests framework under
>           tools/testing/selftests/xsk, and README
> Patch 2: Adds tests: SKB poll and nopoll mode, mac-ip-udp debug,
>           and README updates
> Patch 3: Adds tests: DRV poll and nopoll mode, and README updates
> Patch 4: Adds tests: SKB and DRV Socket Teardown, and README updates
> Patch 5: Adds tests: SKB and DRV Bi-directional Sockets, and README
>           updates
> 
> Thanks: Weqaar
> 
> Weqaar Janjua (5):
>    selftests/xsk: xsk selftests framework
>    selftests/xsk: xsk selftests - SKB POLL, NOPOLL
>    selftests/xsk: xsk selftests - DRV POLL, NOPOLL
>    selftests/xsk: xsk selftests - Socket Teardown - SKB, DRV
>    selftests/xsk: xsk selftests - Bi-directional Sockets - SKB, DRV

Thanks a lot for adding the selftests, Weqaar! Given this needs to copy quite
a bit of BPF selftest base infra e.g. from Makefiles I'd prefer if you could
place these under selftests/bpf/ instead to avoid duplicating changes into two
locations. I understand that these tests don't integrate well into test_progs,
but for example see test_tc_redirect.sh or test_tc_edt.sh for stand-alone tests
which could be done similarly with the xsk ones. Would be great if you could
integrate them and spin a v2 with that.

Thanks,
Daniel
