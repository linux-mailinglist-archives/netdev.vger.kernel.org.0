Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71FD288C1C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbgJIPDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:03:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:38488 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389144AbgJIPDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:03:52 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQtvt-0004zM-MT; Fri, 09 Oct 2020 17:03:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQtvt-000Vcw-G4; Fri, 09 Oct 2020 17:03:45 +0200
Subject: Re: [PATCH bpf-next] xsk: introduce padding between ring pointers
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com
References: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net>
Date:   Fri, 9 Oct 2020 17:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 4:12 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Introduce one cache line worth of padding between the producer and
> consumer pointers in all the lockless rings. This so that the HW
> adjacency prefetcher will not prefetch the consumer pointer when the
> producer pointer is used and vice versa. This improves throughput
> performance for the l2fwd sample app with 2% on my machine with HW
> prefetching turned on.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!

>   net/xdp/xsk_queue.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index dc1dd5e..3c235d2 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -15,6 +15,10 @@
>   
>   struct xdp_ring {
>   	u32 producer ____cacheline_aligned_in_smp;
> +	/* Hinder the adjacent cache prefetcher to prefetch the consumer pointer if the producer
> +	 * pointer is touched and vice versa.
> +	 */
> +	u32 pad ____cacheline_aligned_in_smp;
>   	u32 consumer ____cacheline_aligned_in_smp;
>   	u32 flags;
>   };
> 

I was wondering whether we should even generalize this further for reuse
elsewhere e.g. ...

diff --git a/include/linux/cache.h b/include/linux/cache.h
index 1aa8009f6d06..5521dab01649 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -85,4 +85,17 @@
  #define cache_line_size()      L1_CACHE_BYTES
  #endif

+/*
+ * Dummy element for use in structs in order to pad a cacheline
+ * aligned element with an extra cacheline to hinder the adjacent
+ * cache prefetcher to prefetch the subsequent struct element.
+ */
+#ifndef ____cacheline_padding_in_smp
+# ifdef CONFIG_SMP
+#  define ____cacheline_padding_in_smp u8 :8 ____cacheline_aligned_in_smp
+# else
+#  define ____cacheline_padding_in_smp
+# endif /* CONFIG_SMP */
+#endif
+
  #endif /* __LINUX_CACHE_H */
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index cdb9cf3cd136..1da36423e779 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -15,11 +15,9 @@

  struct xdp_ring {
         u32 producer ____cacheline_aligned_in_smp;
-       /* Hinder the adjacent cache prefetcher to prefetch the consumer
-        * pointer if the producer pointer is touched and vice versa.
-        */
-       u32 pad ____cacheline_aligned_in_smp;
+       ____cacheline_padding_in_smp;
         u32 consumer ____cacheline_aligned_in_smp;
+       ____cacheline_padding_in_smp;
         u32 flags;
  };

... was there any improvement to also pad after the consumer given the struct
xdp_ring is also embedded into other structs?

Thanks,
Daniel
