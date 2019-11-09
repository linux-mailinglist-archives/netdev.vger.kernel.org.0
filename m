Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE36F600A
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfKIPd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:33:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfKIPd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 10:33:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bmMlvm43vvatROWUZECim0DHOI/WF5PoHgKjWYS09fU=; b=EOSOGt7AEsxbrxh965B81UGJl0
        QZZuQCN/4XQ0Ta6H7IUkD7OeHOydgw2HZxZqM+s9GAcdFYmYBXsQWJLiHR6F6OH8pZ9lGK7dTVwaO
        1d9ZrI0n2oaZXYSyn3shztU8kL4X1PZTeuILtCUmq/CvGmMk2qf/SNsBR6VQqIusAm1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTSkN-0002oC-TV; Sat, 09 Nov 2019 16:33:55 +0100
Date:   Sat, 9 Nov 2019 16:33:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20191109153355.GK22978@lunn.ch>
References: <20191109124205.11273-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109124205.11273-1-popadrian1996@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 02:42:05PM +0200, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
> 
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
> 
> Page 0x00 (lower and higher memory) are always implemented, so the ethtool
> expects at least 256 bytes if the identifier matches the one for QSFP-DD.
> For optical connected cables, additional pages are usually available (the
> contain module defined  thresholds or lane diagnostic information). In
> this case, ethtool expects to receive 768 bytes in the following format:
> 
>     +----------+----------+----------+----------+----------+----------+
>     |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
>     |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
>     |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
>     |   128B   |   128B   |   128B   |   128B   |   128B   |   128B   |
>     +----------+----------+----------+----------+----------+----------

Hi Adrian

Which in kernel driver is using this format? As far as i can see, only
mlx5 makes use of ETH_MODULE_SFF_8436_MAX_LEN, which is 640
bytes. After a very quick look, i could not see any driver returning
768 bytes.

     Andrew
