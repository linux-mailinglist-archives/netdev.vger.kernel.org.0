Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E036BD31
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfGQNgy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 09:36:54 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41254 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfGQNgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 09:36:53 -0400
Received: from [192.168.21.149] (unknown [157.25.100.178])
        by mail.holtmann.org (Postfix) with ESMTPSA id A216DCECC9;
        Wed, 17 Jul 2019 15:45:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 1/3] Bluetooth: btintel: Add firmware lock function
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190717074920.21624-1-kai.heng.feng@canonical.com>
Date:   Wed, 17 Jul 2019 15:36:50 +0200
Cc:     Johannes Berg <johannes.berg@intel.com>,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        Johan Hedberg <johan.hedberg@gmail.com>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7CE1949F-76D2-4D27-82B6-02124E62DF5C@holtmann.org>
References: <20190717074920.21624-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,

> When Intel 8260 starts to load Bluetooth firmware and WiFi firmware, by
> calling btintel_download_firmware() and iwl_pcie_load_given_ucode_8000()
> respectively, the Bluetooth btintel_download_firmware() aborts half way:
> [   11.950216] Bluetooth: hci0: Failed to send firmware data (-38)
> 
> Let btusb and iwlwifi load firmwares exclusively can avoid the issue, so
> introduce a lock to use in btusb and iwlwifi.
> 
> This issue still occurs with latest WiFi and Bluetooth firmwares.
> 
> BugLink: https://bugs.launchpad.net/bugs/1832988
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
> - Add bug report link.
> - Rebase on latest wireless-next.
> 
> drivers/bluetooth/btintel.c   | 14 ++++++++++++++
> drivers/bluetooth/btintel.h   | 10 ++++++++++
> include/linux/intel-wifi-bt.h |  8 ++++++++
> 3 files changed, 32 insertions(+)
> create mode 100644 include/linux/intel-wifi-bt.h
> 
> diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
> index bb99c8653aab..93ab18d6ddad 100644
> --- a/drivers/bluetooth/btintel.c
> +++ b/drivers/bluetooth/btintel.c
> @@ -20,6 +20,8 @@
> 
> #define BDADDR_INTEL (&(bdaddr_t) {{0x00, 0x8b, 0x9e, 0x19, 0x03, 0x00}})
> 
> +static DEFINE_MUTEX(firmware_lock);
> +
> int btintel_check_bdaddr(struct hci_dev *hdev)
> {
> 	struct hci_rp_read_bd_addr *bda;
> @@ -709,6 +711,18 @@ int btintel_download_firmware(struct hci_dev *hdev, const struct firmware *fw,
> }
> EXPORT_SYMBOL_GPL(btintel_download_firmware);
> 
> +void btintel_firmware_lock(void)
> +{
> +	mutex_lock(&firmware_lock);
> +}
> +EXPORT_SYMBOL_GPL(btintel_firmware_lock);
> +
> +void btintel_firmware_unlock(void)
> +{
> +	mutex_unlock(&firmware_lock);
> +}
> +EXPORT_SYMBOL_GPL(btintel_firmware_unlock);
> +

so I am not in favor of this solution. The hardware guys should start looking into fixing the firmware loading and provide proper firmware that can be loaded at the same time.

I am also not for sure penalizing all Intel Bluetooth/WiFi combos only because one of them has a bug during simultaneous loading of WiFi and Bluetooth firmware.

Frankly it would be better to detect a failed load and try a second time instead of trying to lock each other out. The cross-contamination of WiFi and Bluetooth drivers is just not clean.

Regards

Marcel

