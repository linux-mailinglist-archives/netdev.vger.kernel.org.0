Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCB548CE72
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiALWfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:35:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48192 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiALWfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:35:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A8D6B82141
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D257FC36AE9;
        Wed, 12 Jan 2022 22:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642026934;
        bh=fsj3DvFQS5NrqQwUKIFMluMmTc4uJU8CiHTRJetQPeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DYoP0mAQsZzY7PnK1QNGeB40q2UefsvkjuVsLffunUrQgFLoXEpWphKNsGA4NVi0h
         pRCEV9nnX52KVWroFFEXLGsJw9ZAKRdUX1/Me6IobXmvKW8qVzaYZvd9NfiUQtpVaw
         X/XRcPwRFvUq141O1ih+iDopBJ3PikB4FUoR7HFzI4uq5UH/VztZpylhe3DLpMk+Y5
         TOTLrU00N1W1axv+TC7Pikb8KFwvCcHQTLDgd7/+QrqZAXp0D21KoJkmMW+ySbFmOz
         TqiEt/S3E8Gly80myL6SRNb8+Ga1+GQOSy0SsATzTorV6Dq9pFAF/bgGaX9ZVaj66Y
         0mjxXeL7AaH8Q==
Date:   Wed, 12 Jan 2022 14:35:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 7/8] net/funeth: add kTLS TX control part
Message-ID: <20220112143532.3aab21e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110015636.245666-8-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220110015636.245666-8-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:56:35 -0800 Dimitris Michailidis wrote:
> This provides the control pieces for kTLS Tx offload, implementinng the
> offload operations.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> ---
>  .../ethernet/fungible/funeth/funeth_ktls.c    | 181 ++++++++++++++++++
>  .../ethernet/fungible/funeth/funeth_ktls.h    |  33 ++++
>  2 files changed, 214 insertions(+)
>  create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
>  create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h
> 
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.c b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
> new file mode 100644
> index 000000000000..bdcf3365bb16
> --- /dev/null
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
> @@ -0,0 +1,181 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
> +
> +#include "funeth.h"
> +#include "funeth_ktls.h"
> +
> +static int fun_admin_ktls_create(struct funeth_priv *fp, unsigned int id)
> +{
> +	struct fun_admin_ktls_create_req req = {
> +		.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
> +						     sizeof(req)),
> +		.subop = FUN_ADMIN_SUBOP_CREATE,
> +		.id = cpu_to_be32(id),
> +	};
> +
> +	return fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
> +}
> +
> +static int fun_ktls_add(struct net_device *netdev, struct sock *sk,
> +			enum tls_offload_ctx_dir direction,
> +			struct tls_crypto_info *crypto_info,
> +			u32 start_offload_tcp_sn)
> +{
> +	struct funeth_priv *fp = netdev_priv(netdev);
> +	struct fun_admin_ktls_modify_req req = {
> +		.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
> +						     sizeof(req)),
> +		.subop = FUN_ADMIN_SUBOP_MODIFY,
> +		.id = cpu_to_be32(fp->ktls_id),
> +		.tcp_seq = cpu_to_be32(start_offload_tcp_sn),
> +	};
> +	struct fun_admin_ktls_modify_rsp rsp;
> +	struct fun_ktls_tx_ctx *tx_ctx;
> +	int rc;
> +
> +	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
> +		return -EOPNOTSUPP;
> +
> +	if (crypto_info->version == TLS_1_2_VERSION)
> +		req.version = FUN_KTLS_TLSV2;
> +	else if (crypto_info->version == TLS_1_3_VERSION)
> +		req.version = FUN_KTLS_TLSV3;


> +	else
> +		return -EOPNOTSUPP;
> +
> +	switch (crypto_info->cipher_type) {
> +	case TLS_CIPHER_AES_GCM_128: {
> +		struct tls12_crypto_info_aes_gcm_128 *c = (void *)crypto_info;
> +
> +		req.cipher = FUN_KTLS_CIPHER_AES_GCM_128;
> +		memcpy(req.key, c->key, sizeof(c->key));
> +		memcpy(req.iv, c->iv, sizeof(c->iv));
> +		memcpy(req.salt, c->salt, sizeof(c->salt));
> +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> +		break;
> +	}
> +
> +	case TLS_CIPHER_AES_GCM_256: {
> +		struct tls12_crypto_info_aes_gcm_256 *c = (void *)crypto_info;
> +
> +		req.cipher = FUN_KTLS_CIPHER_AES_GCM_256;
> +		memcpy(req.key, c->key, sizeof(c->key));
> +		memcpy(req.iv, c->iv, sizeof(c->iv));
> +		memcpy(req.salt, c->salt, sizeof(c->salt));
> +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> +		break;
> +	}
> +
> +	case TLS_CIPHER_CHACHA20_POLY1305: {
> +		struct tls12_crypto_info_chacha20_poly1305 *c;
> +
> +		c = (void *)crypto_info;
> +		req.cipher = FUN_KTLS_CIPHER_CHACHA20_POLY1305;
> +		memcpy(req.key, c->key, sizeof(c->key));
> +		memcpy(req.iv, c->iv, sizeof(c->iv));
> +		memcpy(req.salt, c->salt, sizeof(c->salt));
> +		memcpy(req.record_seq, c->rec_seq, sizeof(c->rec_seq));
> +		break;
> +	}
> +
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	rc = fun_submit_admin_sync_cmd(fp->fdev, &req.common, &rsp,
> +				       sizeof(rsp), 0);
> +	memzero_explicit(&req, sizeof(req));
> +	if (rc)
> +		return rc;
> +
> +	tx_ctx = tls_driver_ctx(sk, direction);
> +	tx_ctx->tlsid = rsp.tlsid;
> +	tx_ctx->next_seq = start_offload_tcp_sn;
> +	atomic64_inc(&fp->tx_tls_add);
> +	return 0;
> +}
> +
> +static void fun_ktls_del(struct net_device *netdev,
> +			 struct tls_context *tls_ctx,
> +			 enum tls_offload_ctx_dir direction)
> +{
> +	struct funeth_priv *fp = netdev_priv(netdev);
> +	struct fun_admin_ktls_modify_req req;
> +	struct fun_ktls_tx_ctx *tx_ctx;
> +
> +	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
> +		return;
> +
> +	tx_ctx = __tls_driver_ctx(tls_ctx, direction);
> +
> +	req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
> +			offsetof(struct fun_admin_ktls_modify_req, tcp_seq));
> +	req.subop = FUN_ADMIN_SUBOP_MODIFY;
> +	req.flags = cpu_to_be16(FUN_KTLS_MODIFY_REMOVE);
> +	req.id = cpu_to_be32(fp->ktls_id);
> +	req.tlsid = tx_ctx->tlsid;
> +
> +	fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
> +	atomic64_inc(&fp->tx_tls_del);
> +}
> +
> +static int fun_ktls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
> +			   u8 *rcd_sn, enum tls_offload_ctx_dir direction)
> +{
> +	struct funeth_priv *fp = netdev_priv(netdev);
> +	struct fun_admin_ktls_modify_req req;
> +	struct fun_ktls_tx_ctx *tx_ctx;
> +	int rc;
> +
> +	if (direction != TLS_OFFLOAD_CTX_DIR_TX)
> +		return -EOPNOTSUPP;
> +
> +	tx_ctx = tls_driver_ctx(sk, direction);
> +
> +	req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_KTLS,
> +			offsetof(struct fun_admin_ktls_modify_req, key));
> +	req.subop = FUN_ADMIN_SUBOP_MODIFY;
> +	req.flags = 0;
> +	req.id = cpu_to_be32(fp->ktls_id);
> +	req.tlsid = tx_ctx->tlsid;
> +	req.tcp_seq = cpu_to_be32(seq);
> +	req.version = 0;
> +	req.cipher = 0;
> +	memcpy(req.record_seq, rcd_sn, sizeof(req.record_seq));
> +
> +	atomic64_inc(&fp->tx_tls_resync);
> +	rc = fun_submit_admin_sync_cmd(fp->fdev, &req.common, NULL, 0, 0);
> +	if (!rc)
> +		tx_ctx->next_seq = seq;
> +	return rc;
> +}
> +
> +static const struct tlsdev_ops fun_ktls_ops = {
> +	.tls_dev_add = fun_ktls_add,
> +	.tls_dev_del = fun_ktls_del,
> +	.tls_dev_resync = fun_ktls_resync,
> +};
> +
> +int fun_ktls_init(struct net_device *netdev)
> +{
> +	struct funeth_priv *fp = netdev_priv(netdev);
> +	int rc;
> +
> +	rc = fun_admin_ktls_create(fp, netdev->dev_port);
> +	if (rc)
> +		return rc;
> +
> +	fp->ktls_id = netdev->dev_port;
> +	netdev->tlsdev_ops = &fun_ktls_ops;
> +	netdev->hw_features |= NETIF_F_HW_TLS_TX;
> +	netdev->features |= NETIF_F_HW_TLS_TX;
> +	return 0;
> +}
> +
> +void fun_ktls_cleanup(struct funeth_priv *fp)
> +{
> +	if (fp->ktls_id == FUN_HCI_ID_INVALID)
> +		return;
> +
> +	fun_res_destroy(fp->fdev, FUN_ADMIN_OP_KTLS, 0, fp->ktls_id);
> +	fp->ktls_id = FUN_HCI_ID_INVALID;
> +}
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.h b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
> new file mode 100644
> index 000000000000..1b433ac8cd7b
> --- /dev/null
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
> +
> +#ifndef _FUN_KTLS_H
> +#define _FUN_KTLS_H
> +
> +struct net_device;
> +struct funeth_priv;
> +
> +#ifdef CONFIG_TLS_DEVICE
> +#include <net/tls.h>
> +
> +struct fun_ktls_tx_ctx {
> +	__be64 tlsid;
> +	u32 next_seq;
> +};
> +
> +int fun_ktls_init(struct net_device *netdev);
> +void fun_ktls_cleanup(struct funeth_priv *fp);
> +
> +#else
> +#include <linux/errno.h>
> +
> +static inline int fun_ktls_init(struct net_device *netdev)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void fun_ktls_cleanup(struct funeth_priv *fp)
> +{
> +}
> +#endif
> +
> +#endif /* _FUN_KTLS_H */

