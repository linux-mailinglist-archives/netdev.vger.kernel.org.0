Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3F3EC395
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhHNPhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 11:37:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234654AbhHNPha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 11:37:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sQ+X1nOHW0Y0aKmJBa2mRiazMXs7QZuokAPbxAsRxD8=; b=CXjZYPd1IemzfTg8ePhC5u+qAZ
        DMCZ7sDD/HiJ5Bzd7wpXV5whRszPhza9An+wS0GMnysZPWmrk453W03AqviTRhhC00uCG+TwPA+jf
        SzziaMxz8SY1gdR6LGuA4Rkr+qZEI8jrZ4N9k0x9gpaU60jowtWlvKLeS7csl5HrXRO0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEviQ-00050a-RI; Sat, 14 Aug 2021 17:36:54 +0200
Date:   Sat, 14 Aug 2021 17:36:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] net: asix: fix uninit value bugs
Message-ID: <YRfjFr9GbcoJrycc@lunn.ch>
References: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210814135505.11920-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814135505.11920-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 04:55:05PM +0300, Pavel Skripkin wrote:
> Syzbot reported uninit-value in asix_mdio_read(). The problem was in
> missing error handling. asix_read_cmd() should initialize passed stack
> variable smsr, but it can fail in some cases. Then while condidition
> checks possibly uninit smsr variable.
> 
> Since smsr is uninitialized stack variable, driver can misbehave,
> because smsr will be random in case of asix_read_cmd() failure.
> Fix it by adding error handling and just continue the loop instead of
> checking uninit value.
> 
> Also, same loop was used in 3 other functions. Fixed uninit value bug
> in them too.

Hi Pavel

Which suggests it might make sense to refactor the code to make a
helper? I will leave you to decide if you want to do that.

The code does looks correct now.

	Andrew
