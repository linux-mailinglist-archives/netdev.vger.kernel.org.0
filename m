Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA18CC2520
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbfI3Q3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:29:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50122 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbfI3Q3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 12:29:08 -0400
Received: from zn.tnic (p200300EC2F058B00329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:8b00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C36C71EC05A1;
        Mon, 30 Sep 2019 18:29:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569860946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jzkAFLaCHV29m/fJWef9IzITfqS1NsfHIWmyf8nzRCA=;
        b=NwVORxvgEnskxgL1hwnDSn7+uvAKGAHnEyl/4bKR9rA40iT/66FCEoXBNC/v06rwEkzJ7W
        raUj6GsQz4BDeSHoexc9g+vzLtMR8MKPasfbleksFjNT0jXulw5du2jg9kqoPX07vxnCA4
        jAjRFl5AhGzlHzMbWO7OFXjJShxZNJw=
Date:   Mon, 30 Sep 2019 18:29:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930162910.GI29694@zn.tnic>
References: <20190930141316.GG29694@zn.tnic>
 <20190930154535.GC22120@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190930154535.GC22120@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 05:45:35PM +0200, Michal Kubecek wrote:
> On Mon, Sep 30, 2019 at 04:13:17PM +0200, Borislav Petkov wrote:
> > I'm seeing this on i386 allyesconfig builds of current Linus master:
> > 
> > ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> This is usually result of dividing (or modulo) by a 64-bit integer. Can
> you identify where (file and line number) is the __umoddi3() call
> generated?

Did another 32-bit allyesconfig build. It said:

ld: drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.o: in function `mlx5dr_icm_alloc_chunk':
dr_icm_pool.c:(.text+0x733): undefined reference to `__umoddi3'
make: *** [vmlinux] Error 1

The .s file then points to the exact location:

# drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:140:   align_diff = icm_mr->icm_start_addr % align_base;
        pushl   %ebx    # align_base
        pushl   %ecx    # align_base
        call    __umoddi3       #
        popl    %edx    #
        popl    %ecx    #

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
