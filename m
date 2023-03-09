Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A636B2BB6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjCIRL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCIRLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:11:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756CAE682F;
        Thu,  9 Mar 2023 09:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B55661C3F;
        Thu,  9 Mar 2023 17:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F1FC433D2;
        Thu,  9 Mar 2023 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678381732;
        bh=DV4YQU9owXP1eZTkwulqsfiIavu+NJM/FI+luiNEu0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tNiQjSVGIvrj908Bmd+xu/W2c7HtmpC7kp2rEDoeHUxTuyPoi59RNE1kI3t+eYY8V
         WDEMWDjoozCoeygv03nEKX/sn6Ja7eZYhWVlxQYO8dfJwopY4sHQsoekUvTUn1V3lP
         +nrmzw8356LN9oUB6f7IKmz0EFy+eRmA7MQKUGmYrFJOomtf4TaPFRHQcH/f2NUmP8
         MafEsL8P4u4w4ERVjgb3+S435CNroJmziEiBMoOUZCt7iDdHPgJ+IA4vKf63lI3uTz
         gPcszm0AZYzesiHY6pF5JjcxrQT+oIQcZbo+jo/X+nAE4F1h691jVqlTWx7WazDdYo
         xMU8eBb4rcXSg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paJlt-0002YF-QI; Thu, 09 Mar 2023 18:09:41 +0100
Date:   Thu, 9 Mar 2023 18:09:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-3-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209020916.6475-3-steev@kali.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:09:14PM -0600, Steev Klimaszewski wrote:
> Added regulators,GPIOs and changes required to power on/off wcn6855.
> Added support for firmware download for wcn6855.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
> Changes since v4:
>  * Remove unused firmware check because we don't have mbn firmware.
>  * Set qcadev->init_speed if it hasn't been set.
> 
> Changes since v3:
>  * drop unused regulators
> 
> Changes since v2:
>  * drop unnecessary commit info
> 
> Changes since v1:
>  * None
> 
>  drivers/bluetooth/btqca.c   |  9 ++++++-
>  drivers/bluetooth/btqca.h   | 10 ++++++++
>  drivers/bluetooth/hci_qca.c | 50 ++++++++++++++++++++++++++++---------
>  3 files changed, 56 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index c9064d34d830..2f9d8bd27c38 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
> @@ -614,6 +614,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  		config.type = ELF_TYPE_PATCH;
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/msbtfw%02x.mbn", rom_ver);
> +	} else if (soc_type == QCA_WCN6855) {
> +		snprintf(config.fwname, sizeof(config.fwname),
> +			 "qca/hpbtfw%02x.tlv", rom_ver);
>  	} else {
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/rampatch_%08x.bin", soc_ver);
> @@ -648,6 +651,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  	else if (soc_type == QCA_WCN6750)
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/msnv%02x.bin", rom_ver);
> +	else if (soc_type == QCA_WCN6855)
> +		snprintf(config.fwname, sizeof(config.fwname),
> +			 "qca/hpnv%02x.bin", rom_ver);
>  	else
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/nvm_%08x.bin", soc_ver);
> @@ -672,6 +678,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  	case QCA_WCN3991:
>  	case QCA_WCN3998:
>  	case QCA_WCN6750:
> +	case QCA_WCN6855:

Did you actually verify the microsoft extensions need this, or you are
assuming it works as 6750?

>  		hci_set_msft_opcode(hdev, 0xFD70);
>  		break;
>  	default:
> @@ -685,7 +692,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  		return err;
>  	}
>  
> -	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
> +	if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {

Line is now over 80 columns which is still the preferred limit.

Perhaps this should now be a switch statement instead?

>  		/* get fw build info */
>  		err = qca_read_fw_build_info(hdev);
>  		if (err < 0)
> diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
> index 61e9a50e66ae..b884095bcd9d 100644
> --- a/drivers/bluetooth/btqca.h
> +++ b/drivers/bluetooth/btqca.h
> @@ -147,6 +147,7 @@ enum qca_btsoc_type {
>  	QCA_WCN3991,
>  	QCA_QCA6390,
>  	QCA_WCN6750,
> +	QCA_WCN6855,
>  };
>  
>  #if IS_ENABLED(CONFIG_BT_QCA)
> @@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
>  {
>  	return soc_type == QCA_WCN6750;
>  }
> +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
> +{
> +	return soc_type == QCA_WCN6855;
> +}
>  
>  #else
>  
> @@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
>  	return false;
>  }
>  
> +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
> +{
> +	return false;
> +}
> +
>  static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> index 3df8c3606e93..efc1c0306b4e 100644
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -605,8 +605,7 @@ static int qca_open(struct hci_uart *hu)
>  	if (hu->serdev) {
>  		qcadev = serdev_device_get_drvdata(hu->serdev);
>  
> -		if (qca_is_wcn399x(qcadev->btsoc_type) ||
> -		    qca_is_wcn6750(qcadev->btsoc_type))
> +		if (!(qcadev->init_speed))
>  			hu->init_speed = qcadev->init_speed;

This change makes no sense. 

In fact, it seems the driver never sets init_speed anywhere.

Either way, it should not be needed for wcn6855.

>  
>  		if (qcadev->oper_speed)
> @@ -1317,7 +1316,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
>  
>  	/* Give the controller time to process the request */
>  	if (qca_is_wcn399x(qca_soc_type(hu)) ||
> -	    qca_is_wcn6750(qca_soc_type(hu)))
> +	    qca_is_wcn6750(qca_soc_type(hu)) ||
> +	    qca_is_wcn6855(qca_soc_type(hu)))
>  		usleep_range(1000, 10000);
>  	else
>  		msleep(300);
> @@ -1394,7 +1394,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
>  static int qca_check_speeds(struct hci_uart *hu)
>  {
>  	if (qca_is_wcn399x(qca_soc_type(hu)) ||
> -	    qca_is_wcn6750(qca_soc_type(hu))) {
> +	    qca_is_wcn6750(qca_soc_type(hu)) ||
> +	    qca_is_wcn6855(qca_soc_type(hu))) {
>  		if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
>  		    !qca_get_speed(hu, QCA_OPER_SPEED))
>  			return -EINVAL;
> @@ -1682,7 +1683,8 @@ static int qca_power_on(struct hci_dev *hdev)
>  		return 0;
>  
>  	if (qca_is_wcn399x(soc_type) ||
> -	    qca_is_wcn6750(soc_type)) {
> +	    qca_is_wcn6750(soc_type) ||
> +	    qca_is_wcn6855(soc_type)) {
>  		ret = qca_regulator_init(hu);
>  	} else {
>  		qcadev = serdev_device_get_drvdata(hu->serdev);
> @@ -1723,7 +1725,8 @@ static int qca_setup(struct hci_uart *hu)
>  
>  	bt_dev_info(hdev, "setting up %s",
>  		qca_is_wcn399x(soc_type) ? "wcn399x" :
> -		(soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
> +		(soc_type == QCA_WCN6750) ? "wcn6750" :
> +		(soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");

This is hideous, but not your fault...

>  
>  	qca->memdump_state = QCA_MEMDUMP_IDLE;
>  
> @@ -1735,7 +1738,8 @@ static int qca_setup(struct hci_uart *hu)
>  	clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
>  
>  	if (qca_is_wcn399x(soc_type) ||
> -	    qca_is_wcn6750(soc_type)) {
> +	    qca_is_wcn6750(soc_type) ||
> +	    qca_is_wcn6855(soc_type)) {
>  		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
>  		hci_set_aosp_capable(hdev);
>  
> @@ -1757,7 +1761,8 @@ static int qca_setup(struct hci_uart *hu)
>  	}
>  
>  	if (!(qca_is_wcn399x(soc_type) ||
> -	     qca_is_wcn6750(soc_type))) {
> +	     qca_is_wcn6750(soc_type) ||
> +	     qca_is_wcn6855(soc_type))) {

Perhaps you can add a leading space while changing this so that the
open-parenthesis alignment makes sense.

>  		/* Get QCA version information */
>  		ret = qca_read_soc_version(hdev, &ver, soc_type);
>  		if (ret)
> @@ -1883,6 +1888,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
>  	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
>  };
>  
> +static const struct qca_device_data qca_soc_data_wcn6855 = {
> +	.soc_type = QCA_WCN6855,
> +	.vregs = (struct qca_vreg []) {
> +		{ "vddio", 5000 },
> +		{ "vddbtcxmx", 126000 },
> +		{ "vddrfacmn", 12500 },
> +		{ "vddrfa0p8", 102000 },
> +		{ "vddrfa1p7", 302000 },
> +		{ "vddrfa1p2", 257000 },

Hmm. More random regulator load values. I really think we should get rid
of this but that's a separate discussion.

> +	},
> +	.num_vregs = 6,
> +	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
> +};
> +
>  static void qca_power_shutdown(struct hci_uart *hu)
>  {
>  	struct qca_serdev *qcadev;

As I mentioned elsewhere, you need to update also this function so that
wcn6855 can be powered down.

> @@ -2047,7 +2066,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
>  
>  	if (data &&
>  	    (qca_is_wcn399x(data->soc_type) ||
> -	    qca_is_wcn6750(data->soc_type))) {
> +	    qca_is_wcn6750(data->soc_type) ||
> +	    qca_is_wcn6855(data->soc_type))) {

Perhaps you fix the alignment here too.

>  		qcadev->btsoc_type = data->soc_type;
>  		qcadev->bt_power = devm_kzalloc(&serdev->dev,
>  						sizeof(struct qca_power),
> @@ -2067,14 +2087,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
>  
>  		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
>  					       GPIOD_OUT_LOW);
> -		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
> +		if (IS_ERR_OR_NULL(qcadev->bt_en)
> +		    && (data->soc_type == QCA_WCN6750 ||

&& operator should go on the previous line before the line break.

> +			data->soc_type == QCA_WCN6855)) {
>  			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
>  			power_ctrl_enabled = false;
>  		}
>  
>  		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
>  					       GPIOD_IN);
> -		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
> +		if (IS_ERR_OR_NULL(qcadev->sw_ctrl)
> +		    && (data->soc_type == QCA_WCN6750 ||

Same here.

> +			data->soc_type == QCA_WCN6855))
>  			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
>  
>  		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
> @@ -2150,7 +2174,8 @@ static void qca_serdev_remove(struct serdev_device *serdev)
>  	struct qca_power *power = qcadev->bt_power;
>  
>  	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
> -	     qca_is_wcn6750(qcadev->btsoc_type)) &&
> +	     qca_is_wcn6750(qcadev->btsoc_type) ||
> +	     qca_is_wcn6855(qcadev->btsoc_type)) &&
>  	     power->vregs_on)
>  		qca_power_shutdown(&qcadev->serdev_hu);
>  	else if (qcadev->susclk)
> @@ -2335,6 +2360,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
>  	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
>  	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
>  	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
> +	{ .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);

With power-off handling fixed, this seems to work as quite well on my
X13s with 6.3-rc1. Nice job!

Btw, apart from the frame reassembly error, I'm also seeing:

	Bluetooth: Received HCI_IBS_WAKE_ACK in tx state 0

during probe.

Johan
