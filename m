Return-Path: <netdev+bounces-10247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA6572D355
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22CBD2810D1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652AB22D6E;
	Mon, 12 Jun 2023 21:31:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5761CC8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:31:17 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB82FC;
	Mon, 12 Jun 2023 14:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=zcs7vbJ+dT3FNoyXVEVaqikD5SEwbga+mp6r1Zac2GE=; b=do
	iczImvW+nqqpPGSB62AOj+Ja5thmyAB7XaMTaexqie/pxquIq2HitqNMr1Lg4F3W0NtvpUhERLQUa
	RWIz7RZ5B7A++GmhcUMyNYwNHocW0D2WaUR3dlBIVs3UJ+iPAUfFfs1j9zxCr1H8EsAkUjKCVsFib
	oyXKWAbCOmGfZUY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8p7M-00Fe7g-NA; Mon, 12 Jun 2023 23:30:28 +0200
Date: Mon, 12 Jun 2023 23:30:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: arinc9.unal@gmail.com,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 0/7] net: dsa: mt7530: fix multiple CPU ports,
 BPDU and LLDP handling
Message-ID: <66751af3-db5e-432a-859f-97e54c930e00@lunn.ch>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <ZIcDee2+Lz7nJ3j6@shell.armlinux.org.uk>
 <ZIeFjdxctcR4yRLZ@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZIeFjdxctcR4yRLZ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 09:52:29PM +0100, Russell King (Oracle) wrote:
> On Mon, Jun 12, 2023 at 12:37:29PM +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > Please slow down your rate of patch submission - I haven't had a chance
> > to review the other patches yet (and I suspect no one else has.) Always
> > allow a bit of time for discussion.
> > 
> > Just because you receive one comment doesn't mean you need to rush to
> > get a new series out. Give it at least a few days because there may be
> > further discussion of the points raised.
> > 
> > Sending new versions quickly after previous comments significantly
> > increases reviewer workload.
> 
> And a very illustratory point is that I responded with a follow up to
> your reply on v2, hadn't noticed that you'd sent v4, and the comments
> I subsequently made on v2 apply to v4... and I haven't even looked at
> v3 yet.

Hi Arınç

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

says:

  don't repost your patches within one 24h period

  2.6.6. Resending after review¶

  Allow at least 24 hours to pass between postings. This will ensure
  reviewers from all geographical locations have a chance to chime
  in. Do not wait too long (weeks) between postings either as it will
  make it harder for reviewers to recall all the context.
 
  Make sure you address all the feedback in your new posting. Do not
  post a new version of the code if the discussion about the previous
  version is still ongoing, unless directly instructed by a reviewer.

During a weekend, i would say 24 hours is way too short, and 3 days is
more like it, given that for a lot of people being a Maintainer is a
day job, 9-5 week days.

You should also try to gauge how fast Maintainers are reacting. 24
hours is often too fast. You know Russell is interested in these
patches, so don't send a new version until you actually get feedback
from him, and the discussion has come to a conclusion.

     Andrew

