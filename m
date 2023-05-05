Return-Path: <netdev+bounces-521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B13C6F7F19
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65CE0280F75
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A4D1FCE;
	Fri,  5 May 2023 08:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19CE6FBA
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FF73C433D2;
	Fri,  5 May 2023 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683275420;
	bh=Xh+MAs5cv5wNzyY4Qb3IokgWAMpQ9j0XmCCpo/doi/8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ns9suoPaM+L7RW4vZCeWKcmdi0BoMwFyWhyCMKS36YLyz2t87PSCa8uSUR3UfYyaq
	 70bgoSoT5zVGNWrZ6A+5s3Am+/XUQJsomNH7XCN26jHYMkaaPLhgVgekLMBLj0pAOo
	 4A61Q5pmmk0AQbXhfUPbp7tHfo8/nhHbzh9KrwMN/hnpLxG2cA29VRY+2wibUpOYYy
	 lSYiiu2qeed7NOopvTxlNfF2O1XANEiGJzL66P89NkU6hx98HGT4atGyP/4WrnUbQZ
	 qWI9XUv27UO4bOUVQnEs20uRbEITLxOqZkFX9Vd7CcNWPxrnTwZT9IRco7H/B3jqi+
	 0x/ZBoeY5emmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5EC97E5FFC4;
	Fri,  5 May 2023 08:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 1/2] net: dsa: mt7530: fix corrupt frames using trgmii
 on 40 MHz XTAL MT7621
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327542038.4615.4214008191819438520.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:30:20 +0000
References: <20230502210947.6815-1-arinc.unal@arinc9.com>
In-Reply-To: <20230502210947.6815-1-arinc.unal@arinc9.com>
To: =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmM5LnVuYWxAZ21haWwuY29tPg==?=@codeaurora.org
Cc: sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
 daniel@makrotopia.org, andrew@lunn.ch, f.fainelli@gmail.com,
 olteanv@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, opensource@vdorst.com,
 arinc.unal@arinc9.com, bartel.eerdekens@constell8.be,
 richard@routerhints.com, vschagen@cs.com, frank-w@public-files.de,
 mithat.guner@xeront.com, erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 May 2023 00:09:46 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The multi-chip module MT7530 switch with a 40 MHz oscillator on the
> MT7621AT, MT7621DAT, and MT7621ST SoCs forwards corrupt frames using
> trgmii.
> 
> This is caused by the assumption that MT7621 SoCs have got 150 MHz PLL,
> hence using the ncpo1 value, 0x0780.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/2] net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
    https://git.kernel.org/netdev/net/c/37c218d8021e
  - [v3,net,2/2] net: dsa: mt7530: fix network connectivity with multiple CPU ports
    https://git.kernel.org/netdev/net/c/120a56b01bee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



