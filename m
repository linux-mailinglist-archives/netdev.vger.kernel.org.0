Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA86E397A
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjDPOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPOoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:44:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD0BE0;
        Sun, 16 Apr 2023 07:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R0OmTuYnRnfC/MO3/XO+qggHJ2auqA4fbzeAg1TSbpA=; b=M4Hh/wBCHKTBbxCoOhitU9u3i+
        /5Z8EricwMTELUIHmfEV7n6ifgDieZs1oAdNJ0hazKigCs4hC4wSSMev3Ln8pw/ErCbNw1VjJvkZy
        0wMu8LhApBjGtx+4HPa+Hztme49nKOs6PVHBIuwhWphMELxJ4ZQXoe5ErNFtsNwrNgXo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1po3c8-00AQp9-TF; Sun, 16 Apr 2023 16:44:24 +0200
Date:   Sun, 16 Apr 2023 16:44:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix calibration data endianness
Message-ID: <6c0c6f91-9b5a-4d0a-b92d-4daf5775f27d@lunn.ch>
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk>
 <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
 <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
 <874jpgxfs7.fsf@toke.dk>
 <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8caecebf-bd88-dffe-7749-b79b7ea61cc7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> |       if (ah->eep_ops->get_eepmisc(ah) & AR5416_EEPMISC_BIG_ENDIAN) {
> |               *swap_needed = true;
> |               ath_dbg(common, EEPROM,
> |                       "Big Endian EEPROM detected according to EEPMISC register.\n");
> |       } else {
> |               *swap_needed = false;
> |       }
> 
> This doesn't take into consideration that swapping is not needed if
> the data is in big endian format on a big endian device. So, this
> could be changed so that the *swap_needed is only true if the flag and
> device endiannes disagrees?

There are versions of the macro which performs the swap which
understands the CPU endianness and become a NOP when it is not
required. htons()/ntohs() are the classic examples. So you need to
consider:

Despite swap_needed being true, it is possible no swap it actually
happening, because such a macro is being used.

and

Maybe using these variant can make the code simpler, by just doing the
NOP swap when the CPU endianess does not require it.

    Andrew
