Return-Path: <netdev+bounces-10453-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF0B72E903
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4C6F28114C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16732DBD8;
	Tue, 13 Jun 2023 17:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A033E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:08:54 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CBE1BCD;
	Tue, 13 Jun 2023 10:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686676090; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ePQ8T8JP2PNFjJ5BwhC8rVkwMI84+f2z/Zg2i1rwTA1eZ1J3vuAZLrD/NRZS/Y2gk/M+HJpV7ABw0/wyKMKPAokA8e2kmpZ0ZI9b2S2cYBF0yO8wKNh6j3vL4VzLoxh6q8MBRkp8qKks5vYCAdc4vIXYJBhZ+c1AeaWMMTaNzwc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686676090; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=rs4XusAan9L2M35MEuiSnW7ruND0UoH2sge7OhY5PEg=; 
	b=CWX0/lQBXyCBOuZDqg6mw/97xqpB6hNZqQXcJyoakqUGesqA71DIgL3A5xLe4Z98MGOAZZlyMpUudjRqnjahnL57nU/o8djYU1Q5VXEsbCrFZJqFf/b78QA+r7XEmLQInfmZfPVAXRwkdl6sMwSQqsUyoTGxCEEhlsbzxaVmRoA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686676090;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rs4XusAan9L2M35MEuiSnW7ruND0UoH2sge7OhY5PEg=;
	b=JWJeZw27NRwZgBoVZXXjufBh/J9ZVZogf9Op5CDmjk+/vXcZY2GYJQVhB5kBMzvU
	2xpHv09IFs8xQnYK8aDA5DEjeUrUO1uph/kjA50Et2qoMyeJbZvtMiNaVfoxsUOWQtc
	kCGzCVu0LX34KwjE7T/up38/lagnJGhj4VL+Cn38=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 168667608891134.02011713856268; Tue, 13 Jun 2023 10:08:08 -0700 (PDT)
Message-ID: <4acff981-c6a9-ac10-d6e5-888386b418ed@arinc9.com>
Date: Tue, 13 Jun 2023 20:07:59 +0300
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
Content-Language: en-US
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
 <9d571682-7271-2a5e-8079-900d14a5d7cd@arinc9.com>
 <ZIbuxohDqHA0S7QP@shell.armlinux.org.uk>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZIbuxohDqHA0S7QP@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12.06.2023 13:09, Russell King (Oracle) wrote:
> On Mon, Jun 12, 2023 at 09:40:45AM +0300, Arınç ÜNAL wrote:
>> On 11.06.2023 19:04, Russell King (Oracle) wrote:
>>> On Sun, Jun 11, 2023 at 11:15:41AM +0300, Arınç ÜNAL wrote:
>>>> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
>>>> SoC represents a CPU port to trap frames to. These switches trap frames to
>>>> the CPU port the user port, which the frames are received from, is affine
>>>> to.
>>>
>>> I think you need to reword that, because at least I went "err what" -
>>> especially the second sentence!
>>
>> Sure, how does this sound:
>>
>> These switches trap frames to the CPU port that is affine to the user port
>> from which the frames are received.
> 
> "... to the inbound user port." I think that's a better way to describe
> "user port from which the frames are received."

Sounds good to me.

> 
> However, I'm still struggling to understand what the overall message for
> this entire commit log actually is.
> 
> The actual affinity of the user ports seems to be not relevant, but this
> commit is more about telling the switch which of its ports are CPU
> ports.

Yes, I also add a comment to explain how frame trapping works. The user 
port - CPU port affinity is only relevant there.

> 
> So, if the problem is that we only end up with a single port set as a
> CPU port when there are multiple, isn't it going to be better to say
> something like:
> 
> "For MT7531 and the switch on MT7988, we are not correctly indicating
> which ports are CPU ports when we have more than one CPU port. In order
> to solve this, we need to set multiple bits in the XYZ register so the
> switch will trap frames to the appropriate CPU port for frames received
> on the inbound user port.

Yes, I'll replace this with the second paragraph.

> 
>>>> Currently, only the bit that corresponds to the first found CPU port is set
>>>> on the bitmap.
>>>
>>> Ok.
>>>
>>>> When multiple CPU ports are being used, frames from the user
>>>> ports affine to the other CPU port which are set to be trapped will be
>>>> dropped as the affine CPU port is not set on the bitmap.
>>>
>>> Hmm. I think this is trying to say:
>>>
>>> "When multiple CPU ports are being used, trapped frames from user ports
>>> not affine to the first CPU port will be dropped we do not set these
>>> ports as being affine to the second CPU port."
>>
>> Yes but it's not the affinity we set here. It's to enable the CPU port for
>> trapping.
> 
> In light of that, is the problem that we only enable one CPU port to
> receive trapped frames from their affine user ports?

Yes.

> 
>>>> Only the MT7531
>>>> switch is affected as there's only one port to be used as a CPU port on the
>>>> switch on the MT7988 SoC.
>>>
>>> Erm, hang on. The previous bit indicated there was a problem when there
>>> are multiple CPU ports, but here you're saying that only one switch is
>>> affected - and that switch has only one CPU port. This at the very least
>>> raises eyebrows, because it's just contradicted the first part
>>> explaining when there's a problem.
>>
>> I meant to say, since I already explained at the start of the patch log that
>> this patch changes the bits of the CPU port bitmap for MT7531 and the switch
>> on the MT7988 SoC, only MT7531 is affected as there's only a single CPU port
>> on the switch on the MT7988 SoC. So the switch on the MT7988 SoC cannot be
>> affected.
> 
> 
> 
>>
>>>
>>>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>>>> index 9bc54e1348cb..8ab4718abb06 100644
>>>> --- a/drivers/net/dsa/mt7530.c
>>>> +++ b/drivers/net/dsa/mt7530.c
>>>> @@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>>>>    	if (priv->id == ID_MT7621)
>>>>    		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>>>> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
>>>> +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
>>>> +	 * trapped to the CPU port the user port, which the frames are received
>>>> +	 * from, is affine to.
>>>
>>> Please reword the second sentence.
>>
>> Any frames set for trapping to CPU port will be trapped to the CPU port that
>> is affine to the user port from which the frames are received.
> 
> Too many "port"s. Would:
> 
> "Add this port to the CPU port bitmap for the MT7531 and switch on the
> MT7988. Trapped frames will be sent to the CPU port that is affine to
> the inbound user port."
> 
> explain it better?

Sounds good.

Arınç

