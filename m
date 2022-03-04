Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC644CDC46
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiCDSWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiCDSWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2C81D3045;
        Fri,  4 Mar 2022 10:21:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C56BB82A88;
        Fri,  4 Mar 2022 18:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D9BC340E9;
        Fri,  4 Mar 2022 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646418081;
        bh=ijAnT92eJIWDRpJp0pSBCthRFzRenCZ3oVxEs3ekiKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eJ+8W3M/Fd3dxHBMcadLocUW48x7wlVV3T950BQXjmcgY5tgOPNMVt8kdZ1dQSrAB
         hSr66zlEH6giXWJvtV6eixvm1ADH1hplwb3t3hegm7uToNSax9wicI9bMEnhFNIcuv
         CT5YoYXa6T9TA55foie+L9Vi/LsMGqOl6bQ6Tjdk=
Date:   Fri, 4 Mar 2022 19:21:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
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
Subject: Re: [PATCH bpf-next v2 02/28] bpf: introduce hid program type
Message-ID: <YiJYlfIywoG5yIMd@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-3-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-3-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:26PM +0100, Benjamin Tissoires wrote:
> HID is a protocol that could benefit from using BPF too.
> 
> This patch implements a net-like use of BPF capability for HID.
> Any incoming report coming from the device can be injected into a series
> of BPF programs that can modify it or even discard it by setting the
> size in the context to 0.
> 
> The kernel/bpf implementation is based on net-namespace.c, with only
> the bpf_link part kept, there is no real points in keeping the
> bpf_prog_{attach|detach} API.
> 
> The implementation here is only focusing on the bpf changes. The HID
> changes that hooks onto this are coming in a separate patch.
> 
> Given that HID can be compiled in as a module, and the functions that
> kernel/bpf/hid.c needs to call in hid.ko are exported in struct hid_hooks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> - unsigned long -> __u16 in uapi/linux/bpf_hid.h
> - change the bpf_ctx to be of variable size, with a min of 1024 bytes
> - make this 1 kB available directly from bpf program, the rest will
>   need a helper
> - add some more doc comments in uapi
> ---
>  include/linux/bpf-hid.h        | 108 ++++++++
>  include/linux/bpf_types.h      |   4 +
>  include/linux/hid.h            |   5 +
>  include/uapi/linux/bpf.h       |   7 +
>  include/uapi/linux/bpf_hid.h   |  39 +++
>  kernel/bpf/Makefile            |   3 +
>  kernel/bpf/hid.c               | 437 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |   8 +
>  tools/include/uapi/linux/bpf.h |   7 +
>  9 files changed, 618 insertions(+)
>  create mode 100644 include/linux/bpf-hid.h
>  create mode 100644 include/uapi/linux/bpf_hid.h
>  create mode 100644 kernel/bpf/hid.c
> 
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> new file mode 100644
> index 000000000000..3cda78051b5f
> --- /dev/null
> +++ b/include/linux/bpf-hid.h
> @@ -0,0 +1,108 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _BPF_HID_H
> +#define _BPF_HID_H
> +
> +#include <linux/mutex.h>
> +#include <uapi/linux/bpf.h>
> +#include <uapi/linux/bpf_hid.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +
> +struct bpf_prog;
> +struct bpf_prog_array;
> +struct hid_device;
> +
> +enum bpf_hid_attach_type {
> +	BPF_HID_ATTACH_INVALID = -1,
> +	BPF_HID_ATTACH_DEVICE_EVENT = 0,
> +	MAX_BPF_HID_ATTACH_TYPE
> +};
> +
> +struct bpf_hid {
> +	struct hid_bpf_ctx *ctx;
> +
> +	/* Array of programs to run compiled from links */
> +	struct bpf_prog_array __rcu *run_array[MAX_BPF_HID_ATTACH_TYPE];
> +	struct list_head links[MAX_BPF_HID_ATTACH_TYPE];
> +};
> +
> +static inline enum bpf_hid_attach_type
> +to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
> +{
> +	switch (attach_type) {
> +	case BPF_HID_DEVICE_EVENT:
> +		return BPF_HID_ATTACH_DEVICE_EVENT;
> +	default:
> +		return BPF_HID_ATTACH_INVALID;
> +	}
> +}
> +
> +static inline struct hid_bpf_ctx *bpf_hid_allocate_ctx(struct hid_device *hdev,
> +						       size_t data_size)
> +{
> +	struct hid_bpf_ctx *ctx;
> +
> +	/* ensure data_size is between min and max */
> +	data_size = clamp_val(data_size,
> +			      HID_BPF_MIN_BUFFER_SIZE,
> +			      HID_BPF_MAX_BUFFER_SIZE);

Do you want to return an error if the data size is not within the range?
Otherwise people will just start to use crazy values and you will always
be limiting them?

> +
> +	ctx = kzalloc(sizeof(*ctx) + data_size, GFP_KERNEL);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ctx->hdev = hdev;
> +	ctx->allocated_size = data_size;
> +
> +	return ctx;
> +}

And why is this an inline function?  Why not put it in a .c file?

> +
> +union bpf_attr;
> +struct bpf_prog;
> +
> +#if IS_ENABLED(CONFIG_HID)
> +int bpf_hid_prog_query(const union bpf_attr *attr,
> +		       union bpf_attr __user *uattr);
> +int bpf_hid_link_create(const union bpf_attr *attr,
> +			struct bpf_prog *prog);
> +#else
> +static inline int bpf_hid_prog_query(const union bpf_attr *attr,
> +				     union bpf_attr __user *uattr)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int bpf_hid_link_create(const union bpf_attr *attr,
> +				      struct bpf_prog *prog)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
> +static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
> +				      enum bpf_hid_attach_type type)
> +{
> +	return list_empty(&bpf->links[type]);
> +}
> +
> +struct bpf_hid_hooks {
> +	struct hid_device *(*hdev_from_fd)(int fd);
> +	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> +	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> +};
> +
> +#ifdef CONFIG_BPF
> +int bpf_hid_init(struct hid_device *hdev);
> +void bpf_hid_exit(struct hid_device *hdev);
> +void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks);
> +#else
> +static inline int bpf_hid_init(struct hid_device *hdev)
> +{
> +	return 0;
> +}
> +
> +static inline void bpf_hid_exit(struct hid_device *hdev) {}
> +static inline void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks) {}
> +#endif
> +
> +#endif /* _BPF_HID_H */
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 48a91c51c015..1509862aacc4 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -76,6 +76,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_EXT, bpf_extension,
>  BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
>  	       void *, void *)
>  #endif /* CONFIG_BPF_LSM */
> +#if IS_ENABLED(CONFIG_HID)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_HID, hid,
> +	      __u32, u32)

Why the mix of __u32 and u32 here?

> +#endif
>  #endif
>  BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
>  	      void *, void *)
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 7487b0586fe6..56f6f4ad45a7 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -15,6 +15,7 @@
>  
>  
>  #include <linux/bitops.h>
> +#include <linux/bpf-hid.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/list.h>
> @@ -639,6 +640,10 @@ struct hid_device {							/* device report descriptor */
>  	struct list_head debug_list;
>  	spinlock_t  debug_list_lock;
>  	wait_queue_head_t debug_wait;
> +
> +#ifdef CONFIG_BPF
> +	struct bpf_hid bpf;
> +#endif
>  };
>  
>  #define to_hid_device(pdev) \
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index afe3d0d7f5f2..5978b92cacd3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -952,6 +952,7 @@ enum bpf_prog_type {
>  	BPF_PROG_TYPE_LSM,
>  	BPF_PROG_TYPE_SK_LOOKUP,
>  	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +	BPF_PROG_TYPE_HID,
>  };
>  
>  enum bpf_attach_type {
> @@ -997,6 +998,7 @@ enum bpf_attach_type {
>  	BPF_SK_REUSEPORT_SELECT,
>  	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>  	BPF_PERF_EVENT,
> +	BPF_HID_DEVICE_EVENT,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> @@ -1011,6 +1013,7 @@ enum bpf_link_type {
>  	BPF_LINK_TYPE_NETNS = 5,
>  	BPF_LINK_TYPE_XDP = 6,
>  	BPF_LINK_TYPE_PERF_EVENT = 7,
> +	BPF_LINK_TYPE_HID = 8,
>  
>  	MAX_BPF_LINK_TYPE,
>  };
> @@ -5870,6 +5873,10 @@ struct bpf_link_info {
>  		struct {
>  			__u32 ifindex;
>  		} xdp;
> +		struct  {
> +			__s32 hidraw_ino;

"ino"?  We have lots of letters to spell words out :)

> +			__u32 attach_type;
> +		} hid;
>  	};
>  } __attribute__((aligned(8)));
>  
> diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
> new file mode 100644
> index 000000000000..975ca5bd526f
> --- /dev/null
> +++ b/include/uapi/linux/bpf_hid.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> +
> +/*
> + *  HID BPF public headers
> + *
> + *  Copyright (c) 2021 Benjamin Tissoires

Did you forget the copyright line on the other .h file above?

> + */
> +
> +#ifndef _UAPI__LINUX_BPF_HID_H__
> +#define _UAPI__LINUX_BPF_HID_H__
> +
> +#include <linux/types.h>
> +
> +/*
> + * The first 1024 bytes are available directly in the bpf programs.
> + * To access the rest of the data (if allocated_size is bigger
> + * than 1024, you need to use bpf_hid_ helpers.
> + */
> +#define HID_BPF_MIN_BUFFER_SIZE		1024
> +#define HID_BPF_MAX_BUFFER_SIZE		16384		/* in sync with HID_MAX_BUFFER_SIZE */

Can't you just use HID_MAX_BUFFER_SIZE?

Anyway, all minor stuff, looks good!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

