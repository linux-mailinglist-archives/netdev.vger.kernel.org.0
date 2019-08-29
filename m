Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8698BA1F42
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfH2Pcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:32:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:58502 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2Pcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 11:32:47 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3MPU-0007r1-Jo; Thu, 29 Aug 2019 17:32:28 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i3MPU-0006H0-Dd; Thu, 29 Aug 2019 17:32:28 +0200
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
To:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc:     davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
Date:   Thu, 29 Aug 2019 17:32:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190829051253.1927291-2-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25556/Thu Aug 29 10:25:39 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
> Implement permissions as stated in uapi/linux/capability.h
> 
> Note that CAP_SYS_ADMIN is replaced with CAP_BPF.
> All existing applications that use BPF do not drop all caps
> and keep only CAP_SYS_ADMIN before doing bpf() syscall.
> Hence it's highly unlikely that existing code will break.
> If there will be reports of breakage then CAP_SYS_ADMIN
> would be allowed as well with "it's usage is deprecated" message
> similar to commit ee24aebffb75 ("cap_syslog: accept CAP_SYS_ADMIN for now")
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[...]
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 22066a62c8c9..f459315625ac 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -244,9 +244,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
>   	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
>   		     offsetof(struct htab_elem, hash_node.pprev));
>   
> -	if (lru && !capable(CAP_SYS_ADMIN))
> +	if (lru && !capable(CAP_BPF))
>   		/* LRU implementation is much complicated than other
> -		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
> +		 * maps.  Hence, limit to CAP_BPF.
>   		 */
>   		return -EPERM;
>   
I don't think this works, this is pretty much going to break use cases where
orchestration daemons are deployed as containers that are explicitly granted
specified cap set and right now this is CAP_SYS_ADMIN and not CAP_BPF for bpf().
The former needs to be a superset of the latter in order for this to work and
not break compatibility between kernel upgrades.

- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container
- https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities

Thanks,
Daniel
