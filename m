Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA251B659
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiEEDRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiEEDRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5067920F66;
        Wed,  4 May 2022 20:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB3A5B82794;
        Thu,  5 May 2022 03:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED32EC385A5;
        Thu,  5 May 2022 03:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651720440;
        bh=fgYShDk8J/LH7fRewSMC+BYKPB5NxskQkpkXs8hqxDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gu8BTaS6QcvN1Zcekn09aNMpiKrZ9CwVxhA+jmfPxjC756WBiUYF+PQtSaX3xzv0C
         WyAvNADizjYRGzBFni+0HqRpXeOUVOjg8WES8/iUOZ8+MICEO2tYZXqGIzVrC+pYR9
         5KzVzpyoiK32DuYzLzdKP9OiZR1Hij1i3gS4meXMP7qH9jTEdHWyAzkc6zDcSmGDmN
         xREyDvy+jPrCIfl6VNibDFXcg8GC6ehZ9/X7cmlyVM9TeWwySYbGw/TYJ6hkWeNJGo
         ZYbThIgvL41D63EC8IcDOPCl88QI75i06nKBS27oAmvBtMYTCkgvoiVLylSEPGNCht
         H9zuPE6rjSBNg==
Date:   Wed, 4 May 2022 20:13:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: chelsio: cxgb4: Avoid potential negative array
 offset
Message-ID: <20220504201358.0ba62232@kernel.org>
In-Reply-To: <20220503144425.2858110-1-keescook@chromium.org>
References: <20220503144425.2858110-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 May 2022 07:44:25 -0700 Kees Cook wrote:
> Using min_t(int, ...) as a potential array index implies to the compiler
> that negative offsets should be allowed. This is not the case, though.
> Replace min_t() with clamp_t(). Fixes the following warning exposed
> under future CONFIG_FORTIFY_SOURCE improvements:

> Additionally remove needless cast from u8[] to char * in last strim()
> call.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/202205031926.FVP7epJM-lkp@intel.com
> Fixes: fc9279298e3a ("cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()")
> Fixes: 24c521f81c30 ("cxgb4: Use pci_vpd_find_id_string() to find VPD ID string")

Is it needed in the current release?

> Cc: Raju Rangoju <rajur@chelsio.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index e7b4e3ed056c..f119ec7323e5 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  		goto out;
>  	na = ret;
>  
> -	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
> +	memcpy(p->id, vpd + id, clamp_t(int, id_len, 0, ID_LEN));

The typing is needed because of the enum, right? The variable is
unsigned, seems a little strange to use clamp(int, ..., 0, constant)
min(unsigned int, ..., constant) will be equivalent with fewer branches.
Is it just me?

>  	strim(p->id);
> -	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
> +	memcpy(p->sn, vpd + sn, clamp_t(int, sn_len, 0, SERNUM_LEN));
>  	strim(p->sn);
> -	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
> +	memcpy(p->pn, vpd + pn, clamp_t(int, pn_len, 0, PN_LEN));
>  	strim(p->pn);
> -	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
> -	strim((char *)p->na);
> +	memcpy(p->na, vpd + na, clamp_t(int, na_len, 0, MACADDR_LEN));
> +	strim(p->na);
>  
>  out:
>  	vfree(vpd);

