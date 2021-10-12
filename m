Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F179142AA13
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhJLQz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhJLQz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 140DB604DC;
        Tue, 12 Oct 2021 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634057637;
        bh=JKUuRorKTxYm5ckk2Kie/A1jzOt25RuUH7zV7NVl70c=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=s8qpmMsB0CfueyurHXojUonqmtmNu90a/B60lDorRlnSuFiIiHqqebyQqodlctNBp
         qnifGQN1VdPaxDkDeSV0ZAGEDQHRZlo4CZOxn7F24Y83B+aDFg1fHxN1L8MEL5p3PR
         42N9IISbBrMGedrKKdG/jCkaMn2Z5Bgsix4cL8nXB9cySpbJO7aaAcvjX2YiaN5Lvz
         A0lDlJ3HZex86KjhRiQh1k3iPMtwRELrkglqrkaLw7SpvOX6g7kzjlhY5DusExvdLR
         3icgxcrZyL0awwm3XBWh/mR0t/++xUs+vjxtYsf6RuZK6J5prGUN/SfDOkNzAVY8VM
         D67uRAZhnmG+w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <419c2d47-4748-8ba4-613c-cc99558eeb48@seco.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com> <163402758460.4280.9175185858026827934@kwain> <419c2d47-4748-8ba4-613c-cc99558eeb48@seco.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org
Message-ID: <163405763441.451779.12901535219994696652@kwain>
Date:   Tue, 12 Oct 2021 18:53:54 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Sean Anderson (2021-10-12 18:34:50)
> On 10/12/21 4:33 AM, Antoine Tenart wrote:
> > Quoting Sean Anderson (2021-10-11 18:55:16)
> >> As the number of interfaces grows, the number of if statements grows
> >> ever more unweildy. Clean everything up a bit by using a switch
> >> statement. No functional change intended.
>=20
> > Maybe you could try a mixed approach; keeping the invalid modes checks
> > (bitmap_zero) at the beginning and once we know the mode is valid using
> > a switch statement. That might make it easier to read as this should
> > remove lots of conditionals. (We'll still have the one/_NA checks
> > though).
>=20
> This is actually the issue I wanted to address. The interface checks are
> effectively performed twice or sometimes three times. There are also
> gotos in the original design to deal with e.g. 10GBASE not having
> 10/100/1000 modes. This makes it easy to introduce bugs when adding new
> modes, such as what happened with SGMII.

I don't think having 1) validity checks 2) availability checks is an
issue. It's a choice between having possible bugs because the two steps
aren't synced vs possible bugs because one of the multiple paths in the
switch gets slightly broken by a patch. IMHO the one easier to read and
follow should win here.

Antoine
