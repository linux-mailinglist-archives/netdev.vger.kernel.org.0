Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E581D298E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgENICE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:02:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:33606 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgENICD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:02:03 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ8ob-0000Bn-Hu; Thu, 14 May 2020 10:02:01 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ8ob-000QuX-9S; Thu, 14 May 2020 10:02:01 +0200
Subject: Re: [bpf-next PATCH 2/3] bpf: sk_msg helpers for probe_* and
 *current_task*
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, jakub@cloudflare.com,
        netdev@vger.kernel.org
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
 <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <384e5835-a241-bc5d-9f3c-729aac4866f3@iogearbox.net>
Date:   Thu, 14 May 2020 10:02:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 9:24 PM, John Fastabend wrote:
> Often it is useful when applying policy to know something about the
> task. If the administrator has CAP_SYS_ADMIN rights then they can
> use kprobe + sk_msg and link the two programs together to accomplish
> this. However, this is a bit clunky and also means we have to call
> sk_msg program and kprobe program when we could just use a single
> program and avoid passing metadata through sk_msg/skb, socket, etc.
> 
> To accomplish this add probe_* helpers to sk_msg programs guarded
> by a CAP_SYS_ADMIN check. New supported helpers are the following,
> 
>   BPF_FUNC_get_current_task
>   BPF_FUNC_current_task_under_cgroup
>   BPF_FUNC_probe_read_user
>   BPF_FUNC_probe_read_kernel
>   BPF_FUNC_probe_read
>   BPF_FUNC_probe_read_user_str
>   BPF_FUNC_probe_read_kernel_str
>   BPF_FUNC_probe_read_str

Given the current discussion in the other thread with Linus et al, please
don't add more users for BPF_FUNC_probe_read and BPF_FUNC_probe_read_str
as I'm cooking up a patch to disable them on non-x86, and cleanups from
Christoph would make them less efficient than the *_user/_kernel{,_str}()
versions anyway, so lets only add the latter.

Thanks,
Daniel
