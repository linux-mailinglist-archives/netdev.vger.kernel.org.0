Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9D669256C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjBJSgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjBJSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:36:52 -0500
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 10:36:48 PST
Received: from pi.fatal.se (94-255-170-6.cust.bredband2.com [94.255.170.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B928E93EA;
        Fri, 10 Feb 2023 10:36:48 -0800 (PST)
Received: by pi.fatal.se (Postfix, from userid 1000)
        id 7B4AF29095; Fri, 10 Feb 2023 19:19:46 +0100 (CET)
Date:   Fri, 10 Feb 2023 19:19:46 +0100
From:   Andreas Henriksson <andreas@fatal.se>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v2 0/3] wifi: rtw88: USB fixes
Message-ID: <20230210181946.cqnvxiomjv77xnf2@fatal.se>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111632.1985205-1-s.hauer@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sacha Hauer,

Thanks alot for fixing this!

On Fri, Feb 10, 2023 at 12:16:29PM +0100, Sascha Hauer wrote:
> This series addresses issues for the recently added RTW88 USB support
> reported by Andreas Henriksson and also our customer.
> 
> The hardware can't handle urbs that have a size of multiple of the
> bulkout_size (usually 512 bytes). The symptom is that the hardware
> stalls completely. The issue can be reproduced by sending a suitably
> sized ping packet from the device:
> 
> ping -s 394 <somehost>
> 
> (It's 394 bytes here on a RTL8822CU and RTL8821CU, the actual size may
> differ on other chips, it was 402 bytes on a RTL8723DU)

I can confirm that with these patches applied that my LM842 dongle
now works reliably on my imx6sx board. On the same board the traffic
would previously usually stall after 80-130MB when downloading.

With patches applied I succesfully completed:
wget -O /dev/null http://speedtest.tele2.net/10GB.zip

Uploading did not seem to trigger the problem before but I still
tested and uploading a gigabyte was no problem using:
curl -T /dev/urandom http://speedtest.tele2.net/upload.php  -O /dev/null

Did not attempt the suggested ping method of reproducing on the old
system, but on the new kernel I could do
$ for a in $(seq 128 512); do ping -n -c 3 -s $a ping.sunet.se ; done
without any stalls.


Feel free to add either or both of:

Reported-by: Andreas Henriksson <andreas@fatal.se>
Tested-by: Andreas Henriksson <andreas@fatal.se>

> 
> Other than that qsel was not set correctly. The sympton here is that
> only one of multiple bulk endpoints was used to send data.
> 
> Changes since v1:
> - Use URB_ZERO_PACKET to let the USB host controller handle it automatically
>   rather than working around the issue.
> 
> Sascha Hauer (3):
>   wifi: rtw88: usb: Set qsel correctly
>   wifi: rtw88: usb: send Zero length packets if necessary
>   wifi: rtw88: usb: drop now unnecessary URB size check
> 
>  drivers/net/wireless/realtek/rtw88/usb.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> -- 
> 2.30.2
> 

Regards,
Andreas Henriksson
