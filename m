Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D72178617
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgCCXBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:01:17 -0500
Received: from www62.your-server.de ([213.133.104.62]:33506 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbgCCXBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:01:17 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9GXK-00083x-ST; Wed, 04 Mar 2020 00:01:14 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9GXK-000MQg-J9; Wed, 04 Mar 2020 00:01:14 +0100
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com, yhs@fb.com
References: <20200303003233.3496043-1-andriin@fb.com>
 <20200303003233.3496043-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
Date:   Wed, 4 Mar 2020 00:01:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200303003233.3496043-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25740/Tue Mar  3 13:12:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> enum values. This preserves constants values and behavior in expressions, but
> has added advantaged of being captured as part of DWARF and, subsequently, BTF
> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> for BPF applications, as it will not require BPF users to copy/paste various
> flags and constants, which are frequently used with BPF helpers. Only those
> constants that are used/useful from BPF program side are converted.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Just thinking out loud, is there some way this could be resolved generically
either from compiler side or via additional tooling where this ends up as BTF
data and thus inside vmlinux.h as anon enum eventually? bpf.h is one single
header and worst case libbpf could also ship a copy of it (?), but what about
all the other things one would need to redefine e.g. for tracing? Small example
that comes to mind are all these TASK_* defines in sched.h etc, and there's
probably dozens of other similar stuff needed too depending on the particular
case; would be nice to have some generic catch-all, hmm.

> ---
>   include/uapi/linux/bpf.h       | 175 ++++++++++++++++++++------------
>   tools/include/uapi/linux/bpf.h | 177 ++++++++++++++++++++-------------
>   2 files changed, 219 insertions(+), 133 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8e98ced0963b..3ce4e8759661 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -325,44 +325,46 @@ enum bpf_attach_type {
>   #define BPF_PSEUDO_CALL		1
>   
>   /* flags for BPF_MAP_UPDATE_ELEM command */
> -#define BPF_ANY		0 /* create new element or update existing */
> -#define BPF_NOEXIST	1 /* create new element if it didn't exist */
> -#define BPF_EXIST	2 /* update existing element */
> -#define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
> +enum {
> +	BPF_ANY		= 0, /* create new element or update existing */
> +	BPF_NOEXIST	= 1, /* create new element if it didn't exist */
> +	BPF_EXIST	= 2, /* update existing element */
> +	BPF_F_LOCK	= 4, /* spin_lock-ed map_lookup/map_update */
> +};
[...]
