Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A354E6BC7
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355204AbiCYBLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357152AbiCYBLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD89B5F8DD
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 18:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79AB66186A
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688FDC340EC;
        Fri, 25 Mar 2022 01:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648170572;
        bh=lIZA0KRntaJN/mpy3RLSiK9qk4buKxQ4Wceh0tqO7tk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rKXihCGuhQr6mKmb5d7u01Hy9trD/ZfgGc7iOE+ZHN2bjrDAGmCVPfKRqU6j3Wsyh
         9yxCohH2UfBcqVdt92dWyUlhK0g0ZVrjfjOg9/0Fqjj4oLbfnT3rUQXqnTSKluvkoe
         VYq2Q58/BrCffIhHDqlVlx+3oTQboalL+f9IZnOAVffXYhTPQC2tpp3lgtfvV6Kg97
         LDUS+wI8fYVrp1jbNiXieQGR4EWnlpWCzkEyrJttqLBjug/qBbwVdwKGy8IQqNj2ef
         SxI+4QacI5d7sTEikEAtN5qrkfQrloAtXVq978NP6nzeQqxGJfblA2FC8Cfl+64Wfr
         0X4GxEsyprmfQ==
Date:   Thu, 24 Mar 2022 18:09:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 02/20] net: introduce operation helpers
 for netdev features
Message-ID: <20220324180931.7e6e5188@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220324154932.17557-3-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-3-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 23:49:14 +0800 Jian Shen wrote:
> Introduce a set of bitmap operation helpers for netdev features,
> then we can use them to replace the logical operation with them.
> As the nic driversare not supposed to modify netdev_features
> directly, it also introduces wrappers helpers to this.
> 
> The implementation of these helpers are based on the old prototype
> of netdev_features_t is still u64. I will rewrite them on the last
> patch, when the prototype changes.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  include/linux/netdevice.h | 597 ++++++++++++++++++++++++++++++++++++++

Please move these helpers to a new header file which won't be included
by netdevice.h and include it at users appropriately.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7307b9553bcf..0af4b26896d6 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2295,6 +2295,603 @@ struct net_device {
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  
> +static inline void netdev_features_zero(netdev_features_t *dst)
> +{
> +	*dst = 0;
> +}
> +
> +static inline void netdev_features_fill(netdev_features_t *dst)
> +{
> +	*dst = ~0ULL;
> +}
> +
> +static inline bool netdev_features_empty(const netdev_features_t src)

Don't pass by value something larger than 64 bit.

> +{
> +	return src == 0;
> +}
> +
> +/* helpers for netdev features '==' operation */
> +static inline bool netdev_features_equal(const netdev_features_t src1,
> +					 const netdev_features_t src2)
> +{
> +	return src1 == src2;
> +}

> +/* helpers for netdev features '&=' operation */
> +static inline void
> +netdev_features_direct_and(netdev_features_t *dst,
> +			   const netdev_features_t features)
> +{
> +	*dst = netdev_features_and(*dst, features);
> +}
> +
> +static inline void
> +netdev_active_features_direct_and(struct net_device *ndev,

s/direct_and/mask/ ?

> +				  const netdev_features_t features)
> +{
> +	ndev->active_features = netdev_active_features_and(ndev, features);
> +}

> +
> +/* helpers for netdev features '|' operation */
> +static inline netdev_features_t
> +netdev_features_or(const netdev_features_t a, const netdev_features_t b)
> +{
> +	return a | b;
> +}

> +/* helpers for netdev features '|=' operation */
> +static inline void
> +netdev_features_direct_or(netdev_features_t *dst,

s/direct_or/set/ ?

> +			  const netdev_features_t features)
> +{
> +	*dst = netdev_features_or(*dst, features);
> +}

> +/* helpers for netdev features '^' operation */
> +static inline netdev_features_t
> +netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
> +{
> +	return a ^ b;
> +}

> +/* helpers for netdev features '^=' operation */
> +static inline void
> +netdev_active_features_direct_xor(struct net_device *ndev,

s/direct_xor/toggle/ ?

> +/* helpers for netdev features '& ~' operation */
> +static inline netdev_features_t
> +netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
> +{
> +	return a & ~b;
> +}

> +static inline void
> +netdev_features_direct_andnot(netdev_features_t *dst,

s/andnot/clear/ ?

> +			     const netdev_features_t features)
> +{
> +	*dst = netdev_features_andnot(*dst, features);
> +}

> +/* helpers for netdev features 'set bit' operation */
> +static inline void netdev_features_set_bit(int nr, netdev_features_t *src)

s/features_set_bit/feature_add/ ?

> +{
> +	*src |= __NETIF_F_BIT(nr);
> +}

> +/* helpers for netdev features 'set bit array' operation */
> +static inline void netdev_features_set_array(const int *array, int array_size,
> +					     netdev_features_t *dst)
> +{
> +	int i;
> +
> +	for (i = 0; i < array_size; i++)
> +		netdev_features_set_bit(array[i], dst);
> +}
> +
> +#define netdev_active_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->active_features)
> +
> +#define netdev_hw_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->hw_features)
> +
> +#define netdev_wanted_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->wanted_features)
> +
> +#define netdev_vlan_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->vlan_features)
> +
> +#define netdev_hw_enc_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->hw_enc_features)
> +
> +#define netdev_mpls_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->mpls_features)
> +
> +#define netdev_gso_partial_features_set_array(ndev, array, array_size) \
> +		netdev_features_set_array(array, array_size, &ndev->gso_partial_features)
> +
> +/* helpers for netdev features 'clear bit' operation */
> +static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)

All the mentions of '_bit' are unnecessary IMHO.
