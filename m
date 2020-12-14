Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759532DA101
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502902AbgLNUDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:03:00 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:20464 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502916AbgLNUCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:02:47 -0500
Received: from [192.168.42.210] ([93.22.36.105])
        by mwinf5d56 with ME
        id 4L0t2400Q2G6YR103L0uuQ; Mon, 14 Dec 2020 21:01:01 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 14 Dec 2020 21:01:01 +0100
X-ME-IP: 93.22.36.105
Subject: Re: [PATCH] net: mscc: ocelot: Fix a resource leak in the error
 handling path of the probe function
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Newsgroups: gmane.linux.kernel,gmane.linux.network,gmane.linux.kernel.janitors
References: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
 <20201214114831.GE2809@kadam>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <ecca5770-7cb3-c0a0-0a33-fcc3854d0b74@wanadoo.fr>
Date:   Mon, 14 Dec 2020 21:00:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201214114831.GE2809@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/12/2020 à 12:48, Dan Carpenter a écrit :
> On Sun, Dec 13, 2020 at 12:48:38PM +0100, Christophe JAILLET wrote:
>> In case of error after calling 'ocelot_init()', it must be undone by a
>> corresponding 'ocelot_deinit()' call, as already done in the remove
>> function.
>>
> 
> This changes the behavior slightly in another way as well, but it's
> probably a bug fix.
> 
> drivers/net/ethernet/mscc/ocelot_vsc7514.c
>    1250          ports = of_get_child_by_name(np, "ethernet-ports");
>    1251          if (!ports) {
>    1252                  dev_err(ocelot->dev, "no ethernet-ports child node found\n");
>    1253                  return -ENODEV;
>    1254          }
>    1255
>    1256          ocelot->num_phys_ports = of_get_child_count(ports);
>    1257          ocelot->num_flooding_pgids = 1;
>    1258
>    1259          ocelot->vcap = vsc7514_vcap_props;
>    1260          ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
>    1261          ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
>    1262          ocelot->npi = -1;
>    1263
>    1264          err = ocelot_init(ocelot);
>    1265          if (err)
>    1266                  goto out_put_ports;
>    1267
>    1268          err = mscc_ocelot_init_ports(pdev, ports);
>    1269          if (err)
>    1270                  goto out_put_ports;
>    1271
>    1272          if (ocelot->ptp) {
>    1273                  err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
>    1274                  if (err) {
>    1275                          dev_err(ocelot->dev,
>    1276                                  "Timestamp initialization failed\n");
>    1277                          ocelot->ptp = 0;
>    1278                  }
> 
> In the original code, if ocelot_init_timestamp() failed we returned
> a negative error code but now we return success.  This probably is what
> the original authors intended, though.
> 

Thanks for the detailed review Dan.

I agree with you. However this "fix" was not intentional. :(

This may worth stating it in the commit message.
Can it be done when/if the patch is applied?

CJ
