Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6762440AE0
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJ3SH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 14:07:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhJ3SH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 14:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=frQo4/Vd2v5L/DwlATBoTIoO3QyDedVn1jJwLc9O8F0=; b=wZpkFVbZxBOYZkzpb3V0qfnWLg
        8mFzTdA1UqPtF60Nfk9+iNZ+iQzuu+T28bFwrP2Au3WQ7G8m4I4ds42RaHoUTKfs2OwtJ8RfP/Fst
        Jj9/fu/Bst20wmljN2+Cj289kCm5oK9YbnypASH+kl003HTJOEE+i42miNtf1PWO4VO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mgsiL-00CBsJ-Co; Sat, 30 Oct 2021 20:04:21 +0200
Date:   Sat, 30 Oct 2021 20:04:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V5 net-next 5/6] net: hns3: add support to set/get rx buf
 len via ethtool for hns3 driver
Message-ID: <YX2JJSQBRFjhmQsx@lunn.ch>
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
 <20211030131001.38739-6-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030131001.38739-6-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int hns3_check_ringparam(struct net_device *ndev,
> -				struct ethtool_ringparam *param)
> +				struct ethtool_ringparam *param,
> +				struct kernel_ethtool_ringparam *kernel_param)
>  {
> +#define RX_BUF_LEN_2K 2048
> +#define RX_BUF_LEN_4K 4096

include/linux/size.h

#define SZ_2K                           0x00000800
#define SZ_4K                           0x00001000


>  	if (hns3_nic_resetting(ndev))
>  		return -EBUSY;
>  
>  	if (param->rx_mini_pending || param->rx_jumbo_pending)
>  		return -EINVAL;
>  
> +	if (kernel_param->rx_buf_len != RX_BUF_LEN_2K &&
> +	    kernel_param->rx_buf_len != RX_BUF_LEN_4K) {
> +		netdev_err(ndev, "Rx buf len only support 2048 and 4096\n");
> +		return -EINVAL;

Same question i asked in the cover note. MTU is 4K, i set rx buf len
to 2K. What happens? Should there be an EINVAL here?

   Andrew
