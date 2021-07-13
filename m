Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78E43C717D
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhGMN4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:56:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236222AbhGMN4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 09:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cKe1AteWlqDqekSoo4sRDpcHirWf7l/w0zsOyjVsOkQ=; b=Y9
        KUB5Oz3rb+GljhPhiQng1dhBJM5Hx74UOBt+LV3BSW0HwRvoHCWOOW5f8aBBY1b3w23wEppBzEtPL
        kLC6yibFS4I0BEYaFRLxJK+LEbMlbYS80GB2V1CAqrpDHqqd26ZRrD2B2n/1G9yH7ciSa46FoiXCm
        FGLTO1BMnQI3vIs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3IqL-00DDQC-HB; Tue, 13 Jul 2021 15:53:01 +0200
Date:   Tue, 13 Jul 2021 15:53:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFC net-next] net: extend netdev features
Message-ID: <YO2avXo6XSBEzZb/@lunn.ch>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
 <YOm82gTf/efnR7Fj@lunn.ch>
 <2b6bc8a7-6fe3-b42e-070d-f9a81560ecda@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b6bc8a7-6fe3-b42e-070d-f9a81560ecda@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> Thanks for your advice.
> 
> I have thought of using linkmode_ before (https://lists.openwall.net/netdev/
> 2021/06/19/11).
> 
> In my humble opinion, there are too many logical operations in stack and
> ethernet drivers,
> I'm not sure changing them to the linkmode_set_ API is the best way. For 
> example,
> 
> below is codes in ethernet drivre:
> netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
>         NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
>         NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
>         NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
>         NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
>         NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
> 
> When using linkmode_ API, I have two choices, one is to define several feature
> arrays or
> a whole features array including all the feature bits supported by the ethernet
> driver.
> const int hns3_nic_vlan_features_array[] = {
>     NETIF_F_HW_VLAN_CTAG_FILTER,
>     NETIF_F_HW_VLAN_CTAG_TX,
>     NETIF_F_HW_VLAN_CTAG_RX,
> };
> const int hns3_nic_tso_features_array[] = {
>     NETIF_F_GSO,
>     NETIF_F_TSO,
>     NETIF_F_TSO6,
>     NETIF_F_GSO_GRE,
>     ...
> };

Using arrays is the way to go. Hopefully Coccinelle can do most of the
work for you.

> linkmode_set_bit_array(hns3_nic_vlan_features_array, ARRAY_SIZE
> (hns3_nic_vlan_features_array), netedv->features);

I would probably add wrappers. So an API like

netdev_feature_set_array(ndev, int hns3_nic_tso_features_array),
                         ARRAY_SIZE(int hns3_nic_tso_features_array);

netdev_hw_feature_set_array(ndev, int hns3_nic_tso_features_array),
                            ARRAY_SIZE(int hns3_nic_vlan_features_array);

etc. This will help during the conversion. You can keep
netdev_features_t as a u64 while you convert to the mew API. Once the
conversion is done, you can then convert the implementation of the API
to a linux bitmap.

> When using netdev_feature_t *, then just need to add an arrary index.
> 
> netdev->features[0] |= NETIF_F_HW_VLAN_CTAG_FILTER |
>         NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX | xxxxxx
> 

And you want to add

netdev->features[1] |= NETIF_F_NEW_FEATURE;

This is going to result in errors, where developers add
NETIF_F_NEW_FEATURE to feature[0], and the compiler will happily do
it, no warnings. Either you need the compiler to enforce the correct
assignment to the array members somehow, or you need a uniform API
which you cannot get wrong.

> By the way, could you introduce me some code re-writing tools ? 

Coccinelle.

https://www.kernel.org/doc/html/latest/dev-tools/coccinelle.html
https://coccinelle.gitlabpages.inria.fr/website/

I've no idea if it can do this level of code re-write. You probably
want to post on the mailing list, describe what you want to do.

     Andrew
