Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0515E6A4BCD
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjB0T5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjB0T5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:57:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1971AF;
        Mon, 27 Feb 2023 11:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8872760F0F;
        Mon, 27 Feb 2023 19:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96506C433EF;
        Mon, 27 Feb 2023 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677527860;
        bh=0RCxE8mEsWFtm6BE7rUL/+5TrM95FurfVX9X5R0bfps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OHW+YzHfB1G9RjW3EW+VD+nTB4dp5JJgh6ZS66pvLZly3IaFlvpR9OUmaQ0VBw4Cq
         GrvFO4TLjKJnUu+yQtQzme54+gANtadjlP8Mr8p4I/plLW5teoz2ZEgKUn7JiqTlSo
         6Yp6D9nnBp2LQHrnJLH7PeWlOv/dh/CYI82EDESqLuFR6QN4PXTLymuZyznTkR7dta
         6vZJxHfIj8Ua2eVtIbHZGeL68DQLQu9vIyZlLXnGtbvIg2+EYSF1Y09T82vOxxA//M
         TRsO/CYQn1IQdCfMGg0e7sravzkzLTT/ulp58qlfGbjBerP/p0Iq4N06F5FeyeGnH+
         35CmOl7WPLH1w==
Date:   Mon, 27 Feb 2023 11:57:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] net: geneve: accept every ethertype
Message-ID: <20230227115739.3f153c7b@kernel.org>
In-Reply-To: <CAHsH6GuHiRDgY+_Epu=ejTAWONuXgzHk326SUuAeRp6pGaTEpA@mail.gmail.com>
References: <20230227074104.42153-1-josef@miegl.cz>
        <CAHsH6GtArNCyA3UAJbSYYD86fb2QxskbSoNQo2RVHQzKC643zg@mail.gmail.com>
        <79dee14b9b96d5916a8652456b78c7a5@miegl.cz>
        <CAHsH6GuHiRDgY+_Epu=ejTAWONuXgzHk326SUuAeRp6pGaTEpA@mail.gmail.com>
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

On Mon, 27 Feb 2023 12:05:51 +0200 Eyal Birger wrote:
> > > This seems like an addition not a bugfix so personally seems like it should
> > > be targeting net-next (which is currently closed afaik).  
> >
> > One could say the receive function should have behaved like that, the
> > transmit function already encapsulates every possible Ethertype and
> > IFLA_GENEVE_INNER_PROTO_INHERIT doesn't sound like it should be limited to
> > IPv4 and IPv6.  
> 
> Indeed the flag is intentionally generic to allow for future extensions
> without having to rename. But both in the commit message, and in the iproute2
> man page I noted support for IPv4/IPv6.
> 
> > If no further modifications down the packet chain are required, I'd say it's
> > 50/50. However I haven't contributed to the Linux kernel ever before, so I
> > really have no clue as to how things go.

I think net-next is a better target, Eyal's explanation that the check
is intentional seems quite reasonable. FWIW, when you repost feel free
to fold the info from the cover letter into the patch description. 
With a single patch cover letters just split the info unnecessarily.
