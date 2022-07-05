Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F788567813
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiGETww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiGETwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:52:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F0A1CB10;
        Tue,  5 Jul 2022 12:52:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r14so13240029wrg.1;
        Tue, 05 Jul 2022 12:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/doxS0i6Wxlf3MlQXzvD1rRavf5pbzG6RAdOF/mnCY4=;
        b=ArexrY44HStoCcsS43la3guKBJ49QQtWvjH+cMc4ug5p3cyvHU5Dyaoyou9wlV98lU
         t1rdtTH4PtO7TMcNN3JUzkdb1mY7LFdrvCuiKfl0rDvV/VcSVMPYlnvaUHFk2NaJPCU4
         XkEjrVKV/65CCHIOXVBkO09lya86ZtlmV/BpPBKLJ74qfJwHi4Zrfq3tvmc7/4RH2UYt
         hxGmVomn9hiIriN8+Zquy93JmujHo2e5lF+3IgxY8MUhetFqIv4HrlJNoowHBBmWt6+J
         QCZ7STtbE+6h60ougeY8ry/e/Rya28iXXXF1KY0QwxW2WTCTZUW5zIvZBRylRhYfvIQg
         JULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/doxS0i6Wxlf3MlQXzvD1rRavf5pbzG6RAdOF/mnCY4=;
        b=A7sTYKXASJ/2hZbu6DNRmZ4+/GBoctFgKLPCtwV6aGpF2av/KLxHvqGhfCJYKt3Xoc
         QpWTjawkBNsmHgOel5xNGl7/NVat3hIoO8z1LGwqMycJEn2O1ziA2NM14gFSZDWQvDMl
         AWwNLErjPUuhoSJ55nuh04sAkRO4/biA2TR6c5n4Bb9BIW05+60dAonu9aBVh/DAS+vh
         Dfo1nxGaxCoHiLnPiAE/bDzGJNrigtjEd63qQU/ZBkOhGXB+X9T//t28BQK/zM/VQPKP
         L1PgjXerkPnC6Y3q3Cn3zwGa4B5Mvbu6myqxDuwtdWQj6bFO4AYDfyb9fVr3KHJH1Chr
         WEGA==
X-Gm-Message-State: AJIora+8h4NAr9EIkUbsxtxmWBpE7zr7WQe7LQGGSVqEU1UvisWmeXbb
        Ksy4NOZhItxMDKiprRS9Ke+/FyS8S8f/gBAsgIg=
X-Google-Smtp-Source: AGRyM1v7ifsufKfy5Jeo+13iCkt+psbaynIFUU7eS3NIGXvLiFM9Ug8mRV/eLUpjyCfhBiEIOSJYh7GFnTe629aUmb0=
X-Received: by 2002:a5d:5703:0:b0:21d:6c55:4986 with SMTP id
 a3-20020a5d5703000000b0021d6c554986mr10402402wrv.455.1657050767617; Tue, 05
 Jul 2022 12:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220704140129.6463-1-fmdefrancesco@gmail.com> <YsSBR5nJovFMHGcB@iweiny-desk3>
In-Reply-To: <YsSBR5nJovFMHGcB@iweiny-desk3>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 5 Jul 2022 12:52:36 -0700
Message-ID: <CAKgT0UcGvjczCZXBS_OunwnZ5Xc7ytDRqjpymiXQni0ugrdmug@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 11:22 AM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Mon, Jul 04, 2022 at 04:01:29PM +0200, Fabio M. De Francesco wrote:
> > Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
> > there is no need to call kmap() on them.
>
> I'm still not 100% sure where this page gets allocated but AFAICT it is
> allocated in ixgbe_alloc_mapped_page() which calls dev_alloc_pages() for the
> allocation which is where the GFP_ATOMIC is specified.
>
> I think I would add this detail here.
>
> That said, and assuming my analysis is correct, the code looks fine so:

Yeah, this is actually called out in other spots in the buffer
cleaning path. This is just something I had overlooked and left in
place back a few refactors ago.. :-)

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c#L1795

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
