Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43D351E239
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444791AbiEFWha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444785AbiEFWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:37:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324ED2528F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30EEB839E6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F51C385A8;
        Fri,  6 May 2022 22:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651876421;
        bh=nkrQEMneJt+GSX4itohckDcneTiK92iKUMLsl99J1ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ThfdUDmRn5U7bQIoVYkr/gvQJ02IH792osJF9jqdqszZb6qAhFqeRgP6wAJD2aUmQ
         N4zbGuI7u9H9FWdgul1JFkigLsEtlWikldaXndKNr6yAFKdtfNxKy7Wr2KDuU66/DE
         /a2p5sjfp8I0tN1muOK5Ld11yp7vbKxyiremerenV7wDQS6quWmk1+gUX1NvZWgAwz
         OOG+qoOi91AOXmdG60XJezFjhM9L19wGgvaoZt+7xmpBjPHCEL+fBdPDhYZlX4Q3pV
         wPcS6U7K8YBD4tASxcIWWIanpEUSjOjiht2yK36gcBGvO0vPeOykBmsR0H0Fv3yr4V
         CHBlDzOYUcbAg==
Date:   Fri, 6 May 2022 15:33:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v4 net-next 10/12] veth: enable BIG TCP packets
Message-ID: <20220506153339.70a78f84@kernel.org>
In-Reply-To: <20220506153048.3695721-11-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-11-eric.dumazet@gmail.com>
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

On Fri,  6 May 2022 08:30:46 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Set the driver limit to 512 KB per TSO ipv6 packet.
> 
> This allows the admin/user to set a GSO ipv6 limit up to this value.
> 
> ip link set dev veth10 gso_ipv6_max_size 200000
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/net/veth.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index f474e79a774580e4cb67da44b5f0c796c3ce8abb..989248b0f0c64349494a54735bb5abac66a42a93 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1647,6 +1647,7 @@ static void veth_setup(struct net_device *dev)
>  	dev->hw_features = VETH_FEATURES;
>  	dev->hw_enc_features = VETH_FEATURES;
>  	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
> +	netif_set_tso_max_size(dev, 512 * 1024);

Should we have a define for a "good SW device limit" ?
Or set it to infinity (TSO_MAX_SIZE)?

>  }
