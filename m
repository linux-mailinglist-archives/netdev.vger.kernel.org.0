Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C226D7820
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbjDEJ1g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 05:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237384AbjDEJ1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:35 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8854C27
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:28 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-ecJt0N-qNKC-LkD-r4iWlg-1; Wed, 05 Apr 2023 05:27:09 -0400
X-MC-Unique: ecJt0N-qNKC-LkD-r4iWlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9131D101A54F;
        Wed,  5 Apr 2023 09:27:08 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A683918EC7;
        Wed,  5 Apr 2023 09:27:07 +0000 (UTC)
Date:   Wed, 5 Apr 2023 11:27:06 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZC0+6hNkTLiDvWEQ@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230329122107.22658-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=1.9 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> Add support for MACsec offload operations for VLAN driver
> to allow offloading MACsec when VLAN's real device supports
> Macsec offload by forwarding the offload request to it.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> ---
> V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> 		  - Allow grep for the functions.
> 		  - Add helper function to get the macsec operation to allow the compiler to make some choice.
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
>  net/8021q/vlan_dev.c                          | 101 ++++++++++++++++++
>  2 files changed, 102 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6db1aff8778d..5ecef26e83c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5076,6 +5076,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>  
>  	netdev->vlan_features    |= NETIF_F_SG;
>  	netdev->vlan_features    |= NETIF_F_HW_CSUM;
> +	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
>  	netdev->vlan_features    |= NETIF_F_GRO;
>  	netdev->vlan_features    |= NETIF_F_TSO;
>  	netdev->vlan_features    |= NETIF_F_TSO6;

IMO that shouldn't be part of this patch. One patch for VLAN to add
MACsec offload, then one for mlx5 to enable the feature.

-- 
Sabrina

