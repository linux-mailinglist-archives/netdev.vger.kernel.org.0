Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646EF6ED44E
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjDXSX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjDXSXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:23:25 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0AB40C3;
        Mon, 24 Apr 2023 11:23:13 -0700 (PDT)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 19D1D4076265;
        Mon, 24 Apr 2023 18:23:07 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 19D1D4076265
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682360587;
        bh=GyggWapQ7n25mm1QU3MnwVH+BHKhrUUHO03Z5ncsQvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPI3VjtbMRea/xqZF287oM+4KjFTF0ROL2Gs++CJwhVJCTEl9XHQhGy9q//ZRF3Ex
         WALuEQXPL3S1t1OsLVG80mAnnBInlPXjSWcEhzmqPOYzOI0jyvn25pSYYI7lIMe0E9
         KfcoQJTb1FBjiqojVRTYqvXKNayRwxUVgG8zWtZU=
Date:   Mon, 24 Apr 2023 21:23:00 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Vallo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/3] wifi: ath9k: avoid referencing uninit memory in
 ath9k_wmi_ctrl_rx
Message-ID: <20230424182300.sw5ogmcst5suf2ab@fpc>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
 <20230315202112.163012-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315202112.163012-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:21:10PM +0300, Fedor Pchelkin wrote:
> For the reasons described in commit b383e8abed41 ("wifi: ath9k: avoid
> uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
> validate pkt_len before accessing the SKB. For example, the obtained SKB
> may have uninitialized memory in the case of
> ioctl(USB_RAW_IOCTL_EP_WRITE).
> 
> Implement sanity checking inside the corresponding endpoint RX handlers:
> ath9k_wmi_ctrl_rx() and ath9k_htc_rxep(). Otherwise, uninit memory can
> be referenced.
> 
> Add comments briefly describing the issue.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---

Apologies for the delay.

I've been able to test the patches in some way on 0cf3:9271 Qualcomm
Atheros Communications AR9271 802.11n .

>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 ++++++
>  drivers/net/wireless/ath/ath9k/htc_hst.c      | 4 ++++
>  drivers/net/wireless/ath/ath9k/wmi.c          | 8 ++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index 672789e3c55d..957efb26019d 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -1147,6 +1147,12 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
>  	if (!data_race(priv->rx.initialized))
>  		goto err;
>  
> +	/* Validate the obtained SKB so that it is handled without error
> +	 * inside rx_tasklet handler.
> +	 */
> +	if (unlikely(skb->len < sizeof(struct ieee80211_hdr)))
> +		goto err;
> +
>  	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
>  	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
>  		if (!tmp_buf->in_process) {

This check above seems to be redundant: SKB is properly checked inside
ath9k_rx_prepare() in rx_tasklet handler.

> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index fe62ff668f75..9d0d9d0e1aa8 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -475,6 +475,10 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>  		skb_pull(skb, sizeof(struct htc_frame_hdr));
>  
>  		endpoint = &htc_handle->endpoint[epid];
> +
> +		/* The endpoint RX handlers should implement their own
> +		 * additional SKB sanity checking
> +		 */
>  		if (endpoint->ep_callbacks.rx)
>  			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
>  						  skb, epid);
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index 19345b8f7bfd..2e7c361b62f5 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -204,6 +204,10 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
>  {
>  	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
>  
> +	/* Once again validate the SKB. */
> +	if (unlikely(skb->len < wmi->cmd_rsp_len))
> +		return;
> +
>  	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
>  		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
>

The change above is very very wrong. Looking at the firmware code and
debugging driver with real device, I realized the command response is
located in the tailroom of an SKB: skb->len (SKB data length) is zero in
such packets while skb->data and skb->tail pointers are equal. So a new
skb->len and cmd_rsp_len check resulted in driver denying all WMI command
responses. My bad for proposing such a mistake.

> @@ -221,6 +225,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
>  	if (unlikely(wmi->stopped))
>  		goto free_skb;
>  
> +	/* Validate the obtained SKB. */
> +	if (unlikely(skb->len < sizeof(struct wmi_cmd_hdr)))
> +		goto free_skb;
> +
>  	hdr = (struct wmi_cmd_hdr *) skb->data;
>  	cmd_id = be16_to_cpu(hdr->command_id);
>  

This check above is actually good. A packet can be obtained constructed
something like this (taken from Syzkaller reproducer):

  *(uint16_t*)0x20000500 = 8; // pkt_len
  *(uint16_t*)0x20000502 = 0x4e00; // ATH_USB_RX_STREAM_MODE_TAG
  memcpy((void*)0x20000504, "\x15\xa7\xd5\x61\xb9\xb3\xb0\x7c", 8);
  syz_usb_ep_write(r[0], 0x82, 0xc, 0x20000500);

pkt_len is 8, so that it can contain an htc_frame_hdr, but when the SKB is
processed in ath9k_htc_rx_msg() and passed to the endpoint RX handler,
ath9k_wmi_ctrl_rx() specifically, the problem arises as there are no other
corresponding headers in the buffer.

wmi_cmd_hdr is pulled later so there are no problems with checking
skb->len. There are no issues arised with the patch on a real device, too.

Not sure if this can happen on an ath9k device with common firmware
(probably can't happen), but that is real with some bad USB device which
Syzkaller emulates.

I'll send the v2 versions for further discussions.

> -- 
> 2.34.1
> 
