Return-Path: <netdev+bounces-10464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5341E72E9D3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 924B8281055
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E223738CA4;
	Tue, 13 Jun 2023 17:32:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C8A33E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:32:03 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B494A1BDB;
	Tue, 13 Jun 2023 10:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686677440; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Y+EMAxMpiRCH413IBVJiA3UKJzsUnn7PworlHspTD0WWb+6QzFPGdlyPkgQgZ2/QsvKoVsawU9O7gDaAvFbxcLGcCFM1Y9XwwN+4MhMN4UtJWgjUB0K88Wk8CkYuNatDUOcuLQFiTRFS8k8p4eGQusMniXxikr4OTzI+GfQEGGY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686677440; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=+I8g8xI0PLvgMDTAKTzT+byqeeeAJ48wgO3/LkZkDfc=; 
	b=Xe6lZ/wxp5SieLpuCdeLtUP37vqfHWb+wJU7rXiu06r99QPKr1lqplNldBBO60XDwJeHJ2vWY8E37cL3geFXgpIO/oPb/kMOEvn6xPSMnVFZP1FyQb4Yf86y27OJ1oz8bpaSWAfN2CQRwFPdW99W70xZ1hksEUWOoe59+kR2XdE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686677440;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+I8g8xI0PLvgMDTAKTzT+byqeeeAJ48wgO3/LkZkDfc=;
	b=aKZ1lY0f/90ohhn38wGIkGs00vNns+YU5emG6cCDfzzYMEYMBzDzlNSGijityrNs
	vRfFZ9mk1VtT3NFGIW2fCBu9cPeGJ4pJJA6m1C6Ku3NkeYz8hHkZVxeITplORwGd1Xj
	9k+GYgSFN50Yji3uCeTMClVthkGXCJmjLOpM0gKE=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686677438530410.51951240935364; Tue, 13 Jun 2023 10:30:38 -0700 (PDT)
Message-ID: <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
Date: Tue, 13 Jun 2023 20:30:28 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
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
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613172402.grdpgago6in4jogq@skbuf>
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

On 13.06.2023 20:24, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 08:18:58PM +0300, Vladimir Oltean wrote:
>> On Tue, Jun 13, 2023 at 08:14:35PM +0300, Arınç ÜNAL wrote:
>>> Actually, having only "net: dsa: introduce preferred_default_local_cpu_port
>>> and use on MT7530" backported is an enough solution for the current stable
>>> kernels.
>>>
>>> When multiple CPU ports are defined on the devicetree, the CPU_PORT bits
>>> will be set to port 6. The active CPU port will also be port 6.
>>>
>>> This would only become an issue with the changing the DSA conduit support.
>>> But that's never going to happen as this patch will always be on the kernels
>>> that support changing the DSA conduit.
>>
>> Aha, ok. I thought that device trees with CPU port 5 exclusively defined
>> also exist in the wild. If not, and this patch fixes a theoretical only
>> issue, then it is net-next material.
> 
> On second thought, compatibility with future device trees is the reason
> for this patch set, so that should equally be a reason for keeping this
> patch in a "net" series.
> 
> If I understand you correctly, port 5 should have worked since commit
> c8b8a3c601f2 ("net: dsa: mt7530: permit port 5 to work without port 6 on
> MT7621 SoC"), and it did, except for trapping, right?

That fixes port 5 on certain variants of the MT7530 switch, as it was 
already working on the other variants, which, in conclusion, fixes port 
5 on all MT7530 variants.

And no, trapping works. Having only CPU port 5 defined on the devicetree 
will cause the CPU_PORT bits to be set to port 5. There's only a problem 
when multiple CPU ports are defined.

> 
> So how about settling on that as a more modest Fixes: tag, and
> explaining clearly in the commit message what's affected?

I don't see anything to change in the patch log except addressing 
Russell's comments.

Arınç

