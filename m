Return-Path: <netdev+bounces-10007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD36872BA99
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F7FF281119
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F7611C88;
	Mon, 12 Jun 2023 08:29:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4EB11198
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:29:31 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6901A4204;
	Mon, 12 Jun 2023 01:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686552057; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=N5Z8Xx5MTDpzPOg5YVNm0zEJIec+1A71b0xOtNYv+vqKhz3ohBwQb7BwUG0aAvh8DJVasq4XUIzBzKWVB5jzd9vI3WWeVE3i8rIfUWOWN0c3NnHaqi1PrzLtAQFOz/PPF3Vk+mYqNwgY54jAUUFNH1LkOyinORjCNa7mesQNWXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686552057; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=7hWIuEKHzKrCPAJw5UGPeTK1NFKqx5fW0IhOyNJ4dto=; 
	b=kd9fUyRWOdCejKUvQBVJfl/QeXp3K7zT6yEqsp02JqijGFFhp0Cf9ekvq4d/5q0JeAdqffGhmoQvSpi3oVNwjCoMDwFQMS4neYLIJAgMN3nu3xdHOqPWk/nUaY9AucNWXiIQkQwf9E/04SKf7wlmFYxt/7lMd9n9sifwexfVEH4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686552057;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7hWIuEKHzKrCPAJw5UGPeTK1NFKqx5fW0IhOyNJ4dto=;
	b=AGWlqaW8ZQo2lx7Q00ggFnpxfqb4rC3EBOtQjanPNvXVjLhIrKUGPeyo+HpsuuIC
	71YK1qKas6rbWgz8BGVu94ToF7f+47xZBVIDg4FrW0rniudo5R5q7GSkee83MhbH3pJ
	Tr6twMxEGyNrnHKMH6cRCRrEWdyyA9tjQIR5dZfE=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686552055037385.4399970646691; Sun, 11 Jun 2023 23:40:55 -0700 (PDT)
Message-ID: <9d571682-7271-2a5e-8079-900d14a5d7cd@arinc9.com>
Date: Mon, 12 Jun 2023 09:40:45 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <ZIXwc0V5Ye6xrpmn@shell.armlinux.org.uk>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZIXwc0V5Ye6xrpmn@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.06.2023 19:04, Russell King (Oracle) wrote:
> On Sun, Jun 11, 2023 at 11:15:41AM +0300, Arınç ÜNAL wrote:
>> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
>> SoC represents a CPU port to trap frames to. These switches trap frames to
>> the CPU port the user port, which the frames are received from, is affine
>> to.
> 
> I think you need to reword that, because at least I went "err what" -
> especially the second sentence!

Sure, how does this sound:

These switches trap frames to the CPU port that is affine to the user 
port from which the frames are received.

> 
>> Currently, only the bit that corresponds to the first found CPU port is set
>> on the bitmap.
> 
> Ok.
> 
>> When multiple CPU ports are being used, frames from the user
>> ports affine to the other CPU port which are set to be trapped will be
>> dropped as the affine CPU port is not set on the bitmap.
> 
> Hmm. I think this is trying to say:
> 
> "When multiple CPU ports are being used, trapped frames from user ports
> not affine to the first CPU port will be dropped we do not set these
> ports as being affine to the second CPU port."

Yes but it's not the affinity we set here. It's to enable the CPU port 
for trapping.

> 
>> Only the MT7531
>> switch is affected as there's only one port to be used as a CPU port on the
>> switch on the MT7988 SoC.
> 
> Erm, hang on. The previous bit indicated there was a problem when there
> are multiple CPU ports, but here you're saying that only one switch is
> affected - and that switch has only one CPU port. This at the very least
> raises eyebrows, because it's just contradicted the first part
> explaining when there's a problem.

I meant to say, since I already explained at the start of the patch log 
that this patch changes the bits of the CPU port bitmap for MT7531 and 
the switch on the MT7988 SoC, only MT7531 is affected as there's only a 
single CPU port on the switch on the MT7988 SoC. So the switch on the 
MT7988 SoC cannot be affected.

> 
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index 9bc54e1348cb..8ab4718abb06 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>>   	if (priv->id == ID_MT7621)
>>   		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>>   
>> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
>> +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
>> +	 * trapped to the CPU port the user port, which the frames are received
>> +	 * from, is affine to.
> 
> Please reword the second sentence.

Any frames set for trapping to CPU port will be trapped to the CPU port 
that is affine to the user port from which the frames are received.

Arınç

