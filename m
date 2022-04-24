Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0158350D4D8
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbiDXThI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiDXThH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:37:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441BA35865;
        Sun, 24 Apr 2022 12:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9353612E8;
        Sun, 24 Apr 2022 19:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACFC385A7;
        Sun, 24 Apr 2022 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650828845;
        bh=1yTMsjzIPbHZvzGsCO7P4g2pcIygu8eX0O+Bh6QMs4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UyPBSsw5JlCD9LjskAiB6XHMmthvmaAWNa8rv8AdALS5/VS5sm0SeKb5dpABbJEVt
         cN4HeUjQd/0ZCQ1jFRXXU5wutcGWW6E+9KpzKNsQRtZTCAQTsqwpYUD1DfQRfaFF1q
         IO/DJUVpV99kaLATYD80QFegSRxRQggpVnArXr6oaerzFVxC3QEwDjATfnnrcrxRQc
         pn/a6VY3OKpvCuDWRV51NrnbpSwz3K0D/jgKd8WTuFwyvJUM4kMKbInGOhrzhsUGes
         eEiNYHKlhM4RI8StNcZB0yfmAVYBGddWlopdp9MSlry2XFM5BtqgM7DOw9W/sC/uP1
         CcY+U9rv47PKw==
Date:   Sun, 24 Apr 2022 21:33:59 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <20220424213359.246cd5ab@thinkpad>
In-Reply-To: <YmWkgkILCrBP5hRG@lunn.ch>
References: <20220424153143.323338-1-nathan@nathanrossi.com>
        <YmWkgkILCrBP5hRG@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 21:26:58 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Apr 24, 2022 at 03:31:43PM +0000, Nathan Rossi wrote:
> > The other port_hidden functions rely on the port_read/port_write
> > functions to access the hidden control port. These functions apply the
> > offset for port_base_addr where applicable. Update port_hidden_wait to
> > use the port_wait_bit so that port_base_addr offsets are accounted for
> > when waiting for the busy bit to change.
> > 
> > Without the offset the port_hidden_wait function would timeout on
> > devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> > devices that have a zero port_base_addr would operate correctly (e.g.
> > MV88E6390).
> > 
> > Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")  
> 
> That is further back than needed. And due to the code moving around
> and getting renamed, you are added extra burden on those doing the
> back port for no actual gain.
> 
> Please verify what i suggested, 609070133aff1 is better and then
> repost.

The bug was introduced by ea89098ef9a5.
609070133aff1 is only requirement for this fix, but Fixes tag should reference
the commit which introduced the bug, afaik.

So it should be 

Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")
Cc: stable@vger.kernel.org # 609070133aff ("net: dsa: mv88e6xxx: update code operating on hidden registers")

Marek
