Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20C5842B3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiG1PMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiG1PMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:12:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E6754AE6;
        Thu, 28 Jul 2022 08:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4796B82495;
        Thu, 28 Jul 2022 15:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A287C433D6;
        Thu, 28 Jul 2022 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659021160;
        bh=WhA/ckzTBm+8Dp8WwZDawmWD2DX62ACRlGO+kSspKMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Chunc4kYxYsCQE/dMUfZERtZnUkAqWJs2po2zdkmjG5RIc6hf1Mb1KDgL344asVLM
         e3fYA7RCfuGfeb+bCqPlS9Vx64f7TKUIi1dpHbBTya1qec8J8rM3qJYK8oZbqb5y6L
         aV98A5qJV55XrTx2kLyvecyLmk6ObCBTnw9WQIS0=
Date:   Thu, 28 Jul 2022 17:12:38 +0200
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
Subject: Re: [PATCH bpf-next v7 23/24] HID: bpf: add Surface Dial example
Message-ID: <YuKnZjtOtHAKVIqX@kroah.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-24-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-24-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:36:24PM +0200, Benjamin Tissoires wrote:
> Add a more complete HID-BPF example.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v7:
> - remove unnecessary __must_check definition
> 
> new in v6
> 
> fix surface dial
> ---
>  samples/bpf/.gitignore             |   1 +
>  samples/bpf/Makefile               |   6 +-
>  samples/bpf/hid_surface_dial.bpf.c | 161 ++++++++++++++++++++++
>  samples/bpf/hid_surface_dial.c     | 212 +++++++++++++++++++++++++++++
>  4 files changed, 379 insertions(+), 1 deletion(-)
>  create mode 100644 samples/bpf/hid_surface_dial.bpf.c
>  create mode 100644 samples/bpf/hid_surface_dial.c
> 
> diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> index 65440bd618b2..6a1079d3d064 100644
> --- a/samples/bpf/.gitignore
> +++ b/samples/bpf/.gitignore
> @@ -3,6 +3,7 @@ cpustat
>  fds_example
>  hbm
>  hid_mouse
> +hid_surface_dial
>  ibumad
>  lathist
>  lwt_len_hist
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index a965bbfaca47..5f5aa7b32565 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -58,6 +58,7 @@ tprogs-y += xdp_redirect
>  tprogs-y += xdp_monitor
>  
>  tprogs-y += hid_mouse
> +tprogs-y += hid_surface_dial
>  
>  # Libbpf dependencies
>  LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
> @@ -122,6 +123,7 @@ xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
>  xdp_router_ipv4-objs := xdp_router_ipv4_user.o $(XDP_SAMPLE)
>  
>  hid_mouse-objs := hid_mouse.o
> +hid_surface_dial-objs := hid_surface_dial.o
>  
>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
> @@ -343,6 +345,7 @@ $(obj)/hbm.o: $(src)/hbm.h
>  $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>  
>  $(obj)/hid_mouse.o: $(obj)/hid_mouse.skel.h
> +$(obj)/hid_surface_dial.o: $(obj)/hid_surface_dial.skel.h
>  
>  # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
>  # TPROGS_CFLAGS causes conflicts
> @@ -429,9 +432,10 @@ $(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
>  	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=)) > $@
>  
>  # Generate BPF skeletons for non XDP progs
> -OTHER_BPF_SKELS := hid_mouse.skel.h
> +OTHER_BPF_SKELS := hid_mouse.skel.h hid_surface_dial.skel.h
>  
>  hid_mouse.skel.h-deps := hid_mouse.bpf.o
> +hid_surface_dial.skel.h-deps := hid_surface_dial.bpf.o
>  
>  OTHER_BPF_SRCS_LINKED := $(patsubst %.skel.h,%.bpf.c, $(OTHER_BPF_SKELS))
>  OTHER_BPF_OBJS_LINKED := $(patsubst %.bpf.c,$(obj)/%.bpf.o, $(OTHER_BPF_SRCS_LINKED))
> diff --git a/samples/bpf/hid_surface_dial.bpf.c b/samples/bpf/hid_surface_dial.bpf.c
> new file mode 100644
> index 000000000000..16c821d3decf
> --- /dev/null
> +++ b/samples/bpf/hid_surface_dial.bpf.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Benjamin Tissoires
> + */

No hints as to what this, and the other program are doing here in a
comment?

> +
> +	while (running)
> +		;

That's burning up a CPU, why not sleep/yield/something to allow the cpu
to not just pound on this variable and allow other things to happen?

thanks,

greg k-h
