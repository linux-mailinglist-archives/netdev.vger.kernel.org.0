Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF8AB0B4
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 04:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391996AbfIFCoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 22:44:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38589 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391998AbfIFCoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 22:44:23 -0400
Received: by mail-qk1-f195.google.com with SMTP id x5so4279167qkh.5
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 19:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/4fDDIpYX1nGa6Qb0nPeh0ZVgtz+HFbR6HLyKfwiow=;
        b=ossHTH2g18CyBktaNondYX5A59F/z9Ziw9LEOsQoedZRquVj7Rw1ocpCcRBwfGDiNN
         XDcrXNG1h97c8OjkeFt9KUEYl3wESgQlXiGgyeyD81XHHmg3qwI+FIu60b7iA/Jc80R1
         YQ6Ffafu+1/manE9swdb+5LGdSlhU1uYbDuioDdk0EEsVZLyutv8m0FLgVNv1mJQIOix
         7Y6T7n5rqAtEl3g61FLrlmu2IKV4Upp7+bZxKgkKsGSIT/dANx5tzdkeQsZCSVNASiEJ
         qy3Za53B0ZKDtw9ni5svJRzIHL/1EMo42uMhTndOwcf05K2Ozq0XmYXQoKcwVCq56d48
         3HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K/4fDDIpYX1nGa6Qb0nPeh0ZVgtz+HFbR6HLyKfwiow=;
        b=MWg3rOASiEi0YISHZ90BGEjLjlsdUmr5i3FEDZZ8QpqyQF0STKnH2bbK3babd+zA6w
         IDzA6cH92xbYw2+6JHHjTgvMlYjiRiojpgJ7fM7Fm/ahlxDuJD6BLPd75hsrD05i5R06
         YU2FMW3u6bNDl2OP62it/biTbrZ7EmF2Qs1N1eZhvxNJsT1IK7qUhhoSHRvT7yBRQ+GK
         gCRJogcjSHsY6IuiJcQUnLNgSCUssU/S655dek56BmhzZ+9b1os8n+VLYSPWEYVTG7QD
         RavUqtzXIM4GU0W1x+Xhb4HxYljk8a0EtISwlUUxVlZhADCE6sebR3z0Cs0tfePKtL7p
         tyYw==
X-Gm-Message-State: APjAAAVd2RWolWqsJyOpz+RI/5dv18brZxLbBwO+WRVloXhS7FFhd1gI
        FX7/AbM4b6Rc2mzsINDdN6OQ61MkXwJR1D6ifI7Neg==
X-Google-Smtp-Source: APXvYqwc7TOG0qibPM4UpDyayQcgcpSOVZsKzmYC6H/swTX41ex+SHTRGFEebvWWuNtzu1q1d94blBrP3gQqxi4cy1o=
X-Received: by 2002:a37:9303:: with SMTP id v3mr6641447qkd.369.1567737861435;
 Thu, 05 Sep 2019 19:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190903053735.85957-1-chiu@endlessm.com>
In-Reply-To: <20190903053735.85957-1-chiu@endlessm.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 6 Sep 2019 10:44:10 +0800
Message-ID: <CAB4CAwc5OBUWFThh__FedmG=fR-_1_GxUuiAb0J5yfU8c1aTfg@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: add bluetooth co-existence support for single antenna
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 1:37 PM Chris Chiu <chiu@endlessm.com> wrote:
>
> The RTL8723BU suffers the wifi disconnection problem while bluetooth
> device connected. While wifi is doing tx/rx, the bluetooth will scan
> without results. This is due to the wifi and bluetooth share the same
> single antenna for RF communication and they need to have a mechanism
> to collaborate.
>
> BT information is provided via the packet sent from co-processor to
> host (C2H). It contains the status of BT but the rtl8723bu_handle_c2h
> dose not really handle it. And there's no bluetooth coexistence
> mechanism to deal with it.
>
> This commit adds a workqueue to set the tdma configurations and
> coefficient table per the parsed bluetooth link status and given
> wifi connection state. The tdma/coef table comes from the vendor
> driver code of the RTL8192EU and RTL8723BU. However, this commit is
> only for single antenna scenario which RTL8192EU is default dual
> antenna. The rtl8xxxu_parse_rxdesc24 which invokes the handle_c2h
> is only for 8723b and 8192e so the mechanism is expected to work
> on both chips with single antenna. Note RTL8192EU dual antenna is
> not supported.
>
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  37 +++
>  .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         |   2 -
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 243 +++++++++++++++++-
>  3 files changed, 275 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 582c2a346cec..22e95b11bfbb 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1220,6 +1220,37 @@ enum ratr_table_mode_new {
>         RATEID_IDX_BGN_3SS = 14,
>  };
>
> +#define BT_INFO_8723B_1ANT_B_FTP               BIT(7)
> +#define BT_INFO_8723B_1ANT_B_A2DP              BIT(6)
> +#define BT_INFO_8723B_1ANT_B_HID               BIT(5)
> +#define BT_INFO_8723B_1ANT_B_SCO_BUSY          BIT(4)
> +#define BT_INFO_8723B_1ANT_B_ACL_BUSY          BIT(3)
> +#define BT_INFO_8723B_1ANT_B_INQ_PAGE          BIT(2)
> +#define BT_INFO_8723B_1ANT_B_SCO_ESCO          BIT(1)
> +#define BT_INFO_8723B_1ANT_B_CONNECTION        BIT(0)
> +
> +enum _BT_8723B_1ANT_STATUS {
> +       BT_8723B_1ANT_STATUS_NON_CONNECTED_IDLE      = 0x0,
> +       BT_8723B_1ANT_STATUS_CONNECTED_IDLE          = 0x1,
> +       BT_8723B_1ANT_STATUS_INQ_PAGE                = 0x2,
> +       BT_8723B_1ANT_STATUS_ACL_BUSY                = 0x3,
> +       BT_8723B_1ANT_STATUS_SCO_BUSY                = 0x4,
> +       BT_8723B_1ANT_STATUS_ACL_SCO_BUSY            = 0x5,
> +       BT_8723B_1ANT_STATUS_MAX
> +};
> +
> +struct rtl8xxxu_btcoex {
> +       u8      bt_status;
> +       bool    bt_busy;
> +       bool    has_sco;
> +       bool    has_a2dp;
> +       bool    has_hid;
> +       bool    has_pan;
> +       bool    hid_only;
> +       bool    a2dp_only;
> +       bool    c2h_bt_inquiry;
> +};
> +
>  #define RTL8XXXU_RATR_STA_INIT 0
>  #define RTL8XXXU_RATR_STA_HIGH 1
>  #define RTL8XXXU_RATR_STA_MID  2
> @@ -1340,6 +1371,10 @@ struct rtl8xxxu_priv {
>          */
>         struct ieee80211_vif *vif;
>         struct delayed_work ra_watchdog;
> +       struct work_struct c2hcmd_work;
> +       struct sk_buff_head c2hcmd_queue;
> +       spinlock_t c2hcmd_lock;
> +       struct rtl8xxxu_btcoex bt_coex;
>  };
>
>  struct rtl8xxxu_rx_urb {
> @@ -1486,6 +1521,8 @@ void rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
>                              struct rtl8xxxu_txdesc32 *tx_desc32, bool sgi,
>                              bool short_preamble, bool ampdu_enable,
>                              u32 rts_rate);
> +void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
> +                          u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5);
>
>  extern struct rtl8xxxu_fileops rtl8192cu_fops;
>  extern struct rtl8xxxu_fileops rtl8192eu_fops;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> index ceffe05bd65b..9ba661b3d767 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> @@ -1580,9 +1580,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>         /*
>          * Software control, antenna at WiFi side
>          */
> -#ifdef NEED_PS_TDMA
>         rtl8723bu_set_ps_tdma(priv, 0x08, 0x00, 0x00, 0x00, 0x00);
> -#endif
>
>         rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
>         rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index a6f358b9e447..4f72c2d14d44 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -3820,9 +3820,8 @@ void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
>         rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
>  }
>
> -#ifdef NEED_PS_TDMA
> -static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
> -                                 u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
> +void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
> +                          u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
>  {
>         struct h2c_cmd h2c;
>
> @@ -3835,7 +3834,6 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
>         h2c.b_type_dma.data5 = arg5;
>         rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
>  }
> -#endif
>
>  void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv)
>  {
> @@ -5186,12 +5184,239 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
>         }
>  }
>
> +void rtl8723bu_set_coex_with_type(struct rtl8xxxu_priv *priv, u8 type)
> +{
> +       switch (type) {
> +       case 0:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 1:
> +       case 3:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 2:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 4:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaa5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 5:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaa5a5a5a);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 6:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaaaaaa);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       case 7:
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0xaaaaaaaa);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaaaaaa);
> +               rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> +               rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
> +void rtl8723bu_update_bt_link_info(struct rtl8xxxu_priv *priv, u8 bt_info)
> +{
> +       struct rtl8xxxu_btcoex *btcoex = &priv->bt_coex;
> +
> +       if (bt_info & BT_INFO_8723B_1ANT_B_INQ_PAGE)
> +               btcoex->c2h_bt_inquiry = true;
> +       else
> +               btcoex->c2h_bt_inquiry = false;
> +
> +       if (!(bt_info & BT_INFO_8723B_1ANT_B_CONNECTION)) {
> +               btcoex->bt_status = BT_8723B_1ANT_STATUS_NON_CONNECTED_IDLE;
> +               btcoex->has_sco = false;
> +               btcoex->has_hid = false;
> +               btcoex->has_pan = false;
> +               btcoex->has_a2dp = false;
> +       } else {
> +               if ((bt_info & 0x1f) == BT_INFO_8723B_1ANT_B_CONNECTION)
> +                       btcoex->bt_status = BT_8723B_1ANT_STATUS_CONNECTED_IDLE;
> +               else if ((bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO) ||
> +                        (bt_info & BT_INFO_8723B_1ANT_B_SCO_BUSY))
> +                       btcoex->bt_status = BT_8723B_1ANT_STATUS_SCO_BUSY;
> +               else if (bt_info & BT_INFO_8723B_1ANT_B_ACL_BUSY)
> +                       btcoex->bt_status = BT_8723B_1ANT_STATUS_ACL_BUSY;
> +               else
> +                       btcoex->bt_status = BT_8723B_1ANT_STATUS_MAX;
> +
> +               if (bt_info & BT_INFO_8723B_1ANT_B_FTP)
> +                       btcoex->has_pan = true;
> +               else
> +                       btcoex->has_pan = false;
> +
> +               if (bt_info & BT_INFO_8723B_1ANT_B_A2DP)
> +                       btcoex->has_a2dp = true;
> +               else
> +                       btcoex->has_a2dp = false;
> +
> +               if (bt_info & BT_INFO_8723B_1ANT_B_HID)
> +                       btcoex->has_hid = true;
> +               else
> +                       btcoex->has_hid = false;
> +
> +               if (bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO)
> +                       btcoex->has_sco = true;
> +               else
> +                       btcoex->has_sco = false;
> +       }
> +
> +       if (!btcoex->has_a2dp &&
> +           !btcoex->has_sco &&
> +           !btcoex->has_pan &&
> +           btcoex->has_hid)
> +               btcoex->hid_only = true;
> +       else
> +               btcoex->hid_only = false;
> +
> +       if (!btcoex->has_sco &&
> +           !btcoex->has_pan &&
> +           !btcoex->has_hid &&
> +           btcoex->has_a2dp)
> +               btcoex->has_a2dp = true;
> +       else
> +               btcoex->has_a2dp = false;
> +
> +       if (btcoex->bt_status == BT_8723B_1ANT_STATUS_SCO_BUSY ||
> +           btcoex->bt_status == BT_8723B_1ANT_STATUS_ACL_BUSY)
> +               btcoex->bt_busy = true;
> +       else
> +               btcoex->bt_busy = false;
> +}
> +
> +static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
> +{
> +       struct rtl8xxxu_priv *priv;
> +       struct rtl8723bu_c2h *c2h;
> +       struct ieee80211_vif *vif;
> +       struct device *dev;
> +       struct sk_buff *skb = NULL;
> +       unsigned long flags;
> +       int len;
> +       u8 bt_info = 0;
> +       struct rtl8xxxu_btcoex *btcoex;
> +
> +       priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
> +       vif = priv->vif;
> +       btcoex = &priv->bt_coex;
> +       dev = &priv->udev->dev;
> +
> +       if (priv->rf_paths > 1)
> +               goto out;
> +
> +       while (!skb_queue_empty(&priv->c2hcmd_queue)) {
> +               spin_lock_irqsave(&priv->c2hcmd_lock, flags);
> +               skb = __skb_dequeue(&priv->c2hcmd_queue);
> +               spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
> +
> +               c2h = (struct rtl8723bu_c2h *)skb->data;
> +               len = skb->len - 2;
> +
> +               switch (c2h->id) {
> +               case C2H_8723B_BT_INFO:
> +                       bt_info = c2h->bt_info.bt_info;
> +
> +                       rtl8723bu_update_bt_link_info(priv, bt_info);
> +
> +                       if (btcoex->c2h_bt_inquiry) {
> +                               if (vif && !vif->bss_conf.assoc) {
> +                                       rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +                                       rtl8723bu_set_coex_with_type(priv, 0);
> +                               } else if (btcoex->has_sco ||
> +                                          btcoex->has_hid ||
> +                                          btcoex->has_a2dp) {
> +                                       rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +                                       rtl8723bu_set_coex_with_type(priv, 4);
> +                               } else if (btcoex->has_pan) {
> +                                       rtl8723bu_set_ps_tdma(priv, 0x61, 0x3f, 0x3, 0x11, 0x11);
> +                                       rtl8723bu_set_coex_with_type(priv, 4);
> +                               } else {
> +                                       rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +                                       rtl8723bu_set_coex_with_type(priv, 7);
> +                               }
> +
> +                               return;
> +                       }
> +
> +                       if (vif && vif->bss_conf.assoc) {
> +                               u32 val32 = 0;
> +                               u32 high_prio_tx = 0, high_prio_rx = 0;
> +
> +                               val32 = rtl8xxxu_read32(priv, 0x770);
> +                               high_prio_tx = val32 & 0x0000ffff;
> +                               high_prio_rx = (val32  & 0xffff0000) >> 16;
> +
> +                               if (btcoex->bt_busy) {
> +                                       if (btcoex->hid_only) {
> +                                               rtl8723bu_set_ps_tdma(priv, 0x61, 0x20, 0x3, 0x11, 0x11);
> +                                               rtl8723bu_set_coex_with_type(priv, 5);
> +                                       } else if (btcoex->a2dp_only) {
> +                                               rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +                                               rtl8723bu_set_coex_with_type(priv, 4);
> +                                       } else if ((btcoex->has_a2dp &&
> +                                                   btcoex->has_pan) ||
> +                                                  (btcoex->has_hid &&
> +                                                   btcoex->has_a2dp &&
> +                                                   btcoex->has_pan)) {
> +                                               rtl8723bu_set_ps_tdma(priv, 0x51, 0x21, 0x3, 0x10, 0x10);
> +                                               rtl8723bu_set_coex_with_type(priv, 4);
> +                                       } else if (btcoex->has_hid &&
> +                                                btcoex->has_a2dp) {
> +                                               rtl8723bu_set_ps_tdma(priv, 0x51, 0x21, 0x3, 0x10, 0x10);
> +                                               rtl8723bu_set_coex_with_type(priv, 3);
> +                                       } else {
> +                                               rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
> +                                               rtl8723bu_set_coex_with_type(priv, 4);
> +                                       }
> +                               } else {
> +                                       rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +                                       if (high_prio_tx + high_prio_rx <= 60)
> +                                               rtl8723bu_set_coex_with_type(priv, 2);
> +                                       else
> +                                               rtl8723bu_set_coex_with_type(priv, 7);
> +                               }
> +                       } else {
> +                               rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
> +                               rtl8723bu_set_coex_with_type(priv, 0);
> +                       }
> +                       break;
> +               default:
> +                       break;
> +               }
> +       }
> +
> +out:
> +       dev_kfree_skb(skb);
> +}
> +
>  static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
>                                  struct sk_buff *skb)
>  {
>         struct rtl8723bu_c2h *c2h = (struct rtl8723bu_c2h *)skb->data;
>         struct device *dev = &priv->udev->dev;
>         int len;
> +       unsigned long flags;
>
>         len = skb->len - 2;
>
> @@ -5229,6 +5454,12 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
>                                16, 1, c2h->raw.payload, len, false);
>                 break;
>         }
> +
> +       spin_lock_irqsave(&priv->c2hcmd_lock, flags);
> +       __skb_queue_tail(&priv->c2hcmd_queue, skb);
> +       spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
> +
> +       schedule_work(&priv->c2hcmd_work);
>  }
>
>  int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
> @@ -5353,7 +5584,6 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
>                 struct device *dev = &priv->udev->dev;
>                 dev_dbg(dev, "%s: C2H packet\n", __func__);
>                 rtl8723bu_handle_c2h(priv, skb);
> -               dev_kfree_skb(skb);
>                 return RX_TYPE_C2H;
>         }
>
> @@ -6272,6 +6502,9 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>         spin_lock_init(&priv->rx_urb_lock);
>         INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
>         INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
> +       spin_lock_init(&priv->c2hcmd_lock);
> +       INIT_WORK(&priv->c2hcmd_work, rtl8xxxu_c2hcmd_callback);
> +       skb_queue_head_init(&priv->c2hcmd_queue);
>
>         usb_set_intfdata(interface, hw);
>
> --
> 2.20.1
>

Gentle ping. Cheers.

Chris
