Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13F1687F6F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjBBN7l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Feb 2023 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjBBN7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:59:40 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF791589A1;
        Thu,  2 Feb 2023 05:59:39 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pNa7g-003JGd-Ko; Thu, 02 Feb 2023 14:59:32 +0100
Received: from p57bd9464.dip0.t-ipconnect.de ([87.189.148.100] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pNa7g-003ogj-Db; Thu, 02 Feb 2023 14:59:32 +0100
Message-ID: <585c4b48790d71ca43b66fc24ea8d84917c4a0e1.camel@physik.fu-berlin.de>
Subject: Re: [PATCH net-next] r8169: use devm_clk_get_optional_enabled() to
 simplify the code
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     hkallweit1@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com, pabeni@redhat.com,
        linux-sh@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Date:   Thu, 02 Feb 2023 14:59:31 +0100
In-Reply-To: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.148.100
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Heiner!

> Now that we have devm_clk_get_optional_enabled(), we don't have to
> open-code it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 37 ++---------------------
>  1 file changed, 3 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a8b0070bb..e6fb6f223 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5122,37 +5122,6 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
>  	}
>  }
>  
> -static void rtl_disable_clk(void *data)
> -{
> -	clk_disable_unprepare(data);
> -}
> -
> -static int rtl_get_ether_clk(struct rtl8169_private *tp)
> -{
> -	struct device *d = tp_to_dev(tp);
> -	struct clk *clk;
> -	int rc;
> -
> -	clk = devm_clk_get(d, "ether_clk");
> -	if (IS_ERR(clk)) {
> -		rc = PTR_ERR(clk);
> -		if (rc == -ENOENT)
> -			/* clk-core allows NULL (for suspend / resume) */
> -			rc = 0;
> -		else
> -			dev_err_probe(d, rc, "failed to get clk\n");
> -	} else {
> -		tp->clk = clk;
> -		rc = clk_prepare_enable(clk);
> -		if (rc)
> -			dev_err(d, "failed to enable clk: %d\n", rc);
> -		else
> -			rc = devm_add_action_or_reset(d, rtl_disable_clk, clk);
> -	}
> -
> -	return rc;
> -}
> -
>  static void rtl_init_mac_address(struct rtl8169_private *tp)
>  {
>  	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
> @@ -5216,9 +5185,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		return -ENOMEM;
>  
>  	/* Get the *optional* external "ether_clk" used on some boards */
> -	rc = rtl_get_ether_clk(tp);
> -	if (rc)
> -		return rc;
> +	tp->clk = devm_clk_get_optional_enabled(&pdev->dev, "ether_clk");
> +	if (IS_ERR(tp->clk))
> +		return dev_err_probe(&pdev->dev, PTR_ERR(tp->clk), "failed to get ether_clk\n");
>  
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>  	rc = pcim_enable_device(pdev);
> -- 
> 2.37.3

This change broke the r8169 driver on my SH7785LCR SuperH Evaluation Board.

With your patch, the driver initialization fails with:

[    1.648000] r8169 0000:00:00.0: error -EINVAL: failed to get ether_clk
[    1.676000] r8169: probe of 0000:00:00.0 failed with error -22

Any idea what could be the problem?

Thanks,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
