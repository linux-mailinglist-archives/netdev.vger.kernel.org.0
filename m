Return-Path: <netdev+bounces-10525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB4372ED95
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6091F280FFF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7893638CD1;
	Tue, 13 Jun 2023 21:05:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162D174FA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:05:14 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A02219A7;
	Tue, 13 Jun 2023 14:05:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686690262; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=h5XT1YKtblE2EbdkfNwDxnv6JsYamFwH2kFnrl/YUs5MFcMAOG3UfjSKcPSJsH4DFrpjFm/+qUTBYfXINdnvbK0ESC6JbhjNateuAUeAYzsmmxXypLV46d+oqWEl89Oo4kaDJiWwQIzKZshxuwfyRSEMSrouJodEvJSHVDp5a+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686690262; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=mNrSoA9RNanVJ842F7+wKKUHtKKldQV+kaGjsFPdlIw=; 
	b=ktzgPAYxOg3Yocw5UfX11w1BH/qcey9+pTuIdgQNvqMRQbtaxj0j/fgIJtn9lUtFWRIIkCNrSt07xTnsxE+ualoKOM5+VkxlRIy9HHCx7A8m14rcEaGm0Ra3p9GDU6SY3jcKe1nKPz7Ud8h4WYue8pYe6vJnCKxgGcKqSUB5JN0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686690262;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=mNrSoA9RNanVJ842F7+wKKUHtKKldQV+kaGjsFPdlIw=;
	b=ANWo1ieZAPI87KHbnBruHf4fRzOgNTl0e9FL0mtBMttmA+JEZI/9nEah39HzcmfJ
	9HF+LTHMZNM1hgcqOz/FzfHCYLHiZYifgZzRiO7hXmR8hDOgqVUa+GLYWUc7LA84w8a
	oahMOKD2Mc92TbRWXwBgoCAsQkqik1dlXCqcGhBQ=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686690259958616.2203158377357; Tue, 13 Jun 2023 14:04:19 -0700 (PDT)
Message-ID: <dd0d716e-8fdc-b6dc-3870-e7e524e8bf49@arinc9.com>
Date: Wed, 14 Jun 2023 00:04:10 +0300
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
References: <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <20230613201850.5g4u3wf2kllmlk27@skbuf>
 <4a2fb3ac-ccad-f56e-4951-e5a5cb80dd1b@arinc9.com>
 <20230613205915.rmpuqq7ahmd7taeq@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613205915.rmpuqq7ahmd7taeq@skbuf>
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

On 13.06.2023 23:59, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 11:35:08PM +0300, Arınç ÜNAL wrote:
>> On 13.06.2023 23:18, Vladimir Oltean wrote:
>>> On Tue, Jun 13, 2023 at 08:58:33PM +0300, Arınç ÜNAL wrote:
>>>> On 13.06.2023 20:39, Vladimir Oltean wrote:
>>>>> Got it. Then this is really not a problem, and the commit message frames
>>>>> it incorrectly.
>>>>
>>>> Actually this patch fixes the issue it describes. At the state of this
>>>> patch, when multiple CPU ports are defined, port 5 is the active CPU port,
>>>> CPU_PORT bits are set to port 6.
>>>>
>>>> Once "the patch that prefers port 6, I could easily find the exact name but
>>>> your mail snipping makes it hard" is applied, this issue becomes redundant.
>>>
>>> Ok. Well, you don't get bonus points for fixing a problem in 2 different
>>> ways, once is enough :)
>>
>> This is not the case here though.
>>
>> This patch fixes an issue that can be stumbled upon in two ways. This is for
>> when multiple CPU ports are defined on the devicetree.
>>
>> As I explained to Russell, the first is the CPU_PORT field not matching the
>> active CPU port.
>>
>> The second is when port 5 becomes the only active CPU port. This can only
>> happen with the changing the DSA conduit support.
>>
>> The "prefer port 6" patch only prevents the first way from happening. The
>> latter still can happen. But this feature doesn't exist yet. Hence why I
>> think we should apply this series as-is (after some patch log changes) and
>> backport it without this patch on kernels older than 5.18.
>>
>> Arınç
> 
> I was following you until the last phrase. Why should we apply this series
> as-is [ to net.git ], if this patch fixes a problem (the *only* problem in
> lack of .port_change_master() support, aka for stable kernels) that is
> already masked by a different patch targeted to net.git?

Because I don't see the latter patch as a fix. It treats the symptom, 
not the cause.

Anyway, I'm fine with taking this patch from this series and put it on 
my series for net-next instead.

Arınç

