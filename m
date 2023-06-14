Return-Path: <netdev+bounces-10608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BAB72F55A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7EA41C20CB4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D5AA41;
	Wed, 14 Jun 2023 07:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6C7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:03:56 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E40026AE;
	Wed, 14 Jun 2023 00:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686726193; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=eJTifTyYgGcPzxCctIdJakliNCFsBfAaDCSwP3fUV9eDuM6CJ8E+p+pyVxEatxnz9QfeQgNI/XuNv1W96FkUbVMXwHdMWnJVvNAEDNMdRqZqtNpSnrGDNsSaRbH5ajAFUrfFeqIGeEblyxQK3fMAYWgwKGTLBcAaDvILFHc4pKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686726193; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=oJwgPQC2BwdnxxzQhr0yGnFZDYEmDJB1f6/H0IgSem8=; 
	b=iGQaj/HpWkYK6ForEf6NTKA+6h4l02d/PcXRVta4nX7f7Sao3JAqt/8undzdvbeaRM2bU2o06MuFo+lzOF1bUUoXaKbla1OLdSUYl8quo8OKt5CdGuqX7J0XzbQCTRY0kctedUmg05gVrKKVkH3jspoy2od1+dCKXvkroMIrUyw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686726193;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=oJwgPQC2BwdnxxzQhr0yGnFZDYEmDJB1f6/H0IgSem8=;
	b=hnPn2XGeaus6xnqt2z6/Ktgagn2ZhNHPpEgDoIZqnUeemHQYNtD4lbwnCAmxXv+O
	Cs9mVBjJw70BiHfxjZmHIXF2l506VOMSAuzsT6gsjRPOeL2BJAANG4zEK5tue+YE8QZ
	hMjaf1tufnAL0LHBVlZJSW/V1pTf+UhLExdUal20=
Received: from [192.168.99.141] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686726191889463.047827467051; Wed, 14 Jun 2023 00:03:11 -0700 (PDT)
Message-ID: <ba072bab-a6af-b6bf-e3c2-de07b1003d41@arinc9.com>
Date: Wed, 14 Jun 2023 10:03:04 +0300
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
References: <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
 <20230613201850.5g4u3wf2kllmlk27@skbuf>
 <4a2fb3ac-ccad-f56e-4951-e5a5cb80dd1b@arinc9.com>
 <20230613205915.rmpuqq7ahmd7taeq@skbuf>
 <dd0d716e-8fdc-b6dc-3870-e7e524e8bf49@arinc9.com>
 <20230613211432.dc66py7nh34ehiv4@skbuf>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613211432.dc66py7nh34ehiv4@skbuf>
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

On 14.06.2023 00:14, Vladimir Oltean wrote:
> On Wed, Jun 14, 2023 at 12:04:10AM +0300, Arınç ÜNAL wrote:
>> Because I don't see the latter patch as a fix. It treats the symptom, not
>> the cause.
>>
>> Anyway, I'm fine with taking this patch from this series and put it on my
>> series for net-next instead.
> 
> Right, but what seems to have been the case during the net.git
> (and linux-stable.git) triage so far is that user impact matters.
> A configuration that works by coincidence and not by intention, but
> otherwise works reliably, still works, at the end of the day.
> 
> If you read the weekly net.git pull requests sent to Linus Torvalds,
> you'll see that maintainers try to make a summary of what had to be
> changed and why. There isn't really a strong reason why this patch *has*
> to be in those pull requests. That's kind of the mindset of what makes
> "stable" "stable".

Makes sense. I have prepared v5 that addresses everything so far, should 
I send it today now that Russell has reviewed v4?

Arınç

