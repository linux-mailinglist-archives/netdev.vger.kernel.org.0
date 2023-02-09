Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E185168FC21
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjBIAru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBIArt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:47:49 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D242C1A948;
        Wed,  8 Feb 2023 16:47:48 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id dr8so1862269ejc.12;
        Wed, 08 Feb 2023 16:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=csaUFD9XPMWnOfebSojpED5cJqAQggMa/pYn+VL37CM=;
        b=Hcmg3NcuxMZp48JVIaeNVjLdopmTTlbGWWNWRC0ISw5Pvr2pPh4vnggQh4el9ERapf
         ejxxuI1Z7/Fn69Qt/JUjfqKKUYMswGzh+1KVA9a6wkHn3SdGYkAqjeh1Pobu9RjQyo9o
         +3RVtr7/bnatz9htnfW/CeAgNdKHTtjM6bn/E3HqVakJwEtHR+B1DwYty3cmGVW9VYq8
         t9/PFo4ibQWMxq5N77EzESOZMrQDBV1GC7rvh4ceoT53EemhHA0GweR3E0stN1TKKrkc
         JmCYO0d9qun5EpFHVkwOrfX9e42UXZCb0wOQXqFNjeNfkgiSEJ+oYPMRksCHz/6I5lLJ
         zhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csaUFD9XPMWnOfebSojpED5cJqAQggMa/pYn+VL37CM=;
        b=4JUKPNhaHumwrEZabho6DZaJ38FHdr0l7Ay82FLvKYR6g1U29oKNOt+7gd1U56YFe8
         ayJk6PPxE+8gPQhKe2tUncwIHN3NTyMkpFG+I1M7bpD9l42zYkE3FkG1KbNsFjjSYsRQ
         7DwbzC9VN8WwrnoKMY1VA/IuaE2pPb1/2c4QW+Y47/wiwd7IDgPCRksmP/zz7prj1nDM
         z/X8GOrjp6qyeeb24r5aAfut5AbjbrHNFCZXBPZiqvyXiMomS7FYYpSUptY33rgiEy5q
         bYTYosQNBKoMGVJGmnwlZw4WlUmFfzxv2RXs5yf9RhWuq4w3DLeGS0SMdehtUhu2Nr6g
         KDpw==
X-Gm-Message-State: AO0yUKUXYY6VjWFh5jfvldqQa/ONHyvtQ+hTQL079DuAasZMXCvg2L/i
        SPDiONbsUmCVDJZJhZ4A8xeH9i6nvhslzao4Sdk=
X-Google-Smtp-Source: AK7set/d76zdEJveJUcIvOlKGZ+pCq9PFMXT1MU7EPKOOnVom4NJ66HyMBsOZb5jDHvehUhyf1m5btZIT5sSn3a/jxM=
X-Received: by 2002:a17:907:2cec:b0:87b:dce7:c245 with SMTP id
 hz12-20020a1709072cec00b0087bdce7c245mr121870ejc.3.1675903667369; Wed, 08 Feb
 2023 16:47:47 -0800 (PST)
MIME-Version: 1.0
References: <20230204133535.99921-1-kerneljasonxing@gmail.com> <20230204133535.99921-4-kerneljasonxing@gmail.com>
In-Reply-To: <20230204133535.99921-4-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 9 Feb 2023 08:47:09 +0800
Message-ID: <CAL+tcoD9nE-Ad7+XoshoQ8qp7C0H+McKX=F6xt2+UF1BeWXKbg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] ixgbe: add double of VLAN header when computing
 the max MTU
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        alexander.duyck@gmail.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC Alexander Duyck

Hello Alexander, thanks for reviewing the other two patches of this
patchset last night. Would you mind reviewing the last one? :)

Thanks,
Jason

On Sat, Feb 4, 2023 at 9:36 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> Include the second VLAN HLEN into account when computing the maximum
> MTU size as other drivers do.
>
> Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 2 ++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index bc68b8f2176d..8736ca4b2628 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -73,6 +73,8 @@
>  #define IXGBE_RXBUFFER_4K    4096
>  #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
>
> +#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
> +
>  /* Attempt to maximize the headroom available for incoming frames.  We
>   * use a 2K buffer for receives and need 1536/1534 to store the data for
>   * the frame.  This leaves us with 512 bytes of room.  From that we need
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 2c1b6eb60436..149f7baf40fe 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6801,8 +6801,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
>         struct ixgbe_adapter *adapter = netdev_priv(netdev);
>
>         if (ixgbe_enabled_xdp_adapter(adapter)) {
> -               int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
> -                                    VLAN_HLEN;
> +               int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
>
>                 if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
>                         e_warn(probe, "Requested MTU size is not supported with XDP\n");
> --
> 2.37.3
>
