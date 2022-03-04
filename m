Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEAA4CDC63
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbiCDS1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiCDS1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:27:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8352E1D3061;
        Fri,  4 Mar 2022 10:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1850D61534;
        Fri,  4 Mar 2022 18:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD82C340E9;
        Fri,  4 Mar 2022 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646418402;
        bh=lZ5n04NgZ1D27gTQ8O/RajGUXL+JNv3iY0Tkd5tklKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNbL0hn+u+RsOR9Tq7OrSd3wUlLkerAoPtS5gjHUcpU+6x7JAD2YYvpqrTa3tZ2oq
         fcVWGqWuTiPZ1zlQrlLv4Xq2MeisIKYE86ivbPEYuyAAdSLxkRcf6gOQk7Azh6TVhE
         9tHI8TzD5eciHd+qhVA+MmrO8U/1l5JC4CGqAgjw=
Date:   Fri, 4 Mar 2022 19:26:23 +0100
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
Subject: Re: [PATCH bpf-next v2 06/28] samples/bpf: add new hid_mouse example
Message-ID: <YiJZz6EjZ3FUsv8h@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-7-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-7-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:30PM +0100, Benjamin Tissoires wrote:
> Everything should be available in the selftest part of the tree, but
> providing an example without uhid and hidraw will be more easy to
> follow for users.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  samples/bpf/.gitignore       |   1 +
>  samples/bpf/Makefile         |   4 ++
>  samples/bpf/hid_mouse_kern.c |  66 ++++++++++++++++++
>  samples/bpf/hid_mouse_user.c | 129 +++++++++++++++++++++++++++++++++++
>  4 files changed, 200 insertions(+)
>  create mode 100644 samples/bpf/hid_mouse_kern.c
>  create mode 100644 samples/bpf/hid_mouse_user.c
> 
> diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> index 0e7bfdbff80a..65440bd618b2 100644
> --- a/samples/bpf/.gitignore
> +++ b/samples/bpf/.gitignore
> @@ -2,6 +2,7 @@
>  cpustat
>  fds_example
>  hbm
> +hid_mouse
>  ibumad
>  lathist
>  lwt_len_hist
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 38638845db9d..84ef458487df 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -60,6 +60,8 @@ tprogs-y += xdp_redirect_map
>  tprogs-y += xdp_redirect
>  tprogs-y += xdp_monitor
>  
> +tprogs-y += hid_mouse
> +
>  # Libbpf dependencies
>  LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
>  LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
> @@ -124,6 +126,7 @@ xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
>  xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
>  xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
>  xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
> +hid_mouse-objs := hid_mouse_user.o
>  
>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
> @@ -181,6 +184,7 @@ always-y += ibumad_kern.o
>  always-y += hbm_out_kern.o
>  always-y += hbm_edt_kern.o
>  always-y += xdpsock_kern.o
> +always-y += hid_mouse_kern.o
>  
>  ifeq ($(ARCH), arm)
>  # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
> diff --git a/samples/bpf/hid_mouse_kern.c b/samples/bpf/hid_mouse_kern.c
> new file mode 100644
> index 000000000000..c24a12e06b40
> --- /dev/null
> +++ b/samples/bpf/hid_mouse_kern.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2021 Benjamin Tissoires

It's 2022 now :(

Other than that, looks nice and simple, good work!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
