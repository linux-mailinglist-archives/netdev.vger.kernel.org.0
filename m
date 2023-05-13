Return-Path: <netdev+bounces-2382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E89F7019FF
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 23:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6451C20A81
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAC61875;
	Sat, 13 May 2023 21:12:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C82262E
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 21:12:27 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9B61997;
	Sat, 13 May 2023 14:12:25 -0700 (PDT)
Received: from fpc (unknown [10.10.165.8])
	by mail.ispras.ru (Postfix) with ESMTPSA id 8D4FF44C100C;
	Sat, 13 May 2023 21:12:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8D4FF44C100C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1684012341;
	bh=h5VwOgu4Ms78MtO1SJ+EbrnBbcjgQHHWiMcv59ZFSQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n54qSLzEKR06mgSWFz9DOGBBEfBdAxzLrb0WYa8XCQDbRx1opF5RTbluQWabw/lyl
	 kyoa3nrgWVUGKCW9fhG0zEYfmxaUcHDKVYadkp1N5a0lk0qoENgaQHq5PENP2Yi9Eo
	 LbsgEUap0NBvo18y5yo3n9KyoA4i000wfnm36jM4=
Date: Sun, 14 May 2023 00:12:14 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>,
	Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: ath9k: Fix memory leak in htc_connect_service
Message-ID: <20230513211214.qtr7yejodbubjbyd@fpc>
References: <ZFXk/AIKeapT72Pj@DESKTOP>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFXk/AIKeapT72Pj@DESKTOP>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Sat, May 06, 2023 at 02:26:20PM +0900, Takeshi Misawa wrote:
> Timeout occurs in htc_connect_service(), then this function returns
> without freeing skb.
> 
> Fix this by going to err path.

This will lead to UAF [1]. If a timeout occurs, htc_connect_service()
returns with error but it is possible that a belated callback will touch
the already freed SKB. It is actually a callback's responsibilty to free
the buffer. The callback is ath9k_htc_txcompletion_cb(). As the urb is
submitted, callback should be always executed, otherwise there is an error
in usb core, not ath9k.

So the problem lies in somewhat another place.

htc_connect_service() issues service connection requests via control
ENDPOINT0. Its pipe_ids are configured in ath9k_htc_hw_alloc():

	/* Assign control endpoint pipe IDs */
	endpoint = &target->endpoint[ENDPOINT0];
	endpoint->ul_pipeid = hif->control_ul_pipe;
	endpoint->dl_pipeid = hif->control_dl_pipe;

ul_pipe is USB_REG_OUT_PIPE and service connection requests should go that
way.

However, the reproducer managed to issue the WMI_CMD and Beacon requests
via USB_REG_OUT_PIPE, but the third one was issued via USB_WLAN_TX_PIPE.
As it went on the wrong way, the SKB simply got lost in __hif_usb_tx() as
the special conditions weren't satisfied.

Somehow the ENDPOINT0 ul_pipeid has unexpectedly changed... Well, it is
htc_process_conn_rsp() which received a badly constructed "service
connection reply" from a bad USB device: the endpoint which attributes
were to be changed pointed to ENDPOINT0 which should never happen with
healthy firmware. But ENDPOINT0 pipeid attributes were changed, so the
next service conn requests went on the wrong path.

The fix seems to be that htc_process_conn_rsp() should immediately return
if the received endpoint which is to be connected to a new service is
ENDPOINT0. 

[1]: https://lore.kernel.org/linux-wireless/20200404041838.10426-2-hqjagain@gmail.com/
> 
> syzbot report:
> BUG: memory leak
> unreferenced object 0xffff88810a980800 (size 240):
>   comm "kworker/1:1", pid 24, jiffies 4294947427 (age 16.220s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff83b971c6>] __alloc_skb+0x206/0x270 net/core/skbuff.c:552
>     [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
>     [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
>     [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
>     [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
>     [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
>     [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
>     [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
>     [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
>     [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
>     [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
>     [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
>     [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Link: https://syzkaller.appspot.com/bug?id=fbf138952d6c1115ba7d797cf7d56f6935184e3f
> Reported-and-tested-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
> Signed-off-by: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_hst.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index ca05b07a45e6..6878da6d15b4 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -285,7 +285,8 @@ int htc_connect_service(struct htc_target *target,
>  	if (!time_left) {
>  		dev_err(target->dev, "Service connection timeout for: %d\n",
>  			service_connreq->service_id);
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto err;
>  	}
>  
>  	*conn_rsp_epid = target->conn_rsp_epid;
> -- 
> 2.39.2
> 

