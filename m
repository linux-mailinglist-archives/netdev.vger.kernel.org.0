Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09768832F9
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbfHFNla convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Aug 2019 09:41:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44242 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFNla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:41:30 -0400
Received: from [38.64.181.146] (helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1huziP-0003n1-Oh; Tue, 06 Aug 2019 13:41:25 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 7D88924026B; Tue,  6 Aug 2019 09:41:24 -0400 (EDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 79646289F62;
        Tue,  6 Aug 2019 09:41:24 -0400 (EDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     YueHaibing <yuehaibing@huawei.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Add vlan tx offload to hw_enc_features
In-reply-to: <20190805134953.63596-1-yuehaibing@huawei.com>
References: <20190805134953.63596-1-yuehaibing@huawei.com>
Comments: In-reply-to YueHaibing <yuehaibing@huawei.com>
   message dated "Mon, 05 Aug 2019 21:49:53 +0800."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4280.1565098884.1@nyx>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 06 Aug 2019 09:41:24 -0400
Message-ID: <4281.1565098884@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

>As commit 30d8177e8ac7 ("bonding: Always enable vlan tx offload")
>said, we should always enable bonding's vlan tx offload, pass the
>vlan packets to the slave devices with vlan tci, let them to handle
>vlan implementation.
>
>Now if encapsulation protocols like VXLAN is used, skb->encapsulation
>may be set, then the packet is passed to vlan devicec which based on

	Typo: "devicec"

>bonding device. However in netif_skb_features(), the check of
>hw_enc_features:
>
>	 if (skb->encapsulation)
>                 features &= dev->hw_enc_features;
>
>clears NETIF_F_HW_VLAN_CTAG_TX/NETIF_F_HW_VLAN_STAG_TX. This results
>in same issue in commit 30d8177e8ac7 like this:
>
>vlan_dev_hard_start_xmit
>  -->dev_queue_xmit
>    -->validate_xmit_skb
>      -->netif_skb_features //NETIF_F_HW_VLAN_CTAG_TX is cleared
>      -->validate_xmit_vlan
>        -->__vlan_hwaccel_push_inside //skb->tci is cleared
>...
> --> bond_start_xmit
>   --> bond_xmit_hash //BOND_XMIT_POLICY_ENCAP34
>     --> __skb_flow_dissect // nhoff point to IP header
>        -->  case htons(ETH_P_8021Q)
>             // skb_vlan_tag_present is false, so
>             vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
>             //vlan point to ip header wrongly
>
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>

	Looks good to me; should this be tagged with

Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")

	as 30d8177e8ac7 was?  If not, is there an appropriate commit id?

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>---
> drivers/net/bonding/bond_main.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 02fd782..931d9d9 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1126,6 +1126,8 @@ static void bond_compute_features(struct bonding *bond)
> done:
> 	bond_dev->vlan_features = vlan_features;
> 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
>+				    NETIF_F_HW_VLAN_CTAG_TX |
>+				    NETIF_F_HW_VLAN_STAG_TX |
> 				    NETIF_F_GSO_UDP_L4;
> 	bond_dev->mpls_features = mpls_features;
> 	bond_dev->gso_max_segs = gso_max_segs;
>-- 
>2.7.4

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
