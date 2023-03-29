Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DA06CF22A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjC2SdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC2SdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:33:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990D91FFF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A4A61DAD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEE0C433EF;
        Wed, 29 Mar 2023 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680114779;
        bh=ExLLINRIt27DaBnndpkuJgMvYUa/i0s8echQYZqRqLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksjR5TSDDCtPUkhda/1vM88cOB9TW+8+3fzDqTm/fzWcx/vX/UaY2Q+6Ohe7RYLdk
         zQjsUJVLqgGDQ8LxRG3M42tw7aPhgreRUF3gtfcfqtSgufV6jQuVIqo9N7PMc+lut4
         Y7z4yPRX1qtnS5IHdH/PAzucxT7EgmjcJxXdSvxq8NgOT8o50UKINUH7vftdF/WaMg
         u7QpyydIv5noQeOlH0x7ikWYf8UenYpjjfy9h/8TufDxaGu0mrMvzebKMt0aZf50cg
         wDTzC9p+zE2Qxk22iuMf0aTx0ITtul6f4DRO83srxoxFxH/W+c9orFvI8aRWeJ3VTP
         g+LSqR4fjp9tw==
Date:   Wed, 29 Mar 2023 21:32:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-af: update type of prof fields in
 nix_aw_enq_req
Message-ID: <20230329183255.GZ831478@unreal>
References: <20230329112356.458072-1-horms@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329112356.458072-1-horms@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 01:23:56PM +0200, Simon Horman wrote:
> Update type of prof and prof_mask fields in nix_as_enq_req
> from u64 to struct nix_bandprof_s, which is 128 bits wide.
> 
> This is to address warnings with compiling with gcc-12 W=1
> regarding string fortification.
> 
> Although the union of which these fields are a member is 128bits
> wide, and thus writing a 128bit entity is safe, the compiler flags
> a problem as the field being written is only 64 bits wide.
> 
>   CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.o
> scripts/Makefile.build:252: ./drivers/net/ethernet/marvell/octeontx2/nic/Makefile: otx2_dcbnl.o is added to multiple modules: rvu_nicpf rvu_nicvf
>   CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.o
>   CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.o
>   CC [M]  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.o
>   CC [M]  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.o
> In file included from ./include/linux/string.h:254,
>                  from ./include/linux/bitmap.h:11,
>                  from ./include/linux/cpumask.h:12,
>                  from ./arch/x86/include/asm/paravirt.h:17,
>                  from ./arch/x86/include/asm/cpuid.h:62,
>                  from ./arch/x86/include/asm/processor.h:19,
>                  from ./arch/x86/include/asm/timex.h:5,
>                  from ./include/linux/timex.h:67,
>                  from ./include/linux/time32.h:13,
>                  from ./include/linux/time.h:60,
>                  from ./include/linux/stat.h:19,
>                  from ./include/linux/module.h:13,
>                  from drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:8:
> In function 'fortify_memcpy_chk',
>     inlined from 'rvu_nix_blk_aq_enq_inst' at drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:969:4:
> ./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   529 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'fortify_memcpy_chk',
>     inlined from 'rvu_nix_blk_aq_enq_inst' at drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:984:4:
> ./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   529 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> Compile tested only!
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
