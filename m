Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3537210063
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgF3X06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:26:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:57986 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgF3X06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:26:58 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqPeH-0008In-Hz; Wed, 01 Jul 2020 01:26:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqPeH-000FUM-CW; Wed, 01 Jul 2020 01:26:45 +0200
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     paulmck@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
Date:   Wed, 1 Jul 2020 01:26:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630043343.53195-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25859/Tue Jun 30 15:38:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 6:33 AM, Alexei Starovoitov wrote:
[...]
>   
> +/* list of non-sleepable kernel functions that are otherwise
> + * available to attach by bpf_lsm or fmod_ret progs.
> + */
> +static int check_sleepable_blacklist(unsigned long addr)
> +{
> +#ifdef CONFIG_BPF_LSM
> +	if (addr == (long)bpf_lsm_task_free)
> +		return -EINVAL;
> +#endif
> +#ifdef CONFIG_SECURITY
> +	if (addr == (long)security_task_free)
> +		return -EINVAL;
> +#endif
> +	return 0;
> +}

Would be nice to have some sort of generic function annotation to describe
that code cannot sleep inside of it, and then filter based on that. Anyway,
is above from manual code inspection?

What about others like security_sock_rcv_skb() for example which could be
bh_lock_sock()'ed (or, generally hooks running in softirq context)?
