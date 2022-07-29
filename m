Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698AD5851E7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiG2O6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiG2O6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:58:36 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3A07FE56;
        Fri, 29 Jul 2022 07:58:34 -0700 (PDT)
Received: from [127.0.0.1] (ip-109-43-49-118.web.vodafone.de [109.43.49.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0BFCF22246;
        Fri, 29 Jul 2022 16:58:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1659106711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+YShM8tCWwaAykVrnA9+dAAicvUjJ1+V+R6kmbwKkA=;
        b=Fb/dpvs46e3e9OHp3FckYJH0lYNTUX0cSMGtqSanZdFeT3MFBOVZxkdzYN6g7pMzajlnDW
        Mq+n2wgNji9jOK0Cw3zQTqLP6Y4qkLD73CEv69jZ+QAO87Q91MxVVhVfyM8o4/shgKO4rO
        sUliLx42Y+BszUhKs/U3zpKXVvt/AQE=
Date:   Fri, 29 Jul 2022 16:58:28 +0200
From:   Michael Walle <michael@walle.cc>
To:     David Laight <David.Laight@ACULAB.COM>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Walle <mwalle@kernel.org>
Subject: RE: [PATCH] wilc1000: fix DMA on stack objects
User-Agent: K-9 Mail for Android
In-Reply-To: <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
References: <20220728152037.386543-1-michael@walle.cc> <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
Message-ID: <612ECEE6-1C05-4325-92A3-21E17EC177A9@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 29=2E Juli 2022 11:51:12 MESZ schrieb David Laight <David=2ELaight@ACULA=
B=2ECOM>:
>From: Michael Walle
>> Sent: 28 July 2022 16:21
>>=20
>> From: Michael Walle <mwalle@kernel=2Eorg>
>>=20
>> Sometimes wilc_sdio_cmd53() is called with addresses pointing to an
>> object on the stack=2E E=2Eg=2E wilc_sdio_write_reg() will call it with=
 an
>> address pointing to one of its arguments=2E Detect whether the buffer
>> address is not DMA-able in which case a bounce buffer is used=2E The bo=
unce
>> buffer itself is protected from parallel accesses by sdio_claim_host()=
=2E
>>=20
>> Fixes: 5625f965d764 ("wilc1000: move wilc driver out of staging")
>> Signed-off-by: Michael Walle <mwalle@kernel=2Eorg>
>> ---
>> The bug itself probably goes back way more, but I don't know if it make=
s
>> any sense to use an older commit for the Fixes tag=2E If so, please sug=
gest
>> one=2E
>>=20
>> The bug leads to an actual error on an imx8mn SoC with 1GiB of RAM=2E B=
ut the
>> error will also be catched by CONFIG_DEBUG_VIRTUAL:
>> [    9=2E817512] virt_to_phys used for non-linear address: (____ptrval_=
___) (0xffff80000a94bc9c)
>>=20
>>  =2E=2E=2E/net/wireless/microchip/wilc1000/sdio=2Ec    | 28 +++++++++++=
+++++---
>>  1 file changed, 24 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio=2Ec
>> b/drivers/net/wireless/microchip/wilc1000/sdio=2Ec
>> index 7962c11cfe84=2E=2Ee988bede880c 100644
>> --- a/drivers/net/wireless/microchip/wilc1000/sdio=2Ec
>> +++ b/drivers/net/wireless/microchip/wilc1000/sdio=2Ec
>> @@ -27,6 +27,7 @@ struct wilc_sdio {
>>  	bool irq_gpio;
>>  	u32 block_size;
>>  	int has_thrpt_enh3;
>> +	u8 *dma_buffer;
>>  };
>>=20
>>  struct sdio_cmd52 {
>> @@ -89,6 +90,9 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct =
sdio_cmd52 *cmd)
>>  static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
>>  {
>>  	struct sdio_func *func =3D container_of(wilc->dev, struct sdio_func, =
dev);
>> +	struct wilc_sdio *sdio_priv =3D wilc->bus_data;
>> +	bool need_bounce_buf =3D false;
>> +	u8 *buf =3D cmd->buffer;
>>  	int size, ret;
>>=20
>>  	sdio_claim_host(func);
>> @@ -100,12 +104,20 @@ static int wilc_sdio_cmd53(struct wilc *wilc, str=
uct sdio_cmd53 *cmd)
>>  	else
>>  		size =3D cmd->count;
>>=20
>> +	if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&
>
>How cheap are the above tests?
>It might just be worth always doing the 'bounce'?

I'm not sure how cheap they are, but I don't think it costs more than copy=
ing the bulk data around=2E That's up to the maintainer to decide=2E=20

>
>> +	    !WARN_ON_ONCE(size > WILC_SDIO_BLOCK_SIZE)) {
>
>That WARN() ought to be an error return?

It will just behave as before=2E I noticed it *will* work in some cases, a=
lthough the object is on the stack=2E I mean the driver seems to work fine =
at least on some SoCs=2E So I didn't want to change the behavior if the bou=
nce buffer is too small=2E Of course we could also return an error here=2E =
All the calls with stack adresses I've seen for now were the register reads=
 and writes and the txq handling (the vmm_tables IIRC)=2E=20

>Or just assume that large buffers will dma-capable?

See above=2E It should be large enough=2E But I didn't audit everything=2E=
=20

-michael=20

>
>	David
>
>> +		need_bounce_buf =3D true;
>> +		buf =3D sdio_priv->dma_buffer;
>> +	}
>> +
>>  	if (cmd->read_write) {  /* write */
>> -		ret =3D sdio_memcpy_toio(func, cmd->address,
>> -				       (void *)cmd->buffer, size);
>> +		if (need_bounce_buf)
>> +			memcpy(buf, cmd->buffer, size);
>> +		ret =3D sdio_memcpy_toio(func, cmd->address, buf, size);
>>  	} else {        /* read */
>> -		ret =3D sdio_memcpy_fromio(func, (void *)cmd->buffer,
>> -					 cmd->address,  size);
>> +		ret =3D sdio_memcpy_fromio(func, buf, cmd->address, size);
>> +		if (need_bounce_buf)
>> +			memcpy(cmd->buffer, buf, size);
>>  	}
>>=20
>>  	sdio_release_host(func);
>> @@ -127,6 +139,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
>>  	if (!sdio_priv)
>>  		return -ENOMEM;
>>=20
>> +	sdio_priv->dma_buffer =3D kzalloc(WILC_SDIO_BLOCK_SIZE, GFP_KERNEL);
>> +	if (!sdio_priv->dma_buffer) {
>> +		ret =3D -ENOMEM;
>> +		goto free;
>> +	}
>> +
>>  	ret =3D wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
>>  				 &wilc_hif_sdio);
>>  	if (ret)
>> @@ -160,6 +178,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
>>  	irq_dispose_mapping(wilc->dev_irq_num);
>>  	wilc_netdev_cleanup(wilc);
>>  free:
>> +	kfree(sdio_priv->dma_buffer);
>>  	kfree(sdio_priv);
>>  	return ret;
>>  }
>> @@ -171,6 +190,7 @@ static void wilc_sdio_remove(struct sdio_func *func=
)
>>=20
>>  	clk_disable_unprepare(wilc->rtc_clk);
>>  	wilc_netdev_cleanup(wilc);
>> +	kfree(sdio_priv->dma_buffer);
>>  	kfree(sdio_priv);
>>  }
>>=20
>> --
>> 2=2E30=2E2
>
>-
>Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
>Registration No: 1397386 (Wales)
>

