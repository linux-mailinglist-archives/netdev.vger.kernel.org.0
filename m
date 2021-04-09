Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE935A0F1
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhDIOXF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Apr 2021 10:23:05 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47805 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIOXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:23:04 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id D1920CECC3;
        Fri,  9 Apr 2021 16:30:32 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2] Bluetooth: hci_h5: btrtl: Add quirk for keep power in
 suspend/resume
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210316100657.16499-1-hildawu@realtek.com>
Date:   Fri, 9 Apr 2021 16:22:48 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, tientzu@chromium.org,
        max.chou@realtek.com, alex_lu@realsil.com.cn, kidman@realtek.com
Content-Transfer-Encoding: 8BIT
Message-Id: <BBA01EB8-970A-410B-93DA-0342F47A6186@holtmann.org>
References: <20210316100657.16499-1-hildawu@realtek.com>
To:     Hilda Wu <hildawu@realtek.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hilda,

> RTL8822C devices support BT wakeup Host. Add a quirk for these specific
> devices did not power off during suspend and resume.
> By this change, if the Host support that received BT device signal then
> it can be wakeup.
> 
> Signed-off-by: hildawu <hildawu@realtek.com>
> ---
> Changes in v2:
> - Add missing struct member
> - Modify title for fit length
> ---
> ---
> drivers/bluetooth/btrtl.c   | 36 ------------------------------------
> drivers/bluetooth/btrtl.h   | 36 ++++++++++++++++++++++++++++++++++++
> drivers/bluetooth/hci_h5.c  | 35 ++++++++++++++++++++++++-----------
> include/net/bluetooth/hci.h |  9 +++++++++
> 4 files changed, 69 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
> index e7fe5fb22753..94d1e7885aee 100644
> --- a/drivers/bluetooth/btrtl.c
> +++ b/drivers/bluetooth/btrtl.c
> @@ -38,42 +38,6 @@
> 	.hci_ver = (hciv), \
> 	.hci_bus = (bus)
> 
> -enum btrtl_chip_id {
> -	CHIP_ID_8723A,
> -	CHIP_ID_8723B,
> -	CHIP_ID_8821A,
> -	CHIP_ID_8761A,
> -	CHIP_ID_8822B = 8,
> -	CHIP_ID_8723D,
> -	CHIP_ID_8821C,
> -	CHIP_ID_8822C = 13,
> -	CHIP_ID_8761B,
> -	CHIP_ID_8852A = 18,
> -};
> -
> -struct id_table {
> -	__u16 match_flags;
> -	__u16 lmp_subver;
> -	__u16 hci_rev;
> -	__u8 hci_ver;
> -	__u8 hci_bus;
> -	bool config_needed;
> -	bool has_rom_version;
> -	char *fw_name;
> -	char *cfg_name;
> -};
> -
> -struct btrtl_device_info {
> -	const struct id_table *ic_info;
> -	u8 rom_version;
> -	u8 *fw_data;
> -	int fw_len;
> -	u8 *cfg_data;
> -	int cfg_len;
> -	bool drop_fw;
> -	int project_id;
> -};
> -
> static const struct id_table ic_id_table[] = {
> 	/* 8723A */
> 	{ IC_INFO(RTL_ROM_LMP_8723A, 0xb, 0x6, HCI_USB),
> diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
> index 2a582682136d..713768b38e21 100644
> --- a/drivers/bluetooth/btrtl.h
> +++ b/drivers/bluetooth/btrtl.h
> @@ -12,6 +12,42 @@
> #define rtl_dev_info(dev, fmt, ...) bt_dev_info(dev, "RTL: " fmt, ##__VA_ARGS__)
> #define rtl_dev_dbg(dev, fmt, ...) bt_dev_dbg(dev, "RTL: " fmt, ##__VA_ARGS__)
> 
> +enum btrtl_chip_id {
> +	CHIP_ID_8723A,
> +	CHIP_ID_8723B,
> +	CHIP_ID_8821A,
> +	CHIP_ID_8761A,
> +	CHIP_ID_8822B = 8,
> +	CHIP_ID_8723D,
> +	CHIP_ID_8821C,
> +	CHIP_ID_8822C = 13,
> +	CHIP_ID_8761B,
> +	CHIP_ID_8852A = 18,
> +};
> +
> +struct id_table {
> +	__u16 match_flags;
> +	__u16 lmp_subver;
> +	__u16 hci_rev;
> +	__u8 hci_ver;
> +	__u8 hci_bus;
> +	bool config_needed;
> +	bool has_rom_version;
> +	char *fw_name;
> +	char *cfg_name;
> +};
> +
> +struct btrtl_device_info {
> +	const struct id_table *ic_info;
> +	u8 rom_version;
> +	u8 *fw_data;
> +	int fw_len;
> +	u8 *cfg_data;
> +	int cfg_len;
> +	bool drop_fw;
> +	int project_id;
> +};
> +
> struct btrtl_device_info;

I rather not move around these things.

> struct rtl_download_cmd {
> diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
> index 27e96681d583..1ca4ff89ea14 100644
> --- a/drivers/bluetooth/hci_h5.c
> +++ b/drivers/bluetooth/hci_h5.c
> @@ -909,7 +909,15 @@ static int h5_btrtl_setup(struct h5 *h5)
> 	/* Enable controller to do both LE scan and BR/EDR inquiry
> 	 * simultaneously.
> 	 */
> -	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &h5->hu->hdev->quirks);
> +	switch (btrtl_dev->project_id) {
> +	case CHIP_ID_8822C:
> +	case CHIP_ID_8852A:
> +		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &h5->hu->hdev->quirks);
> +		set_bit(HCI_QUIRK_DEVICES_WAKEUP_SUPPORTED, &h5->hu->hdev->quirks);
> +		break;
> +	default:
> +		break;
> +	}
> 
> out_free:
> 	btrtl_free(btrtl_dev);
> @@ -945,8 +953,11 @@ static void h5_btrtl_close(struct h5 *h5)
> static int h5_btrtl_suspend(struct h5 *h5)
> {
> 	serdev_device_set_flow_control(h5->hu->serdev, false);
> -	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
> -	gpiod_set_value_cansleep(h5->enable_gpio, 0);
> +
> +	if (!test_bit(HCI_QUIRK_DEVICES_WAKEUP_SUPPORTED, &h5->hu->hdev->quirks)) {
> +		gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
> +		gpiod_set_value_cansleep(h5->enable_gpio, 0);
> +	}
> 	return 0;
> }
> 
> @@ -972,17 +983,19 @@ static void h5_btrtl_reprobe_worker(struct work_struct *work)
> 
> static int h5_btrtl_resume(struct h5 *h5)
> {
> -	struct h5_btrtl_reprobe *reprobe;
> +	if (!test_bit(HCI_QUIRK_DEVICES_WAKEUP_SUPPORTED, &h5->hu->hdev->quirks)) {
> +		struct h5_btrtl_reprobe *reprobe;
> 
> -	reprobe = kzalloc(sizeof(*reprobe), GFP_KERNEL);
> -	if (!reprobe)
> -		return -ENOMEM;
> +		reprobe = kzalloc(sizeof(*reprobe), GFP_KERNEL);
> +		if (!reprobe)
> +			return -ENOMEM;
> 
> -	__module_get(THIS_MODULE);
> +		__module_get(THIS_MODULE);
> 
> -	INIT_WORK(&reprobe->work, h5_btrtl_reprobe_worker);
> -	reprobe->dev = get_device(&h5->hu->serdev->dev);
> -	queue_work(system_long_wq, &reprobe->work);
> +		INIT_WORK(&reprobe->work, h5_btrtl_reprobe_worker);
> +		reprobe->dev = get_device(&h5->hu->serdev->dev);
> +		queue_work(system_long_wq, &reprobe->work);
> +	}
> 	return 0;
> }
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index ea4ae551c426..1e4c2a97ab8d 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -246,6 +246,15 @@ enum {
> 	 * HCI after resume.
> 	 */
> 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
> +
> +	/* When this quirk is set, the controller does not power off
> +	 * during suspend and resume. This mechanism lets BT devices wake
> +	 * the Host up if the Host and chips support.
> +	 *
> +	 * This quirk can be set before hci_register_dev is called or
> +	 * during the hdev->setup vendor callback.
> +	 */
> +	HCI_QUIRK_DEVICES_WAKEUP_SUPPORTED,
> };

Since this hci_uart specific, please don’t introduce another quirk and keep this internal.

Regards

Marcel

