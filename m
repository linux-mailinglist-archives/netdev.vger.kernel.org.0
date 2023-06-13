Return-Path: <netdev+bounces-10473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE0372EA97
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9378D1C20889
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B4C3C0BC;
	Tue, 13 Jun 2023 18:12:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B24038CA4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82C3C433D9;
	Tue, 13 Jun 2023 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686679940;
	bh=ki+xIq/Dtd9uylVNt8VBujumNOAojzQwiYYysPBIzcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hBhEDrl4b8DDCLZU8lDdDOYrB0LSlfpGhPq1VZj+bHO12jCDh3U+pK/tzcaq1z8lV
	 JtCGVSdsyZDbMN4gHGtaow3ty0MNeGKIwp1KxZnb2XcDVs8mDxWSDW/ah48vkJOBzP
	 TCITMHrsqHCnZxeTdojdkzXP8siv3Bzcb8HWrUI59/C6xhTb3ghvXvOMyCuFWszrds
	 mb9yb2LtSZam88vyxKBwb+zYPpk6KMHWBFS5G4xcIbZvPqEOlBbUat0ePSe/uMdyJ8
	 cTqtnF0ag1mr9lVl+z2xwunbrQzwAyETLw5kqSrdtWDlBoGcVn32WaNZ/DoQG61KLp
	 ZcP74nuDe0zuA==
Date: Tue, 13 Jun 2023 11:12:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, Daniel Golle
 <daniel@makrotopia.org>, Landen Chao <Landen.Chao@mediatek.com>, DENG
 Qingfang <dqfext@gmail.com>, Sean Wang <sean.wang@mediatek.com>, Andrew
 Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>, Frank Wunderlich
 <frank-w@public-files.de>, Bartel Eerdekens
 <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613111218.0e1b3e9f@kernel.org>
In-Reply-To: <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
	<20230611081547.26747-2-arinc.unal@arinc9.com>
	<20230613150815.67uoz3cvvwgmhdp2@skbuf>
	<a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
	<20230613171858.ybhtlwxqwp7gyrfs@skbuf>
	<20230613172402.grdpgago6in4jogq@skbuf>
	<ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
	<20230613173908.iuofbuvkanwyr7as@skbuf>
	<edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Jun 2023 20:58:33 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> > Ok. I see Russell has commented on v4, though I don't see that he parti=
cularly
> > pointed out that this fixes a problem which isn't yet a problem. I got =
lost in
> > all the versions. v2 and v3 are out of my inbox now :) =20
>=20
> All good, I had to quickly roll v3 as v2 had wrong author information=20
> and I couldn't risk getting v2 applied.

FWIW you can reply with pw-bot: changes-requested to your own patches
and the bot should discard them from patchwork.

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#updatin=
g-patch-status

It's a new capability that nobody has used, yet, so YMMV :)

