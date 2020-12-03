Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04E72CE28A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgLCXSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgLCXSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:18:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B37C061A51;
        Thu,  3 Dec 2020 15:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=GbN6p5LJBQMV2DfD8kd+4I6ceA4CufBGmT9SnoxAGqQ=; b=S0DSvSsIRZ3cajRtUQngzvi2RO
        RH3MNAgj67ramRwATf22c0EhXildLAliL+awWFv99Mz2cruVI2y2Prc7MppWAr2wM3LUvG9k9ZW9N
        qrJ4yPftx9LgfQpk9J0R0lPPy/RhPW9A5j+3CpCb008mLd+B3R3TsxAc19g/aVv8aOtPFjQyavGEB
        o+RH6n+pd2DHYfQgebZS8ns6MTrWdslMJ+YPdfvUnDNY9eiXGwsf5sKt4M3QDbE0b3Gd2K6VFE5nY
        bvylAntUCCdP3jpHt9diDX0VI7lXRxjri2eaf50ujgmvhq5lSN6dfBf99Dc4VxdAgLuf6POhA5ysQ
        vwRGw/rg==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkxrK-0001Tg-JT; Thu, 03 Dec 2020 23:17:58 +0000
Subject: Re: [PATCH] net/mlx5e: fix non-IPV6 build
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Boris Pismenny <borisp@nvidia.com>,
        Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201203231314.1483198-1-arnd@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <48fbaf7c-9661-c485-584f-d54c9ab9ec67@infradead.org>
Date:   Thu, 3 Dec 2020 15:17:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203231314.1483198-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 3:12 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When IPv6 is disabled, the flow steering code causes a build failure:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: error: no member named 'skc_v6_daddr' in 'struct sock_common'; did you mean 'skc_daddr'?
>                &sk->sk_v6_daddr, 16);
>                     ^
> include/net/sock.h:380:34: note: expanded from macro 'sk_v6_daddr'
>  #define sk_v6_daddr             __sk_common.skc_v6_daddr
> 
> Hide the newly added function in an #ifdef that matches its callers
> and the struct member definition.
> 
> Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules add/del")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> index 97f1594cee11..e51f60b55daa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> @@ -44,6 +44,7 @@ static void accel_fs_tcp_set_ipv4_flow(struct mlx5_flow_spec *spec, struct sock
>  			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
>  static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
>  {
>  	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
> @@ -63,6 +64,7 @@ static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock
>  			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
>  	       0xff, 16);
>  }
> +#endif
>  
>  void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
>  {
> 

Fix for this was just merged by Linus [NETWORKING PR].

thanks.
-- 
~Randy

