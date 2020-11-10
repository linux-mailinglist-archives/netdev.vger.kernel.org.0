Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8352ADB6B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgKJQQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJQQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 11:16:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DCAD206E3;
        Tue, 10 Nov 2020 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605025017;
        bh=4gmtA/yuGGJcTi7/FecgJWoThfPjpjrkVVDpswNAn04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eRHRE0GQdUDjBsHOwvVGyY3UMntZbQj8kYMGipRJrkAtp3MOF+S5VZPn8Y9+Qy065
         X+AYPIHg84GFG4cmVT/OfNcaeNd6IYoBazm727azzL6+97st5Kv0cogUSqy6zJTr5l
         7k/XI4p3rJTYb43PVCTbSuat90kb7bTXhrCt59Kg=
Date:   Tue, 10 Nov 2020 08:16:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Message-ID: <20201110081655.29cbcd34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110111932.GS595944@mussarela>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
        <20201013171849.236025-2-kleber.souza@canonical.com>
        <20201016153016.04bffc1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201109114828.GP595944@mussarela>
        <20201109094938.45b230c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201109210909.GQ595944@mussarela>
        <20201109131554.5f65b2fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201109213134.GR595944@mussarela>
        <20201109141553.30e9d502@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201110111932.GS595944@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:19:32 -0300 Thadeu Lima de Souza Cascardo wrote:
> Yeah, I agree with your initial email. The patch I submitted for that fix needs
> rework, which is what I tried and failed so far. I need to get back to some
> testing of my latest fix and find out what needs fixing there.
> 
> But I am also saying that simply doing a del_timer_sync on disconnect paths
> won't do, because there are non-disconnect paths where there is a CCID that we
> will remove and replace and that will still trigger a timer UAF.
> 
> So I have been working on a fix that involves a refcnt on ccid itself. But I
> want to test that it really fixes the problem and I have spent most of the time
> finding out a way to trigger the timer in a race with the disconnect path.

Sounds good, thanks a lot for working on this!

> And that same test has showed me that this timer UAF will happen regardless of
> commit 2677d20677314101293e6da0094ede7b5526d2b1, which led me into stating that
> reverting it should be done in any case.
> 
> I think I can find some time this week to work a little further on the fix for
> the time UAF.

