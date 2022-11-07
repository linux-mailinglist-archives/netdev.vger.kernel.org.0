Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18D261EAD4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKGGOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKGGOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:14:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4EDFCCE
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 22:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E841AB80D15
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC62C433C1;
        Mon,  7 Nov 2022 06:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667801657;
        bh=WvjfOU2RGhn6iwH6/Qyt+iTwBe66sVxxVvw9Y9eeA30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TvCC/AFjGkMJQUgRyEaHcn2qQ5+HQq1exlag6xPgN9O32JawfeO3Ss66LLu+hjv26
         5qjEx0INpTUrKbrClZcBK9wf+0W+lhyCWJCecDSDofk1i0FI6g75OrZi4zPZ9uTPjy
         Lm8+hW3RHff+szfQMpVPafCKJ0DdN6UfBgweOfA6pB5ED4WmX7nJNqYdfq+bVMUzvI
         4Ccnlhj/PF63irTDrc19blmRbw0/QPBK/qdM31BFuNZ0/3NBaWe5lOY924a53C0tJU
         OiTcXYphUh2ob4SRLDYvdc09TRHnU6LG0nb9K3yHELdtvVBqC9zaXRJreVH63MH3oL
         pMVM+nkc+JkIw==
Date:   Mon, 7 Nov 2022 08:14:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v3 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <Y2iiNMxr3IeDgIaA@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101110248.423966-4-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:02:48PM +0100, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Xfrm callbacks are implemented to offload SA info into firmware
> by mailbox. It supports 16K SA info in total.
> 
> Expose ipsec offload feature to upper layer, this feature will
> signal the availability of the offload.
> 
> Based on initial work of Norm Bagley <norman.bagley@netronome.com>.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 532 +++++++++++++++++-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
>  3 files changed, 538 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> index 11575a9cb3b0..664a36be60e7 100644
> --- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> +++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
> @@ -16,18 +16,546 @@

<...>

> +/* IPSEC_CFG_MSSG_ADD_SA */
> +struct nfp_ipsec_cfg_add_sa {
> +	u32 ciph_key[8];		  /* Cipher Key */
> +	union {
> +		u32 auth_key[16];	  /* Authentication Key */
> +		struct nfp_ipsec_aesgcm { /* AES-GCM-ESP fields */
> +			u32 salt;	  /* Initialized with SA */
> +			u32 iv[2];	  /* Firmware use only */
> +			u32 cntr;
> +			u32 zeros[4];	  /* Init to 0 with SA */
> +			u32 len_a[2];	  /* Firmware use only */
> +			u32 len_c[2];
> +			u32 spare0[4];
> +		} aesgcm_fields;
> +	};
> +	struct sa_ctrl_word {
> +		uint32_t hash   :4;	  /* From nfp_ipsec_sa_hash_type */
> +		uint32_t cimode :4;	  /* From nfp_ipsec_sa_cipher_mode */
> +		uint32_t cipher :4;	  /* From nfp_ipsec_sa_cipher */
> +		uint32_t mode   :2;	  /* From nfp_ipsec_sa_mode */
> +		uint32_t proto  :2;	  /* From nfp_ipsec_sa_prot */
> +		uint32_t dir :1;	  /* SA direction */
> +		uint32_t ena_arw:1;	  /* Anti-Replay Window */
> +		uint32_t ext_seq:1;	  /* 64-bit Sequence Num */
> +		uint32_t ext_arw:1;	  /* 64b Anti-Replay Window */
> +		uint32_t spare2 :9;	  /* Must be set to 0 */
> +		uint32_t encap_dsbl:1;	  /* Encap/Decap disable */
> +		uint32_t gen_seq:1;	  /* Firmware Generate Seq */
> +		uint32_t spare8 :1;	  /* Must be set to 0 */
> +	} ctrl_word;
> +	u32 spi;			  /* SPI Value */
> +	uint32_t pmtu_limit :16;	  /* PMTU Limit */
> +	uint32_t spare3     :1;
> +	uint32_t frag_check :1;		  /* Stateful fragment checking flag */
> +	uint32_t bypass_DSCP:1;		  /* Bypass DSCP Flag */
> +	uint32_t df_ctrl    :2;		  /* DF Control bits */
> +	uint32_t ipv6       :1;		  /* Outbound IPv6 addr format */
> +	uint32_t udp_enable :1;		  /* Add/Remove UDP header for NAT */
> +	uint32_t tfc_enable :1;		  /* Traffic Flow Confidentiality */
> +	uint32_t spare4	 :8;
> +	u32 soft_lifetime_byte_count;
> +	u32 hard_lifetime_byte_count;

These fields are not relevant for IPsec crypto offload. I would be more
than happy to see only used fields here.

> +	u32 src_ip[4];			  /* Src IP addr */
> +	u32 dst_ip[4];			  /* Dst IP addr */
> +	uint32_t natt_dst_port :16;	  /* NAT-T UDP Header dst port */
> +	uint32_t natt_src_port :16;	  /* NAT-T UDP Header src port */
> +	u32 soft_lifetime_time_limit;
> +	u32 hard_lifetime_time_limit;
> +	u32 sa_creation_time_lo_32;	  /* Ucode fills this in */
> +	u32 sa_creation_time_hi_32;	  /* Ucode fills this in */
> +	uint32_t reserved0   :16;
> +	uint32_t tfc_padding :16;	  /* Traffic Flow Confidential Pad */
> +};
> +
> +/* IPSEC_CFG_MSSG_INV_SA */
> +struct nfp_ipsec_cfg_inv_sa {
> +	u32 spare6;
> +};
> +
> +/* IPSEC_CFG_MSSG_GET_SA_STATS */
> +struct nfp_ipsec_cfg_get_sa_stats {
> +	u32 seq_lo;					/* Sequence Number (low 32bits) */
> +	u32 seq_high;					/* Sequence Number (high 32bits) */
> +	u32 arw_counter_lo;				/* Anti-replay wndw cntr */
> +	u32 arw_counter_high;				/* Anti-replay wndw cntr */
> +	u32 arw_bitmap_lo;				/* Anti-replay wndw bitmap */
> +	u32 arw_bitmap_high;				/* Anti-replay wndw bitmap */
> +	uint32_t reserved1:1;
> +	uint32_t soft_lifetime_byte_cnt_exceeded :1;	/* Soft cnt_exceeded */
> +	uint32_t hard_lifetime_byte_cnt_exceeded :1;	/* Hard cnt_exceeded */
> +	uint32_t soft_lifetime_time_limit_exceeded :1;	/* Soft cnt_exceeded */
> +	uint32_t hard_lifetime_time_limit_exceeded :1;	/* Hard cnt_exceeded */

Not relevant for crypto.

> +	uint32_t spare7:27;
> +	u32 lifetime_byte_count;

Ditto

> +	u32 pkt_count;
> +	u32 discards_auth;				/* Auth failures */
> +	u32 discards_unsupported;			/* Unsupported crypto mode */
> +	u32 discards_alignment;				/* Alignment error */
> +	u32 discards_hard_bytelimit;			/* Byte Count limit */
> +	u32 discards_seq_num_wrap;			/* Sequ Number wrap */
> +	u32 discards_pmtu_limit_exceeded;		/* PMTU Limit */
> +	u32 discards_arw_old_seq;			/* Anti-Replay seq small */
> +	u32 discards_arw_replay;			/* Anti-Replay seq rcvd */
> +	u32 discards_ctrl_word;				/* Bad SA Control word */
> +	u32 discards_ip_hdr_len;			/* Hdr offset from too high */
> +	u32 discards_eop_buf;				/* No EOP buffer */
> +	u32 ipv4_id_counter;				/* IPv4 ID field counter */
> +	u32 discards_isl_fail;				/* Inbound SPD Lookup failure */
> +	u32 discards_ext_not_found;			/* Ext header end */
> +	u32 discards_max_ext_hdrs;			/* Max ext header */
> +	u32 discards_non_ext_hdrs;			/* Non-extension headers */
> +	u32 discards_ext_hdr_too_big;			/* Ext header chain */
> +	u32 discards_hard_timelimit;			/* Time Limit */
> +};

<...>

> +static int nfp_ipsec_cfg_cmd_issue(struct nfp_net *nn, int type, int saidx,
> +				   struct nfp_ipsec_cfg_mssg *msg)
> +{
> +	int i, msg_size, ret;
> +
> +	msg->cmd = type;
> +	msg->sa_idx = saidx;
> +	msg->rsp = 0;
> +	msg_size = ARRAY_SIZE(msg->raw);
> +
> +	for (i = 0; i < msg_size; i++)
> +		nn_writel(nn, NFP_NET_CFG_MBOX_VAL + 4 * i, msg->raw[i]);
> +
> +	ret = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_IPSEC);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* For now we always read the whole message response back */
> +	for (i = 0; i < msg_size; i++)
> +		msg->raw[i] = nn_readl(nn, NFP_NET_CFG_MBOX_VAL + 4 * i);
> +
> +	switch (msg->rsp) {
> +	case NFP_IPSEC_CFG_MSSG_OK:
> +		return 0;
> +	case NFP_IPSEC_CFG_MSSG_SA_INVALID_CMD:
> +		return -EINVAL;
> +	case NFP_IPSEC_CFG_MSSG_SA_VALID:
> +		return -EEXIST;
> +	case NFP_IPSEC_CFG_MSSG_FAILED:
> +	case NFP_IPSEC_CFG_MSSG_SA_HASH_ADD_FAILED:
> +	case NFP_IPSEC_CFG_MSSG_SA_HASH_DEL_FAILED:
> +		return -EIO;
> +	default:
> +		return -EDOM;

Let's not bring cool error numbers when they don't need to be such.
It is -EINVAL here.

> +	}
> +}
> +
> +static int set_aes_keylen(struct nfp_ipsec_cfg_add_sa *cfg, int alg, int keylen)
> +{
> +	if (alg == SADB_X_EALG_NULL_AES_GMAC) {
> +		if (keylen == 128)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES128_NULL;
> +		else if (keylen == 192)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES192_NULL;
> +		else if (keylen == 256)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES256_NULL;
> +		else
> +			return -EINVAL;

Place "return 0;" here and get rid of "else".

> +	} else {
> +		if (keylen == 128)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES128;
> +		else if (keylen == 192)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES192;
> +		else if (keylen == 256)
> +			cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_AES256;
> +		else
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int nfp_net_xfrm_add_state(struct xfrm_state *x)
>  {
> -	return -EOPNOTSUPP;
> +	struct net_device *netdev = x->xso.dev;
> +	struct nfp_ipsec_cfg_mssg msg = {0};
> +	int i, key_len, trunc_len, err = 0;
> +	struct nfp_ipsec_cfg_add_sa *cfg;
> +	struct nfp_net *nn;
> +	unsigned int saidx;
> +	__be32 *p;
> +
> +	nn = netdev_priv(netdev);
> +	cfg = &msg.cfg_add_sa;
> +
> +	/* General */
> +	switch (x->props.mode) {
> +	case XFRM_MODE_TUNNEL:
> +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TUNNEL;
> +		break;
> +	case XFRM_MODE_TRANSPORT:
> +		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
> +		break;

Why is it important for IPsec crypto? The HW logic must be the same for
all modes. There are no differences between transport and tunnel.

> +	default:
> +		nn_err(nn, "Unsupported mode for xfrm offload\n");

There are no other modes.

> +		return -EINVAL;
> +	}
> +
> +	switch (x->id.proto) {
> +	case IPPROTO_ESP:
> +		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_ESP;
> +		break;
> +	case IPPROTO_AH:
> +		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_AH;
> +		break;
> +	default:
> +		nn_err(nn, "Unsupported protocol for xfrm offload\n");
> +		return -EINVAL;
> +	}

<...>

> +	err = xa_alloc(&nn->xa_ipsec, &saidx, x,
> +		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1), GFP_KERNEL);

Create XArray with XA_FLAGS_ALLOC1, it will cause to xarray skip 0.
See DEFINE_XARRAY_ALLOC1() for more info.


> +	if (err < 0) {
> +		nn_err(nn, "Unable to get sa_data number for IPsec\n");
> +		return err;
> +	}
> +
> +	/* Allocate saidx and commit the SA */
> +	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
> +	if (err) {
> +		xa_erase(&nn->xa_ipsec, saidx);
> +		nn_err(nn, "Failed to issue IPsec command err ret=%d\n", err);
> +		return err;
> +	}
> +
> +	/* 0 is invalid offload_handle for kernel */
> +	x->xso.offload_handle = saidx + 1;

If you create XArray as I said above, you won't need to add +1.

> +	return 0;
>  }

<...>

>  static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
>  {
> -	return false;
> +	if (x->props.family == AF_INET) {
> +		/* Offload with IPv4 options is not supported yet */
> +		if (ip_hdr(skb)->ihl != 5)
> +			return false;

return here and remove "else" from all places.

> +	} else {
> +		/* Offload with IPv6 extension headers is not support yet */
> +		if (ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
> +			return false;
> +	}
> +
> +	return true;
>  }

Thanks
