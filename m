Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F01E7F0
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 07:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfEOFcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 01:32:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOFcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 01:32:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5330D60A05; Wed, 15 May 2019 05:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557898329;
        bh=06S3eHHeGJowU5mz+CsunnA1wJOM7wbntuYhHzpkXks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zw96L+lLZ1G31THW/ShB1TSvyAIJoROiiAbhhviMAC3IGxiIJsIT0eyEdqX9Cy5Zc
         gRHRv5S6wc/du5kUMVHL1R1V3CSEU+vKLIH85++rPYm8Z/TOK6HbhhwDbBmCFGaqL+
         RLbiTN9Egbe6m5UZsqPMWdowa2aB6+KHDEjbSGO8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2B51360A05;
        Wed, 15 May 2019 05:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557898328;
        bh=06S3eHHeGJowU5mz+CsunnA1wJOM7wbntuYhHzpkXks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LL7hewrv9e+U16IYkAy0TKhKq+nS9AV9Om3mEzb0u5wMUFd8HXvO0MynsCh96F/bm
         t5uq+p1mR4W91ItUg5Bu99PevIJnCnMPHRLRAgq/N7NB5HgMOMVR5+LOqObp7Qe0+C
         Y19mC/LEuH/aY/+VHvj12Y5tZZ2JyKW6EP2CmTuc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 May 2019 11:02:08 +0530
From:   Balakrishna Godavarthi <bgodavar@codeaurora.org>
To:     Rocky Liao <rjliao@codeaurora.org>
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, thierry.escande@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, hemtang@codeaurora.org
Subject: Re: [PATCH v4 1/2] Bluetooth: hci_qca: Load customized NVM based on
 the device property
In-Reply-To: <1557631148-5120-1-git-send-email-rjliao@codeaurora.org>
References: <1554888451-17518-1-git-send-email-rjliao@codeaurora.org>
 <1557631148-5120-1-git-send-email-rjliao@codeaurora.org>
Message-ID: <50debf59532279fa0d0bf7156b48831a@codeaurora.org>
X-Sender: bgodavar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rocky,

On 2019-05-12 08:49, Rocky Liao wrote:
> QCA BTSOC NVM is a customized firmware file and different vendors may
> want to have different BTSOC configuration (e.g. Configure SCO over PCM
> or I2S, Setting Tx power, etc.) via this file. This patch will allow
> vendors to download different NVM firmware file by reading a device
> property "firmware-name".
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> Changes in v4:
>   * rebased the code base and merge with latest code
> ---
>  drivers/bluetooth/btqca.c   | 14 ++++++++++----
>  drivers/bluetooth/btqca.h   |  6 ++++--
>  drivers/bluetooth/hci_qca.c | 19 ++++++++++++++++++-
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index cc12eec..0ea690a 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
> @@ -332,7 +332,8 @@ int qca_set_bdaddr_rome(struct hci_dev *hdev,
> const bdaddr_t *bdaddr)
>  EXPORT_SYMBOL_GPL(qca_set_bdaddr_rome);
> 
>  int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
> -		   enum qca_btsoc_type soc_type, u32 soc_ver)
> +		   enum qca_btsoc_type soc_type, u32 soc_ver,
> +		   const char *firmware_name)
>  {
>  	struct rome_config config;
>  	int err;
> @@ -368,9 +369,14 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t 
> baudrate,
>  	if (qca_is_wcn399x(soc_type))
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/crnv%02x.bin", rom_ver);
> -	else
> -		snprintf(config.fwname, sizeof(config.fwname),
> -			 "qca/nvm_%08x.bin", soc_ver);
> +	else {
> +		if (firmware_name)
> +			snprintf(config.fwname, sizeof(config.fwname),
> +				 "qca/%s", firmware_name);
> +		else
> +			snprintf(config.fwname, sizeof(config.fwname),
> +				 "qca/nvm_%08x.bin", soc_ver);
> +	}
> 
[Bala]: Can you make this change  applicable to the wcn399x series chip 
sets too.

        something like this

        if (qca_is_wcn399x(soc_type) && !firmware_name)
          snprintf(config.fwname, sizeof(config.fwname),
               "qca/crnv%02x.bin", rom_ver);
       elseif (firmware_name)
          snprintf(config.fwname, sizeof(config.fwname),
             "qca/%s", firmware_name);
       else
         snprintf(config.fwname, sizeof(config.fwname),
               "qca/nvm_%08x.bin", soc_ver);


>  	err = qca_download_firmware(hdev, &config);
>  	if (err < 0) {
> diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
> index 4c4fe2b..8c037bb 100644
> --- a/drivers/bluetooth/btqca.h
> +++ b/drivers/bluetooth/btqca.h
> @@ -140,7 +140,8 @@ enum qca_btsoc_type {
> 
>  int qca_set_bdaddr_rome(struct hci_dev *hdev, const bdaddr_t *bdaddr);
>  int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
> -		   enum qca_btsoc_type soc_type, u32 soc_ver);
> +		   enum qca_btsoc_type soc_type, u32 soc_ver,
> +		   const char *firmware_name);
>  int qca_read_soc_version(struct hci_dev *hdev, u32 *soc_version);
>  int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr);
>  static inline bool qca_is_wcn399x(enum qca_btsoc_type soc_type)
> @@ -155,7 +156,8 @@ static inline int qca_set_bdaddr_rome(struct
> hci_dev *hdev, const bdaddr_t *bdad
>  }
> 
>  static inline int qca_uart_setup(struct hci_dev *hdev, uint8_t 
> baudrate,
> -				 enum qca_btsoc_type soc_type, u32 soc_ver)
> +				 enum qca_btsoc_type soc_type, u32 soc_ver,
> +				 const char *firmware_name)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> index 57322c4..9590602 100644
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -169,6 +169,7 @@ struct qca_serdev {
>  	struct qca_power *bt_power;
>  	u32 init_speed;
>  	u32 oper_speed;
> +	const char *firmware_name;
>  };
> 
>  static int qca_power_setup(struct hci_uart *hu, bool on);
> @@ -190,6 +191,17 @@ static enum qca_btsoc_type qca_soc_type(struct
> hci_uart *hu)
>  	return soc_type;
>  }
> 
> +static const char *qca_get_firmware_name(struct hci_uart *hu)
> +{
> +	if (hu->serdev) {
> +		struct qca_serdev *qsd = serdev_device_get_drvdata(hu->serdev);
> +
> +		return qsd->firmware_name;
> +	} else {
> +		return NULL;
> +	}
> +}
> +
>  static void __serial_clock_on(struct tty_struct *tty)
>  {
>  	/* TODO: Some chipset requires to enable UART clock on client
> @@ -1195,6 +1207,7 @@ static int qca_setup(struct hci_uart *hu)
>  	struct qca_data *qca = hu->priv;
>  	unsigned int speed, qca_baudrate = QCA_BAUDRATE_115200;
>  	enum qca_btsoc_type soc_type = qca_soc_type(hu);
> +	const char *firmware_name = qca_get_firmware_name(hu);
>  	int ret;
>  	int soc_ver = 0;
> 
> @@ -1245,7 +1258,8 @@ static int qca_setup(struct hci_uart *hu)
> 
>  	bt_dev_info(hdev, "QCA controller version 0x%08x", soc_ver);
>  	/* Setup patch / NVM configurations */
> -	ret = qca_uart_setup(hdev, qca_baudrate, soc_type, soc_ver);
> +	ret = qca_uart_setup(hdev, qca_baudrate, soc_type, soc_ver,
> +			firmware_name);
>  	if (!ret) {
>  		set_bit(QCA_IBS_ENABLED, &qca->flags);
>  		qca_debugfs_init(hdev);
> @@ -1477,6 +1491,9 @@ static int qca_serdev_probe(struct serdev_device 
> *serdev)
>  			return PTR_ERR(qcadev->bt_en);
>  		}
> 
> +		device_property_read_string(&serdev->dev, "firmware-name",
> +					 &qcadev->firmware_name);
> +
>  		qcadev->susclk = devm_clk_get(&serdev->dev, NULL);
>  		if (IS_ERR(qcadev->susclk)) {
>  			dev_err(&serdev->dev, "failed to acquire clk\n");

-- 
Regards
Balakrishna.
