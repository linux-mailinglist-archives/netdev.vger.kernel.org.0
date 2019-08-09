Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C987136
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfHIFCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:02:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfHIFCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:02:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A853C14249743;
        Thu,  8 Aug 2019 22:02:29 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:02:29 -0700 (PDT)
Message-Id: <20190808.220229.26286305923067210.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@resnulli.us, jay.vosburgh@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] bonding: Add vlan tx offload to hw_enc_features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807021959.58572-1-yuehaibing@huawei.com>
References: <20190807021959.58572-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:02:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 7 Aug 2019 10:19:59 +0800

> As commit 30d8177e8ac7 ("bonding: Always enable vlan tx offload")
> said, we should always enable bonding's vlan tx offload, pass the
> vlan packets to the slave devices with vlan tci, let them to handle
> vlan implementation.
> 
> Now if encapsulation protocols like VXLAN is used, skb->encapsulation
> may be set, then the packet is passed to vlan device which based on
> bonding device. However in netif_skb_features(), the check of
> hw_enc_features:
> 
> 	 if (skb->encapsulation)
>                  features &= dev->hw_enc_features;
> 
> clears NETIF_F_HW_VLAN_CTAG_TX/NETIF_F_HW_VLAN_STAG_TX. This results
> in same issue in commit 30d8177e8ac7 like this:
> 
> vlan_dev_hard_start_xmit
>   -->dev_queue_xmit
>     -->validate_xmit_skb
>       -->netif_skb_features //NETIF_F_HW_VLAN_CTAG_TX is cleared
>       -->validate_xmit_vlan
>         -->__vlan_hwaccel_push_inside //skb->tci is cleared
> ...
>  --> bond_start_xmit
>    --> bond_xmit_hash //BOND_XMIT_POLICY_ENCAP34
>      --> __skb_flow_dissect // nhoff point to IP header
>         -->  case htons(ETH_P_8021Q)
>              // skb_vlan_tag_present is false, so
>              vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
>              //vlan point to ip header wrongly
> 
> Fixes: b2a103e6d0af ("bonding: convert to ndo_fix_features")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Applied and queued up for -stable.
