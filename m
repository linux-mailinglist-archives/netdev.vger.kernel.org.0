Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3864D2A9F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiCII2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCII2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:28:14 -0500
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE146C12DD;
        Wed,  9 Mar 2022 00:27:15 -0800 (PST)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 75846101C67; Wed,  9 Mar 2022 08:27:11 +0000 (UTC)
Date:   Wed, 9 Mar 2022 08:27:11 +0000
From:   Sean Young <sean@mess.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 01/28] bpf: add new is_sys_admin_prog_type()
 helper
Message-ID: <Yihk34SLS6ZYS01D@gofer.mess.org>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-2-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-2-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:25PM +0100, Benjamin Tissoires wrote:
> LIRC_MODE2 does not really need net_admin capability, but only sys_admin.
> 
> Extract a new helper for it, it will be also used for the HID bpf
> implementation.
> 
> Cc: Sean Young <sean@mess.org>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

For BPF_PROG_TYPE_LIRC_MODE2, I don't think this change will break userspace.
This is called from ir-keytable(1) which is called from udev. It should have
all the necessary permissions.

In addition, the vast majority IR decoders are non-bpf. bpf ir decoders have
very few users at the moment.

Acked-by: Sean Young <sean@mess.org>


Sean

> 
> ---
> 
> new in v2
> ---
>  kernel/bpf/syscall.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index db402ebc5570..cc570891322b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2165,7 +2165,6 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>  	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
>  	case BPF_PROG_TYPE_SK_SKB:
>  	case BPF_PROG_TYPE_SK_MSG:
> -	case BPF_PROG_TYPE_LIRC_MODE2:
>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>  	case BPF_PROG_TYPE_CGROUP_SOCK:
> @@ -2202,6 +2201,17 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
>  	}
>  }
>  
> +static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> +{
> +	switch (prog_type) {
> +	case BPF_PROG_TYPE_LIRC_MODE2:
> +	case BPF_PROG_TYPE_EXT: /* extends any prog */
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /* last field in 'union bpf_attr' used by this command */
>  #define	BPF_PROG_LOAD_LAST_FIELD core_relo_rec_size
>  
> @@ -2252,6 +2262,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  		return -EPERM;
>  	if (is_perfmon_prog_type(type) && !perfmon_capable())
>  		return -EPERM;
> +	if (is_sys_admin_prog_type(type) && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
>  
>  	/* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
>  	 * or btf, we need to check which one it is
> -- 
> 2.35.1
