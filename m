Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E8B63E283
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiK3VJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiK3VJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:09:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60A95474F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 13:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669842494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zuR/603fC7oK9nUlhZCLCOYS4yq/2eg7O9E/kbNn+vo=;
        b=NGqYR0J6lofamqBg7UXL6Yi6zKyEKUi9z+X7fDllO6pgJI7/EkrH1aqpPDktqomOW+s/wL
        NzC0bh05TwP1eit6Kq6Km95nPT4RqYMfdGJUl+2cj4vfWAEL2Uce0jiTYsUUnC6Ds8AFG7
        gCoK8OTKo68Ukh53By+6+0x9lWZ+nCU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-P7Q_RPQ6MReQE8k-yWfILw-1; Wed, 30 Nov 2022 16:08:12 -0500
X-MC-Unique: P7Q_RPQ6MReQE8k-yWfILw-1
Received: by mail-qk1-f200.google.com with SMTP id de43-20020a05620a372b00b006fae7e5117fso40921373qkb.6
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 13:08:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuR/603fC7oK9nUlhZCLCOYS4yq/2eg7O9E/kbNn+vo=;
        b=h/YCdix/Qse1PgjO5SUUS8Bo/16NU62hr4QZCbvxsLfHxqVoCV1zbvz1NWKpEylEk8
         B5b6nSKIH2yX+On/nDrX4w/8YzsS3E3TDzCTITuGY6OIS7PUHJBHyTmdjgxP6Gu22RZW
         1MfB/7VrvE12LMdnw+N+mpP3n83C8n0+YmM5GUuvWUT/7KirzMgbzommf8WPMedCAtU1
         4AoAssTHfvKJ+sP+naA2Wh6BOa8yjTelNPpzY0LT65rTKZV6KS2II2hjLv1qTuRGZzxF
         vwZLa6chFrOLbILE75ejXm1WnPCXh9g/bmDDPiw4pziBhjMYlHSODeSnJEimdNmqE1id
         /iqw==
X-Gm-Message-State: ANoB5pkWGThDeQUbX+Sm5DwpuzSpiXk92AalZccAQJyPfmq+bB8uCB/I
        7rnjdkKw+WqlCKwecI1tbVEgLru8ajtsH9nrDVYkV/AYVhdqhsHSmEdaWW5FiAT5gNW5GKjpe/q
        g9uCJY2LNX1sE9EzO
X-Received: by 2002:a0c:c3cc:0:b0:4c6:a05d:f67e with SMTP id p12-20020a0cc3cc000000b004c6a05df67emr40931291qvi.4.1669842491512;
        Wed, 30 Nov 2022 13:08:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6/8Pjy+T5/FfojJPxX4yLbLk/OTvhYqmsxgDyVe0BPtb/Wl3vgppylUjojOezJs9ZPj9Po4Q==
X-Received: by 2002:a0c:c3cc:0:b0:4c6:a05d:f67e with SMTP id p12-20020a0cc3cc000000b004c6a05df67emr40931260qvi.4.1669842491240;
        Wed, 30 Nov 2022 13:08:11 -0800 (PST)
Received: from x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a258a00b006fc92cf4703sm1898765qko.132.2022.11.30.13.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 13:08:10 -0800 (PST)
Date:   Wed, 30 Nov 2022 16:08:09 -0500
From:   Brian Masney <bmasney@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cth451@gmail.com
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <Y4fGORYQRfYTabH1@x1>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ex6WqiY8IdwfHe@lunn.ch>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 08:41:29PM +0100, Andrew Lunn wrote:
> On Wed, Nov 30, 2022 at 12:42:59PM -0500, Brian Masney wrote:
> > The Qualcomm sa8540p automotive development board (QDrive3) has an
> > Aquantia NIC wired over PCIe. The ethernet MAC address assigned to
> > all of the boards in our lab is 00:17:b6:00:00:00. The existing
> > check in aq_nic_is_valid_ether_addr() only checks for leading zeros
> > in the MAC address. Let's update the check to also check for trailing
> > zeros in the MAC address so that a random MAC address is assigned
> > in this case.
> > 
> > Signed-off-by: Brian Masney <bmasney@redhat.com>
> > ---
> >  drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> > index 06508eebb585..c9c850bbc805 100644
> > --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> > +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> > @@ -293,7 +293,8 @@ static bool aq_nic_is_valid_ether_addr(const u8 *addr)
> >  	/* Some engineering samples of Aquantia NICs are provisioned with a
> >  	 * partially populated MAC, which is still invalid.
> >  	 */
> > -	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0);
> > +	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0) &&
> > +		!(addr[3] == 0 && addr[4] == 0 && addr[5] == 0);
> 
> Hi Brian
> 
> is_valid_ether_addr()

aq_nic_ndev_register() already calls is_valid_ether_addr():

	if (is_valid_ether_addr(addr) &&
	    aq_nic_is_valid_ether_addr(addr)) {
		(self->ndev, addr);
	} else {
		...
	}

That won't work for this board since that function only checks that the
MAC "is not 00:00:00:00:00:00, is not a multicast address, and is not
FF:FF:FF:FF:FF:FF." The MAC address that we get on all of our boards is
00:17:b6:00:00:00.

Brian

