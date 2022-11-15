Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A280E628FD1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 03:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiKOCRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 21:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKOCRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:17:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B81C750;
        Mon, 14 Nov 2022 18:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB88B8164F;
        Tue, 15 Nov 2022 02:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BDBC433D6;
        Tue, 15 Nov 2022 02:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668478634;
        bh=4G9rM5GyCs9KUnWAB86MPtmNNb//3iFZFJvNSZg7pEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=akO22M5N8I/TuGi6Ti78V9XRT1EHtbDn3OEjbkxcdofYCeo8I344XMhIx10gZzxWa
         k+igRKHC7/XmFQ7OzU+x5uYA3VpDtPygDl0lKACv85+++cDp+re0vcAQJO49uM2BFr
         3lpzJkF+OnWYfbWHSVCXgJsrifQyrCPIgmoc+UYTBIESf2UjkAvKHcZh+J3rHgRhYV
         Z2HUWTSYVp8ixsDAIRk+JqFAhvKpSFmn9+Gnl79k9W111CC87ilk5xTjyGoK4VABpo
         lAdgGBNNFRZGta/1VriT0yDz2xNHnJrlWK2VXE/fn8pKTzmiFYgD6qXD7dChClgyq6
         TAlilC3m4+pNg==
Date:   Mon, 14 Nov 2022 18:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: use NET_NAME_PREDICTABLE for user ports with
 name given in DT
Message-ID: <20221114181712.51856dd4@kernel.org>
In-Reply-To: <26d3b005-aa4e-66d3-32eb-568d3dfe6379@rasmusvillemoes.dk>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
        <Y26B8NL3Rv2u/otG@lunn.ch>
        <26d3b005-aa4e-66d3-32eb-568d3dfe6379@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Nov 2022 21:03:52 +0100 Rasmus Villemoes wrote:
> > I know it is a change in behaviour, but it seems like NET_NAME_ENUM
> > should be used, not NET_NAME_UNKNOWN. alloc_etherdev_mqs() uses
> > NET_NAME_ENUM.  
> 
> I don't really have any strong opinion on the case where we fall back to
> eth%d, as its not relevant to any board I've worked on.
> 
> > https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/netdevice.h#L42
> > says that NET_NAME_UNKNOWN does not get passed to user space, but i
> > assume NET_NAME_ENUM does. So maybe changing it would be an ABI
> > change?  
> 
> Well, the name_assign_type ABI is kind of silly. I mean, userspace knows
> that when one gets EINVAL trying to read the value, that really means
> that the value is NET_NAME_UNKNOWN. But I won't propose changing that.
> 
> However, what I do propose here is obviously already an ABI change; I
> _want_ to expose more proper information in the case where the port has
> a label, and just kept the NET_NAME_UNKNOWN for the eth%d case to make
> the minimal change. But if people want to change that to NET_NAME_ENUM
> while we're here, I can certainly do that. I can't think of any real
> scenario where NET_NAME_ENUM would be treated differently than
> NET_NAME_UNKNOWN - in both cases, userspace don't know that the name can
> be trusted to be predictable.

Apparently there may be a reason, see commit e9f656b7a214 ("net:
ethernet: set default assignment identifier to NET_NAME_ENUM")
so let's switch to ENUM while at it.
