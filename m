Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374EC50E3C4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242673AbiDYO57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242675AbiDYO5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:57:54 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A3D36319;
        Mon, 25 Apr 2022 07:54:49 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj06y-000DXg-1G; Mon, 25 Apr 2022 16:54:48 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj06x-000K3I-NO; Mon, 25 Apr 2022 16:54:47 +0200
Subject: Re: [PATCH bpf-next] bpftoo: Support user defined vmlinux path
To:     Jianlin Lv <iecedge@gmail.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        quentin@isovalent.com, jean-philippe@linaro.org,
        mauricio@kinvolk.io, ytcoode@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jianlv@ebay.com
References: <20220425075724.48540-1-jianlv@ebay.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <873eaf55-6e9d-7f19-232c-6d55e1d33d89@iogearbox.net>
Date:   Mon, 25 Apr 2022 16:54:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220425075724.48540-1-jianlv@ebay.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 9:57 AM, Jianlin Lv wrote:
> From: Jianlin Lv <iecedge@gmail.com>
> 
> Add EXTERNAL_PATH variable that define unconventional vmlinux path
> 
> Signed-off-by: Jianlin Lv <iecedge@gmail.com>
> ---
> When building Ubuntu-5.15.0 kernel, '../../../vmlinux' cannot locate
> compiled vmlinux image. Incorrect vmlinux generated vmlinux.h missing some
> structure definitions that broken compiling pipe.

You should already be able to define custom VMLINUX_BTF_PATHS, no?

See commit :

commit ec23eb705620234421fd48fc2382490fcfbafc37
Author: Andrii Nakryiko <andriin@fb.com>
Date:   Mon Jun 29 17:47:58 2020 -0700

     tools/bpftool: Allow substituting custom vmlinux.h for the build

> ---
>   tools/bpf/bpftool/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c6d2c77d0252..fefa3b763eb7 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -160,6 +160,7 @@ $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
>   VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
>   		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
>   		     ../../../vmlinux					\
> +		     $(if $(EXTERNAL_PATH),$(EXTERNAL_PATH)/vmlinux)	\
>   		     /sys/kernel/btf/vmlinux				\
>   		     /boot/vmlinux-$(shell uname -r)
>   VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> 

