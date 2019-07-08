Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34B62444
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391031AbfGHPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:41:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:45366 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388894AbfGHP0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:26:48 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVXP-0000jC-V5; Mon, 08 Jul 2019 17:26:44 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVXP-000CEe-Mh; Mon, 08 Jul 2019 17:26:43 +0200
Subject: Re: [PATCH net-next 1/2] bpf: skip sockopt hooks without CONFIG_NET
To:     Yonghong Song <yhs@fb.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>,
        Mauricio Vasquez B <mauricio.vasquez@polito.it>,
        Roman Gushchin <guro@fb.com>, Matt Mullins <mmullins@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190708125733.3944836-1-arnd@arndb.de>
 <0e7cf1b5-579f-5fcd-0966-8760148b00de@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <abd13bae-2520-0bb0-20ba-0a19786d3a23@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:26:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <0e7cf1b5-579f-5fcd-0966-8760148b00de@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08/2019 05:06 PM, Yonghong Song wrote:
> On 7/8/19 5:57 AM, Arnd Bergmann wrote:
>> When CONFIG_NET is disabled, we get a link error:
>>
>> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
>> cgroup.c:(.text+0x3010): undefined reference to `lock_sock_nested'
>> cgroup.c:(.text+0x3258): undefined reference to `release_sock'
>> kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
>> cgroup.c:(.text+0x3568): undefined reference to `lock_sock_nested'
>> cgroup.c:(.text+0x3870): undefined reference to `release_sock'
>> kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
>> cgroup.c:(.text+0x41d8): undefined reference to `bpf_sk_storage_delete_proto'
>>
>> None of this code is useful in this configuration anyway, so we can
>> simply hide it in an appropriate #ifdef.
>>
>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> FYI.
> 
> There is already a patch to fix the same issue,
> https://lore.kernel.org/bpf/e9e489fe-feec-a211-82aa-5df0c6a308d1@huawei.com/T/#t
> 
> which has been acked and not merged yet.

Done now, and I've also applied patch 2/2 from here, thanks.
