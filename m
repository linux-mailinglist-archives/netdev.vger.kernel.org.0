Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6507A34BB85
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 09:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhC1HYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 03:24:39 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:49711 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhC1HYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 03:24:10 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1lQPmL-001GUe-Cn; Sun, 28 Mar 2021 09:24:09 +0200
Received: from dynamic-078-054-150-182.78.54.pool.telefonica.de ([78.54.150.182] helo=[192.168.1.10])
          by inpost2.zedat.fu-berlin.de (Exim 4.94)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lQPmL-0041C0-5c; Sun, 28 Mar 2021 09:24:09 +0200
Subject: Re: [PATCH] tools: Remove duplicate definition of ia64_mf() on ia64
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210323182520.858611-1-glaubitz@physik.fu-berlin.de>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <568b0f11-de1b-e76d-db4f-c84e7e03d41e@physik.fu-berlin.de>
Date:   Sun, 28 Mar 2021 09:24:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323182520.858611-1-glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 78.54.150.182
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 3/23/21 7:25 PM, John Paul Adrian Glaubitz wrote:
> The ia64_mf() macro defined in tools/arch/ia64/include/asm/barrier.h
> is already defined in <asm/gcc_intrin.h> on ia64 which causes libbpf
> failing to build:
> 
>   CC       /usr/src/linux/tools/bpf/bpftool//libbpf/staticobjs/libbpf.o
> In file included from /usr/src/linux/tools/include/asm/barrier.h:24,
>                  from /usr/src/linux/tools/include/linux/ring_buffer.h:4,
>                  from libbpf.c:37:
> /usr/src/linux/tools/include/asm/../../arch/ia64/include/asm/barrier.h:43: error: "ia64_mf" redefined [-Werror]
>    43 | #define ia64_mf()       asm volatile ("mf" ::: "memory")
>       |
> In file included from /usr/include/ia64-linux-gnu/asm/intrinsics.h:20,
>                  from /usr/include/ia64-linux-gnu/asm/swab.h:11,
>                  from /usr/include/linux/swab.h:8,
>                  from /usr/include/linux/byteorder/little_endian.h:13,
>                  from /usr/include/ia64-linux-gnu/asm/byteorder.h:5,
>                  from /usr/src/linux/tools/include/uapi/linux/perf_event.h:20,
>                  from libbpf.c:36:
> /usr/include/ia64-linux-gnu/asm/gcc_intrin.h:382: note: this is the location of the previous definition
>   382 | #define ia64_mf() __asm__ volatile ("mf" ::: "memory")
>       |
> cc1: all warnings being treated as errors
> 
> Thus, remove the definition from tools/arch/ia64/include/asm/barrier.h.
> 
> Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> ---
>  tools/arch/ia64/include/asm/barrier.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/arch/ia64/include/asm/barrier.h b/tools/arch/ia64/include/asm/barrier.h
> index 4d471d9511a5..6fffe5682713 100644
> --- a/tools/arch/ia64/include/asm/barrier.h
> +++ b/tools/arch/ia64/include/asm/barrier.h
> @@ -39,9 +39,6 @@
>   * sequential memory pages only.
>   */
>  
> -/* XXX From arch/ia64/include/uapi/asm/gcc_intrin.h */
> -#define ia64_mf()       asm volatile ("mf" ::: "memory")
> -
>  #define mb()		ia64_mf()
>  #define rmb()		mb()
>  #define wmb()		mb()
> 

Shall I ask Andrew Morton to pick up this patch? It's needed to fix the Debian
kernel build on ia64 and it would be great if it could be included for 5.12.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

