Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90479179653
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387706AbgCDRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:09:04 -0500
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:32638
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727308AbgCDRJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:09:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMWNYUXl4i9yU2NxxDm+hEXp4es7vJEN1G2rM5vQWJI6jxzkYylr1FqS13xmOYTO5z2nc3xQ0N7/QewaqULJT8I2Zk14z1nuNHshCvDzJm1NK7C8bymnkBv6bi8K/S6w9cX4eFZ+vab/y5kiDqQ+d0Z/g+8ZkCwxG6eb0D7djWha44UpMyZSlrFEbwNJftebihC6loBg4gLqHnwRe54Oasu1XT+lqFTz5VA9MD+yewTksjCUmEyNwAebfb117R8VYc49Iku2SWs8uUz+udgk7LUSFyTgXlbJf66rh76ePhws/MKoHqAPAHsl4b66pineJRvF3vzH9eeU0/mxUPaeZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD9suvxrKr03CwsV+CyAXnpItsZYW5lFWeXgJ5O4ZMU=;
 b=gwSlh0f8MCAfoE9TkezFpgBTm7W/LhTjif+UXZRyULePymVdx7qHQLJGG22CbEBupmZSgzRilpyMnVRthlExwOqI0iek57YtO9Qd4u094L5qSKCY6megbQqrBIDJMFpv9t8K1jHDxxthxFmPaiKJppE2w9Q4nt5cR6ySWAHdRy8tjcBYoF8eMc0gXngq4ivo0F4gyj1GPZCOKZV2FXKO2U8J+ZpN/qiBnISDwTMnEvqIsX9OqBauA8FvEPTB7mN5aTCIsZl7gY9F0H5ItRQlLYSl7nNkTswrVBE0uCkdPG6QJTW8UoHU/2khESGlt69PByPAJaVTWyi78NBtzp/SUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD9suvxrKr03CwsV+CyAXnpItsZYW5lFWeXgJ5O4ZMU=;
 b=HMfneEhcECZmMfp+RQChxuyPY0BhrLDuRIyZnqeFgz9FFroRlrkHkHVZd42R1B5yRGjAPKRgEawTIaYMFC17doQ+vsKhIsNX025WLB5Db05UjoqddIhkZ/7Ps2o+OccL5nep/g4JuOc7fanI0RZDeXTzogj64JtxzI8/s0mSX5U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (20.181.27.19) by
 AM7PR05MB6866.eurprd05.prod.outlook.com (20.181.26.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Wed, 4 Mar 2020 17:09:00 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::9025:8313:4e65:3a05%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 17:09:00 +0000
Subject: Re: [PATCH net-next v3 3/6] cxgb4/chcr: complete record tx handling
To:     rohit maheshwari <rohitm@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-4-rohitm@chelsio.com>
 <a02d18ce-4f30-9478-d50a-7e2fef974019@mellanox.com>
 <bd4b1961-7c86-bec5-05be-fc8b164f20a1@chelsio.com>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <94ee193d-a2b7-9746-a335-0a464468337e@mellanox.com>
Date:   Wed, 4 Mar 2020 19:08:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <bd4b1961-7c86-bec5-05be-fc8b164f20a1@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.14] (213.57.108.28) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Wed, 4 Mar 2020 17:08:59 +0000
X-Originating-IP: [213.57.108.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb788c2e-788c-4de4-3dee-08d7c05ebb92
X-MS-TrafficTypeDiagnostic: AM7PR05MB6866:
X-Microsoft-Antispam-PRVS: <AM7PR05MB6866CC2A84E8CD2F9646E502B0E50@AM7PR05MB6866.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(81166006)(2906002)(81156014)(8676002)(66946007)(31696002)(86362001)(4326008)(8936002)(478600001)(31686004)(66556008)(52116002)(66476007)(5660300002)(53546011)(16576012)(316002)(36756003)(26005)(6666004)(6486002)(186003)(16526019)(2616005)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR05MB6866;H:AM7PR05MB7092.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqzRtQE6RUC90ghgqjXaKqEr6f4xn+AQc2Hbdj5e1FcUnN1SVqr+BkoxKUx4DMElKSVllaUHPuUyRR3z19oTvA+eI9qM6gnBApEKbie7eXjeA4WtbIaIk8F5DS0G4OkD90L7dXphF3iDbLJpl4VAgZ1IAbUZAkYd8pA+aNtFxqS6+Y53aPoJLB8Oeyva6FoVeEhzjHRBNu+7xX4l5BoWRHEf0ij0r4nS5baDENHKWe2vI7r0JNM9wx0AsuPAlIQrrwS083PrwJVQReZosG090W//snfAscEY3UMEH4ptGWT9aQFYq2pAGbD9MoZ1eK17X6g9G/xHL/KNa5+fLnhaC0kap89nEBCRxANC2+kaCLUC0NgHbyXg9VO15Pjfl4e4Pc/JiTUj1JGMna91iEa4Z4ruWzA+KdD3DpdfOck8wHMtCh0LTphYWzKaptwFQWpk
X-MS-Exchange-AntiSpam-MessageData: HOZxymyLYX18yTMgrTd0TAJ4VJ6o9JMtp0cOQn2ZIs+xyt+coiDY3b38GjcXBGVB/SraMBRQMaTpC6PTAKiosW2Hm1Vr2Dkjv5+6OSdXsEyJg/fTDdkTtVPnzEdJ6qB0EfDP8gTSL9Ps0+pfoxaWlg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb788c2e-788c-4de4-3dee-08d7c05ebb92
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 17:09:00.5334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSNaTc6XyH+cGZgv5u6lxLubxFkKiEDIxo7Klb/Wfmfthjp0lLbDyPqekoAnbDFjAOKIOAmpvKE4bLFDy3IjGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6866
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/03/2020 17:47, rohit maheshwari wrote:
> Hi Boris,
> 
> On 01/03/20 2:05 PM, Boris Pismenny wrote:
>> Hi Rohit,
>>
>> On 2/29/2020 3:24 AM, Rohit Maheshwari wrote:
>>> Added tx handling in this patch. This includes handling of segments
>>> contain single complete record.
>>>
>>> v1->v2:
>>> - chcr_write_cpl_set_tcb_ulp is added in this patch.
>>>
>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>> ---
>>>   drivers/crypto/chelsio/chcr_common.h        |  36 ++
>>>   drivers/crypto/chelsio/chcr_core.c          |  18 +-
>>>   drivers/crypto/chelsio/chcr_core.h          |   1 +
>>>   drivers/crypto/chelsio/chcr_ktls.c          | 568 ++++++++++++++++++++
>>>   drivers/crypto/chelsio/chcr_ktls.h          |  13 +
>>>   drivers/net/ethernet/chelsio/cxgb4/sge.c    |   6 +-
>>>   drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  20 +
>>>   drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h |  20 +
>>>   8 files changed, 675 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/crypto/chelsio/chcr_common.h
>>> b/drivers/crypto/chelsio/chcr_common.h
>>> index 852f64322326..f4ccea68df6f 100644
>>> --- a/drivers/crypto/chelsio/chcr_common.h
>>> +++ b/drivers/crypto/chelsio/chcr_common.h
>>> @@ -9,6 +9,11 @@
>>>   #define CHCR_MAX_SALT                      4
>>>   #define CHCR_KEYCTX_MAC_KEY_SIZE_128       0
>>>   #define CHCR_KEYCTX_CIPHER_KEY_SIZE_128    0
>>> +#define CHCR_SCMD_CIPHER_MODE_AES_GCM      2
>>> +#define CHCR_CPL_TX_SEC_PDU_LEN_64BIT      2
>>> +#define CHCR_SCMD_SEQ_NO_CTRL_64BIT        3
>>> +#define CHCR_SCMD_PROTO_VERSION_TLS        0
>>> +#define CHCR_SCMD_AUTH_MODE_GHASH          4
>>>     enum chcr_state {
>>>       CHCR_INIT = 0,
>>> @@ -93,4 +98,35 @@ static inline void *chcr_copy_to_txd(const void
>>> *src, const struct sge_txq *q,
>>>       }
>>>       return p;
>>>   }
>>> +
>>> +static inline unsigned int chcr_txq_avail(const struct sge_txq *q)
>>> +{
>>> +    return q->size - 1 - q->in_use;
>>> +}
>>> +
>>> +static inline void chcr_txq_advance(struct sge_txq *q, unsigned int n)
>>> +{
>>> +    q->in_use += n;
>>> +    q->pidx += n;
>>> +    if (q->pidx >= q->size)
>>> +        q->pidx -= q->size;
>>> +}
>>> +
>>> +static inline void chcr_eth_txq_stop(struct sge_eth_txq *q)
>>> +{
>>> +    netif_tx_stop_queue(q->txq);
>>> +    q->q.stops++;
>>> +}
>>> +
>>> +static inline unsigned int chcr_sgl_len(unsigned int n)
>>> +{
>>> +    n--;
>>> +    return (3 * n) / 2 + (n & 1) + 2;
>>> +}
>>> +
>>> +static inline unsigned int chcr_flits_to_desc(unsigned int n)
>>> +{
>>> +    WARN_ON(n > SGE_MAX_WR_LEN / 8);
>>> +    return DIV_ROUND_UP(n, 8);
>>> +}
>>>   #endif /* __CHCR_COMMON_H__ */
>>> diff --git a/drivers/crypto/chelsio/chcr_core.c
>>> b/drivers/crypto/chelsio/chcr_core.c
>>> index a52ce6fc9858..0015810214a9 100644
>>> --- a/drivers/crypto/chelsio/chcr_core.c
>>> +++ b/drivers/crypto/chelsio/chcr_core.c
>>> @@ -49,9 +49,9 @@ static struct cxgb4_uld_info chcr_uld_info = {
>>>       .add = chcr_uld_add,
>>>       .state_change = chcr_uld_state_change,
>>>       .rx_handler = chcr_uld_rx_handler,
>>> -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) ||
>>> defined(CONFIG_CHELSIO_TLS_DEVICE)
>>>       .tx_handler = chcr_uld_tx_handler,
>>> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
>>> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>>>   };
>>>     static void detach_work_fn(struct work_struct *work)
>>> @@ -237,12 +237,22 @@ int chcr_uld_rx_handler(void *handle, const
>>> __be64 *rsp,
>>>       return 0;
>>>   }
>>>   -#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>> +#if defined(CONFIG_CHELSIO_IPSEC_INLINE) ||
>>> defined(CONFIG_CHELSIO_TLS_DEVICE)
>>>   int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev)
>>>   {
>>> +    /* In case if skb's decrypted bit is set, it's nic tls packet,
>>> else it's
>>> +     * ipsec packet.
>>> +     */
>>> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
>>> +    if (skb->decrypted)
>>> +        return chcr_ktls_xmit(skb, dev);
>>> +#endif
>>> +#ifdef CONFIG_CHELSIO_IPSEC_INLINE
>>>       return chcr_ipsec_xmit(skb, dev);
>>> +#endif
>>> +    return 0;
>>>   }
>>> -#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
>>> +#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
>>>     static void chcr_detach_device(struct uld_ctx *u_ctx)
>>>   {
>>> diff --git a/drivers/crypto/chelsio/chcr_core.h
>>> b/drivers/crypto/chelsio/chcr_core.h
>>> index 2dcbd188290a..b5b371b8d343 100644
>>> --- a/drivers/crypto/chelsio/chcr_core.h
>>> +++ b/drivers/crypto/chelsio/chcr_core.h
>>> @@ -227,5 +227,6 @@ void chcr_enable_ktls(struct adapter *adap);
>>>   void chcr_disable_ktls(struct adapter *adap);
>>>   int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char
>>> *input);
>>>   int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char
>>> *input);
>>> +int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
>>>   #endif
>>>   #endif /* __CHCR_CORE_H__ */
>>> diff --git a/drivers/crypto/chelsio/chcr_ktls.c
>>> b/drivers/crypto/chelsio/chcr_ktls.c
>>> index f945b93a1bf0..f4c860665c9c 100644
>>> --- a/drivers/crypto/chelsio/chcr_ktls.c
>>> +++ b/drivers/crypto/chelsio/chcr_ktls.c
>>> @@ -39,6 +39,22 @@ static int chcr_ktls_save_keys(struct
>>> chcr_ktls_info *tx_info,
>>>           salt = info_128_gcm->salt;
>>>           tx_info->record_no = *(u64 *)info_128_gcm->rec_seq;
>>>   +        /* The SCMD fields used when encrypting a full TLS
>>> +         * record. Its a one time calculation till the
>>> +         * connection exists.
>>> +         */
>>> +        tx_info->scmd0_seqno_numivs =
>>> +            SCMD_SEQ_NO_CTRL_V(CHCR_SCMD_SEQ_NO_CTRL_64BIT) |
>>> +            SCMD_CIPH_AUTH_SEQ_CTRL_F |
>>> +            SCMD_PROTO_VERSION_V(CHCR_SCMD_PROTO_VERSION_TLS) |
>>> +            SCMD_CIPH_MODE_V(CHCR_SCMD_CIPHER_MODE_AES_GCM) |
>>> +            SCMD_AUTH_MODE_V(CHCR_SCMD_AUTH_MODE_GHASH) |
>>> +            SCMD_IV_SIZE_V(TLS_CIPHER_AES_GCM_128_IV_SIZE >> 1) |
>>> +            SCMD_NUM_IVS_V(1);
>>> +
>>> +        /* keys will be sent inline. */
>>> +        tx_info->scmd0_ivgen_hdrlen = SCMD_KEY_CTX_INLINE_F;
>>> +
>>>           break;
>>>         default:
>>> @@ -373,6 +389,7 @@ static int chcr_ktls_dev_add(struct net_device
>>> *netdev, struct sock *sk,
>>>         tx_info->adap = adap;
>>>       tx_info->netdev = netdev;
>>> +    tx_info->first_qset = pi->first_qset;
>>>       tx_info->tx_chan = pi->tx_chan;
>>>       tx_info->smt_idx = pi->smt_idx;
>>>       tx_info->port_id = pi->port_id;
>>> @@ -572,4 +589,555 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter
>>> *adap, unsigned char *input)
>>>       chcr_ktls_update_connection_state(tx_info, KTLS_CONN_SET_TCB_RPL);
>>>       return 0;
>>>   }
>>> +
>>> +/*
>>> + * chcr_write_cpl_set_tcb_ulp: update tcb values.
>>> + * TCB is responsible to create tcp headers, so all the related values
>>> + * should be correctly updated.
>>> + * @tx_info - driver specific tls info.
>>> + * @q - tx queue on which packet is going out.
>>> + * @tid - TCB identifier.
>>> + * @pos - current index where should we start writing.
>>> + * @word - TCB word.
>>> + * @mask - TCB word related mask.
>>> + * @val - TCB word related value.
>>> + * @reply - set 1 if looking for TP response.
>>> + * return - next position to write.
>>> + */
>>> +static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
>>> +                    struct sge_eth_txq *q, u32 tid,
>>> +                    void *pos, u16 word, u64 mask,
>>> +                    u64 val, u32 reply)
>>> +{
>>> +    struct cpl_set_tcb_field_core *cpl;
>>> +    struct ulptx_idata *idata;
>>> +    struct ulp_txpkt *txpkt;
>>> +    void *save_pos = NULL;
>>> +    u8 buf[48] = {0};
>>> +    int left;
>>> +
>>> +    left = (void *)q->q.stat - pos;
>>> +    if (unlikely(left < CHCR_SET_TCB_FIELD_LEN)) {
>>> +        if (!left) {
>>> +            pos = q->q.desc;
>>> +        } else {
>>> +            save_pos = pos;
>>> +            pos = buf;
>>> +        }
>>> +    }
>>> +    /* ULP_TXPKT */
>>> +    txpkt = pos;
>>> +    txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
>>> ULP_TXPKT_DEST_V(0));
>>> +    txpkt->len = htonl(DIV_ROUND_UP(CHCR_SET_TCB_FIELD_LEN, 16));
>>> +
>>> +    /* ULPTX_IDATA sub-command */
>>> +    idata = (struct ulptx_idata *)(txpkt + 1);
>>> +    idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_IMM));
>>> +    idata->len = htonl(sizeof(*cpl));
>>> +    pos = idata + 1;
>>> +
>>> +    cpl = pos;
>>> +    /* CPL_SET_TCB_FIELD */
>>> +    OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
>>> +    cpl->reply_ctrl = htons(QUEUENO_V(tx_info->rx_qid) |
>>> +            NO_REPLY_V(!reply));
>>> +    cpl->word_cookie = htons(TCB_WORD_V(word));
>>> +    cpl->mask = cpu_to_be64(mask);
>>> +    cpl->val = cpu_to_be64(val);
>>> +
>>> +    /* ULPTX_NOOP */
>>> +    idata = (struct ulptx_idata *)(cpl + 1);
>>> +    idata->cmd_more = htonl(ULPTX_CMD_V(ULP_TX_SC_NOOP));
>>> +    idata->len = htonl(0);
>>> +
>>> +    if (save_pos) {
>>> +        pos = chcr_copy_to_txd(buf, &q->q, save_pos,
>>> +                       CHCR_SET_TCB_FIELD_LEN);
>>> +    } else {
>>> +        /* check again if we are at the end of the queue */
>>> +        if (left == CHCR_SET_TCB_FIELD_LEN)
>>> +            pos = q->q.desc;
>>> +        else
>>> +            pos = idata + 1;
>>> +    }
>>> +
>>> +    return pos;
>>> +}
>>> +
>>> +/*
>>> + * chcr_ktls_xmit_tcb_cpls: update tcb entry so that TP will create
>>> the header
>> It seems fundamentally wrong to have the HW construct the header
>> instead of working with the existing packet header. This seems like
>> you are still using the TCP offload engine here which may miss some
>> TCP flags/options.
>>
>> For instance, how do you handle TCP timstamps or ECN?
> Hardware is not modifying the TCP header given from stack. The hardware
> needs
> to know some of header fields to update the TCP header for the segmented
> packets. These required fields are being passed to hardware here.
> 
> TCP options are also untouched and informed to hardware as plain text. The
> hardware will send the TCP options as is, on the wire, without
> modification.

The question is not whether the packet is modified while it is passed to
HW, but whether you send the original packets given by the stack to the
wire?

Also, how is segmentation different for inline-tls compared to any other
TSO?

I think it would help a lot if you could explain the interaction between
the TOE and inline-tls offload. In particular, please explain the
challenges and limitations of using the TOE to perform inline-tls
without offloading TCP.
