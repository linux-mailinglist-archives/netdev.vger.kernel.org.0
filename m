Return-Path: <netdev+bounces-10455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A83DE72E925
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD6FD2811ED
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198D330B60;
	Tue, 13 Jun 2023 17:15:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7CB33E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:15:34 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD48B19B7;
	Tue, 13 Jun 2023 10:15:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686676491; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lz3sdfZjEVjsHOHX1i+1kne1PU5B10VTEJ44ohq/FmwWqdNKwhrNoLHDhK2b759ZrPb8QW+aOxebY9rvuEy9BoHRf5UpGzM3OOhCGbwpastP8gtNxAGk354KLiUpNrvUetaRV8ukyVo8hVZw+yy86/Bl/AvalnYDJc3UdQ8HVTQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686676491; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=nEMtIqngoCAEAyT+fpf/LXjugwgNpXqZT2MooeG0VEk=; 
	b=UCzvd6VAF+Y+FiklAgTUDa75yDjZBBA8aVVlr6qHHCd5l4TjL7Am1DMeHAaGKCjiPt8lzCoKr0BTpRsFaFG88oyFmaI1rzhBgeU/tIQoqgOcGCIhNcwM19CnhUGL3vWTsDBVyd7KSJVeMx6RoTeKEHW1r7ACx+XUxfPNpnegl4U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686676491;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=nEMtIqngoCAEAyT+fpf/LXjugwgNpXqZT2MooeG0VEk=;
	b=AjM/jtql6fiVufSKKLUDB2frT5CoRHbXUAhS6wYCvEJ/OeIkFE9tAPWHv+b1r/0f
	s62ZjndlrGNUMdHbnpy2k2X0cUMV4h7iIxxl6XkJC7fCzely07TlDuXhGDat4fiKbOz
	IieXNrnAKjgBiEjKdb06JgsFBfgOK65omjiwfkKc=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686676484920865.7792338096236; Tue, 13 Jun 2023 10:14:44 -0700 (PDT)
Message-ID: <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
Date: Tue, 13 Jun 2023 20:14:35 +0300
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
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230613150815.67uoz3cvvwgmhdp2@skbuf>
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

On 13.06.2023 18:08, Vladimir Oltean wrote:
> On Sun, Jun 11, 2023 at 11:15:42AM +0300, Arınç ÜNAL wrote:
>> The CPU_PORT bits represent the CPU port to trap frames to for the MT7530
>> switch. This switch traps frames to the CPU port set on the CPU_PORT bits,
>> regardless of the affinity of the user port which the frames are received
>> from.
>>
>> When multiple CPU ports are being used, the trapped frames won't be
>> received when the DSA conduit interface, which the frames are supposed to
>> be trapped to, is down because it's not affine to any user port. This
>> requires the DSA conduit interface to be manually set up for the trapped
>> frames to be received.
>>
>> To fix this, implement ds->ops->master_state_change() on this subdriver and
>> set the CPU_PORT bits to the CPU port which the DSA conduit interface its
>> affine to is up. Introduce the active_cpu_ports field to store the
>> information of the active CPU ports. Correct the macros, CPU_PORT is bits 4
>> through 6 of the register.
>>
>> Add comments to explain frame trapping for this switch.
>>
>> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
>> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> My only concern with this patch is that it depends upon functionality
> that was introduced in kernel v5.18 - commit 295ab96f478d ("net: dsa:
> provide switch operations for tracking the master state"). But otherwise
> it is correct, does not require subsequent net-next rework, and
> relatively clean, at least I think it's cleaner than checking which of
> the multiple CPU ports is the active CPU port - the other will have no
> user port dp->cpu_dp pointing to it. But strictly, the master_state_change()
> logic is not needed when you can't change the CPU port assignment.
> 
> It might also be that your patch "net: dsa: introduce
> preferred_default_local_cpu_port and use on MT7530" gets backported
> to stable kernels that this patch doesn't get backported to, and then,
> we have a problem, because that will cause even more breakage.
> 
> I wonder if there's a way to specify a dependency from this to that
> other patch, to ensure that at least that does not happen?

Actually, having only "net: dsa: introduce 
preferred_default_local_cpu_port and use on MT7530" backported is an 
enough solution for the current stable kernels.

When multiple CPU ports are defined on the devicetree, the CPU_PORT bits 
will be set to port 6. The active CPU port will also be port 6.

This would only become an issue with the changing the DSA conduit 
support. But that's never going to happen as this patch will always be 
on the kernels that support changing the DSA conduit.

Arınç

