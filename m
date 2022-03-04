Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848214CDCD3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiCDSmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiCDSmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:42:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717951C887D;
        Fri,  4 Mar 2022 10:41:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24488B82AB6;
        Fri,  4 Mar 2022 18:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A04BC340E9;
        Fri,  4 Mar 2022 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646419275;
        bh=uxk8jrltaI2bVraUdYKTkU9k+XFyK/OnzyDp1sbSgVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sUcs4WgIH6R+ZZEPQK4UoiWMqAYIJXAgGfqZAYzJonteRITY92L2DwiOF7rRyQlBD
         1Be95H+zW+ls6ErzlcclmLSqlGkxyNnGFyzfUrue1pFJDJRfHNJXSoPH4Y+A6Ikhyf
         7+O0Lpanus/sCgGHDKahstBt0GzMjFzZc2zlHvz8=
Date:   Fri, 4 Mar 2022 19:41:09 +0100
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
Subject: Re: [PATCH bpf-next v2 12/28] bpf/hid: add hid_{get|set}_data helpers
Message-ID: <YiJdRQxYzfncfTR5@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-13-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-13-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:36PM +0100, Benjamin Tissoires wrote:
> When we process an incoming HID report, it is common to have to account
> for fields that are not aligned in the report. HID is using 2 helpers
> hid_field_extract() and implement() to pick up any data at any offset
> within the report.
> 
> Export those 2 helpers in BPF programs so users can also rely on them.
> The second net worth advantage of those helpers is that now we can
> fetch data anywhere in the report without knowing at compile time the
> location of it. The boundary checks are done in hid-bpf.c, to prevent
> a memory leak.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v2:
> - split the patch with libbpf and HID left outside.
> ---
>  include/linux/bpf-hid.h        |  4 +++
>  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++++
>  kernel/bpf/hid.c               | 53 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++++
>  4 files changed, 121 insertions(+)
> 
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> index 0c5000b28b20..69bb28523ceb 100644
> --- a/include/linux/bpf-hid.h
> +++ b/include/linux/bpf-hid.h
> @@ -93,6 +93,10 @@ struct bpf_hid_hooks {
>  	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
>  	void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
>  	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> +	int (*hid_get_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> +			    u64 offset, u32 n, u8 *data, u64 data_size);
> +	int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> +			    u64 offset, u32 n, u8 *data, u64 data_size);
>  };
>  
>  #ifdef CONFIG_BPF
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a7a8d9cfcf24..4845a20e6f96 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5090,6 +5090,36 @@ union bpf_attr {
>   *	Return
>   *		0 on success, or a negative error in case of failure. On error
>   *		*dst* buffer is zeroed out.
> + *
> + * int bpf_hid_get_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> + *	Description
> + *		Get the data of size n (in bits) at the given offset (bits) in the
> + *		ctx->event.data field and store it into data.
> + *
> + *		if n is less or equal than 32, we can address with bit precision,
> + *		the value in the buffer. However, data must be a pointer to a u32
> + *		and size must be 4.
> + *
> + *		if n is greater than 32, offset and n must be a multiple of 8
> + *		and the result is working with a memcpy internally.
> + *	Return
> + *		The length of data copied into data. On error, a negative value
> + *		is returned.
> + *
> + * int bpf_hid_set_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> + *	Description
> + *		Set the data of size n (in bits) at the given offset (bits) in the
> + *		ctx->event.data field.
> + *
> + *		if n is less or equal than 32, we can address with bit precision,
> + *		the value in the buffer. However, data must be a pointer to a u32
> + *		and size must be 4.
> + *
> + *		if n is greater than 32, offset and n must be a multiple of 8
> + *		and the result is working with a memcpy internally.
> + *	Return
> + *		The length of data copied into ctx->event.data. On error, a negative
> + *		value is returned.

Wait, nevermind my reviewed-by previously, see my comment about how this
might be split into 4:
	bpf_hid_set_bytes()
	bpf_hid_get_bytes()
	bpf_hid_set_bits()
	bpf_hid_get_bits()

Should be easier to understand and maintain over time, right?

thanks,

greg k-h
