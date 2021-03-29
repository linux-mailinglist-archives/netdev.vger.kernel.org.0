Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0D234D958
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhC2U4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhC2U4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:56:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D79061883;
        Mon, 29 Mar 2021 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051370;
        bh=qHo/yGQIIZlrZzV8Nq0BOuyZ1B4eQ5Plw35hWvbnclo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S7i7gQ0vlN7OoZVMV1Y8K6yGx59tgyzYf8xIiqwu3vxKZl+LccwlRS1F8YEs/00NO
         kKjZD7UQhHc3w0LGKkv0lgvqwlrCf1+0LuF2IFD6uZfA3DerTg1PA4eirSI8C2qmVB
         QCL7cH8xPVXNzErC1hqQomv3HfibWt7WqttqdRIgHmhAJ6LMgGl9XJT46kKh5RR5lE
         euWCVeMRT/gj8ZZTEBPPF8V5SeZBUZddvcbRs2CY7IcLUNk1tQ9t+Z3a6w6Xg5kIxB
         FMvlk8X+XnlJLWKBIw9zdgvs27bPT+LM4rMN9sXlV6DGSIp8VSniWF1S2gQl0wKoXE
         1AamXIY/+YiOw==
Message-ID: <0a6894be727b1bb2124bff19a419972f589b4d7e.camel@kernel.org>
Subject: Re: ESP RSS support for NVIDIA Mellanox ConnectX-6 Ethernet Adapter
 Cards
From:   Saeed Mahameed <saeed@kernel.org>
To:     =?UTF-8?Q?=E9=AB=98=E9=92=A7=E6=B5=A9?= <gaojunhao0504@gmail.com>,
        borisp@nvidia.com
Cc:     netdev@vger.kernel.org, seven.wen@ucloud.cn, junhao.gao@ucloud.cn
Date:   Mon, 29 Mar 2021 13:56:09 -0700
In-Reply-To: <CAOJPZgnLjr6VHvtv9NnemxFagvL-k1wrRsB1f1Pq+9qbtPWw0g@mail.gmail.com>
References: <CAOJPZgnLjr6VHvtv9NnemxFagvL-k1wrRsB1f1Pq+9qbtPWw0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 12:33 +0800, 高钧浩 wrote:
> Hi borisp, saeedm
> 
>      I have seen mlx5 driver in 5.12.0-rc4 kernel, then find that
> mlx5e_set_rss_hash_opt only support tcp4/udp4/tcp6/udp6. So mlx5
> kernel driver doesn't support esp4 rss? Then do you have any plan to
> support esp4 or other latest mlx5 driver have supported esp4? Then
> does NVIDIA Mellanox ConnectX-6 Ethernet Adapter Cards support esp4
> rss in hardware?
> 

Hi Juhano

we do support RSS ESP out of the box on the SPI, src and dst IP fields

#define MLX5_HASH_IP_IPSEC_SPI	(MLX5_HASH_FIELD_SEL_SRC_IP   |\
				 MLX5_HASH_FIELD_SEL_DST_IP   |\
				 MLX5_HASH_FIELD_SEL_IPSEC_SPI)

[MLX5E_TT_IPV4_IPSEC_ESP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
			      .l4_prot_type = 0,
			      .rx_hash_fields =
MLX5_HASH_IP_IPSEC_SPI,
},

[MLX5E_TT_IPV6_IPSEC_ESP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
			      .l4_prot_type = 0,
			      .rx_hash_fields =
MLX5_HASH_IP_IPSEC_SPI,
},

But we don't allow rss_hash_opt at the moment. 

what exactly are you looking for ?

> static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
>                  struct ethtool_rxnfc *nfc)
> {
>     int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
>     enum mlx5e_traffic_types tt;
>     u8 rx_hash_field = 0;
>     void *in;
>     tt = flow_type_to_traffic_type(nfc->flow_type);
>     if (tt == MLX5E_NUM_INDIR_TIRS)
>         return -EINVAL;
>     /* RSS does not support anything other than hashing to queues
>      * on src IP, dest IP, TCP/UDP src port and TCP/UDP dest
>      * port.
>      */
>     if (nfc->flow_type != TCP_V4_FLOW &&
>       nfc->flow_type != TCP_V6_FLOW &&
>       nfc->flow_type != UDP_V4_FLOW &&
>       nfc->flow_type != UDP_V6_FLOW)
>         return -EOPNOTSUPP;
> 
> Best Regards,
> Junhao


