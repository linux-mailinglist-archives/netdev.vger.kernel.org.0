Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0AE6B84A8
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjCMWSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCMWSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8208E3D0;
        Mon, 13 Mar 2023 15:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57B9CB81185;
        Mon, 13 Mar 2023 22:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F42C433D2;
        Mon, 13 Mar 2023 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678745926;
        bh=4Ie5F9+yNd8+j8B1DSv2ufImjnst5rSZzdgnN+9xPUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pxstvy70o1gpf5ktY9c/lxqUWBDtPdq41c8M6hPu1oYc5T6emC3cTgn5SioBe/n/O
         zDqq2wvPlzvO0GKsRJsSMIcxHe6FGli8L8Vs6zvsDKkqxccjkzfgadlE7u+oDYlxst
         rgAZGjQVfBEXk+5+Y67+EtAvl9p0IHfnbRtHzfkRZ0tDS2V8qNPiHgY3qvo7OCfayO
         5aGRujMT4uJRgiwD7zhtELPJGyRDvbMP3lfSl/XBTS0a3VLEI4HLdKShCGMbYD5CtP
         ymSvXVgOujhBE9/EyEwnKfXJRdhxmTxs1LchisSLFt3WZhtlGf4VQwzFdMf2GDNgds
         kuDxyOWx/kzMA==
Date:   Mon, 13 Mar 2023 15:18:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Horatiu Vultur' <horatiu.vultur@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: lan966x: Stop using packing library
Message-ID: <20230313151844.6eee28c6@kernel.org>
In-Reply-To: <cad1c4aac9ae4047b8ed29b181c908fd@AcuMS.aculab.com>
References: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
        <20230312202424.1495439-3-horatiu.vultur@microchip.com>
        <cad1c4aac9ae4047b8ed29b181c908fd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 17:04:11 +0000 David Laight wrote:
> It has to be possible to do much better that that.
> Given  that 'pos' and 'length' are always constants it looks like
> each call should reduce to (something like):
> 	ifh[k] |= val << n;
> 	ifk[k + 1] |= val >> (8 - n);
> 	...
> It might be that the compiler manages to do this, but I doubt it.

Agreed, going bit-by-bit seems overly cautious.
