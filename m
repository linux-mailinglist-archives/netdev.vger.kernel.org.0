Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7745730E90E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhBDA5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhBDA5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:57:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D7564DF8;
        Thu,  4 Feb 2021 00:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612400213;
        bh=y2j4NwrmVhYU27HliyaJXdE+dek/9+rFkJIF35QH3/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j8GJj683FCnZet922FzcouHsEAQi2f2PinLv6ueljUe+KP66AevBTIZjQ73u4OEBi
         R+jY0OaFp/hLvkVMwFiHT1dn/MqIjZxyOsu+tuLmg6Lo0vCD866G5FZjtAn+rqnKwr
         wm4YVHzZZ4Q2QZQ0DsNZYGqcUUsX/IM8cfChiNH46s1wXyYv3yPydwF5fOGPvWT95V
         faFoXM4G0JEc4AfQ/ALogwOPITwd13jOdP7EOIR6Xlvx4V1FVvFzrqaK2K4nfMYm8z
         zG8wFBmyK4TPQvBf4BHTQTl6NUqZeuG5HtUaIcaDxsDMd29Xlm08NS1yBr8bm3Fd4Y
         UEovs6WVWo8EA==
Date:   Wed, 3 Feb 2021 16:56:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 4/7] net: hns3: add support for obtaining the
 maximum frame length
Message-ID: <20210203165652.25000212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612269593-18691-5-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
        <1612269593-18691-5-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 20:39:50 +0800 Huazhong Tan wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> Since the newer hardware may supports different frame size,
> so add support to obtain the capability from the firmware
> instead of the fixed value.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

> @@ -9659,7 +9663,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
>  	/* HW supprt 2 layer vlan */
>  	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
>  	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
> -	    max_frm_size > HCLGE_MAC_MAX_FRAME)
> +	    max_frm_size > hdev->ae_dev->dev_specs.max_pkt_len)
>  		return -EINVAL;
>  
>  	max_frm_size = max(max_frm_size, HCLGE_MAC_DEFAULT_FRAME);

Don't you have to adjust netdev->max_mtu as well when device specifies
max_pkt_len different than HCLGE_MAC_MAX_FRAME?
