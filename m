Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A672B55B3E5
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiFZTzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFZTzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:55:19 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA038B9;
        Sun, 26 Jun 2022 12:55:18 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id ECB992222E;
        Sun, 26 Jun 2022 21:55:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656273317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tx44gz4c/mqxeeGkG/B8AgM0VUfKCxNhrmmznwu4ypk=;
        b=Ot6dT2qRBPEZu49hPQNVzQJmsAE/znuYp5WxIv1wDC6zNLkkVQUlOKXZfds6Gyi5RmNbPW
        tV2DHmrEcWhahlQ2j1bo84Oe04FkqEr1LodSpXtKboYP2F6JlSrZlM7Kk7q7/IFGP7Ioaf
        WNdFIfVCn5t8/FrFNSud4NoaPs2v8S8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 26 Jun 2022 21:55:16 +0200
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?Q?Cl=C3=A9ment_?= =?UTF-8?Q?Perrochaud?= 
        <clement.perrochaud@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] NFC: nxp-nci: check return code of i2c_master_recv()
In-Reply-To: <99e3ad4f-077a-0ca0-6842-b0c5a3439b68@linaro.org>
References: <20220626194243.4059870-1-michael@walle.cc>
 <99e3ad4f-077a-0ca0-6842-b0c5a3439b68@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cd4780159ec9a66b417c4f1fb50d288c@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-06-26 21:49, schrieb Krzysztof Kozlowski:
> On 26/06/2022 21:42, Michael Walle wrote:
>> Check the return code of i2c_master_recv() for actual errors and
>> propagate it to the caller.
>> 
>> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI 
>> driver")
> 
> The check was there, so I don't see here bug. The only thing missing 
> was
> a bit more detailed error message (without cast to %u) and propagating
> error code instead of EBADMSG, but these are not bugs. The commit msg
> should sound different and Fixes tag is not appropriate.

Well one could argue the nfc_err() is very misleading as it prints
an unreasonable large number. Will remove the Fixes tag and reword
the commit message.

>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/nfc/nxp-nci/i2c.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
>> index 7e451c10985d..9c80d5a6d56b 100644
>> --- a/drivers/nfc/nxp-nci/i2c.c
>> +++ b/drivers/nfc/nxp-nci/i2c.c
>> @@ -163,7 +163,10 @@ static int nxp_nci_i2c_nci_read(struct 
>> nxp_nci_i2c_phy *phy,
>>  	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
>> 
>>  	r = i2c_master_recv(client, skb_put(*skb, header.plen), 
>> header.plen);
>> -	if (r != header.plen) {
>> +	if (r < 0) {
>> +		nfc_err(&client->dev, "I2C receive error %pe\n", ERR_PTR(r));
> 
> Print just 'r'.

Personally, I prefer seeing the actual error string and this idiom is
also used in other drivers. But I wont insist, will change it.

> 
>> +		goto nci_read_exit_free_skb;
>> +	} else if (r != header.plen) {
>>  		nfc_err(&client->dev,
>>  			"Invalid frame payload length: %u (expected %u)\n",
>>  			r, header.plen);
> 
> 
> Best regards,
> Krzysztof

-michael
