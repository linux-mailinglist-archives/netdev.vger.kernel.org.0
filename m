Return-Path: <netdev+bounces-10107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 037D872C487
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 411051C20BA9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89B01641D;
	Mon, 12 Jun 2023 12:39:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC98171CA;
	Mon, 12 Jun 2023 12:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AB9C433EF;
	Mon, 12 Jun 2023 12:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686573580;
	bh=s5OWn+vJ8rm4xIEu+0N/EO9cIklh3sUq0qSuiTLWKFw=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=snyk9/+Y+WRpdb3l80ci5t40I0wV7ygI6u3QQSl3/aa5IDM7bsPHc8maQwJDxur2e
	 pj6O2+5Q6p6nx1LUfY5qH64QxsTekbTwPKYwBG32GD2Fb9gw2nWvuDdYPExOasA6L/
	 WDz/AzRja0GR/GMJUXi0QpeKw/ls7TCZHSSwi5avRxM87LI7bHk1B/nINGg1sGgFIg
	 s9yzcLd5jr9MnR24M1ZAMHQ+rsAIzLFjFl42DzhD9CmFk5zQWKeM2Wk9+toYMXew7B
	 q3ctxoOolEXArYeMAgHEwW9A6X3/ZWAFleAkJ2SnsHZjO0KlesP+ra+FVJYPcQAj9v
	 +hTiyEuBP9Ldg==
From: Kalle Valo <kvalo@kernel.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Andrey Rakhmatullin <wrar@wrar.name>,  Linux regressions mailing list <regressions@lists.linux.dev>,  linux-wireless@vger.kernel.org,  Neil Chen <yn.chen@mediatek.com>,  Deren Wu <deren.wu@mediatek.com>,  Lorenzo Bianconi <lorenzo@kernel.org>,  Felix Fietkau <nbd@nbd.name>,  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  netdev <netdev@vger.kernel.org>
Subject: Re: MT7922 problem with "fix rx filter incorrect by drv/fw inconsistent"
References: <ZGY4peApQnPAmDkY@durkon.wrar.name>
	<ad948b42-74d3-b4f1-bbd6-449f71703083@leemhuis.info>
	<ZGtsNO0VZQDWJG+A@durkon.wrar.name>
	<cd7d298b-2b46-770e-ed54-7ae3f33b97ee@leemhuis.info>
	<c647de2d-fbb5-4793-99b3-b800c95c04c2@leemhuis.info>
Date: Mon, 12 Jun 2023 15:39:35 +0300
In-Reply-To: <c647de2d-fbb5-4793-99b3-b800c95c04c2@leemhuis.info> (Thorsten
	Leemhuis's message of "Fri, 2 Jun 2023 14:03:59 +0200")
Message-ID: <87jzw8g8hk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thorsten Leemhuis <regressions@leemhuis.info> writes:

> [CCing the wifi-driver and the net developers, as a "JFYI" to ensure
> they are aware of this "newer kernel requires newer firmware"
> regression, so they can jump in if they want]
>
> On 22.05.23 16:12, Thorsten Leemhuis wrote:
>> On 22.05.23 15:20, Andrey Rakhmatullin wrote:
>>> On Mon, May 22, 2023 at 03:00:30PM +0200, Linux regression tracking
>>> #adding (Thorsten Leemhuis) wrote:
>>>> On 18.05.23 16:39, Andrey Rakhmatullin wrote:
>>>>> Hello. I have a "MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless
>>>>> Network Adapter" (14c3:0616) and when the commit c222f77fd4 ("wifi: m=
t76:
>>>>> mt7921: fix rx filter incorrect by drv/fw inconsistent") is applied (=
found
>>>>> by bisecting, checked by reverting it on v6.3) I have the following
>>>>> problem on my machine: when I connect to my router no DHCPv4 exchange
>>>>> happens, I don't see responses in tcpdump. My network setup is non-tr=
ivial
>>>>> though, and it looks like the problem is specific to it, but I still
>>>>> wonder if it's some bug in the aforementioned patch as my setup works=
 with
>>>>> all other devices and I would expect it to work as long as the network
>>>>> packets sent by the device are the same.
>>>>>
>>>>> My setup is as follows: I have an ISP router which provides a 2.4GHz
>>>>> network and another router (Xiaomi R4AC with OpenWRT) connected by
>>>>> Ethernet to it that provides a 5GHz network and is configured as a "R=
elay
>>>>> bridge" (using relayd) to forward packets to the ISP router and back.=
 This
>>>>> includes DHCPv4 packets, which are handled by the ISP router. tcpdump=
 on
>>>>> the machine with MT7922 shows that the DHCP requests are sent while t=
he
>>>>> responses are not received, while tcpdump on the bridge router shows =
both
>>>>> requests and responses.
>>>>>
>>>>> I've tried connecting the machine to the ISP router network directly =
and
>>>>> also to another AP (one on my phone) and those work correctly on all
>>>>> kernels.
>>>
>>> Deren Wu asked me privately
>>> if I'm using the latest firmware, and I
>>> wasn't. I updated the firmware and now the problem doesn't happen.
>>> The firmware where the problem happens is
>>> mediatek/WIFI_RAM_CODE_MT7922_1.bin from the linux-firmware commit
>>> e2d11744ef (file size 826740, md5sum 8ff1bdc0f54f255bb2a1d6825781506b),
>>> the one where the problem doesn't happen is from the commit 6569484e6b
>>> (file size 827124, md5sum 14c08c8298b639ee52409b5e9711a083).
>>=20
>> FWIW, just checked: that commit is from 2023-05-15, so quite recent.
>>=20
>>> I haven't
>>> tried the version committed between these ones.
>>> Not sure if this should be reported to regzbot and if there are any
>>> further actions needed by the kernel maintainers.
>>=20
>> Well, to quote the first sentence from
>> Documentation/driver-api/firmware/firmware-usage-guidelines.rst
>>=20
>> ```Users switching to a newer kernel should *not* have to install newer
>> firmware files to keep their hardware working.```
>>=20
>> IOW: the problem you ran into should not happen. This afaics makes it a
>> regression that needs to be addressed -- at least if it's something that
>> is likely to hit others users as well. But I'd guess that's the case.
>
> Well, until now I didn't see any other report about a problem like this.
> Maybe things work better for others with that hardware =E2=80=93 in that =
case it
> might be something not worth making a fuzz about. But I'll wait another
> week or two before I remove this from the tracking.

Yeah, this is bad. mt76 (or any other wireless driver) must not require
a new firmware whenever upgrading the kernel. Instead the old and new
firmware should coexist (for example have firmware-2.bin for the new
version and firmware.bin for the old version). Then mt76 should first
try loading the new firmware (eg. firmware-2.bin) and then try the old
one (eg. firmware.bin).

Should we revert commit c222f77fd4 or how to solve this?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

