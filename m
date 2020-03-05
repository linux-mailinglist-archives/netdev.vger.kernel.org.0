Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E581617A43D
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgCEL2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:28:40 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:31884 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCEL2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:28:40 -0500
Received: from [10.193.187.27] (donald.blr.asicdesigners.com [10.193.187.27])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 025BSGkG016103;
        Thu, 5 Mar 2020 03:28:17 -0800
Subject: Re: [PATCH net-next v3 3/6] cxgb4/chcr: complete record tx handling
To:     Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-4-rohitm@chelsio.com>
 <a02d18ce-4f30-9478-d50a-7e2fef974019@mellanox.com>
 <bd4b1961-7c86-bec5-05be-fc8b164f20a1@chelsio.com>
 <94ee193d-a2b7-9746-a335-0a464468337e@mellanox.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <c9c8ae71-47f3-f3b4-4225-69e75d1d0cf6@chelsio.com>
Date:   Thu, 5 Mar 2020 16:58:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <94ee193d-a2b7-9746-a335-0a464468337e@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

On 04/03/20 10:38 PM, Boris Pismenny wrote:
>
> On 04/03/2020 17:47, rohit maheshwari wrote:
>> Hi Boris,
>>
>> On 01/03/20 2:05 PM, Boris Pismenny wrote:
>>> Hi Rohit,
>>>
>>> On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
>>>> Added tx handling in this patch. This includes handling of segments
>>>> contain single complete record.
>>>>
>>>> v1->v2:
>>>> - chcr_write_cpl_set_tcb_ulp is added in this patch.
>>>>
>>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>>> ---
>>>>    drivers/crypto/chelsio/chcr_common.h        |  36 ++
>>>>    drivers/crypto/chelsio/chcr_core.c          |  18 +-
>>>>    drivers/crypto/chelsio/chcr_core.h          |   1 +
>>>>    drivers/crypto/chelsio/chcr_ktls.c          | 568 ++++++++++++++++++++
>>>>    drivers/crypto/chelsio/chcr_ktls.h          |  13 +
>>>>    drivers/net/ethernet/chelsio/cxgb4/sge.c    |   6 +-
>>>>    drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  20 +
>>>>    drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h |  20 +
>>>>    8 files changed, 675 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/chelsio/chcr_common.h
>>>> b/drivers/crypto/chelsio/chcr_common.h
>>>> index 852f64322326..f4ccea68df6f 100644
>>>> --- a/drivers/crypto/chelsio/chcr_common.h
>>>> +++ b/drivers/crypto/chelsio/chcr_common.h
>>>> @@ -9,6 +9,11 @@
>>>>    #define CHCR_MAX_SALT                      4
>>>>    #define CHCR_KEYCTX_MAC_KEY_SIZE_128       0
>>>>    #define CHCR_KEYCTX_CIPHER_KEY_SIZE_128    0
>>>> +#define CHCR_SCMD_CIPHER_MODE_AES_GCM      2
>>>> +#define CHCR_CPL_TX_SEC_PDU_LEN_64BIT      2
>>>> +#define CHCR_SCMD_SEQ_NO_CTRL_64BIT        3
>>>> +#define CHCR_SCMD_PROTO_VERSION_TLS        0
>>>> +#define CHCR_SCMD_AUTH_MODE_GHASH          4
>>>>      enum chcr_state {
>>>>        CHCR_INIT = 0,
>>>> @@ -93,4 +98,35 @@ static inline void *chcr_copy_to_txd(const void
>>>> *src, const struct sge_txq *q,
>>>>        }
>>>>        return p;
>>>>    }
>>>> +
>>>> +static inline unsigned int chcr_txq_avail(const struct sge_txq *q)
>>>> +{
>>>> +    return q->size - 1 - q->in_use;
>>>> +}
>>>> +
>>>> +static inline void chcr_txq_advance(struct sge_txq *q, unsigned int n)
>>>> +{
>>>> +    q->in_use += n;
>>>> +    q->pidx += n;
>>>> +    if (q->pidx >= q->size)
>>>> +        q->pidx -= q->size;
>>>> +}
>>>> +
>>>> +static inline void chcr_eth_txq_stop(struct sge_eth_txq *q)
>>>> +{
>>>> +    netif_tx_stop_queue(q->txq);
>>>> +    q->q.stops++;
>>>> +}
>>>> +
>>>> +static inline unsigned int chcr_sgl_len(unsigned int n)
>>>> +{
>>>> +    n--;
>>>> +    return (3 * n) / 2 + (n & 1) + 2;
>>>> +}
>>>> +
>>>> +static inline unsigned int chcr_flits_to_desc(unsigned int n)
>>>> +{
>>>> +    WARN_ON(n > SGE_MAX_WR_LEN / 8);
>>>> +    return DIV_ROUND_UP(n, 8);
>>>> +}
>>>>    #endif /* __CHCR_COMMON_H__ */
>>>> diff --git a/drivers/crypto/chelsio/chcr_core.c
>>>> b/drivers/crypto/chelsio/chcr_core.c
>>>> index a52ce6fc9858..0015810214a9 100644
>>>> --- a/drivers/crypto/chelsio/chcr_core.c
>>>> +++ b/drivers/crypto/chelsio/chcr_core.c
>>>> @@ -49,9 +49,9 @@ static struct cxgb4_uld_info chcr_uld_info = {
>>>>        .add = chcr_uld_add,
>>>>        .state_change = chcr_uld_state_change,
>>>>        .rx_handler = chcr_uld_rx_handler,
>>>> -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>>> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) ||
>>>> defined(CONFIG_CHELSIO_TLS_DEVICE)
>>>>        .tx_handler = chcr_uld_tx_handler,
>>>> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
>>>> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>>>>    };
>>>>      static void detach_work_fn(struct work_struct *work)
>>>> @@ -237,12 +237,22 @@ int chcr_uld_rx_handler(void *handle, const
>>>> __be64 *rsp,
>>>>        return 0;
>>>>    }
>>>>    -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>>> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) ||
>>>> defined(CONFIG_CHELSIO_TLS_DEVICE)
>>>>    int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev)
>>>>    {
>>>> +    /* In case if skb's decrypted bit is set, it's nic tls packet,
>>>> else it's
>>>> +     * ipsec packet.
>>>> +     */
>>>> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
>>>> +    if (skb->decrypted)
>>>> +        return chcr_ktls_xmit(skb, dev);
>>>> +#endif
>>>> +#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>>>        return chcr_ipsec_xmit(skb, dev);
>>>> +#endif
>>>> +    return 0;
>>>>    }
>>>> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
>>>> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>>>>      static void chcr_detach_device(struct uld_ctx *u_ctx)
>>>>    {
>>>> diff --git a/drivers/crypto/chelsio/chcr_core.h
>>>> b/drivers/crypto/chelsio/chcr_core.h
>>>> index 2dcbd188290a..b5b371b8d343 100644
>>>> --- a/drivers/crypto/chelsio/chcr_core.h
>>>> +++ b/drivers/crypto/chelsio/chcr_core.h
>>>> @@ -227,5 +227,6 @@ void chcr_enable_ktls(struct adapter *adap);
>>>>    void chcr_disable_ktls(struct adapter *adap);
>>>>    int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char
>>>> *input);
>>>>    int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char
>>>> *input);
>>>> +int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
>>>>    #endif
>>>>    #endif /* __CHCR_CORE_H__ */
>>>> diff --git a/drivers/crypto/chelsio/chcr_ktls.c
>>>> b/drivers/crypto/chelsio/chcr_ktls.c
>>>> index f945b93a1bf0..f4c860665c9c 100644
>>>> --- a/drivers/crypto/chelsio/chcr_ktls.c
>>>> +++ b/drivers/crypto/chelsio/chcr_ktls.c
>>>> @@ -39,6 +39,22 @@ static int chcr_ktls_save_keys(struct
>>>> chcr_ktls_info *tx_info,
>>>>            salt = info_128_gcm->salt;
>>>>            tx_info->record_no = *(u64 *)info_128_gcm->rec_seq;
>>>>    +        /* The SCMD fields used when encrypting a full TLS
>>>> +         * record. Its a one time calculation till the
>>>> +         * connection exists.
>>>> +         */
>>>> +        tx_info->scmd0_seqno_numivs =
>>>> +            SCMD_SEQ_NO_CTRL_V(CHCR_SCMD_SEQ_NO_CTRL_64BIT) |
>>>> +            SCMD_CIPH_AUTH_SEQ_CTRL_F |
>>>> +            SCMD_PROTO_VERSION_V(CHCR_SCMD_PROTO_VERSION_TLS) |
>>>> +            SCMD_CIPH_MODE_V(CHCR_SCMD_CIPHER_MODE_AES_GCM) |
>>>> +            SCMD_AUTH_MODE_V(CHCR_SCMD_AUTH_MODE_GHASH) |
>>>> +            SCMD_IV_SIZE_V(TLS_CIPHER_AES_GCM_128_IV_SIZE >> 1) |
>>>> +            SCMD_NUM_IVS_V(1);
>>>> +
>>>> +        /* keys will be sent inline. */
>>>> +        tx_info->scmd0_ivgen_hdrlen = SCMD_KEY_CTX_INLINE_F;
>>>> +
>>>>            break;
>>>>          default:
>>>> @@ -373,6 +389,7 @@ static int chcr_ktls_dev_add(struct net_device
>>>> *netdev, struct sock *sk,
>>>>          tx_info->adap = adap;
>>>>        tx_info->netdev = netdev;
>>>> +    tx_info->first_qset = pi->first_qset;
>>>>        tx_info->tx_chan = pi->tx_chan;
>>>>        tx_info->smt_idx = pi->smt_idx;
>>>>        tx_info->port_id = pi->port_id;
>>>> @@ -572,4 +589,555 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter
>>>> *adap, unsigned char *input)
>>>>        chcr_ktls_update_connection_state(tx_info, KTLS_CONN_SET_TCB_RPL);
>>>>        return 0;
>>>>    }
>>>> +
>>>> +/*
>>>> + * chcr_write_cpl_set_tcb_ulp: update tcb values.
>>>> + * TCB is responsible to create tcp headers, so all the related values
>>>> + * should be correctly updated.
>>>> + * @tx_info - driver specific tls info.
>>>> + * @q - tx queue on which packet is going out.
>>>> + * @tid - TCB identifier.
>>>> + * @pos - current index where should we start writing.
>>>> + * @word - TCB word.
>>>> + * @mask - TCB word related mask.
>>>> + * @val - TCB word related value.
>>>> + * @reply - set 1 if looking for TP response.
>>>> + * return - next position to write.
>>>> + */
>>>> +static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
>>>> +                    struct sge_eth_txq *q, u32 tid,
>>>> +                    void *pos, u16 word, u64 mask,
>>>> +                    u64 val, u32 reply)
>>>> +{
>>>> +    struct cpl_set_tcb_field_core *cpl;
>>>> +    struct ulptx_idata *idata;
>>>> +    struct ulp_txpkt *txpkt;
>>>> +    void *save_pos = NULL;
>>>> +    u8 buf[48] = {0};
>>>> +    int left;
>>>> +
>>>> +    left = (void *)q->q.stat - pos;
>>>> +    if (unlikely(left < CHCR_SET_TCB_FIELD_LEN)) {
>>>> +        if (!left) {
>>>> +            pos = q->q.desc;
>>>> +        } else {
>>>> +            save_pos = pos;
>>>> +            pos = buf;
>>>> +        }
>>>> +    }
>>>> +    /* ULP_TXPKT */
>>>> +    txpkt = pos;
>>>> +    txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
>>>> ULP_TXPKT_DEST_V(0));
>>>> +    txpkt->len = htonl(DIV_ROUND_UP(CHCR_SET_TCB_FIELD_LEN, 16));
>>>> +
>>>> +    /* ULPTX_IDATA sub-command */
>>>> +    idata = (struct ulptx_idata *)(txpkt + 1);
>>>> +    idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM));
>>>> +    idata->len = htonl(sizeof(*cpl));
>>>> +    pos = idata + 1;
>>>> +
>>>> +    cpl = pos;
>>>> +    /* CPL_SET_TCB_FIELD */
>>>> +    OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
>>>> +    cpl->reply_ctrl = htons(QUEUENO_V(tx_info->rx_qid) |
>>>> +            NO_REPLY_V(!reply));
>>>> +    cpl->word_cookie = htons(TCB_WORD_V(word));
>>>> +    cpl->mask = cpu_to_be64(mask);
>>>> +    cpl->val = cpu_to_be64(val);
>>>> +
>>>> +    /* ULPTX_NOOP */
>>>> +    idata = (struct ulptx_idata *)(cpl + 1);
>>>> +    idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_NOOP));
>>>> +    idata->len = htonl(0);
>>>> +
>>>> +    if (save_pos) {
>>>> +        pos = chcr_copy_to_txd(buf, &q->q, save_pos,
>>>> +                       CHCR_SET_TCB_FIELD_LEN);
>>>> +    } else {
>>>> +        /* check again if we are at the end of the queue */
>>>> +        if (left == CHCR_SET_TCB_FIELD_LEN)
>>>> +            pos = q->q.desc;
>>>> +        else
>>>> +            pos = idata + 1;
>>>> +    }
>>>> +
>>>> +    return pos;
>>>> +}
>>>> +
>>>> +/*
>>>> + * chcr_ktls_xmit_tcb_cpls: update tcb entry so that TP will create
>>>> the header
>>> It seems fundamentally wrong to have the HW construct the header
>>> instead of working with the existing packet header. This seems like
>>> you are still using the TCP offload engine here which may miss some
>>> TCP flags/options.
>>>
>>> For instance, how do you handle TCP timstamps or ECN?
>> Hardware is not modifying the TCP header given from stack. The hardware
>> needs
>> to know some of header fields to update the TCP header for the segmented
>> packets. These required fields are being passed to hardware here.
>>
>> TCP options are also untouched and informed to hardware as plain text. The
>> hardware will send the TCP options as is, on the wire, without
>> modification.
> The question is not whether the packet is modified while it is passed to
> HW, but whether you send the original packets given by the stack to the
> wire?
>
> Also, how is segmentation different for inline-tls compared to any other
> TSO?
>
> I think it would help a lot if you could explain the interaction between
> the TOE and inline-tls offload. In particular, please explain the
> challenges and limitations of using the TOE to perform inline-tls
> without offloading TCP.
TCP offload is disabled to support inline-tls. For crypto packets, T6 uses
offload engine to perform TSO activity. And since the 'TCP offload' is
disabled, offload engine uses driver's input for required fields to form TCP
header.
