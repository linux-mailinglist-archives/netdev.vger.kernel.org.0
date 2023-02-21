Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E812069D7B8
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjBUAuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjBUAuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:50:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5C31D93B;
        Mon, 20 Feb 2023 16:50:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCE12B80E0E;
        Tue, 21 Feb 2023 00:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E790C433EF;
        Tue, 21 Feb 2023 00:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940602;
        bh=5rFjN5uIbhkdj6kARYf9bweTSU0CALPinH2kWA8//JE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sG6sQSdjyhNdFspWWXRid0ky4Cjq3rQ8r3Omk1tF0k5BM41zu0/5Xv7/RSX85u+Ju
         +1IbzTV1oOUc+/1Z2T/EtHWP1CNe6Eg2R3Ic+SI/Gz+jMge+0QkIHOiuCrAi3Ys62N
         lCphhcxOqOYpn/S7Xz3NedIvy3rud+tBAEZXpJKwgijDH9QbqJkGNEvV6AZQkG1Sk2
         InhqCfkiO3u56OsSHrjCKAa3MJOJcu/SGWSOU7mhEnIRETe9MJI9YK/VYwz/Ymf/gK
         DvY3oQARDFEt+h44Wat//MeeFiKX5IPJdcODtiWVfL3MVPA6eT0HTZvwSka+mLva2+
         RnB82+Zo1IILw==
Date:   Mon, 20 Feb 2023 16:50:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix memory leak in IPsec RoCE
 creation
Message-ID: <20230220165000.1eda0afb@kernel.org>
In-Reply-To: <1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org>
References: <1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Feb 2023 14:59:57 +0200 Leon Romanovsky wrote:
> -rule_fail:
> +fail_rule:
>  	mlx5_destroy_flow_group(roce->g);
> -fail:
> +fail_group:
>  	mlx5_destroy_flow_table(ft);
> +fail_table:
> +	kvfree(in);
>  	return err;

If you're touching all of them please name them after what they do.
Much easier to review.
