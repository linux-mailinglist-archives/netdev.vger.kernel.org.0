Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5453083D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 06:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243160AbiEWEQR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 May 2022 00:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiEWEQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 00:16:15 -0400
Received: from mailproxy09.manitu.net (mailproxy09.manitu.net [217.11.48.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2373627D;
        Sun, 22 May 2022 21:16:08 -0700 (PDT)
Received: from [192.168.3.184] (cable-78-34-17-55.nc.de [78.34.17.55])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: linux@ulli-kroll.de)
        by mailproxy09.manitu.net (Postfix) with ESMTPSA id 4B61212000F4;
        Mon, 23 May 2022 06:07:22 +0200 (CEST)
Message-ID: <9766817fae774b24372edb09666c0bab6ebf40b4.camel@ulli-kroll.de>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
From:   Hans Ulli Kroll <linux@ulli-kroll.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        neo_jou <neo_jou@realtek.com>
Date:   Mon, 23 May 2022 06:07:22 +0200
In-Reply-To: <20220518082318.3898514-7-s.hauer@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-7-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> Add the common bits and pieces to add USB support to the RTW88 driver.
> This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> itself is first written by Neo Jou.
> 

Neo Jou borrowed the usb logic from rtlwifi.
This was (maybe) also in the early stages of the vendor driver.

Newer ones doesn't use async write for register access.

In short it looks like this.
The extra "time consume" is added between v5.2.4 and v5.3.1

static int __rtw_usb_vendor_request(struct usb_device *udev, unsigned int pipe,
				    u8 request, u8 requesttype, u16 val, u16 index,
				    void *buf, size_t len)
{
	int i, ret;

	for (i = 0; i < MAX_USBCTRL_VENDORREQ_TIMES; i++) {
		ret = usb_control_msg(udev, pipe, request, requesttype, val,
				      index, buf, len, RTW_USBCTRL_MSG_TIMEOUT);

		if (ret <= 0)
			return ret;
	}

	if (val <= 0xff ||
	    (val >= 0x1000 && val <= 0x10ff)) {
		/* add a write to consume time on device */

		unsigned int t_pipe = usb_sndctrlpipe(udev, 0);/* write_out */
		u8 t_reqtype =  RTW_USB_CMD_WRITE;
		u8 t_len = 1;
		u8 t_req = RTW_USB_CMD_REQ;
		u16 t_reg = 0x4e0;	/* unknown reg on device */
		u16 t_index = 0;

		ret = usb_control_msg(udev, t_pipe, t_req, t_reqtype,
				      t_reg, t_index, buf, t_len,
				      RTW_USBCTRL_MSG_TIMEOUT);

		if (ret != 1)
			return ret;
	}


	return ret;
}

static int rtw_vendor_request(struct rtw_usb *rtwusb, unsigned int pipe,
			      u8 request, u8 requesttype, u16 val, u16 index,
			      void *buf, size_t len)
{
	struct usb_device *udev = rtwusb->udev;
	int ret;

	mutex_lock(&rtwusb->usb_ctrl_mtx);
	ret = __rtw_usb_vendor_request(udev, pipe, request, requesttype,
				       val, index, buf, len);
	mutex_unlock(&rtwusb->usb_ctrl_mtx);

	return ret;
}


Hans Ulli
