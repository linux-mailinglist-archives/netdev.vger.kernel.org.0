Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64924524D7E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353961AbiELMu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354040AbiELMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:50:06 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E348224F0D1;
        Thu, 12 May 2022 05:50:00 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652359798; bh=98g8YRRaj0MjLN/x5A3xUMwHLtbWASMbKhpV4ODYJwA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=tVMw0JJ/AyQIOHEqcRg0sX2VzH8JcEIEUEFPyZTAqBF/KNFfOb9TYTQhqrbYRJX92
         7r19nB+YayrLVuGTlh7cRKVzsJG/wkjKtGGLNQIt/ioWaBq+/5R2BswduY/Hs7oV9c
         3MDYLsMLqenk+6vV/bhh/KjlUYfg5SkXsKYvPinX9kaBCVpzqC7RnVL1C+E6GEhZRq
         pfEsLCzv5SHOVs3RtrjEvPVZ9cVjVJtzJmME1LkbM3GDsdo79JgeQDzsUoseuH7JzY
         3hOXBol2j40eMSZ+YhmdT21COCtvPD7V6ujeHGQg5BiIxtdapjwpEEhIAqOVzZ4HLw
         p6rxsSECQBKzQ==
To:     Pavel Skripkin <paskripkin@gmail.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
Date:   Thu, 12 May 2022 14:49:57 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r14yhq4q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv = priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()		   <--- priv pointer is freed
>
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Could you link the original syzbot report in the commit message as well,
please? Also that 'tested-by' implies that syzbot run-tested this? How
does it do that; does it have ath9k_htc hardware?

> ---
>
> Changes since v2:
> 	- My send-email script forgot, that mailing lists exist.
> 	  Added back all related lists
>
> Changes since v1:
> 	- Removed clean-ups and moved them to 2/2
>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 6b45e63fae4b..141642e5e00d 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -327,11 +327,11 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>  }
>  
>  #ifdef CONFIG_ATH9K_HTC_DEBUGFS
> -
> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> +#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
> +#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> +#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> +#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> +#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
>  #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++

s/SAVE/SAFE/ here and in the next patch (and the commit message).

-Toke
