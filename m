Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56875EE0B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfD3Ass (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:48:48 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46177 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3Ass (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:48:48 -0400
Received: by mail-oi1-f195.google.com with SMTP id d62so4035355oib.13;
        Mon, 29 Apr 2019 17:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3LLCrVwndh89HDrUTbNFdjB4RLNuFL662PMbx3f2tgA=;
        b=p0Xl1k5oIWsQs8405r3zG6j2KZOYdkbDMkt/8Cfu+gE5pQnci8qOgI/p8CF+KbSfnd
         DWUiGqwvycW08yjGflfZ2n4DTMYgGzYM8HpqfBN8ys44p71fjeLg5ASsh0E99lgN5VWr
         kg500B3Dm2yghv0KsjvvJzie0bY+R4zQp9Ol7E6IpDBiMvwxyOg7E08DBPkY9x6Sku7c
         q56NmrcwmSErTfBEZDZxoG9B3N0bn0uX6GGZKh67ZRk0YyFFgQQ51/pBOkaId2z9q34y
         iofoh6jzhD8bcFzdnjDYNrmuq/BvrhR2nwKYpTd93RXRcQqSnUfQls01tP14VsuBpJCd
         L8tQ==
X-Gm-Message-State: APjAAAUds4EF76oOQEeY4EOBzZMbIgZBvcJg4bO8XEfH7rNFaE2wPVbM
        Ukxafcd6LtdIA8sMgRWB+ZCzdDc=
X-Google-Smtp-Source: APXvYqz3+NrqGRV8jIzOYetoWp5GwMwH0s9yuWbug5KeFIA4ZT8NuRKChaeSv18Sd6RkIlHDlFH4qA==
X-Received: by 2002:aca:d7c6:: with SMTP id o189mr1373207oig.2.1556585327162;
        Mon, 29 Apr 2019 17:48:47 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 88sm16415422otj.3.2019.04.29.17.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 17:48:45 -0700 (PDT)
Date:   Mon, 29 Apr 2019 19:48:45 -0500
From:   Rob Herring <robh@kernel.org>
To:     Frank Rowand <frowand.list@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] of_net: add mtd-mac-address support to
 of_get_mac_address()
Message-ID: <20190430004845.GA29722@bogus>
References: <1555445100-30936-1-git-send-email-ynezz@true.cz>
 <d29bcf08-9299-8f2c-00bc-791b60658581@gmail.com>
 <93770c6a-5f99-38f6-276b-316c00176cac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93770c6a-5f99-38f6-276b-316c00176cac@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 16, 2019 at 08:01:56PM -0700, Frank Rowand wrote:
> Hi Rob,
> 
> On 4/16/19 5:29 PM, Florian Fainelli wrote:
> > 
> > 
> > On 16/04/2019 13:05, Petr Štetiar wrote:
> >> From: John Crispin <john@phrozen.org>
> >>
> >> Many embedded devices have information such as MAC addresses stored
> >> inside MTD devices. This patch allows us to add a property inside a node
> >> describing a network interface. The new property points at a MTD
> >> partition with an offset where the MAC address can be found.
> >>
> >> This patch has originated in OpenWrt some time ago, so in order to
> >> consider usefulness of this patch, here are some real-world numbers
> >> which hopefully speak for themselves:
> >>
> >>   * mtd-mac-address                used 497 times in 357 device tree files
> >>   * mtd-mac-address-increment      used  74 times in  58 device tree files
> >>   * mtd-mac-address-increment-byte used   1 time  in   1 device tree file
> >>
> >> Signed-off-by: John Crispin <john@phrozen.org>
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> [cleanup of the patch for upstream submission]
> >> Signed-off-by: Petr Štetiar <ynezz@true.cz>
> >> ---
> > 
> > [snip]
> > 
> >> +static const void *of_get_mac_address_mtd(struct device_node *np)
> >> +{
> >> +#ifdef CONFIG_MTD
> >> +    void *addr;
> >> +    size_t retlen;
> >> +    int size, ret;
> >> +    u8 mac[ETH_ALEN];
> >> +    phandle phandle;
> >> +    const char *part;
> >> +    const __be32 *list;
> >> +    struct mtd_info *mtd;
> >> +    struct property *prop;
> >> +    u32 mac_inc = 0;
> >> +    u32 inc_idx = ETH_ALEN-1;
> >> +    struct device_node *mtd_np = NULL;
> > 
> > Reverse christmas tree would look a bit nicer here.
> 
> Do we a variable declaration format preference for drivers/of/*?

We'd better get one. It's all the rage.

How about fallen Christmas tree:

	int a;
	bool fallen;
	char christmas_tree;
	int for_our;
	int dt;

Rob
