Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F758099C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiGZCtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbiGZCtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:49:00 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF29029C90;
        Mon, 25 Jul 2022 19:48:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VKTDtRm_1658803734;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VKTDtRm_1658803734)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 10:48:55 +0800
Date:   Tue, 26 Jul 2022 10:48:54 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 1/4] net/smc: Eliminate struct smc_ism_position
Message-ID: <Yt9WFkDYP+N+bS+4@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
 <20220725141000.70347-2-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725141000.70347-2-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 04:09:57PM +0200, Wenjia Zhang wrote:
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> This struct is used in a single place only, and its usage generates
> inefficient code. Time to clean up!
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Reviewed-and-tested-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>

This patch looks good to me.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/smc_ism.c | 11 -----------
>  net/smc/smc_ism.h | 20 +++++++++++---------
>  net/smc/smc_tx.c  | 10 +++-------
>  3 files changed, 14 insertions(+), 27 deletions(-)
> 
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index a2084ecdb97e..c656ef25ee4b 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -33,17 +33,6 @@ int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
>  					   vlan_id);
>  }
>  
> -int smc_ism_write(struct smcd_dev *smcd, const struct smc_ism_position *pos,
> -		  void *data, size_t len)
> -{
> -	int rc;
> -
> -	rc = smcd->ops->move_data(smcd, pos->token, pos->index, pos->signal,
> -				  pos->offset, data, len);
> -
> -	return rc < 0 ? rc : 0;
> -}
> -
>  void smc_ism_get_system_eid(u8 **eid)
>  {
>  	if (!smc_ism_v2_capable)
> diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
> index 004b22a13ffa..d6b2db604fe8 100644
> --- a/net/smc/smc_ism.h
> +++ b/net/smc/smc_ism.h
> @@ -28,13 +28,6 @@ struct smc_ism_vlanid {			/* VLAN id set on ISM device */
>  	refcount_t refcnt;		/* Reference count */
>  };
>  
> -struct smc_ism_position {	/* ISM device position to write to */
> -	u64 token;		/* Token of DMB */
> -	u32 offset;		/* Offset into DMBE */
> -	u8 index;		/* Index of DMBE */
> -	u8 signal;		/* Generate interrupt on owner side */
> -};
> -
>  struct smcd_dev;
>  
>  int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *dev);
> @@ -45,12 +38,21 @@ int smc_ism_put_vlan(struct smcd_dev *dev, unsigned short vlan_id);
>  int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
>  			 struct smc_buf_desc *dmb_desc);
>  int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
> -int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
> -		  void *data, size_t len);
>  int smc_ism_signal_shutdown(struct smc_link_group *lgr);
>  void smc_ism_get_system_eid(u8 **eid);
>  u16 smc_ism_get_chid(struct smcd_dev *dev);
>  bool smc_ism_is_v2_capable(void);
>  void smc_ism_init(void);
>  int smcd_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
> +
> +static inline int smc_ism_write(struct smcd_dev *smcd, u64 dmb_tok,
> +				unsigned int idx, bool sf, unsigned int offset,
> +				void *data, size_t len)
> +{
> +	int rc;
> +
> +	rc = smcd->ops->move_data(smcd, dmb_tok, idx, sf, offset, data, len);
> +	return rc < 0 ? rc : 0;
> +}
> +
>  #endif
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 4e8377657a62..64dedffe9d26 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -320,15 +320,11 @@ int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
>  int smcd_tx_ism_write(struct smc_connection *conn, void *data, size_t len,
>  		      u32 offset, int signal)
>  {
> -	struct smc_ism_position pos;
>  	int rc;
>  
> -	memset(&pos, 0, sizeof(pos));
> -	pos.token = conn->peer_token;
> -	pos.index = conn->peer_rmbe_idx;
> -	pos.offset = conn->tx_off + offset;
> -	pos.signal = signal;
> -	rc = smc_ism_write(conn->lgr->smcd, &pos, data, len);
> +	rc = smc_ism_write(conn->lgr->smcd, conn->peer_token,
> +			   conn->peer_rmbe_idx, signal, conn->tx_off + offset,
> +			   data, len);
>  	if (rc)
>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>  	return rc;
> -- 
> 2.35.2
