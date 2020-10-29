Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295E629F43E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgJ2Sqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgJ2Sqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 14:46:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8880206B6;
        Thu, 29 Oct 2020 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603997210;
        bh=/yM64ReMgF87Hwyv/ZYL+osCJxbb1ouFPVdxOacUs5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NjVz5QtEvoYzNe3DiTqkGO8NAvrd5AGW1Bl+IXfrfDmnBPDOdiESCssj6Opt3GFeu
         yWV0Ps/MLE4h+uk14TF5Qjd3QpqotRQ3PInjI+7imCVpg5Yo174nAwW6ihgo4RjzRo
         mLVfkfFx35j41UMu3yPKTrxE7S47xBxwnTQc+lTo=
Date:   Thu, 29 Oct 2020 11:46:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        rdunlap@infradead.org, dave.taht@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>,
        syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] netem: fix zero division in tabledist
Message-ID: <20201029114648.64e00e22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028111959.6ed6d2c2@hermes.local>
References: <20201028170731.1383332-1-aleksandrnogikh@gmail.com>
        <20201028111959.6ed6d2c2@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 11:19:59 -0700 Stephen Hemminger wrote:
> On Wed, 28 Oct 2020 17:07:31 +0000
> Aleksandr Nogikh <aleksandrnogikh@gmail.com> wrote:
> 
> > From: Aleksandr Nogikh <nogikh@google.com>
> > 
> > Currently it is possible to craft a special netlink RTM_NEWQDISC
> > command that can result in jitter being equal to 0x80000000. It is
> > enough to set the 32 bit jitter to 0x02000000 (it will later be
> > multiplied by 2^6) or just set the 64 bit jitter via
> > TCA_NETEM_JITTER64. This causes an overflow during the generation of
> > uniformly distributed numbers in tabledist(), which in turn leads to
> > division by zero (sigma != 0, but sigma * 2 is 0).
> > 
> > The related fragment of code needs 32-bit division - see commit
> > 9b0ed89 ("netem: remove unnecessary 64 bit modulus"), so switching to
> > 64 bit is not an option.
> > 
> > Fix the issue by keeping the value of jitter within the range that can
> > be adequately handled by tabledist() - [0;INT_MAX]. As negative std
> > deviation makes no sense, take the absolute value of the passed value
> > and cap it at INT_MAX. Inside tabledist(), switch to unsigned 32 bit
> > arithmetic in order to prevent overflows.
> > 
> > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > Reported-by: syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com  
> 
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>

Applied, thanks!
