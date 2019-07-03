Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90895E757
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfGCPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:04:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:53706 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCPEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:04:41 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1higoJ-0001a2-EO; Wed, 03 Jul 2019 17:04:39 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1higoJ-0002AL-6S; Wed, 03 Jul 2019 17:04:39 +0200
Subject: Re: [PATCH bpf v2] selftests: bpf: fix inlines in test_lwt_seg6local
To:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>, Y Song <ys114321@gmail.com>
References: <bf60860191c7d4ab0f50fe3143f3d175bd6ee112.1562089104.git.jbenc@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cc3e08a3-633e-c601-c78e-c4b81bd48ada@iogearbox.net>
Date:   Wed, 3 Jul 2019 17:04:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <bf60860191c7d4ab0f50fe3143f3d175bd6ee112.1562089104.git.jbenc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 07:40 PM, Jiri Benc wrote:
> Selftests are reporting this failure in test_lwt_seg6local.sh:
> 
> + ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
> Error fetching program/map!
> Failed to parse eBPF program: Operation not permitted
> 
> The problem is __attribute__((always_inline)) alone is not enough to prevent
> clang from inserting those functions in .text. In that case, .text is not
> marked as relocateable.
> 
> See the output of objdump -h test_lwt_seg6local.o:
> 
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
> 
> This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
> bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
> relocateable .text section in the file.
> 
> To fix this, convert to 'static __always_inline'.
> 
> v2: Use 'static __always_inline' instead of 'static inline
>     __attribute__((always_inline))'
> 
> Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Applied, thanks!
