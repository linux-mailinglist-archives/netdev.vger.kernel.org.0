Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C095E58FF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIVDKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIVDK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:10:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA366717C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b75so7948092pfb.7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Vn16rLGrbDDjaKey8W5tBl33Bv/zSWk+J99kOTcbUQE=;
        b=AE85R2lewHV6WpJoVOU7vYZV1LEmLLSYclgKQnUnY2xKVDNii5Fo/BkTgD3yH2NCT3
         SVad2gPnMgif6X0cTuEEQWajnZUigllF8Swz/AIt7V/3KOVHG8p4eV2QEjA7+Ig8Tbzm
         hCWNqHwmKS+0LzUeaR2ah/lhPJclhFqcjfbic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Vn16rLGrbDDjaKey8W5tBl33Bv/zSWk+J99kOTcbUQE=;
        b=rrSk1ZMIYrAJ/ve7ueg0lEw4qw/B6ikOEINzo7eP5KtiyyQ3kTQRsqK3Gu5F2lFYCH
         FZZQUrj0aMZCluR5PO/PUbAiA+/WI/4ThapdGeB9WLYRp83ZdL96Iad2VmnE3WEcK9eT
         DXVl4PgaO0USfTjNSwl82/UMEuj/4P1C2JVozgaF+LSM7iOpHUt7UfdEbu0PyGLOHd8k
         n+kQ3Qg9tZxQX3wpJMd4APigeceN+dtUFkPgzxmETqHNl5hdEBdkbUxsANz+rUaYDYja
         6bqvnjAA1xf90fCnXfUJDxWJ7dMhAK1z6D3MJtNXL0YplrJ1upnACuvDkOjN3SY4S4O7
         QY2w==
X-Gm-Message-State: ACrzQf3JHp0e10jNTAFTobreZz5V+nmNFGjLu0v/4FUWbPeaAoimToR1
        be03WjFZ2RPigtMAk9ZK2/u2Yw==
X-Google-Smtp-Source: AMsMyM5kbtfQXBGy+UgqYmJ89cy++RVO/0JPV5R9E0qA9P5D2h03X/wzrRsUp18SKmZq4kCTVEHctQ==
X-Received: by 2002:a05:6a00:2314:b0:546:ce91:89a3 with SMTP id h20-20020a056a00231400b00546ce9189a3mr1393996pfh.77.1663816223317;
        Wed, 21 Sep 2022 20:10:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q21-20020a170902bd9500b001785fa792f4sm2713016pls.243.2022.09.21.20.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:22 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH 00/12] slab: Introduce kmalloc_size_roundup()
Date:   Wed, 21 Sep 2022 20:10:01 -0700
Message-Id: <20220922031013.2150682-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4981; h=from:subject; bh=s4SaVhOuX1ncHIDJErOKK4BV4PgBIHpDN/h97+EEvV8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9ISNp90ZWOfSod9OsDV3Pgtvy1E13pzv3DCmYbF tf0g8d2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEgAKCRCJcvTf3G3AJkzwD/ wIy7miKIK9lOw6XzF5heENIATw2uhYlNzjs0acveP+ZCyoyc5I/WgCfqRAXAmHiXedbujzGw2FDqqT syY2emsesoSNP3gS/GOKo8RJDSOQC9cSQtEjb+mjbPF7Fkzqn/ZGRwMTbs9UaBsTj9Tj2fL7NNiO9p dwoQsa5XdmYV2vD0OlPuGJimN4Jz3oRQSNVQkawd+40awqnlGD9yQqU64uaLr5mwdGgPkIuw3aLLFd 5YiPwZw6bM1vgbnqBIuIHr/Z7XwM9EEapPwfqVdg/9dcOavsB633n1itcgsIqIDBioJGxOM0Ts7T86 4Jlikvby9AVebqTHq4+YuA+QwXaCQlzI8PxvKGF5ANAjeoheIYOhRCZTs4Dpe3aQtWFnO3FqVYLrzT cc2coPLbTlqbCxnMzWO5XK6k+LQJYAS5r5kCiddkkzITSqNSDkHLgAWrVT+WoO8GDM5wBJEy4K4BDX /s7uUaLCb4fXbubShHzmjelGTOPkp/YtKLrJhFLmk8oztScmMVc7cus/HhSCEpn2aXj3zHgtLJzUfw SN01q4wcwhmS6xqLuWl/PHEsTyaH69+g+rznvzhR64VGsg0V8g68wKeLcHDL9rQRALeFd3MBdV5n9s KFNBVsIrnbnnS1eImonqd1xuYH0pPRl+0Ng4aVcGGvP/yynpBokeriuTdCqA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series fixes up the cases where callers of ksize() use it to
opportunistically grow their buffer sizes, which can run afoul of the
__alloc_size hinting that CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE
use to perform dynamic buffer bounds checking. Quoting the first patch:


In the effort to help the compiler reason about buffer sizes, the
__alloc_size attribute was added to allocators. This improves the scope
of the compiler's ability to apply CONFIG_UBSAN_BOUNDS and (in the near
future) CONFIG_FORTIFY_SOURCE. For most allocations, this works well,
as the vast majority of callers are not expecting to use more memory
than what they asked for.

There is, however, one common exception to this: anticipatory resizing
of kmalloc allocations. These cases all use ksize() to determine the
actual bucket size of a given allocation (e.g. 128 when 126 was asked
for). This comes in two styles in the kernel:

1) An allocation has been determined to be too small, and needs to be
   resized. Instead of the caller choosing its own next best size, it
   wants to minimize the number of calls to krealloc(), so it just uses
   ksize() plus some additional bytes, forcing the realloc into the next
   bucket size, from which it can learn how large it is now. For example:

	data = krealloc(data, ksize(data) + 1, gfp);
	data_len = ksize(data);

2) The minimum size of an allocation is calculated, but since it may
   grow in the future, just use all the space available in the chosen
   bucket immediately, to avoid needing to reallocate later. A good
   example of this is skbuff's allocators:

	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
	...
	/* kmalloc(size) might give us more room than requested.
	 * Put skb_shared_info exactly at the end of allocated zone,
	 * to allow max possible filling before reallocation.
	 */
	osize = ksize(data);
        size = SKB_WITH_OVERHEAD(osize);

In both cases, the "how large is the allocation?" question is answered
_after_ the allocation, where the compiler hinting is not in an easy place
to make the association any more. This mismatch between the compiler's
view of the buffer length and the code's intention about how much it is
going to actually use has already caused problems[1]. It is possible to
fix this by reordering the use of the "actual size" information.

We can serve the needs of users of ksize() and still have accurate buffer
length hinting for the compiler by doing the bucket size calculation
_before_ the allocation. Code can instead ask "how large an allocation
would I get for a given size?".

Introduce kmalloc_size_roundup(), to serve this function so we can start
replacing the "anticipatory resizing" uses of ksize().

[1] https://github.com/ClangBuiltLinux/linux/issues/1599
    https://github.com/KSPP/linux/issues/183
-------

And after adding kmalloc_size_roundup(), put it to use with the various
ksize() callers, restore the previously removed __alloc_size hint,
and fix the use of __malloc annotations.

I tried to trim the CC list on this series since it got rather long. I
kept all the suggested mailing lists, though. :)

Thanks!

-Kees

Kees Cook (12):
  slab: Introduce kmalloc_size_roundup()
  skbuff: Proactively round up to kmalloc bucket size
  net: ipa: Proactively round up to kmalloc bucket size
  btrfs: send: Proactively round up to kmalloc bucket size
  dma-buf: Proactively round up to kmalloc bucket size
  coredump: Proactively round up to kmalloc bucket size
  igb: Proactively round up to kmalloc bucket size
  openvswitch: Proactively round up to kmalloc bucket size
  x86/microcode/AMD: Track patch allocation size explicitly
  iwlwifi: Track scan_cmd allocation size explicitly
  slab: Remove __malloc attribute from realloc functions
  slab: Restore __alloc_size attribute to __kmalloc_track_caller

 arch/x86/include/asm/microcode.h              |  1 +
 arch/x86/kernel/cpu/microcode/amd.c           |  3 +-
 drivers/dma-buf/dma-resv.c                    |  9 +++-
 drivers/net/ethernet/intel/igb/igb_main.c     |  1 +
 drivers/net/ipa/gsi_trans.c                   |  7 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 10 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  6 +--
 fs/btrfs/send.c                               | 11 +++--
 fs/coredump.c                                 |  7 ++-
 include/linux/compiler_types.h                | 13 ++----
 include/linux/slab.h                          | 46 ++++++++++++++++---
 mm/slab_common.c                              | 17 +++++++
 net/core/skbuff.c                             | 34 +++++++-------
 net/openvswitch/flow_netlink.c                |  4 +-
 17 files changed, 125 insertions(+), 51 deletions(-)

-- 
2.34.1

