Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36011C48CA
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgEDVHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 17:07:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:32810 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 17:07:15 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jViIn-0001Gq-FV; Mon, 04 May 2020 23:07:01 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jViIm-000G0e-PC; Mon, 04 May 2020 23:07:00 +0200
Subject: Re: [PATCH 05/15] bpf: avoid gcc-10 stringop-overflow warning
To:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200430213101.135134-1-arnd@arndb.de>
 <20200430213101.135134-6-arnd@arndb.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f1ffd814-538b-1913-5b67-266060abfa7a@iogearbox.net>
Date:   Mon, 4 May 2020 23:06:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200430213101.135134-6-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25802/Mon May  4 14:12:31 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 11:30 PM, Arnd Bergmann wrote:
> gcc-10 warns about accesses to zero-length arrays:
> 
> kernel/bpf/core.c: In function 'bpf_patch_insn_single':
> cc1: warning: writing 8 bytes into a region of size 0 [-Wstringop-overflow=]
> In file included from kernel/bpf/core.c:21:
> include/linux/filter.h:550:20: note: at offset 0 to object 'insnsi' with size 0 declared here
>    550 |   struct bpf_insn  insnsi[0];
>        |                    ^~~~~~
> 
> In this case, we really want to have two flexible-array members,
> but that is not possible. Removing the union to make insnsi a
> flexible-array member while leaving insns as a zero-length array
> fixes the warning, as nothing writes to the other one in that way.
> 
> This trick only works on linux-3.18 or higher, as older versions
> had additional members in the union.
> 
> Fixes: 60a3b2253c41 ("net: bpf: make eBPF interpreter images read-only")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Not pretty but looks okay to me, both have the same offset afterwards
in the pahole dump as well.

struct bpf_prog {
[...]
         unsigned int               (*bpf_func)(const void  *, const struct bpf_insn  *); /*    48     8 */
         struct sock_filter         insns[0];             /*    56     0 */
         struct bpf_insn            insnsi[];             /*    56     0 */

         /* size: 56, cachelines: 1, members: 21 */
         /* sum members: 50, holes: 1, sum holes: 4 */
         /* sum bitfield members: 10 bits, bit holes: 1, sum bit holes: 6 bits */
         /* last cacheline: 56 bytes */
};

Applied to bpf-next, thanks!
