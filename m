Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57AD14529A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAVK3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:29:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:53456 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAVK3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:29:12 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuDFt-0000Qo-GA; Wed, 22 Jan 2020 11:29:02 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuDFt-000LOf-57; Wed, 22 Jan 2020 11:29:01 +0100
Subject: Re: [PATCH v2 bpf 0/2] Fix the classification based on port ranges in
 bpf hook
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d2c7815c-22a0-0004-5151-f3a43941af0a@iogearbox.net>
Date:   Wed, 22 Jan 2020 11:29:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25702/Tue Jan 21 12:39:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/20 8:05 AM, Yoshiki Komachi wrote:
> When I tried a test based on the selftest program for BPF flow dissector
> (test_flow_dissector.sh), I observed unexpected result as below:
> 
> $ tc filter add dev lo parent ffff: protocol ip pref 1337 flower ip_proto \
> 	udp src_port 8-10 action drop
> $ tools/testing/selftests/bpf/test_flow_dissector -i 4 -f 9 -F
> inner.dest4: 127.0.0.1
> inner.source4: 127.0.0.3
> pkts: tx=10 rx=10
> 
> The last rx means the number of received packets. I expected rx=0 in this
> test (i.e., all received packets should have been dropped), but it resulted
> in acceptance.
> 
> Although the previous commit 8ffb055beae5 ("cls_flower: Fix the behavior
> using port ranges with hw-offload") added new flag and field toward filtering
> based on port ranges with hw-offload, it missed applying for BPF flow dissector
> then. As a result, BPF flow dissector currently stores data extracted from
> packets in incorrect field used for exact match whenever packets are classified
> by filters based on port ranges. Thus, they never match rules in such cases
> because flow dissector gives rise to generating incorrect flow keys.
> 
> This series fixes the issue by replacing incorrect flag and field with new
> ones in BPF flow dissector, and adds a test for filtering based on specified
> port ranges to the existing selftest program.
> 
> Changes in v2:
>   - set key_ports to NULL at the top of __skb_flow_bpf_to_target()
> 
> Yoshiki Komachi (2):
>    flow_dissector: Fix to use new variables for port ranges in bpf hook
>    selftests/bpf: Add test based on port range for BPF flow dissector
> 
>   net/core/flow_dissector.c                          |  9 ++++++++-
>   tools/testing/selftests/bpf/test_flow_dissector.sh | 14 ++++++++++++++
>   2 files changed, 22 insertions(+), 1 deletion(-)
> 

Applied, thanks!
