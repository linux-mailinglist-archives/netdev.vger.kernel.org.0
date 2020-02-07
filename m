Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74589155F0F
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 21:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGUNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 15:13:07 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32803 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgBGUNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 15:13:06 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so202967plb.0;
        Fri, 07 Feb 2020 12:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=kcQAMbXiKsyHfk8kEqjCjb6+QVO8ymQGE7x+ZDv0a5M=;
        b=RKpQqBJbluyp2umIgj+e3Hn/E0+1a9K1Bviue7ZHC8diWUVzoGGx7cM85PaM6ydxLD
         CYh3hCcRtJc/9S01lgNSBNslZSTiGNLh0zgf0vCzYfPDz3pQkD7Jaz1OhqKQVjoiPfcO
         DGfmq/uKK2m00/50SylvosZuz5BP39/UXV37qA5+klu6pNuJ5VhPwPoF9OjqwB34I80O
         F7LtLmPE+cV/q/xKMVPXsLhPN3KDC63/r8encJ0787LJXFfd5jxRHEvURtaxQQea5mfv
         KdaenLAviB5cYk/qtWPSvh8mgPojlWaxiK52dMoTziKE2xP5Nm9uDf6iszeqCeaAI0V6
         0BiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kcQAMbXiKsyHfk8kEqjCjb6+QVO8ymQGE7x+ZDv0a5M=;
        b=f/7bnzY0fxJa4yYUAHvOg4IVItnbPoVzuD9GfyBWn/xWs7pEH9xBlpZztW+undC5Nj
         l1ykgEO6DJAnSkvkoO1gZUWUdsc1b/VNbFAkZ5JNGS2GNCXJEvdUzBpPZ8WOTo0lMcAh
         TeeZjxCfzKnxBHP/W3vkDRsXl2CdIpUNABHsfR28O0n/aYfKW4vPLlgdZ++xxo80mEGA
         HHJh0qw7HUqQR4+OnrmdHtz5zSKYPpl7JJ9rDIY9UyzJeXO2IHtxEeyOlqsqTef2vN56
         nobLzPa/9JPZGXReqDnoiwO/UuYnpRpRULfPOQzR7agikTpIE0wsP+YScnJXJPYWQelG
         nl+g==
X-Gm-Message-State: APjAAAUgIJqk0tm/MCwFy+o3Q+DF1xIm0by91EeT4fpN4enWEPvweaXY
        Wa8WHlulhEu5AOZ2d0HejwA=
X-Google-Smtp-Source: APXvYqwL80v+je9ysxmEnt4t9B4PfF81b9Xdht1ywC6cDF8hPAmyvBd1nJ/rbsyerp5AdJ1J8yZdUw==
X-Received: by 2002:a17:902:9698:: with SMTP id n24mr89639plp.312.1581106385771;
        Fri, 07 Feb 2020 12:13:05 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:3970])
        by smtp.gmail.com with ESMTPSA id y64sm3716408pgb.25.2020.02.07.12.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Feb 2020 12:13:05 -0800 (PST)
Date:   Fri, 7 Feb 2020 12:13:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH bpf] bpf: Improve bucket_log calculation logic
Message-ID: <20200207201301.wpq4abick4j3rucl@ast-mbp.dhcp.thefacebook.com>
References: <20200207081810.3918919-1-kafai@fb.com>
 <CAHk-=wieADOQcYkehVN7meevnd3jZrq06NkmyH9GGR==2rEpuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wieADOQcYkehVN7meevnd3jZrq06NkmyH9GGR==2rEpuQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 10:07:32AM -0800, Linus Torvalds wrote:
> On Fri, Feb 7, 2020 at 12:18 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > It was reported that the max_t, ilog2, and roundup_pow_of_two macros have
> > exponential effects on the number of states in the sparse checker.
> 
> Patch looks good, but I'd like to point out that it's not just sparse.
> 
> You can see it with a simple
> 
>     make net/core/bpf_sk_storage.i
>     grep 'smap->bucket_log = ' net/core/bpf_sk_storage.i | wc
> 
> and see the end result:
> 
>       1  365071 2686974
> 
> That's one line (the assignment line) that is 2,686,974 characters in length.

In addition to this patch I've tried:
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 83a4a3ca3e8a..7363abf60854 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -74,74 +74,76 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
  * Use this where sparse expects a true constant expression, e.g. for array
  * indices.
  */
-#define const_ilog2(n)                         \
-(                                              \
-       __builtin_constant_p(n) ? (             \
-               (n) < 2 ? 0 :                   \
-               (n) & (1ULL << 63) ? 63 :       \
-               (n) & (1ULL << 62) ? 62 :       \
...
+#define __const_ilog2(n, unique_n) ({                  \
+       typeof(n) unique_n = (n);                       \
+       __builtin_constant_p(unique_n) ? (              \
+               (unique_n) < 2 ? 0 :                    \
+               (unique_n) & (1ULL << 63) ? 63 :        \
+               (unique_n) & (1ULL << 62) ? 62 :        \
+               (unique_n) & (1ULL << 61) ? 61 :        \
+               (unique_n) & (1ULL << 60) ? 60 :        \
+               (unique_n) & (1ULL << 59) ? 59 :        \
...
+               (unique_n) & (1ULL <<  3) ?  3 :        \
+               (unique_n) & (1ULL <<  2) ?  2 :        \
                1) :                            \
-       -1)
+       -1; })
+
+#define const_ilog2(n) __const_ilog2(n, __UNIQUE_ID(__n))

and for this nested ilog2() case that caused this explosion
the line got shorter: from 2.6M characters to 144k.
Still a lot.
Unfortunately this approach doesn't work in all cases:
../include/linux/log2.h:77:36: error: braced-group within expression allowed only inside a function
   77 | #define __const_ilog2(n, unique_n) ({   \
      |                                    ^
../include/linux/log2.h:146:24: note: in expansion of macro ‘__const_ilog2’
  146 | #define const_ilog2(n) __const_ilog2(n, __UNIQUE_ID(__n))
      |                        ^~~~~~~~~~~~~
../include/linux/log2.h:161:2: note: in expansion of macro ‘const_ilog2’
  161 |  const_ilog2(n) :  \
      |  ^~~~~~~~~~~
../include/linux/blockgroup_lock.h:14:27: note: in expansion of macro ‘ilog2’
   14 | #define NR_BG_LOCKS (4 << ilog2(NR_CPUS < 32 ? NR_CPUS : 32))
      |                           ^~~~~
../include/linux/blockgroup_lock.h:24:24: note: in expansion of macro ‘NR_BG_LOCKS’
   24 |  struct bgl_lock locks[NR_BG_LOCKS];

Just fyi for folks who're looking at ilog2 and wondering
why it was done this way without ({ })
