Return-Path: <netdev+bounces-10867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B72373097B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180481C20D71
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1787011CAF;
	Wed, 14 Jun 2023 20:57:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CBF2EC3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:57:31 +0000 (UTC)
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9637E19B5;
	Wed, 14 Jun 2023 13:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686776211; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=aFappWL7SsPfif8zE0D8Tfmhy4NUMvXsuamJWPTdw2rM4GmUKGoQqI5Guw9NdZHa2p2UDWih9mbJx37mXwxEOa7IAJyYz6SStmnO9PwPITPtqo0dG1TnZK3qZfLf0an0wGPe2zI7Y4gEN0YL3RtvkI0nCE8mhCZa9Tn7G0VJUBI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686776211; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=ElJHcwOE2MD9MomG0N24epuSaWGnZJlvFOibVGSk+nA=; 
	b=c0hShkqBouNuIVvFnIxBqAfcPho0VvFLeLnC6A7biB3yz7ZMta8+IPRMKQWJWvk5GpRZ8KGNkN/hKm73gwFMQrA3XTUGEZ27fnkM+IIj7jR+Kew0kYRdI0yzkn0tNtDXeD069t6GUaGWgaHIm0nwZHlgMXmbeh/lj80uRn1967A=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686776211;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ElJHcwOE2MD9MomG0N24epuSaWGnZJlvFOibVGSk+nA=;
	b=ShtRgEElMlF/a608D506cpQfhGjn2MqBsOZwcue1eAY2vadQ6gtCSrTh4mNIGI3m
	iB/tQYtOAH10+JjYcHROpjXLSklOKRjAAdTHJKO8SbjmkPqYHRSzWCm1i0tPAcstm21
	LjrERJaVFow+5miCJa4c4BbOUJIlEDOwJfF42X3c=
Received: from [192.168.99.141] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 168677621095320.21150552014285; Wed, 14 Jun 2023 13:56:50 -0700 (PDT)
Message-ID: <1e737fe9-6a2e-225b-9c0f-9a069e8fd4bc@arinc9.com>
Date: Wed, 14 Jun 2023 23:56:44 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230612075945.16330-2-arinc.unal@arinc9.com>
 <20230614194330.qhhoxai7namrgczq@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230614194330.qhhoxai7namrgczq@skbuf>
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

On 14.06.2023 22:43, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 10:59:39AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
>> SoC represents a CPU port to trap frames to. These switches trap frames
>> received from a user port to the CPU port that is affine to the user port
>> from which the frames are received.
>>
>> Currently, only the bit that corresponds to the first found CPU port is set
>> on the bitmap. When multiple CPU ports are being used, the trapped frames
>> from the user ports not affine to the first CPU port will be dropped as the
>> other CPU port is not set on the bitmap. The switch on the MT7988 SoC is
>> not affected as there's only one port to be used as a CPU port.
>>
>> To fix this, introduce the MT7531_CPU_PMAP macro to individually set the
>> bits of the CPU port bitmap. Set the CPU port bitmap for MT7531 and the
>> switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on a loop
>> for each CPU port.
>>
>> Add a comment to explain frame trapping for these switches.
>>
>> According to the document MT7531 Reference Manual for Development Board
>> v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
>> beforehand. Since there's currently no public document for the switch on
>> the MT7988 SoC, I assume this is also the case for this switch.
>>
>> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> Would you agree that this is just preparatory work for change "net: dsa:
> introduce preferred_default_local_cpu_port and use on MT7530" and not a
> fix to an existing problem in the code base?

Makes sense. Pre-preferred_default_local_cpu_port patch, there isn't a 
case where there's a user port affine to a CPU port that is not enabled 
on the CPU port bitmap. So yeah, this is just preparatory work for "net: 
dsa: introduce preferred_default_local_cpu_port and use on MT7530".

So how do I change the patch to reflect this?

Arınç

