Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA9174C49
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCAIiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:38:55 -0500
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:22938
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbgCAIiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 03:38:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWwUBkEAjpyLYt+kBq/FqoCouAPNITi+NK2bzYW717NcCysUPQ1+r+WrwSbJYBq74sYR4Fy5IZUZ3Y13ENMZqFzM68HIFej4GgQImfFWfdMrk1EQ6WtZ2zF+xHCxuW/7Ohz3OB3+JXtcZMZoNKnUWatl9+pooOCeKofX2yg5Ziy7h2fH74uTxBOx1x3S56cwmRMWu6d0c0BJOSxMLMwbP18RaBeLftmUb0aP57MfJZi+6M3bzlvzSjEYy5uK1YDo6JqxNtogfe45oJkxaGkBZB59Onqt2l3keCXbdO5SigMFgsHy8HtJABR+HzQLu6YVoINMLXb2PENu4mymRRMA1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndHLAHAX+yoeRQ83Fco2Du2rGHCmn4GhReC+rgg5pes=;
 b=lhJ0bHwYdSFZUxthj0UlFPJOYYkXTvUaHmeN1Fb9uIoseEWAglxX3+A52M2S8reM7TfIla5Y0ZtzWgMXyhxaq8LvtyQPBJmMkOIOGZ+5I0TIgO60Ao0UgVhSmhAYmdBAFEzs/JHpAzU2awbQbXrJzxsAu4KB9gBduuSpoNSe9nT3B12FgP+BZXIkiXODpagxfT8cFbMPJbkDdgwwjd0vZIVJSdED5BYTbsK5qeiGZdHMQVIvFXiJH+Xjgzt0aOkTHuOHHPB8cDp0o+7IqSC2JNfZUDLsX/Jtauh17eZH1XUo22x+qPGy4Fpj6KC6xTvlCSf2RL5vs7zRj27yuw12Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndHLAHAX+yoeRQ83Fco2Du2rGHCmn4GhReC+rgg5pes=;
 b=fKUy7kFukwky+krB9X3f2QUjsO9aGQKcthLDM8AVcCYb++JSecKQEQRcznaz6PjlHMeOpfV9m/1KQCvU80I8Q+Il8ZAU1/yqI31ff31+JsdTd28ejW5VwxvJgrddaRABJUn4KjypYRhmszRv/WFsJOzMKULjkXJOVR2otRaYQP8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (20.181.27.19) by
 AM7PR05MB6711.eurprd05.prod.outlook.com (10.186.168.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Sun, 1 Mar 2020 08:36:00 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2772.018; Sun, 1 Mar 2020
 08:36:00 +0000
Subject: Re: [PATCH net-next v3 3/6] cxgb4/chcr: complete record tx handling
To:     Rohit Maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-4-rohitm@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <a02d18ce-4f30-9478-d50a-7e2fef974019@mellanox.com>
Date:   Sun, 1 Mar 2020 10:35:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200229012426.30981-4-rohitm@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.80.4.9] (193.47.165.251) by FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Sun, 1 Mar 2020 08:35:58 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66e23de1-3971-4458-6f67-08d7bdbb916f
X-MS-TrafficTypeDiagnostic: AM7PR05MB6711:
X-Microsoft-Antispam-PRVS: <AM7PR05MB67111262293D495B63B60FCAB0E60@AM7PR05MB6711.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(396003)(366004)(189003)(199004)(8936002)(26005)(316002)(16576012)(53546011)(66946007)(52116002)(478600001)(81166006)(31686004)(4326008)(81156014)(36756003)(956004)(5660300002)(2616005)(8676002)(186003)(66476007)(30864003)(16526019)(66556008)(86362001)(2906002)(6486002)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR05MB6711;H:AM7PR05MB7092.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U78l8HPjhRVTKV+exeAzizMn6lhldggDiL0wzT1qaK82htSeOsov4JDxQ9DNssZVSMkaSpIjag60ajZfKJHy6cQ2ex2dJ5VqL5vh14Bf3mVvhFi8cVm9yoEoJDeNsQOLgdAoOWrF1j9pWHjR71Tl8NW2UXzklaEA0m+s17mZfmhDRk6LNBOgCG1S3DZVlfibS12dfLD56YQoNZAvaMb7RY7+36wiN4mMVggGXhRd8rhWG69AYTIhyWTSKOG2ZB6pHaMjldvd5UxNOvUGwshhQt1RGH94gQmsxuYEPmFDqZ57B0Gxir7T+DTyDvTcbkaAxACqYPHgTRp922lp6uvrfxNnMSqpebZZtXEGuLE6RXYp+gmd4qGdd98yM4JtlQdxwtQQYhdwRn/seVeTZLjaATcps0+icOv4uJ8Nd432gJ+hzL09coc3NRKqfQVFMQ5u
X-MS-Exchange-AntiSpam-MessageData: 1A/0aqIauTU61I4HJg2OJ7/9/fJ4uV9ZyfXE+3SBe6L/gR5M0tlLvkLVY8QLZTTB5aitJ+GAI1Rov7b/MtdrYInCAtkjxzUgLCHo2/XDhSsymyqhKrLzpDwBUhkB3OyeSBW4YSpcwnkzj2WMWXXJKg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e23de1-3971-4458-6f67-08d7bdbb916f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 08:35:59.9309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIGySUL/WnccoPk7+DbY+p9gSvvEx9FCdjVXl9TdNeRuGcen+kK5cZJq9EaX1N45SHEKOVHww35/g9yJbVHeXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6711
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rohit,

On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
> Added tx handling in this patch. This includes handling of segments
> contain single complete record.
>
> v1->v2:
> - chcr_write_cpl_set_tcb_ulp is added in this patch.
>
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_common.h        |  36 ++
>  drivers/crypto/chelsio/chcr_core.c          |  18 +-
>  drivers/crypto/chelsio/chcr_core.h          |   1 +
>  drivers/crypto/chelsio/chcr_ktls.c          | 568 ++++++++++++++++++++
>  drivers/crypto/chelsio/chcr_ktls.h          |  13 +
>  drivers/net/ethernet/chelsio/cxgb4/sge.c    |   6 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  20 +
>  drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h |  20 +
>  8 files changed, 675 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_common.h b/drivers/crypto/chelsio/chcr_common.h
> index 852f64322326..f4ccea68df6f 100644
> --- a/drivers/crypto/chelsio/chcr_common.h
> +++ b/drivers/crypto/chelsio/chcr_common.h
> @@ -9,6 +9,11 @@
>  #define CHCR_MAX_SALT                      4
>  #define CHCR_KEYCTX_MAC_KEY_SIZE_128       0
>  #define CHCR_KEYCTX_CIPHER_KEY_SIZE_128    0
> +#define CHCR_SCMD_CIPHER_MODE_AES_GCM      2
> +#define CHCR_CPL_TX_SEC_PDU_LEN_64BIT      2
> +#define CHCR_SCMD_SEQ_NO_CTRL_64BIT        3
> +#define CHCR_SCMD_PROTO_VERSION_TLS        0
> +#define CHCR_SCMD_AUTH_MODE_GHASH          4
>  
>  enum chcr_state {
>  	CHCR_INIT = 0,
> @@ -93,4 +98,35 @@ static inline void *chcr_copy_to_txd(const void *src, const struct sge_txq *q,
>  	}
>  	return p;
>  }
> +
> +static inline unsigned int chcr_txq_avail(const struct sge_txq *q)
> +{
> +	return q->size - 1 - q->in_use;
> +}
> +
> +static inline void chcr_txq_advance(struct sge_txq *q, unsigned int n)
> +{
> +	q->in_use += n;
> +	q->pidx += n;
> +	if (q->pidx >= q->size)
> +		q->pidx -= q->size;
> +}
> +
> +static inline void chcr_eth_txq_stop(struct sge_eth_txq *q)
> +{
> +	netif_tx_stop_queue(q->txq);
> +	q->q.stops++;
> +}
> +
> +static inline unsigned int chcr_sgl_len(unsigned int n)
> +{
> +	n--;
> +	return (3 * n) / 2 + (n & 1) + 2;
> +}
> +
> +static inline unsigned int chcr_flits_to_desc(unsigned int n)
> +{
> +	WARN_ON(n > SGE_MAX_WR_LEN / 8);
> +	return DIV_ROUND_UP(n, 8);
> +}
>  #endif /* __CHCR_COMMON_H__ */
> diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
> index a52ce6fc9858..0015810214a9 100644
> --- a/drivers/crypto/chelsio/chcr_core.c
> +++ b/drivers/crypto/chelsio/chcr_core.c
> @@ -49,9 +49,9 @@ static struct cxgb4_uld_info chcr_uld_info = {
>  	.add = chcr_uld_add,
>  	.state_change = chcr_uld_state_change,
>  	.rx_handler = chcr_uld_rx_handler,
> -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
>  	.tx_handler = chcr_uld_tx_handler,
> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>  };
>  
>  static void detach_work_fn(struct work_struct *work)
> @@ -237,12 +237,22 @@ int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
>  	return 0;
>  }
>  
> -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
>  int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev)
>  {
> +	/* In case if skb's decrypted bit is set, it's nic tls packet, else it's
> +	 * ipsec packet.
> +	 */
> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +	if (skb->decrypted)
> +		return chcr_ktls_xmit(skb, dev);
> +#endif
> +#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>  	return chcr_ipsec_xmit(skb, dev);
> +#endif
> +	return 0;
>  }
> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>  
>  static void chcr_detach_device(struct uld_ctx *u_ctx)
>  {
> diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
> index 2dcbd188290a..b5b371b8d343 100644
> --- a/drivers/crypto/chelsio/chcr_core.h
> +++ b/drivers/crypto/chelsio/chcr_core.h
> @@ -227,5 +227,6 @@ void chcr_enable_ktls(struct adapter *adap);
>  void chcr_disable_ktls(struct adapter *adap);
>  int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
>  int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
> +int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
>  #endif
>  #endif /* __CHCR_CORE_H__ */
> diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
> index f945b93a1bf0..f4c860665c9c 100644
> --- a/drivers/crypto/chelsio/chcr_ktls.c
> +++ b/drivers/crypto/chelsio/chcr_ktls.c
> @@ -39,6 +39,22 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
>  		salt = info_128_gcm->salt;
>  		tx_info->record_no = *(u64 *)info_128_gcm->rec_seq;
>  
> +		/* The SCMD fields used when encrypting a full TLS
> +		 * record. Its a one time calculation till the
> +		 * connection exists.
> +		 */
> +		tx_info->scmd0_seqno_numivs =
> +			SCMD_SEQ_NO_CTRL_V(CHCR_SCMD_SEQ_NO_CTRL_64BIT) |
> +			SCMD_CIPH_AUTH_SEQ_CTRL_F |
> +			SCMD_PROTO_VERSION_V(CHCR_SCMD_PROTO_VERSION_TLS) |
> +			SCMD_CIPH_MODE_V(CHCR_SCMD_CIPHER_MODE_AES_GCM) |
> +			SCMD_AUTH_MODE_V(CHCR_SCMD_AUTH_MODE_GHASH) |
> +			SCMD_IV_SIZE_V(TLS_CIPHER_AES_GCM_128_IV_SIZE >> 1) |
> +			SCMD_NUM_IVS_V(1);
> +
> +		/* keys will be sent inline. */
> +		tx_info->scmd0_ivgen_hdrlen = SCMD_KEY_CTX_INLINE_F;
> +
>  		break;
>  
>  	default:
> @@ -373,6 +389,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
>  
>  	tx_info->adap = adap;
>  	tx_info->netdev = netdev;
> +	tx_info->first_qset = pi->first_qset;
>  	tx_info->tx_chan = pi->tx_chan;
>  	tx_info->smt_idx = pi->smt_idx;
>  	tx_info->port_id = pi->port_id;
> @@ -572,4 +589,555 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
>  	chcr_ktls_update_connection_state(tx_info, KTLS_CONN_SET_TCB_RPL);
>  	return 0;
>  }
> +
> +/*
> + * chcr_write_cpl_set_tcb_ulp: update tcb values.
> + * TCB is responsible to create tcp headers, so all the related values
> + * should be correctly updated.
> + * @tx_info - driver specific tls info.
> + * @q - tx queue on which packet is going out.
> + * @tid - TCB identifier.
> + * @pos - current index where should we start writing.
> + * @word - TCB word.
> + * @mask - TCB word related mask.
> + * @val - TCB word related value.
> + * @reply - set 1 if looking for TP response.
> + * return - next position to write.
> + */
> +static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
> +					struct sge_eth_txq *q, u32 tid,
> +					void *pos, u16 word, u64 mask,
> +					u64 val, u32 reply)
> +{
> +	struct cpl_set_tcb_field_core *cpl;
> +	struct ulptx_idata *idata;
> +	struct ulp_txpkt *txpkt;
> +	void *save_pos = NULL;
> +	u8 buf[48] = {0};
> +	int left;
> +
> +	left = (void *)q->q.stat - pos;
> +	if (unlikely(left < CHCR_SET_TCB_FIELD_LEN)) {
> +		if (!left) {
> +			pos = q->q.desc;
> +		} else {
> +			save_pos = pos;
> +			pos = buf;
> +		}
> +	}
> +	/* ULP_TXPKT */
> +	txpkt = pos;
> +	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) | ULP_TXPKT_DEST_V(0));
> +	txpkt->len = htonl(DIV_ROUND_UP(CHCR_SET_TCB_FIELD_LEN, 16));
> +
> +	/* ULPTX_IDATA sub-command */
> +	idata = (struct ulptx_idata *)(txpkt + 1);
> +	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM));
> +	idata->len = htonl(sizeof(*cpl));
> +	pos = idata + 1;
> +
> +	cpl = pos;
> +	/* CPL_SET_TCB_FIELD */
> +	OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
> +	cpl->reply_ctrl = htons(QUEUENO_V(tx_info->rx_qid) |
> +			NO_REPLY_V(!reply));
> +	cpl->word_cookie = htons(TCB_WORD_V(word));
> +	cpl->mask = cpu_to_be64(mask);
> +	cpl->val = cpu_to_be64(val);
> +
> +	/* ULPTX_NOOP */
> +	idata = (struct ulptx_idata *)(cpl + 1);
> +	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_NOOP));
> +	idata->len = htonl(0);
> +
> +	if (save_pos) {
> +		pos = chcr_copy_to_txd(buf, &q->q, save_pos,
> +				       CHCR_SET_TCB_FIELD_LEN);
> +	} else {
> +		/* check again if we are at the end of the queue */
> +		if (left == CHCR_SET_TCB_FIELD_LEN)
> +			pos = q->q.desc;
> +		else
> +			pos = idata + 1;
> +	}
> +
> +	return pos;
> +}
> +
> +/*
> + * chcr_ktls_xmit_tcb_cpls: update tcb entry so that TP will create the header

It seems fundamentally wrong to have the HW construct the header instead of working with the existing packet header. This seems like you are still using the TCP offload engine here which may miss some TCP flags/options.

For instance, how do you handle TCP timstamps or ECN?

> + * with updated values like tcp seq, ack, window etc.
> + * @tx_info - driver specific tls info.
> + * @q - TX queue.
> + * @tcp_seq
> + * @tcp_ack
> + * @tcp_win
> + * return: NETDEV_TX_BUSY/NET_TX_OK.
> + */
> +static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
> +				   struct sge_eth_txq *q, u64 tcp_seq,
> +				   u64 tcp_ack, u64 tcp_win)
> +{
> +	bool first_wr = ((tx_info->prev_ack == 0) && (tx_info->prev_win == 0));
> +	u32 len, cpl = 0, ndesc, wr_len;
> +	struct fw_ulptx_wr *wr;
> +	int credits;
> +	void *pos;
> +
> +	wr_len = sizeof(*wr);
> +	/* there can be max 4 cpls, check if we have enough credits */
> +	len = wr_len + 4 * roundup(CHCR_SET_TCB_FIELD_LEN, 16);
> +	ndesc = DIV_ROUND_UP(len, 64);
> +
> +	credits = chcr_txq_avail(&q->q) - ndesc;
> +	if (unlikely(credits < 0)) {
> +		chcr_eth_txq_stop(q);
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	pos = &q->q.desc[q->q.pidx];
> +	/* make space for WR, we'll fill it later when we know all the cpls
> +	 * being sent out and have complete length.
> +	 */
> +	wr = pos;
> +	pos += wr_len;
> +	/* update tx_max if its a re-transmit or the first wr */
> +	if (first_wr || tcp_seq != tx_info->prev_seq) {
> +		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
> +						 TCB_TX_MAX_W,
> +						 TCB_TX_MAX_V(TCB_TX_MAX_M),
> +						 TCB_TX_MAX_V(tcp_seq), 0);
> +		cpl++;
> +	}
> +	/* reset snd una if it's a re-transmit pkt */
> +	if (tcp_seq != tx_info->prev_seq) {
> +		/* reset snd_una */
> +		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
> +						 TCB_SND_UNA_RAW_W,
> +						 TCB_SND_UNA_RAW_V
> +						 (TCB_SND_UNA_RAW_M),
> +						 TCB_SND_UNA_RAW_V(0), 0);
> +		cpl++;
> +	}
> +	/* update ack */
> +	if (first_wr || tx_info->prev_ack != tcp_ack) {
> +		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
> +						 TCB_RCV_NXT_W,
> +						 TCB_RCV_NXT_V(TCB_RCV_NXT_M),
> +						 TCB_RCV_NXT_V(tcp_ack), 0);
> +		tx_info->prev_ack = tcp_ack;
> +		cpl++;
> +	}
> +	/* update receive window */
> +	if (first_wr || tx_info->prev_win != tcp_win) {
> +		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
> +						 TCB_RCV_WND_W,
> +						 TCB_RCV_WND_V(TCB_RCV_WND_M),
> +						 TCB_RCV_WND_V(tcp_win), 0);
> +		tx_info->prev_win = tcp_win;
> +		cpl++;
> +	}
> +
> +	if (cpl) {
> +		/* get the actual length */
> +		len = wr_len + cpl * roundup(CHCR_SET_TCB_FIELD_LEN, 16);
> +		/* ULPTX wr */
> +		wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
> +		wr->cookie = 0;
> +		/* fill len in wr field */
> +		wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
> +
> +		ndesc = DIV_ROUND_UP(len, 64);
> +		chcr_txq_advance(&q->q, ndesc);
> +		cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * chcr_ktls_skb_copy
> + * @nskb - new skb where the frags to be added.
> + * @skb - old skb from which frags will be copied.
> + */
> +static void chcr_ktls_skb_copy(struct sk_buff *skb, struct sk_buff *nskb)
> +{
> +	int i;
> +
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +		skb_shinfo(nskb)->frags[i] = skb_shinfo(skb)->frags[i];
> +		__skb_frag_ref(&skb_shinfo(nskb)->frags[i]);
> +	}
> +
> +	skb_shinfo(nskb)->nr_frags = skb_shinfo(skb)->nr_frags;
> +	nskb->len += skb->data_len;
> +	nskb->data_len = skb->data_len;
> +	nskb->truesize += skb->data_len;
> +}
> +
> +/*
> + * chcr_ktls_get_tx_flits
> + * returns number of flits to be sent out, it includes key context length, WR
> + * size and skb fragments.
> + */
> +static unsigned int
> +chcr_ktls_get_tx_flits(const struct sk_buff *skb, unsigned int key_ctx_len)
> +{
> +	return chcr_sgl_len(skb_shinfo(skb)->nr_frags) +
> +	       DIV_ROUND_UP(key_ctx_len + CHCR_KTLS_WR_SIZE, 8);
> +}
> +
> +/*
> + * chcr_ktls_xmit_wr_complete: This sends out the complete record. If an skb
> + * received has partial end part of the record, send out the complete record, so
> + * that crypto block will be able to generate TAG/HASH.
> + * @skb - segment which has complete or partial end part.
> + * @tx_info - driver specific tls info.
> + * @q - TX queue.
> + * @tcp_seq
> + * @tcp_push - tcp push bit.
> + * @mss - segment size.
> + * return: NETDEV_TX_BUSY/NET_TX_OK.
> + */
> +static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
> +				      struct chcr_ktls_info *tx_info,
> +				      struct sge_eth_txq *q, u32 tcp_seq,
> +				      bool tcp_push, u32 mss)
> +{
> +	u32 len16, wr_mid = 0, flits = 0, ndesc, cipher_start;
> +	struct adapter *adap = tx_info->adap;
> +	int credits, left, last_desc;
> +	struct tx_sw_desc *sgl_sdesc;
> +	struct cpl_tx_data *tx_data;
> +	struct cpl_tx_sec_pdu *cpl;
> +	struct ulptx_idata *idata;
> +	struct ulp_txpkt *ulptx;
> +	struct fw_ulptx_wr *wr;
> +	void *pos;
> +	u64 *end;
> +
> +	/* get the number of flits required */
> +	flits = chcr_ktls_get_tx_flits(skb, tx_info->key_ctx_len);
> +	/* number of descriptors */
> +	ndesc = chcr_flits_to_desc(flits);
> +	/* check if enough credits available */
> +	credits = chcr_txq_avail(&q->q) - ndesc;
> +	if (unlikely(credits < 0)) {
> +		chcr_eth_txq_stop(q);
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
> +		/* Credits are below the threshold vaues, stop the queue after
> +		 * injecting the Work Request for this packet.
> +		 */
> +		chcr_eth_txq_stop(q);
> +		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
> +	}
> +
> +	last_desc = q->q.pidx + ndesc - 1;
> +	if (last_desc >= q->q.size)
> +		last_desc -= q->q.size;
> +	sgl_sdesc = &q->q.sdesc[last_desc];
> +
> +	if (unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
> +		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
> +		q->mapping_err++;
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	pos = &q->q.desc[q->q.pidx];
> +	end = (u64 *)pos + flits;
> +	/* FW_ULPTX_WR */
> +	wr = pos;
> +	/* WR will need len16 */
> +	len16 = DIV_ROUND_UP(flits, 2);
> +	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
> +	wr->flowid_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
> +	wr->cookie = 0;
> +	pos += sizeof(*wr);
> +	/* ULP_TXPKT */
> +	ulptx = pos;
> +	ulptx->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
> +				ULP_TXPKT_CHANNELID_V(tx_info->port_id) |
> +				ULP_TXPKT_FID_V(q->q.cntxt_id) |
> +				ULP_TXPKT_RO_F);
> +	ulptx->len = htonl(len16 - 1);
> +	/* ULPTX_IDATA sub-command */
> +	idata = (struct ulptx_idata *)(ulptx + 1);
> +	idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM) | ULP_TX_SC_MORE_F);
> +	/* idata length will include cpl_tx_sec_pdu + key context size +
> +	 * cpl_tx_data header.
> +	 */
> +	idata->len = htonl(sizeof(*cpl) + tx_info->key_ctx_len +
> +			   sizeof(*tx_data));
> +	/* SEC CPL */
> +	cpl = (struct cpl_tx_sec_pdu *)(idata + 1);
> +	cpl->op_ivinsrtofst =
> +		htonl(CPL_TX_SEC_PDU_OPCODE_V(CPL_TX_SEC_PDU) |
> +		      CPL_TX_SEC_PDU_CPLLEN_V(CHCR_CPL_TX_SEC_PDU_LEN_64BIT) |
> +		      CPL_TX_SEC_PDU_PLACEHOLDER_V(1) |
> +		      CPL_TX_SEC_PDU_IVINSRTOFST_V(TLS_HEADER_SIZE + 1));
> +	cpl->pldlen = htonl(skb->data_len);
> +
> +	/* encryption should start after tls header size + iv size */
> +	cipher_start = TLS_HEADER_SIZE + tx_info->iv_size + 1;
> +
> +	cpl->aadstart_cipherstop_hi =
> +		htonl(CPL_TX_SEC_PDU_AADSTART_V(1) |
> +		      CPL_TX_SEC_PDU_AADSTOP_V(TLS_HEADER_SIZE) |
> +		      CPL_TX_SEC_PDU_CIPHERSTART_V(cipher_start));
> +
> +	/* authentication will also start after tls header + iv size */
> +	cpl->cipherstop_lo_authinsert =
> +	htonl(CPL_TX_SEC_PDU_AUTHSTART_V(cipher_start) |
> +	      CPL_TX_SEC_PDU_AUTHSTOP_V(TLS_CIPHER_AES_GCM_128_TAG_SIZE) |
> +	      CPL_TX_SEC_PDU_AUTHINSERT_V(TLS_CIPHER_AES_GCM_128_TAG_SIZE));
> +
> +	/* These two flits are actually a CPL_TLS_TX_SCMD_FMT. */
> +	cpl->seqno_numivs = htonl(tx_info->scmd0_seqno_numivs);
> +	cpl->ivgen_hdrlen = htonl(tx_info->scmd0_ivgen_hdrlen);
> +	cpl->scmd1 = cpu_to_be64(tx_info->record_no);
> +
> +	pos = cpl + 1;
> +	/* check if space left to fill the keys */
> +	left = (void *)q->q.stat - pos;
> +	if (!left) {
> +		left = (void *)end - (void *)q->q.stat;
> +		pos = q->q.desc;
> +		end = pos + left;
> +	}
> +
> +	pos = chcr_copy_to_txd(&tx_info->key_ctx, &q->q, pos,
> +			       tx_info->key_ctx_len);
> +	left = (void *)q->q.stat - pos;
> +
> +	if (!left) {
> +		left = (void *)end - (void *)q->q.stat;
> +		pos = q->q.desc;
> +		end = pos + left;
> +	}
> +	/* CPL_TX_DATA */
> +	tx_data = (void *)pos;
> +	OPCODE_TID(tx_data) = htonl(MK_OPCODE_TID(CPL_TX_DATA, tx_info->tid));
> +	tx_data->len = htonl(TX_DATA_MSS_V(mss) | TX_LENGTH_V(skb->data_len));
> +
> +	tx_data->rsvd = htonl(tcp_seq);
> +
> +	tx_data->flags = htonl(TX_BYPASS_F);
> +	if (tcp_push)
> +		tx_data->flags |= htonl(TX_PUSH_F | TX_SHOVE_F);
> +
> +	/* check left again, it might go beyond queue limit */
> +	pos = tx_data + 1;
> +	left = (void *)q->q.stat - pos;
> +
> +	/* check the position again */
> +	if (!left) {
> +		left = (void *)end - (void *)q->q.stat;
> +		pos = q->q.desc;
> +		end = pos + left;
> +	}
> +
> +	/* send the complete packet except the header */
> +	cxgb4_write_sgl(skb, &q->q, pos, end, skb->len - skb->data_len,
> +			sgl_sdesc->addr);
> +	sgl_sdesc->skb = skb;
> +
> +	chcr_txq_advance(&q->q, ndesc);
> +	cxgb4_ring_tx_db(adap, &q->q, ndesc);
> +
> +	return 0;
> +}
> +
> +/*
> + * chcr_end_part_handler: This handler will handle the record which
> + * is complete or if record's end part is received. T6 adapter has a issue that
> + * it can't send out TAG with partial record so if its an end part then we have
> + * to send TAG as well and for which we need to fetch the complete record and
> + * send it to crypto module.
> + * @tx_info - driver specific tls info.
> + * @skb - skb contains partial record.
> + * @record - complete record of 16K size.
> + * @tcp_seq
> + * @mss - segment size in which TP needs to chop a packet.
> + * @tcp_push_no_fin - tcp push if fin is not set.
> + * @q - TX queue.
> + * @tls_end_offset - offset from end of the record.
> + * @last wr : check if this is the last part of the skb going out.
> + * return: NETDEV_TX_OK/NETDEV_TX_BUSY.
> + */
> +static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
> +				 struct sk_buff *skb,
> +				 struct tls_record_info *record,
> +				 u32 tcp_seq, int mss, bool tcp_push_no_fin,
> +				 struct sge_eth_txq *q,
> +				 u32 tls_end_offset, bool last_wr)
> +{
> +	struct sk_buff *nskb = NULL;
> +	/* check if it is a complete record */
> +	if (tls_end_offset == record->len) {
> +		nskb = skb;
> +	} else {
> +		/* handle it in next patch */
> +		goto out;
> +	}
> +
> +	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
> +				       (last_wr && tcp_push_no_fin),
> +				       mss)) {
> +		goto out;
> +	}
> +	return 0;
> +out:
> +	if (nskb)
> +		kfree_skb(nskb);
> +	return NETDEV_TX_BUSY;
> +}
> +
> +/* nic tls TX handler */
> +int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
> +	struct tcphdr *th = tcp_hdr(skb);
> +	int data_len, qidx, ret = 0, mss;
> +	struct tls_record_info *record;
> +	struct chcr_ktls_info *tx_info;
> +	u32 tls_end_offset, tcp_seq;
> +	struct tls_context *tls_ctx;
> +	struct sk_buff *local_skb;
> +	int new_connection_state;
> +	struct sge_eth_txq *q;
> +	struct adapter *adap;
> +	unsigned long flags;
> +
> +	tcp_seq = ntohl(th->seq);
> +
> +	mss = dev->mtu - (tcp_hdrlen(skb) + (ip_hdr(skb))->ihl * 4);
> +	if (mss < 0)
> +		mss = dev->mtu;

Is this the TCP MSS?

You shouldn't calculate the mss this way, it is either provided to you by GSO, or you can infer it from the SKB itself without the device MTU.

> +
> +	/* check if we haven't set it for ktls offload */
> +	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
> +		goto out;
> +
> +	tls_ctx = tls_get_ctx(skb->sk);
> +	if (unlikely(tls_ctx->netdev != dev))
> +		goto out;
> +
> +	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
> +	tx_info = tx_ctx->chcr_info;
> +
> +	if (unlikely(!tx_info))
> +		goto out;
> +
> +	/* check the connection state, we don't need to pass new connection
> +	 * state, state machine will check and update the new state if it is
> +	 * stuck due to responses not received from HW.
> +	 * Start the tx handling only if state is KTLS_CONN_TX_READY.
> +	 */
> +	new_connection_state = chcr_ktls_update_connection_state(tx_info, 0);
> +	if (new_connection_state != KTLS_CONN_TX_READY)
> +		goto out;
> +
> +	adap = tx_info->adap;
> +	qidx = skb->queue_mapping;
> +	q = &adap->sge.ethtxq[qidx + tx_info->first_qset];
> +	cxgb4_reclaim_completed_tx(adap, &q->q, true);
> +	/* update tcb */
> +	ret = chcr_ktls_xmit_tcb_cpls(tx_info, q, ntohl(th->seq),
> +				      ntohl(th->ack_seq),
> +				      ntohs(th->window));

I see that you update all kinds of TCP header fields in the NIC. Does it mean that if the stack provides some field which you do not expect, then it gets dropped?

Does your NIC construct the TCP header by itself? i.e. it does not send the header provided as-is?

> +	if (ret)
> +		return NETDEV_TX_BUSY;
> +	/* don't touch the original skb, make a new skb to extract each records
> +	 * and send them separately.
> +	 */
> +	local_skb = alloc_skb(0, GFP_KERNEL);
> +
> +	if (unlikely(!local_skb))
> +		return NETDEV_TX_BUSY;
What about the chcr_ktls_xmit.. Does operation above need to be reversed?
> +
> +	chcr_ktls_skb_copy(skb, local_skb);
> +	/* go through the skb and send only one record at a time. */
> +	data_len = skb->data_len;
> +	/* TCP segments can be in received from host either complete or partial.
> +	 * chcr_end_part_handler will handle cases if complete record or end
> +	 * part of the record is received. Incase of partial end part of record,
> +	 * we will send the complete record again.
> +	 */

The stack expects SKBs to be sent according to how it formatted them. You must not reformat them in any way. If the T6 cannot confirm to this demand, then I'm afraid it just does not support this.

> +	do {
> +		int i;
> +
> +		cxgb4_reclaim_completed_tx(adap, &q->q, true);
> +		/* lock taken */
> +		spin_lock_irqsave(&tx_ctx->base.lock, flags);
> +		/* fetch the tls record */
> +		record = tls_get_record(&tx_ctx->base, tcp_seq,
> +					&tx_info->record_no);
> +		/* By the time packet reached to us, ACK is received, and record
> +		 * won't be found in that case, handle it gracefully.
> +		 */
> +		if (unlikely(!record)) {
> +			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
> +			goto out;
> +		}
> +		/* increase page reference count of the record, so that there
> +		 * won't be any chance of page free in middle if in case stack
> +		 * receives ACK and try to delete the record.
> +		 */
> +		for (i = 0; i < record->num_frags; i++)
> +			__skb_frag_ref(&record->frags[i]);
> +		/* lock cleared */
> +		spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
> +
> +		tls_end_offset = record->end_seq - tcp_seq;
> +
> +		pr_debug("seq 0x%x, end_seq 0x%x prev_seq 0x%x, datalen 0x%x\n",
> +			 tcp_seq, record->end_seq, tx_info->prev_seq, data_len);
> +		/* if a tls record is finishing in this SKB */
> +		if (tls_end_offset <= data_len) {
> +			struct sk_buff *nskb = NULL;
> +
> +			if (tls_end_offset < data_len) {
> +				/* handle it later */
> +				goto clear_ref;
> +			} else {
> +				/* its the only record in this skb, directly
> +				 * point it.
> +				 */
> +				nskb = local_skb;
> +			}
> +			ret = chcr_end_part_handler(tx_info, nskb, record,
> +						    tcp_seq, mss,
> +						    (!th->fin && th->psh), q,
> +						    tls_end_offset,
> +						    (nskb == local_skb));
> +
> +			if (ret && nskb != local_skb)
> +				kfree_skb(local_skb);
> +
> +			data_len -= tls_end_offset;
> +			/* tcp_seq increment is required to handle next record.
> +			 */
> +			tcp_seq += tls_end_offset;
> +		}
> +clear_ref:
> +		/* clear the frag ref count which increased locally before */
> +		for (i = 0; i < record->num_frags; i++) {
> +			/* clear the frag ref count */
> +			__skb_frag_unref(&record->frags[i]);
> +		}
> +
> +		if (ret)
> +			goto out;
> +
> +		WARN_ON(data_len < 0);
> +
> +	} while (data_len > 0);
> +
> +	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
> +out:
> +	kfree_skb(skb);
IMO dev_kfree_skb_any is better here and throughout
> +	return NETDEV_TX_OK;
> +}
>  #endif /* CONFIG_CHELSIO_TLS_DEVICE */
> diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
> index 15e79bdfb13c..df54b210324d 100644
> --- a/drivers/crypto/chelsio/chcr_ktls.h
> +++ b/drivers/crypto/chelsio/chcr_ktls.h
> @@ -15,6 +15,13 @@
>  #define CHCR_TCB_STATE_CLOSED	0
>  #define CHCR_KTLS_KEY_CTX_LEN	16
>  #define CHCR_SET_TCB_FIELD_LEN	sizeof(struct cpl_set_tcb_field)
> +#define CHCR_PLAIN_TX_DATA_LEN	(sizeof(struct fw_ulptx_wr) +\
> +				 sizeof(struct ulp_txpkt) +\
> +				 sizeof(struct ulptx_idata) +\
> +				 sizeof(struct cpl_tx_data))
> +
> +#define CHCR_KTLS_WR_SIZE	(CHCR_PLAIN_TX_DATA_LEN +\
> +				 sizeof(struct cpl_tx_sec_pdu))
>  
>  enum chcr_ktls_conn_state {
>  	KTLS_CONN_CLOSED,
> @@ -39,14 +46,19 @@ struct chcr_ktls_info {
>  	int rx_qid;
>  	u32 iv_size;
>  	u32 prev_seq;
> +	u32 prev_ack;
>  	u32 salt_size;
>  	u32 key_ctx_len;
> +	u32 scmd0_seqno_numivs;
> +	u32 scmd0_ivgen_hdrlen;
>  	u32 tcp_start_seq_number;
>  	enum chcr_ktls_conn_state connection_state;
> +	u16 prev_win;
>  	u8 tx_chan;
>  	u8 smt_idx;
>  	u8 port_id;
>  	u8 ip_family;
> +	u8 first_qset;
>  };
>  
>  struct chcr_ktls_ofld_ctx_tx {
> @@ -78,5 +90,6 @@ void chcr_enable_ktls(struct adapter *adap);
>  void chcr_disable_ktls(struct adapter *adap);
>  int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
>  int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
> +int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
>  #endif /* CONFIG_CHELSIO_TLS_DEVICE */
>  #endif /* __CHCR_KTLS_H__ */
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
> index 97cda501e7e8..952315e5de60 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
> @@ -1407,10 +1407,10 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
>  	pi = netdev_priv(dev);
>  	adap = pi->adapter;
>  	ssi = skb_shinfo(skb);
> -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
> -	if (xfrm_offload(skb) && !ssi->gso_size)
> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
> +	if ((xfrm_offload(skb) && !ssi->gso_size) || skb->decrypted)
>  		return adap->uld[CXGB4_ULD_CRYPTO].tx_handler(skb, dev);
> -#endif /* CHELSIO_IPSEC_INLINE */
> +#endif /* CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>  
>  	qidx = skb_get_queue_mapping(skb);
>  	if (ptp_enabled) {
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
> index e9c775f1dd3e..57de78ac2a3b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
> @@ -47,6 +47,7 @@ enum {
>  	CPL_CLOSE_LISTSRV_REQ = 0x9,
>  	CPL_ABORT_REQ         = 0xA,
>  	CPL_ABORT_RPL         = 0xB,
> +	CPL_TX_DATA           = 0xC,
>  	CPL_RX_DATA_ACK       = 0xD,
>  	CPL_TX_PKT            = 0xE,
>  	CPL_L2T_WRITE_REQ     = 0x12,
> @@ -1470,6 +1471,16 @@ struct cpl_tx_data {
>  #define TX_FORCE_S	13
>  #define TX_FORCE_V(x)	((x) << TX_FORCE_S)
>  
> +#define TX_DATA_MSS_S    16
> +#define TX_DATA_MSS_M    0xFFFF
> +#define TX_DATA_MSS_V(x) ((x) << TX_DATA_MSS_S)
> +#define TX_DATA_MSS_G(x) (((x) >> TX_DATA_MSS_S) & TX_DATA_MSS_M)
> +
> +#define TX_LENGTH_S    0
> +#define TX_LENGTH_M    0xFFFF
> +#define TX_LENGTH_V(x) ((x) << TX_LENGTH_S)
> +#define TX_LENGTH_G(x) (((x) >> TX_LENGTH_S) & TX_LENGTH_M)
> +
>  #define T6_TX_FORCE_S		20
>  #define T6_TX_FORCE_V(x)	((x) << T6_TX_FORCE_S)
>  #define T6_TX_FORCE_F		T6_TX_FORCE_V(1U)
> @@ -1479,6 +1490,15 @@ struct cpl_tx_data {
>  
>  #define TX_SHOVE_S    14
>  #define TX_SHOVE_V(x) ((x) << TX_SHOVE_S)
> +#define TX_SHOVE_F    TX_SHOVE_V(1U)
> +
> +#define TX_BYPASS_S    21
> +#define TX_BYPASS_V(x) ((x) << TX_BYPASS_S)
> +#define TX_BYPASS_F    TX_BYPASS_V(1U)
> +
> +#define TX_PUSH_S    22
> +#define TX_PUSH_V(x) ((x) << TX_PUSH_S)
> +#define TX_PUSH_F    TX_PUSH_V(1U)
>  
>  #define TX_ULP_MODE_S    10
>  #define TX_ULP_MODE_M    0x7
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
> index fc93389148c8..50232e063f49 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
> @@ -74,6 +74,16 @@
>  #define TCB_RTT_TS_RECENT_AGE_M		0xffffffffULL
>  #define TCB_RTT_TS_RECENT_AGE_V(x)	((x) << TCB_RTT_TS_RECENT_AGE_S)
>  
> +#define TCB_T_RTSEQ_RECENT_W    7
> +#define TCB_T_RTSEQ_RECENT_S    0
> +#define TCB_T_RTSEQ_RECENT_M    0xffffffffULL
> +#define TCB_T_RTSEQ_RECENT_V(x) ((x) << TCB_T_RTSEQ_RECENT_S)
> +
> +#define TCB_TX_MAX_W		9
> +#define TCB_TX_MAX_S		0
> +#define TCB_TX_MAX_M		0xffffffffULL
> +#define TCB_TX_MAX_V(x)		((x) << TCB_TX_MAX_S)
> +
>  #define TCB_SND_UNA_RAW_W	10
>  #define TCB_SND_UNA_RAW_S	0
>  #define TCB_SND_UNA_RAW_M	0xfffffffULL
> @@ -89,6 +99,16 @@
>  #define TCB_SND_MAX_RAW_M	0xfffffffULL
>  #define TCB_SND_MAX_RAW_V(x)	((x) << TCB_SND_MAX_RAW_S)
>  
> +#define TCB_RCV_NXT_W		16
> +#define TCB_RCV_NXT_S		10
> +#define TCB_RCV_NXT_M		0xffffffffULL
> +#define TCB_RCV_NXT_V(x)	((x) << TCB_RCV_NXT_S)
> +
> +#define TCB_RCV_WND_W		17
> +#define TCB_RCV_WND_S		10
> +#define TCB_RCV_WND_M		0xffffffULL
> +#define TCB_RCV_WND_V(x)	((x) << TCB_RCV_WND_S)
> +
>  #define TCB_RX_FRAG2_PTR_RAW_W	27
>  #define TCB_RX_FRAG3_LEN_RAW_W	29
>  #define TCB_RX_FRAG3_START_IDX_OFFSET_RAW_W	30
