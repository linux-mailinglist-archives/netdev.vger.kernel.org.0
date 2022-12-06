Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1103C644FCF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLFXsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLFXst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:48:49 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AD827DDD;
        Tue,  6 Dec 2022 15:48:42 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p2hfp-000Fvc-La; Wed, 07 Dec 2022 00:48:29 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p2hfp-000Hk8-45; Wed, 07 Dec 2022 00:48:29 +0100
Subject: Re: [PATCH bpf-next 07/15] selftests/xsk: get rid of asm
 store/release implementations
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-8-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3489505c-3e33-880e-6f19-1796ca897553@iogearbox.net>
Date:   Wed, 7 Dec 2022 00:48:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221206090826.2957-8-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26742/Tue Dec  6 09:18:20 2022)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 10:08 AM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Get rid of our own homegrown assembly store/release and load/acquire
> implementations. Use the HW agnositic APIs the compiler offers
> instead.

The description is a bit terse. Could you add a bit more context, discussion
or reference on why it's safe to replace them with C11 atomics?

> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   tools/testing/selftests/bpf/xsk.h | 80 ++-----------------------------
>   1 file changed, 4 insertions(+), 76 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> index 997723b0bfb2..24ee765aded3 100644
> --- a/tools/testing/selftests/bpf/xsk.h
> +++ b/tools/testing/selftests/bpf/xsk.h
> @@ -23,77 +23,6 @@
>   extern "C" {
>   #endif
>   
> -/* This whole API has been deprecated and moved to libxdp that can be found at
> - * https://github.com/xdp-project/xdp-tools. The APIs are exactly the same so
> - * it should just be linking with libxdp instead of libbpf for this set of
> - * functionality. If not, please submit a bug report on the aforementioned page.
> - */
> -
> -/* Load-Acquire Store-Release barriers used by the XDP socket
> - * library. The following macros should *NOT* be considered part of
> - * the xsk.h API, and is subject to change anytime.
> - *
> - * LIBRARY INTERNAL
> - */
> -
> -#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
> -#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
> -
> -#if defined(__i386__) || defined(__x86_64__)
> -# define libbpf_smp_store_release(p, v)					\
> -	do {								\
> -		asm volatile("" : : : "memory");			\
> -		__XSK_WRITE_ONCE(*p, v);				\
> -	} while (0)
> -# define libbpf_smp_load_acquire(p)					\
> -	({								\
> -		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
> -		asm volatile("" : : : "memory");			\
> -		___p1;							\
> -	})
> -#elif defined(__aarch64__)
> -# define libbpf_smp_store_release(p, v)					\
> -		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
> -# define libbpf_smp_load_acquire(p)					\
> -	({								\
> -		typeof(*p) ___p1;					\
> -		asm volatile ("ldar %w0, %1"				\
> -			      : "=r" (___p1) : "Q" (*p) : "memory");	\
> -		___p1;							\
> -	})
> -#elif defined(__riscv)
> -# define libbpf_smp_store_release(p, v)					\
> -	do {								\
> -		asm volatile ("fence rw,w" : : : "memory");		\
> -		__XSK_WRITE_ONCE(*p, v);				\
> -	} while (0)
> -# define libbpf_smp_load_acquire(p)					\
> -	({								\
> -		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
> -		asm volatile ("fence r,rw" : : : "memory");		\
> -		___p1;							\
> -	})
> -#endif
> -
> -#ifndef libbpf_smp_store_release
> -#define libbpf_smp_store_release(p, v)					\
> -	do {								\
> -		__sync_synchronize();					\
> -		__XSK_WRITE_ONCE(*p, v);				\
> -	} while (0)
> -#endif
> -
> -#ifndef libbpf_smp_load_acquire
> -#define libbpf_smp_load_acquire(p)					\
> -	({								\
> -		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
> -		__sync_synchronize();					\
> -		___p1;							\
> -	})
> -#endif
> -
> -/* LIBRARY INTERNAL -- END */
> -
>   /* Do not access these members directly. Use the functions below. */
>   #define DEFINE_XSK_RING(name) \
>   struct name { \
> @@ -168,7 +97,7 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
>   	 * this function. Without this optimization it whould have been
>   	 * free_entries = r->cached_prod - r->cached_cons + r->size.
>   	 */
> -	r->cached_cons = libbpf_smp_load_acquire(r->consumer);
> +	r->cached_cons = __atomic_load_n(r->consumer, __ATOMIC_ACQUIRE);
>   	r->cached_cons += r->size;
>   
>   	return r->cached_cons - r->cached_prod;
> @@ -179,7 +108,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>   	__u32 entries = r->cached_prod - r->cached_cons;
>   
>   	if (entries == 0) {
> -		r->cached_prod = libbpf_smp_load_acquire(r->producer);
> +		r->cached_prod = __atomic_load_n(r->producer, __ATOMIC_ACQUIRE);
>   		entries = r->cached_prod - r->cached_cons;
>   	}
>   
> @@ -202,7 +131,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
>   	/* Make sure everything has been written to the ring before indicating
>   	 * this to the kernel by writing the producer pointer.
>   	 */
> -	libbpf_smp_store_release(prod->producer, *prod->producer + nb);
> +	__atomic_store_n(prod->producer, *prod->producer + nb, __ATOMIC_RELEASE);
>   }
>   
>   static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
> @@ -227,8 +156,7 @@ static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
>   	/* Make sure data has been read before indicating we are done
>   	 * with the entries by updating the consumer pointer.
>   	 */
> -	libbpf_smp_store_release(cons->consumer, *cons->consumer + nb);
> -
> +	__atomic_store_n(cons->consumer, *cons->consumer + nb, __ATOMIC_RELEASE);
>   }
>   
>   static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
> 

