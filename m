Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43BC5840EF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiG1OT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiG1OT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C2852E7B;
        Thu, 28 Jul 2022 07:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D997660CF5;
        Thu, 28 Jul 2022 14:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B743CC433C1;
        Thu, 28 Jul 2022 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659017995;
        bh=U5iozSv/8RP3dsBx9k6LZep1YUm9fKbhqK00jFLY6MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PSaiytatvrk5GSUslwFa5vrteSRxZWvGSSS3IJrNjkht2SCbj6v4HHbWgwpFYpeZF
         sqFC/VVHrn1wkSpMEsHGQvYJcEYfSxYgCU8sdL75lXqIqXcDDoZWUHLhXxf8tncm4f
         bAVq+OXuSLiOqXXaPJvC2mlQq0+4bSklCLZcTlRM=
Date:   Thu, 28 Jul 2022 16:19:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 13/24] HID: initial BPF implementation
Message-ID: <YuKbCCOAtSvUlI3z@kroah.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:36:14PM +0200, Benjamin Tissoires wrote:
> --- /dev/null
> +++ b/include/linux/hid_bpf.h
> @@ -0,0 +1,102 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */

This is not a uapi .h file, so the "WITH Linux-syscall-note" should not
be here, right?


> +
> +#ifndef __HID_BPF_H
> +#define __HID_BPF_H
> +
> +#include <linux/spinlock.h>
> +#include <uapi/linux/hid.h>
> +#include <uapi/linux/hid_bpf.h>
> +
> +struct hid_device;
> +
> +/*
> + * The following is the HID BPF API.
> + *
> + * It should be treated as UAPI, so extra care is required
> + * when making change to this file.

So is this uapi?  If so, shouldn't it go into a uapi include directory
so we know this and properly track it and maintain it that way?

> + */
> +
> +/**
> + * struct hid_bpf_ctx - User accessible data for all HID programs
> + *
> + * ``data`` is not directly accessible from the context. We need to issue
> + * a call to ``hid_bpf_get_data()`` in order to get a pointer to that field.
> + *
> + * All of these fields are currently read-only.
> + *
> + * @index: program index in the jump table. No special meaning (a smaller index
> + *         doesn't mean the program will be executed before another program with
> + *         a bigger index).
> + * @hid: the ``struct hid_device`` representing the device itself
> + * @report_type: used for ``hid_bpf_device_event()``
> + * @size: Valid data in the data field.
> + *
> + *        Programs can get the available valid size in data by fetching this field.
> + */
> +struct hid_bpf_ctx {
> +	__u32 index;
> +	const struct hid_device *hid;
> +	enum hid_report_type report_type;
> +	__s32 size;
> +};
> +
> +/* Following functions are tracepoints that BPF programs can attach to */
> +int hid_bpf_device_event(struct hid_bpf_ctx *ctx);
> +
> +/* Following functions are kfunc that we export to BPF programs */
> +/* only available in tracing */
> +__u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t __sz);
> +
> +/* only available in syscall */
> +int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags);
> +
> +/*
> + * Below is HID internal
> + */
> +
> +/* internal function to call eBPF programs, not to be used by anybody */
> +int __hid_bpf_tail_call(struct hid_bpf_ctx *ctx);
> +
> +#define HID_BPF_MAX_PROGS_PER_DEV 64
> +#define HID_BPF_FLAG_MASK (((HID_BPF_FLAG_MAX - 1) << 1) - 1)
> +
> +/* types of HID programs to attach to */
> +enum hid_bpf_prog_type {
> +	HID_BPF_PROG_TYPE_UNDEF = -1,
> +	HID_BPF_PROG_TYPE_DEVICE_EVENT,			/* an event is emitted from the device */
> +	HID_BPF_PROG_TYPE_MAX,
> +};
> +
> +struct hid_bpf_ops {
> +	struct module *owner;
> +	struct bus_type *bus_type;
> +};
> +
> +extern struct hid_bpf_ops *hid_bpf_ops;
> +
> +struct hid_bpf_prog_list {
> +	u16 prog_idx[HID_BPF_MAX_PROGS_PER_DEV];
> +	u8 prog_cnt;
> +};
> +
> +/* stored in each device */
> +struct hid_bpf {
> +	struct hid_bpf_prog_list __rcu *progs[HID_BPF_PROG_TYPE_MAX];	/* attached BPF progs */
> +	bool destroyed;			/* prevents the assignment of any progs */
> +
> +	spinlock_t progs_lock;		/* protects RCU update of progs */
> +};
> +
> +#ifdef CONFIG_HID_BPF
> +int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
> +				  u32 size, int interrupt);
> +void hid_bpf_destroy_device(struct hid_device *hid);
> +void hid_bpf_device_init(struct hid_device *hid);
> +#else /* CONFIG_HID_BPF */
> +static inline int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
> +						u32 size, int interrupt) { return 0; }
> +static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
> +static inline void hid_bpf_device_init(struct hid_device *hid) {}
> +#endif /* CONFIG_HID_BPF */
> +
> +#endif /* __HID_BPF_H */
> diff --git a/include/uapi/linux/hid_bpf.h b/include/uapi/linux/hid_bpf.h
> new file mode 100644
> index 000000000000..ba8caf9b60ee
> --- /dev/null
> +++ b/include/uapi/linux/hid_bpf.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */

This is fine, it is in include/uapi/

Other than those minor comments, this all looks good to me!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
