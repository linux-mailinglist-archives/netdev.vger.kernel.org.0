Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A291D6CFB6D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjC3GUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjC3GUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38772720;
        Wed, 29 Mar 2023 23:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3817A61EFB;
        Thu, 30 Mar 2023 06:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170BDC433EF;
        Thu, 30 Mar 2023 06:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680157219;
        bh=D7PyQ6TsbNfjIMV6PxSHu+0NI59UxISDjnWFpjKI2mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bp7ePw28GQWqU1QJBIMBxAXKE3X2LVDeQ8W9fppv2YadTs863lbRnuxF9lb9otXAx
         hod3QvAzi/QyvQuIkeiNSjGQ2iyishmV9xXjjIA2/AQZIWtlMC9DGrUH8Zn9XfGF7w
         4Q9FUHMEKHaJEJpYL4mwxFJCIp+YbUwmnecjK7+dWizfoUYegUweLNKeeSP2PvPDLa
         1vha932i9EgXRuierMW8hj/OPZiNPUo4384mRBHEJbjTguHgcfs5aVuckkrhtyUoLJ
         yVy4UrIS4v7BtSef0/xHxx/YMUNJQ3wbFQOcEiT9LIZdk6jN7Onu93fxVnaJSwYKry
         frLnI6DyVuoAw==
Date:   Thu, 30 Mar 2023 09:20:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Message-ID: <20230330062015.GO831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-6-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-6-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:17PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> 1. Update secret key mbox to provide hash mask and hash control as well.
> 2. Allow field hash configuration for both source and destination IPv6
> 3. Fix internal logic for IPv6 source/destination address hash
> reduction via ntuple rule
> 4. Configure hardware parser based on hash extract feature enable flag
>        for IPv6.

This commit message explained what you did, but not what was the
problem.

Thanks

> 
> Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  16 ++-
>  .../marvell/octeontx2/af/rvu_npc_fs.c         |  23 +++-
>  .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
>  .../marvell/octeontx2/af/rvu_npc_hash.c       | 121 ++++++++++--------
>  .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
>  5 files changed, 108 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index 5727d67e0259..0ce533848536 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -245,9 +245,9 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
>  M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
>  				   npc_mcam_get_stats_req,              \
>  				   npc_mcam_get_stats_rsp)              \
> -M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
> -				   npc_get_secret_key_req,              \
> -				   npc_get_secret_key_rsp)              \
> +M(NPC_GET_FIELD_HASH_INFO, 0x6013, npc_get_field_hash_info,                     \
> +				   npc_get_field_hash_info_req,              \
> +				   npc_get_field_hash_info_rsp)              \
>  M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                     \
>  				   npc_get_field_status_req,              \
>  				   npc_get_field_status_rsp)              \
> @@ -1524,14 +1524,20 @@ struct npc_mcam_get_stats_rsp {
>  	u8 stat_ena; /* enabled */
>  };
>  
> -struct npc_get_secret_key_req {
> +struct npc_get_field_hash_info_req {
>  	struct mbox_msghdr hdr;
>  	u8 intf;
>  };
>  
> -struct npc_get_secret_key_rsp {
> +struct npc_get_field_hash_info_rsp {
>  	struct mbox_msghdr hdr;
>  	u64 secret_key[3];
> +#define NPC_MAX_HASH 2
> +#define NPC_MAX_HASH_MASK 2
> +	/* NPC_AF_INTF(0..1)_HASH(0..1)_MASK(0..1) */
> +	u64 hash_mask[NPC_MAX_INTF][NPC_MAX_HASH][NPC_MAX_HASH_MASK];
> +	/* NPC_AF_INTF(0..1)_HASH(0..1)_RESULT_CTRL */
> +	u64 hash_ctrl[NPC_MAX_INTF][NPC_MAX_HASH];
>  };
>  
>  enum ptp_op {
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> index 27603078689a..6d63a0ef6d9c 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> @@ -13,11 +13,6 @@
>  #include "rvu_npc_fs.h"
>  #include "rvu_npc_hash.h"
>  
> -#define NPC_BYTESM		GENMASK_ULL(19, 16)
> -#define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
> -#define NPC_KEY_OFFSET		GENMASK_ULL(5, 0)
> -#define NPC_LDATA_EN		BIT_ULL(7)
> -
>  static const char * const npc_flow_names[] = {
>  	[NPC_DMAC]	= "dmac",
>  	[NPC_SMAC]	= "smac",
> @@ -442,6 +437,7 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
>  static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
>  			   u8 lt, u64 cfg, u8 intf)
>  {
> +	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
>  	struct npc_mcam *mcam = &rvu->hw->mcam;
>  	u8 hdr, key, nr_bytes, bit_offset;
>  	u8 la_ltype, la_start;
> @@ -490,8 +486,21 @@ do {									       \
>  	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
>  	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
>  	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC, NPC_LT_LC_IP6_EXT, 6, 1);
> -	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
> -	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
> +	if (rvu->hw->cap.npc_hash_extract) {
> +		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][0])
> +			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 4);
> +		else
> +			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
> +
> +		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][1])
> +			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 4);
> +		else
> +			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
> +	} else {
> +		NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
> +		NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
> +	}
> +
>  	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
>  	NPC_SCAN_HDR(NPC_DPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 2, 2);
>  	NPC_SCAN_HDR(NPC_SPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 0, 2);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> index bdd65ce56a32..3f5c9042d10e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> @@ -9,6 +9,10 @@
>  #define __RVU_NPC_FS_H
>  
>  #define IPV6_WORDS	4
> +#define NPC_BYTESM	GENMASK_ULL(19, 16)
> +#define NPC_HDR_OFFSET	GENMASK_ULL(15, 8)
> +#define NPC_KEY_OFFSET	GENMASK_ULL(5, 0)
> +#define NPC_LDATA_EN	BIT_ULL(7)
>  
>  void npc_update_entry(struct rvu *rvu, enum key_fields type,
>  		      struct mcam_entry *entry, u64 val_lo,
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> index 6597af84aa36..51209119f0f2 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> @@ -78,42 +78,43 @@ static u32 rvu_npc_toeplitz_hash(const u64 *data, u64 *key, size_t data_bit_len,
>  	return hash_out;
>  }
>  
> -u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
> -			u64 *secret_key, u8 intf, u8 hash_idx)
> +u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
> +			u8 intf, u8 hash_idx)
>  {
>  	u64 hash_key[3];
>  	u64 data_padded[2];
>  	u32 field_hash;
>  
> -	hash_key[0] = secret_key[1] << 31;
> -	hash_key[0] |= secret_key[2];
> -	hash_key[1] = secret_key[1] >> 33;
> -	hash_key[1] |= secret_key[0] << 31;
> -	hash_key[2] = secret_key[0] >> 33;
> +	hash_key[0] = rsp.secret_key[1] << 31;
> +	hash_key[0] |= rsp.secret_key[2];
> +	hash_key[1] = rsp.secret_key[1] >> 33;
> +	hash_key[1] |= rsp.secret_key[0] << 31;
> +	hash_key[2] = rsp.secret_key[0] >> 33;
>  
> -	data_padded[0] = mkex_hash->hash_mask[intf][hash_idx][0] & ldata[0];
> -	data_padded[1] = mkex_hash->hash_mask[intf][hash_idx][1] & ldata[1];
> +	data_padded[0] = rsp.hash_mask[intf][hash_idx][0] & ldata[0];
> +	data_padded[1] = rsp.hash_mask[intf][hash_idx][1] & ldata[1];
>  	field_hash = rvu_npc_toeplitz_hash(data_padded, hash_key, 128, 159);
>  
> -	field_hash &= mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
> -	field_hash |= mkex_hash->hash_ctrl[intf][hash_idx];
> +	field_hash &= FIELD_GET(GENMASK(63, 32), rsp.hash_ctrl[intf][hash_idx]);
> +	field_hash += FIELD_GET(GENMASK(31, 0), rsp.hash_ctrl[intf][hash_idx]);
>  	return field_hash;
>  }
>  
> -static u64 npc_update_use_hash(int lt, int ld)
> +static u64 npc_update_use_hash(struct rvu *rvu, int blkaddr,
> +			       u8 intf, int lid, int lt, int ld)
>  {
> -	u64 cfg = 0;
> -
> -	switch (lt) {
> -	case NPC_LT_LC_IP6:
> -		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
> -		 * in KEX_LD_CFG
> -		 */
> -		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
> -					  ld ? 0x8 : 0x18,
> -					  0x1, 0x0, 0x10);
> -		break;
> -	}
> +	u8 hdr, key;
> +	u64 cfg;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, lt, ld));
> +	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
> +	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
> +
> +	/* Update use_hash(bit-20) to 'true' and
> +	 * bytesm1(bit-16:19) to '0x3' in KEX_LD_CFG
> +	 */
> +	cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
> +				  hdr, 0x1, 0x0, key);
>  
>  	return cfg;
>  }
> @@ -132,12 +133,13 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
>  		for (lt = 0; lt < NPC_MAX_LT; lt++) {
>  			for (ld = 0; ld < NPC_MAX_LD; ld++) {
>  				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
> -					u64 cfg = npc_update_use_hash(lt, ld);
> +					u64 cfg;
>  
> -					hash_cnt++;
>  					if (hash_cnt == NPC_MAX_HASH)
>  						return;
>  
> +					cfg = npc_update_use_hash(rvu, blkaddr,
> +								  intf, lid, lt, ld);
>  					/* Set updated KEX configuration */
>  					SET_KEX_LD(intf, lid, lt, ld, cfg);
>  					/* Set HASH configuration */
> @@ -149,6 +151,8 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
>  							     mkex_hash->hash_mask[intf][ld][1]);
>  					SET_KEX_LD_HASH_CTRL(intf, ld,
>  							     mkex_hash->hash_ctrl[intf][ld]);
> +
> +					hash_cnt++;
>  				}
>  			}
>  		}
> @@ -169,12 +173,13 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
>  		for (lt = 0; lt < NPC_MAX_LT; lt++) {
>  			for (ld = 0; ld < NPC_MAX_LD; ld++)
>  				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
> -					u64 cfg = npc_update_use_hash(lt, ld);
> +					u64 cfg;
>  
> -					hash_cnt++;
>  					if (hash_cnt == NPC_MAX_HASH)
>  						return;
>  
> +					cfg = npc_update_use_hash(rvu, blkaddr,
> +								  intf, lid, lt, ld);
>  					/* Set updated KEX configuration */
>  					SET_KEX_LD(intf, lid, lt, ld, cfg);
>  					/* Set HASH configuration */
> @@ -187,8 +192,6 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
>  					SET_KEX_LD_HASH_CTRL(intf, ld,
>  							     mkex_hash->hash_ctrl[intf][ld]);
>  					hash_cnt++;
> -					if (hash_cnt == NPC_MAX_HASH)
> -						return;
>  				}
>  		}
>  	}
> @@ -238,8 +241,8 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
>  			   struct flow_msg *omask)
>  {
>  	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
> -	struct npc_get_secret_key_req req;
> -	struct npc_get_secret_key_rsp rsp;
> +	struct npc_get_field_hash_info_req req;
> +	struct npc_get_field_hash_info_rsp rsp;
>  	u64 ldata[2], cfg;
>  	u32 field_hash;
>  	u8 hash_idx;
> @@ -250,7 +253,7 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
>  	}
>  
>  	req.intf = intf;
> -	rvu_mbox_handler_npc_get_secret_key(rvu, &req, &rsp);
> +	rvu_mbox_handler_npc_get_field_hash_info(rvu, &req, &rsp);
>  
>  	for (hash_idx = 0; hash_idx < NPC_MAX_HASH; hash_idx++) {
>  		cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_CFG(intf, hash_idx));
> @@ -266,44 +269,45 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
>  				 * is hashed to 32 bit value.
>  				 */
>  				case NPC_LT_LC_IP6:
> -					if (features & BIT_ULL(NPC_SIP_IPV6)) {
> +					/* ld[0] == hash_idx[0] == Source IPv6
> +					 * ld[1] == hash_idx[1] == Destination IPv6
> +					 */
> +					if ((features & BIT_ULL(NPC_SIP_IPV6)) && !hash_idx) {
>  						u32 src_ip[IPV6_WORDS];
>  
>  						be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
> -						ldata[0] = (u64)src_ip[0] << 32 | src_ip[1];
> -						ldata[1] = (u64)src_ip[2] << 32 | src_ip[3];
> +						ldata[1] = (u64)src_ip[0] << 32 | src_ip[1];
> +						ldata[0] = (u64)src_ip[2] << 32 | src_ip[3];
>  						field_hash = npc_field_hash_calc(ldata,
> -										 mkex_hash,
> -										 rsp.secret_key,
> +										 rsp,
>  										 intf,
>  										 hash_idx);
>  						npc_update_entry(rvu, NPC_SIP_IPV6, entry,
> -								 field_hash, 0, 32, 0, intf);
> +								 field_hash, 0,
> +								 GENMASK(31, 0), 0, intf);
>  						memcpy(&opkt->ip6src, &pkt->ip6src,
>  						       sizeof(pkt->ip6src));
>  						memcpy(&omask->ip6src, &mask->ip6src,
>  						       sizeof(mask->ip6src));
> -						break;
> -					}
> -
> -					if (features & BIT_ULL(NPC_DIP_IPV6)) {
> +					} else if ((features & BIT_ULL(NPC_DIP_IPV6)) && hash_idx) {
>  						u32 dst_ip[IPV6_WORDS];
>  
>  						be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
> -						ldata[0] = (u64)dst_ip[0] << 32 | dst_ip[1];
> -						ldata[1] = (u64)dst_ip[2] << 32 | dst_ip[3];
> +						ldata[1] = (u64)dst_ip[0] << 32 | dst_ip[1];
> +						ldata[0] = (u64)dst_ip[2] << 32 | dst_ip[3];
>  						field_hash = npc_field_hash_calc(ldata,
> -										 mkex_hash,
> -										 rsp.secret_key,
> +										 rsp,
>  										 intf,
>  										 hash_idx);
>  						npc_update_entry(rvu, NPC_DIP_IPV6, entry,
> -								 field_hash, 0, 32, 0, intf);
> +								 field_hash, 0,
> +								 GENMASK(31, 0), 0, intf);
>  						memcpy(&opkt->ip6dst, &pkt->ip6dst,
>  						       sizeof(pkt->ip6dst));
>  						memcpy(&omask->ip6dst, &mask->ip6dst,
>  						       sizeof(mask->ip6dst));
>  					}
> +
>  					break;
>  				}
>  			}
> @@ -311,13 +315,13 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
>  	}
>  }
>  
> -int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
> -					struct npc_get_secret_key_req *req,
> -					struct npc_get_secret_key_rsp *rsp)
> +int rvu_mbox_handler_npc_get_field_hash_info(struct rvu *rvu,
> +					     struct npc_get_field_hash_info_req *req,
> +					     struct npc_get_field_hash_info_rsp *rsp)
>  {
>  	u64 *secret_key = rsp->secret_key;
>  	u8 intf = req->intf;
> -	int blkaddr;
> +	int i, j, blkaddr;
>  
>  	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
>  	if (blkaddr < 0) {
> @@ -329,6 +333,19 @@ int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
>  	secret_key[1] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf));
>  	secret_key[2] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf));
>  
> +	for (i = 0; i < NPC_MAX_HASH; i++) {
> +		for (j = 0; j < NPC_MAX_HASH_MASK; j++) {
> +			rsp->hash_mask[NIX_INTF_RX][i][j] =
> +				GET_KEX_LD_HASH_MASK(NIX_INTF_RX, i, j);
> +			rsp->hash_mask[NIX_INTF_TX][i][j] =
> +				GET_KEX_LD_HASH_MASK(NIX_INTF_TX, i, j);
> +		}
> +	}
> +
> +	for (i = 0; i < NPC_MAX_INTF; i++)
> +		for (j = 0; j < NPC_MAX_HASH; j++)
> +			rsp->hash_ctrl[i][j] = GET_KEX_LD_HASH_CTRL(i, j);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> index 3efeb09c58de..a1c3d987b804 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> @@ -31,6 +31,12 @@
>  	rvu_write64(rvu, blkaddr,	\
>  		    NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx), cfg)
>  
> +#define GET_KEX_LD_HASH_CTRL(intf, ld)	\
> +	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld))
> +
> +#define GET_KEX_LD_HASH_MASK(intf, ld, mask_idx)	\
> +	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx))
> +
>  #define SET_KEX_LD_HASH_CTRL(intf, ld, cfg) \
>  	rvu_write64(rvu, blkaddr,	\
>  		    NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld), cfg)
> @@ -56,8 +62,8 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
>  			   struct flow_msg *omask);
>  void npc_config_secret_key(struct rvu *rvu, int blkaddr);
>  void npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
> -u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
> -			u64 *secret_key, u8 intf, u8 hash_idx);
> +u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
> +			u8 intf, u8 hash_idx);
>  
>  static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
>  	.lid_lt_ld_hash_en = {
> -- 
> 2.25.1
> 
