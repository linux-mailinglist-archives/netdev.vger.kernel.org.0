Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55011266B2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLSQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:21:00 -0500
Received: from www62.your-server.de ([213.133.104.62]:56570 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfLSQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:20:59 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihyXk-0003mT-CK; Thu, 19 Dec 2019 17:20:52 +0100
Date:   Thu, 19 Dec 2019 17:20:51 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Matteo Croce <mcroce@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: core: sysctl: fix compiler warning when only
 cBPF is present
Message-ID: <20191219162051.GA11015@linux-9.fritz.box>
References: <20191218091821.7080-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218091821.7080-1-alobakin@dlink.ru>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:18:21PM +0300, Alexander Lobakin wrote:
> proc_dointvec_minmax_bpf_restricted() has been firstly introduced
> in commit 2e4a30983b0f ("bpf: restrict access to core bpf sysctls")
> under CONFIG_HAVE_EBPF_JIT. Then, this ifdef has been removed in
> ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv
> allocations"), because a new sysctl, bpf_jit_limit, made use of it.
> Finally, this parameter has become long instead of integer with
> fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
> and thus, a new proc_dolongvec_minmax_bpf_restricted() has been
> added.
> With this last change, we got back to that
> proc_dointvec_minmax_bpf_restricted() is used only under
> CONFIG_HAVE_EBPF_JIT, but the corresponding ifdef has not been
> brought back.
> 
> So, in configurations like CONFIG_BPF_JIT=y && CONFIG_HAVE_EBPF_JIT=n
> since v4.20 we have:
> 
>   CC      net/core/sysctl_net_core.o
> net/core/sysctl_net_core.c:292:1: warning: ‘proc_dointvec_minmax_bpf_restricted’ defined but not used [-Wunused-function]
>   292 | proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Suppress this by guarding it with CONFIG_HAVE_EBPF_JIT again.
> 
> Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Applied, thanks!
