Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D08969E515
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjBUQsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbjBUQr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:47:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA4B1BFF;
        Tue, 21 Feb 2023 08:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E658B80FA8;
        Tue, 21 Feb 2023 16:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868B6C433D2;
        Tue, 21 Feb 2023 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676998075;
        bh=fZ7QbnFNb2SmsiwjDZpljpEV7ataQ6s54HSJhzUKGSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8ptiBQSITwFOmEIfsiabNBy03LzOsmq9Vo+g2cFjeNsrQVKexJi3Vq5qB/eKiYyf
         ICEiDA7w54IBPqGSGE9XCFAMsn1pGl/SRFQn0OhpV/Z5ZSpc97WYlDvI+7UvruIhQq
         seWx+7lTTl1hgBIZGDSa8bXw/sS+nWIw3GoCPcEk=
Date:   Tue, 21 Feb 2023 17:47:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <Y/T1uMqUeW67tgzX@kroah.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
 <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 09:55:41PM +0530, Neeraj Sanjay Kale wrote:
> +		bt_dev_info(hdev, "Set UART break: %s, status=%d",
> +			    ps_state == PS_STATE_AWAKE ? "off" : "on", status);

You have a lot of "noise" in this driver, remove all "info" messages, as
if a driver is working properly, it is quiet.

> +		break;
> +	}
> +	psdata->ps_state = ps_state;
> +	if (ps_state == PS_STATE_AWAKE)
> +		btnxpuart_tx_wakeup(nxpdev);
> +}
> +
> +static void ps_work_func(struct work_struct *work)
> +{
> +	struct ps_data *data = container_of(work, struct ps_data, work);
> +
> +	if (!data)
> +		return;

You did not test this, that check can never happen, please do not do
pointless checks.



> +
> +	if (data->ps_cmd == PS_CMD_ENTER_PS && data->cur_psmode == PS_MODE_ENABLE)
> +		ps_control(data->hdev, PS_STATE_SLEEP);
> +	else if (data->ps_cmd == PS_CMD_EXIT_PS)
> +		ps_control(data->hdev, PS_STATE_AWAKE);
> +}
> +
> +static void ps_timeout_func(struct timer_list *t)
> +{
> +	struct ps_data *data = from_timer(data, t, ps_timer);
> +	struct hci_dev *hdev = data->hdev;
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	data->timer_on = false;
> +	if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +		ps_start_timer(nxpdev);
> +	} else {
> +		data->ps_cmd = PS_CMD_ENTER_PS;
> +		schedule_work(&data->work);
> +	}
> +}
> +
> +static int ps_init_work(struct hci_dev *hdev)
> +{
> +	struct ps_data *psdata = kzalloc(sizeof(*psdata), GFP_KERNEL);

Don't do allocations in variable declarations :(

> +	} else if (req_len == sizeof(uart_config)) {
> +		uart_config.clkdiv.address = __cpu_to_le32(CLKDIVADDR);
> +		uart_config.clkdiv.value = __cpu_to_le32(0x00c00000);
> +		uart_config.uartdiv.address = __cpu_to_le32(UARTDIVADDR);
> +		uart_config.uartdiv.value = __cpu_to_le32(1);
> +		uart_config.mcr.address = __cpu_to_le32(UARTMCRADDR);
> +		uart_config.mcr.value = __cpu_to_le32(MCR);
> +		uart_config.re_init.address = __cpu_to_le32(UARTREINITADDR);
> +		uart_config.re_init.value = __cpu_to_le32(INIT);
> +		uart_config.icr.address = __cpu_to_le32(UARTICRADDR);
> +		uart_config.icr.value = __cpu_to_le32(ICR);
> +		uart_config.fcr.address = __cpu_to_le32(UARTFCRADDR);
> +		uart_config.fcr.value = __cpu_to_le32(FCR);
> +		uart_config.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +								(char *)&uart_config,
> +								sizeof(uart_config) - 4));
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_config, req_len);
> +		serdev_device_wait_until_sent(nxpdev->serdev, 0);

You are sending magic commands over the serial connection, are you sure
that is ok?

> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		 * Simply send the same bytes again.
> +		 */
> +		requested_len = nxpdev->fw_v1_sent_bytes;
> +		bt_dev_err(hdev, "CRC error. Resend %d bytes of FW.", requested_len);

Why is this an error sent to the kernel log?

Again, be quiet if there is nothing that a user can do.

thanks,

greg k-h
