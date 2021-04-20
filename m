Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E903651A5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhDTEyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:54:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:35848 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhDTEys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 00:54:48 -0400
IronPort-SDR: w67AFBKy6kpfOeEbDp1LeXqhMhCd4OT0S6mh5Vhca3yJBi6xU+89DQqFAo9QN+L9JDnihpSgkP
 GbgCvEOiSndw==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="194999330"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="194999330"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 21:54:18 -0700
IronPort-SDR: nEMBihshE4yQfnc91H+r5M0JhwCHq4QgMAVmqFlQwCBJJUWMaoYyxpnC5or3FlRkJcVqpDMjHu
 hWq5/hyuybZw==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="390879095"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.195.85]) ([10.212.195.85])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 21:54:17 -0700
Subject: Re: [net-next 07/15] net/mlx5: mlx5_ifc updates for flex parser
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210420032018.58639-1-saeed@kernel.org>
 <20210420032018.58639-8-saeed@kernel.org>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <f21f0500-2150-9975-cfee-1629766634b8@intel.com>
Date:   Mon, 19 Apr 2021 21:54:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420032018.58639-8-saeed@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/2021 8:20 PM, Saeed Mahameed wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>
> Added the required definitions for supporting more protocols by flex parsers
> (GTP-U, Geneve TLV options), and for using the right flex parser that was
> configured for this protocol.
Are you planning to support adding flow rules to match on these protocol 
specific fields?
If so,  are you planning to extend tc flower OR use other interfaces?


> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   include/linux/mlx5/mlx5_ifc.h | 32 ++++++++++++++++++++++++++++----
>   1 file changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index f2c51d6833c6..aa6effe1dd6d 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -622,7 +622,19 @@ struct mlx5_ifc_fte_match_set_misc3_bits {
>   
>   	u8         geneve_tlv_option_0_data[0x20];
>   
> -	u8         reserved_at_140[0xc0];
> +	u8	   gtpu_teid[0x20];
> +
> +	u8	   gtpu_msg_type[0x8];
> +	u8	   gtpu_msg_flags[0x8];
> +	u8	   reserved_at_170[0x10];
> +
> +	u8	   gtpu_dw_2[0x20];
> +
> +	u8	   gtpu_first_ext_dw_0[0x20];
> +
> +	u8	   gtpu_dw_0[0x20];
> +
> +	u8	   reserved_at_1e0[0x20];
>   };
>   
>   struct mlx5_ifc_fte_match_set_misc4_bits {
> @@ -1237,9 +1249,17 @@ enum {
>   
>   enum {
>   	MLX5_FLEX_PARSER_GENEVE_ENABLED		= 1 << 3,
> +	MLX5_FLEX_PARSER_MPLS_OVER_GRE_ENABLED	= 1 << 4,
> +	mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED	= 1 << 5,
>   	MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED	= 1 << 7,
>   	MLX5_FLEX_PARSER_ICMP_V4_ENABLED	= 1 << 8,
>   	MLX5_FLEX_PARSER_ICMP_V6_ENABLED	= 1 << 9,
> +	MLX5_FLEX_PARSER_GENEVE_TLV_OPTION_0_ENABLED = 1 << 10,
> +	MLX5_FLEX_PARSER_GTPU_ENABLED		= 1 << 11,
> +	MLX5_FLEX_PARSER_GTPU_DW_2_ENABLED	= 1 << 16,
> +	MLX5_FLEX_PARSER_GTPU_FIRST_EXT_DW_0_ENABLED = 1 << 17,
> +	MLX5_FLEX_PARSER_GTPU_DW_0_ENABLED	= 1 << 18,
> +	MLX5_FLEX_PARSER_GTPU_TEID_ENABLED	= 1 << 19,
>   };
>   
>   enum {
> @@ -1637,7 +1657,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>   	u8         cqe_compression_timeout[0x10];
>   	u8         cqe_compression_max_num[0x10];
>   
> -	u8         reserved_at_5e0[0x10];
> +	u8         reserved_at_5e0[0x8];
> +	u8         flex_parser_id_gtpu_dw_0[0x4];
> +	u8         reserved_at_5ec[0x4];
>   	u8         tag_matching[0x1];
>   	u8         rndv_offload_rc[0x1];
>   	u8         rndv_offload_dc[0x1];
> @@ -1648,7 +1670,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>   	u8	   affiliate_nic_vport_criteria[0x8];
>   	u8	   native_port_num[0x8];
>   	u8	   num_vhca_ports[0x8];
> -	u8	   reserved_at_618[0x6];
> +	u8         flex_parser_id_gtpu_teid[0x4];
> +	u8         reserved_at_61c[0x2];
>   	u8	   sw_owner_id[0x1];
>   	u8         reserved_at_61f[0x1];
>   
> @@ -1683,7 +1706,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>   	u8	   reserved_at_6e0[0x10];
>   	u8	   sf_base_id[0x10];
>   
> -	u8	   reserved_at_700[0x8];
> +	u8         flex_parser_id_gtpu_dw_2[0x4];
> +	u8         flex_parser_id_gtpu_first_ext_dw_0[0x4];
>   	u8	   num_total_dynamic_vf_msix[0x18];
>   	u8	   reserved_at_720[0x14];
>   	u8	   dynamic_msix_table_size[0xc];

