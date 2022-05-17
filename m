Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A7C52A592
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiEQPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349548AbiEQPDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:03:42 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794CC39142
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:03:41 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id s22so8801305qta.0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYw9MLrmTgrCyt32icuujwVIUmzRK3qobN37OJ0H6Dk=;
        b=YIjyNubMBQN3j3kq8COxDOs9ZfyumC6z67UoQ2FYG9OrbcSw89m7muMq6Ee/AEBQIN
         Znt8L77xweytRK5+XWVErzOjLGyuLd781OgCT7nEzZ+2p42AFQcJW6+vMmMqNqb6imCH
         yC5ny4vzLdqIcnFqOtpkVy9/pchereg5BA/DDcpwXqViuGISm1EmqlzOWKyzrzLEX8fW
         PDZupU2SGzflxTCdTC9+1ls0wSz05ZJSH8vKc7S2E+G40p9vgyR74ZH21+jPx5Ew26MD
         sZbtW2pwcterOngapb6X791W2mKDNIB20J4hw3mTG8/RNL6irZULDmfs53nRiHWko8FA
         +p/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYw9MLrmTgrCyt32icuujwVIUmzRK3qobN37OJ0H6Dk=;
        b=laNiqw4JzRoX2fUWSnYBnEDeLVMmbTE416fiRJKmVk2YDh00+tjsMAH7zV+9nmwB5x
         2Bfkn13fF7snxKKKvpJrMEIQ6v7wyCxHmFw3TP3qdOc80+i1KijY/OFdj7iojJj+5TrZ
         7yelf1NFqGYUKofyAzuIxPXqErUJnF687XlCPOO267PUjffcDPq24ON/lPg0JL3HgLdv
         IAbZwlKxV+eala0f468/TFB6e29cXiuskInFkOd84BDXNBKbFG/70Z7e2QJUYNym+Bx4
         tVrR8+b+OGmgJ3kZEv3daJhM5aqSZ5RwE2RpWJglIjSH6hsU/F0UJIu+JF6qsKHXm0NN
         HgIQ==
X-Gm-Message-State: AOAM531CWPclg9ISNzX0Xq8bABzET6LPR8qc+hDpEfbwqMBroPLe5iUI
        qZQC0Wj4SOcXayFYhDrog4se0A==
X-Google-Smtp-Source: ABdhPJzNAviWPSBXWWUJ/iGKw+c/h25D3QSyPMqu9y9mjuiv7nOxJijw6Gy3AK7v52SKehoMul0w4Q==
X-Received: by 2002:ac8:7f43:0:b0:2f3:d55d:7296 with SMTP id g3-20020ac87f43000000b002f3d55d7296mr20083913qtk.635.1652799820611;
        Tue, 17 May 2022 08:03:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u123-20020ae9d881000000b006a0462eb091sm7772405qkf.80.2022.05.17.08.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 08:03:39 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nqyjb-0084ZN-6l; Tue, 17 May 2022 12:03:39 -0300
Date:   Tue, 17 May 2022 12:03:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 09/12] net: mana: Move header files to a common location
Message-ID: <20220517150339.GI63055@ziepe.ca>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-10-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652778276-2986-10-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 02:04:33AM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> In preparation to add MANA RDMA driver, move all the required header files
> to a common location for use by both Ethernet and RDMA drivers.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  MAINTAINERS                                                   | 1 +
>  drivers/net/ethernet/microsoft/mana/gdma_main.c               | 2 +-
>  drivers/net/ethernet/microsoft/mana/hw_channel.c              | 4 ++--
>  drivers/net/ethernet/microsoft/mana/mana_bpf.c                | 2 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c                 | 2 +-
>  drivers/net/ethernet/microsoft/mana/mana_ethtool.c            | 2 +-
>  drivers/net/ethernet/microsoft/mana/shm_channel.c             | 2 +-
>  {drivers/net/ethernet/microsoft => include/linux}/mana/gdma.h | 0
>  .../ethernet/microsoft => include/linux}/mana/hw_channel.h    | 0
>  {drivers/net/ethernet/microsoft => include/linux}/mana/mana.h | 0
>  .../ethernet/microsoft => include/linux}/mana/shm_channel.h   | 0
>  11 files changed, 8 insertions(+), 7 deletions(-)
>  rename {drivers/net/ethernet/microsoft => include/linux}/mana/gdma.h (100%)
>  rename {drivers/net/ethernet/microsoft => include/linux}/mana/hw_channel.h (100%)
>  rename {drivers/net/ethernet/microsoft => include/linux}/mana/mana.h (100%)
>  rename {drivers/net/ethernet/microsoft => include/linux}/mana/shm_channel.h (100%)

I know mlx5 did it like this, but I wonder if include/net is more
appropriate?

Or maybe include/aux/?

Jason
