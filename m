Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD91BD749
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgD2I3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgD2I3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 04:29:39 -0400
X-Greylist: delayed 178 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Apr 2020 01:29:39 PDT
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473EC03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588148978;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BfHXos+9450rpGvIhO6jrZq3f/TYqCe6XZMBD0vryCQ=;
        b=mNRYkB3KL5KRcqz49DYr9bMePbzJJl3zxQxD3goMb/qwCz0yLXOPHXc81y13KM6jKW
        U/9lt4KeVnucFQOIWeUpklnamgAqF2WSMdlaKxuGp+wWHpzy+raklYyIyGbTrghCf+L7
        Pddu4Tfo3ei/GO0RD6fTgnakOLwExffYmLiIJoc1sOCzNEH+iN/jbkWgTsQBj057gO8D
        3ywMI4n3uf01+hXybJOuRlJ54wA418crUnZKnE24NeRMQhM4CdgN0j9+sJC+3ZdlqEbc
        OHZAI+QssxvHz4OQe6Y6jG+6ftUQg1PkFBypZ2fMX+UQeidbg22u6vyoH7TyweAHeABW
        xUFw==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSdWimbfxYLit+vlzeN0mUI0H8aQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:1c94:f1a9:15ea:cac1]
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id I01247w3T8QYYNW
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Apr 2020 10:26:34 +0200 (CEST)
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
To:     Darren Stevens <darren@stevens-zone.net>, madalin.bacur@nxp.com,
        netdev@vger.kernel.org, mad skateman <madskateman@gmail.com>
Cc:     oss@buserror.net, linuxppc-dev@lists.ozlabs.org,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        "contact@a-eon.com" <contact@a-eon.com>
References: <20200424232938.1a85d353@Cyrus.lan>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <ca95a1b2-1b16-008c-18ba-2cbd79f240e6@xenosoft.de>
Date:   Wed, 29 Apr 2020 10:26:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424232938.1a85d353@Cyrus.lan>
Content-Type: multipart/mixed;
 boundary="------------BF1782061CAC7863F4EF23B5"
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------BF1782061CAC7863F4EF23B5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Darren,

Thanks a lot for your patch!

I tested it with the RC3 today.

Unfortunately it doesn't compile because a bracket is missing in the 
following line:

+    if (prop && !strncmp(prop, "disabled", 8) {

And a semicolon is missing in the following line:

+        goto _return

I added the bracket and the semicolon and after that it compiled without 
any problems. (New patch attached)

Unfortunately I see more than 2 ethernet ports with the RC3 and your 
patch on my Cyrus P5040. Maybe Skateman has an other result on his Cyrus 
P5020.

Maybe we have to modify the dtb file.

Thanks,
Christian


On 25 April 2020 at 00:29 am, Darren Stevens wrote:
> Since cbb961ca271e ("Use random MAC address when none is given")
> Varisys Cyrus P5020 boards have been listing 5 ethernet ports instead of
> the 2 the board has.This is because we were preventing the adding of the
> unused ports by not suppling them a MAC address, which this patch now
> supplies.
>
> Prevent them from appearing in the net devices list by checking for a
> 'status="disabled"' entry during probe and skipping the port if we find
> it.
>
> Signed-off-by: Darren Stevens <Darren@stevens-zone.net>
>
> ---
>
>   drivers/net/ethernet/freescale/fman/mac.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index 43427c5..c9ed411 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -606,6 +606,7 @@ static int mac_probe(struct platform_device *_of_dev)
>   	struct resource		 res;
>   	struct mac_priv_s	*priv;
>   	const u8		*mac_addr;
> +	const char 		*prop;
>   	u32			 val;
>   	u8			fman_id;
>   	phy_interface_t          phy_if;
> @@ -628,6 +629,16 @@ static int mac_probe(struct platform_device *_of_dev)
>   	mac_dev->priv = priv;
>   	priv->dev = dev;
>   
> +	/* check for disabled devices and skip them, as now a missing
> +	 * MAC address will be replaced with a Random one rather than
> +	 * disabling the port
> +	 */
> +	prop = of_get_property(mac_node, "status", NULL);
> +	if (prop && !strncmp(prop, "disabled", 8) {
> +		err = -ENODEV;
> +		goto _return
> +	}
> +
>   	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
>   		setup_dtsec(mac_dev);
>   		priv->internal_phy_node = of_parse_phandle(mac_node,


--------------BF1782061CAC7863F4EF23B5
Content-Type: text/x-patch; charset=UTF-8;
 name="dpss_eth.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dpss_eth.patch"

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 43427c5..c9ed411 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -606,6 +606,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct resource		 res;
 	struct mac_priv_s	*priv;
 	const u8		*mac_addr;
+	const char 		*prop;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -628,6 +629,16 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->priv = priv;
 	priv->dev = dev;
 
+	/* check for disabled devices and skip them, as now a missing
+	 * MAC address will be replaced with a Random one rather than
+	 * disabling the port
+	 */
+	prop = of_get_property(mac_node, "status", NULL);
+	if (prop && !strncmp(prop, "disabled", 8)) {
+		err = -ENODEV;
+		goto _return;
+	}
+
 	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
 		setup_dtsec(mac_dev);
 		priv->internal_phy_node = of_parse_phandle(mac_node,

--------------BF1782061CAC7863F4EF23B5--
