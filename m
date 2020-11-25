Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB52C4238
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgKYOfb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Nov 2020 09:35:31 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45977 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgKYOfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 09:35:30 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id A1926CED08;
        Wed, 25 Nov 2020 15:42:40 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v5 5/5] Bluetooth: Change MGMT security info CMD to be
 more generic
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201124100610.v5.5.I5068c01cae3cea674a96e103a0cf4d8c81425a4f@changeid>
Date:   Wed, 25 Nov 2020 15:35:27 +0100
Cc:     ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8D21C628-B5B8-460B-867D-1D84C0101DD5@holtmann.org>
References: <20201124180746.1773091-1-danielwinkler@google.com>
 <20201124100610.v5.5.I5068c01cae3cea674a96e103a0cf4d8c81425a4f@changeid>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> For advertising, we wish to know the LE tx power capabilities of the
> controller in userspace, so this patch edits the Security Info MGMT
> command to be more generic, such that other various controller
> capabilities can be included in the EIR data. This change also includes
> the LE min and max tx power into this newly-named command.
> 
> The change was tested by manually verifying that the MGMT command
> returns the tx power range as expected in userspace.
> 
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> ---
> 
> Changes in v5: None
> Changes in v4:
> - Combine LE tx range into a single EIR field for MGMT capabilities cmd
> 
> Changes in v3:
> - Re-using security info MGMT command to carry controller capabilities
> 
> Changes in v2:
> - Fixed sparse error in Capabilities MGMT command
> 
> include/net/bluetooth/mgmt.h | 15 +++++++++-----
> net/bluetooth/mgmt.c         | 39 +++++++++++++++++++++++-------------
> 2 files changed, 35 insertions(+), 19 deletions(-)
> 
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index 2e18e4173e2fa5..f9a6638e20b3c6 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -686,11 +686,16 @@ struct mgmt_cp_set_blocked_keys {
> 
> #define MGMT_OP_SET_WIDEBAND_SPEECH	0x0047
> 
> -#define MGMT_OP_READ_SECURITY_INFO	0x0048
> -#define MGMT_READ_SECURITY_INFO_SIZE	0
> -struct mgmt_rp_read_security_info {
> -	__le16   sec_len;
> -	__u8     sec[];
> +#define MGMT_CAP_SEC_FLAGS		0x01
> +#define MGMT_CAP_MAX_ENC_KEY_SIZE	0x02
> +#define MGMT_CAP_SMP_MAX_ENC_KEY_SIZE	0x03
> +#define MGMT_CAP_LE_TX_PWR		0x04
> +
> +#define MGMT_OP_READ_CONTROLLER_CAP	0x0048
> +#define MGMT_READ_CONTROLLER_CAP_SIZE	0
> +struct mgmt_rp_read_controller_cap {
> +	__le16   cap_len;
> +	__u8     cap[0];
> } __packed;
> 
> #define MGMT_OP_READ_EXP_FEATURES_INFO	0x0049
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 668a62c8181eb1..d8adf78a437e0b 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -110,7 +110,7 @@ static const u16 mgmt_commands[] = {
> 	MGMT_OP_SET_APPEARANCE,
> 	MGMT_OP_SET_BLOCKED_KEYS,
> 	MGMT_OP_SET_WIDEBAND_SPEECH,
> -	MGMT_OP_READ_SECURITY_INFO,
> +	MGMT_OP_READ_CONTROLLER_CAP,
> 	MGMT_OP_READ_EXP_FEATURES_INFO,
> 	MGMT_OP_SET_EXP_FEATURE,
> 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
> @@ -176,7 +176,7 @@ static const u16 mgmt_untrusted_commands[] = {
> 	MGMT_OP_READ_CONFIG_INFO,
> 	MGMT_OP_READ_EXT_INDEX_LIST,
> 	MGMT_OP_READ_EXT_INFO,
> -	MGMT_OP_READ_SECURITY_INFO,
> +	MGMT_OP_READ_CONTROLLER_CAP,
> 	MGMT_OP_READ_EXP_FEATURES_INFO,
> 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
> 	MGMT_OP_READ_DEF_RUNTIME_CONFIG,
> @@ -3710,13 +3710,14 @@ static int set_wideband_speech(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> -static int read_security_info(struct sock *sk, struct hci_dev *hdev,
> -			      void *data, u16 data_len)
> +static int read_controller_cap(struct sock *sk, struct hci_dev *hdev,
> +			       void *data, u16 data_len)
> {
> -	char buf[16];
> -	struct mgmt_rp_read_security_info *rp = (void *)buf;
> -	u16 sec_len = 0;
> +	char buf[20];
> +	struct mgmt_rp_read_controller_cap *rp = (void *)buf;
> +	u16 cap_len = 0;
> 	u8 flags = 0;
> +	u8 tx_power_range[2];
> 
> 	bt_dev_dbg(hdev, "sock %p", sk);
> 
> @@ -3740,23 +3741,33 @@ static int read_security_info(struct sock *sk, struct hci_dev *hdev,
> 
> 	flags |= 0x08;		/* Encryption key size enforcement (LE) */
> 
> -	sec_len = eir_append_data(rp->sec, sec_len, 0x01, &flags, 1);
> +	cap_len = eir_append_data(rp->cap, cap_len, MGMT_CAP_SEC_FLAGS,
> +				  &flags, 1);
> 
> 	/* When the Read Simple Pairing Options command is supported, then
> 	 * also max encryption key size information is provided.
> 	 */
> 	if (hdev->commands[41] & 0x08)
> -		sec_len = eir_append_le16(rp->sec, sec_len, 0x02,
> +		cap_len = eir_append_le16(rp->cap, cap_len,
> +					  MGMT_CAP_MAX_ENC_KEY_SIZE,
> 					  hdev->max_enc_key_size);
> 
> -	sec_len = eir_append_le16(rp->sec, sec_len, 0x03, SMP_MAX_ENC_KEY_SIZE);
> +	cap_len = eir_append_le16(rp->cap, cap_len,
> +				  MGMT_CAP_SMP_MAX_ENC_KEY_SIZE,
> +				  SMP_MAX_ENC_KEY_SIZE);
> +
> +	/* Append the min/max LE tx power parameters */
> +	memcpy(&tx_power_range[0], &hdev->min_le_tx_power, 1);
> +	memcpy(&tx_power_range[1], &hdev->max_le_tx_power, 1);
> +	cap_len = eir_append_data(rp->cap, cap_len, MGMT_CAP_LE_TX_PWR,
> +				  tx_power_range, 2);

this is not enough. You need to also factor in if the command is supported or not. If the command is not supported we are not providing this field.

Regards

Marcel

