Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CCA5906D1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiHKTFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHKTFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB3982870;
        Thu, 11 Aug 2022 12:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED5E60C03;
        Thu, 11 Aug 2022 19:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C9C433D6;
        Thu, 11 Aug 2022 19:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660244729;
        bh=0SThgFqFZyXezUn0d6O27jzfZynm2O9WY2w+bU36Vno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQSDeiZt3INPVzxg4SYeispGR7rJh9zxFmLpTigxTbUU/kLB3VyqAbGMoQDPfjfZa
         VD49nTgv1XCzS+/qTcYtNcn07Y59fjdSLN9IGfLF8RpyCEN0CAku+iUPjS1PwA7G4C
         k6b0fJ8hYYea8lR83Yd0GnOL5DFtTvJ+9Ik/NOBBH0ymxRovg7MmLxk/5Z2IfVdPq7
         ZdCCOXwBR3Ng4lfPt4i+y5h1pUhtSG1Fye43bvjjhgGyKIk6589HNRMe349GkXAeCT
         uq9aWw6wOLYfsthYnrgm/mF58ONb0bc+9VzsJKWD9ed1mv0HcFwP3XHmL4JHCGJ1Fd
         BCx3UccaNLxvg==
Date:   Thu, 11 Aug 2022 12:05:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-next@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: Re: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
Message-ID: <20220811120528.0e2bc1e5@kernel.org>
In-Reply-To: <YvVQEDs75pxSgxjM@debian>
References: <YvVQEDs75pxSgxjM@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 19:53:04 +0100 Sudip Mukherjee (Codethink) wrote:
> Hi All,
> 
> Not sure if it has been reported, builds of csky and mips allmodconfig
> failed to build next-20220811 with gcc-12.

Heh, 2 minutes after I submitted it to Linus :S

> mips error is:
> 
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]

Source is the second argument? memcmp does not really have src and dst..

Assuming it's the second one it appears to object to the:

#define BDADDR_ANY  (&(bdaddr_t) {{0, 0, 0, 0, 0, 0}})

Which, well, kinda understandable but why does it not dislike the same
construct when used in the other 70 places in the tree?

My preferred fix would be to do the same thing as we do for ethernet
i.e. open code the helper, see is_zero_ether_addr().

>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
>   420 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
>   420 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> 
> 
> csky error is:
> 
> In file included from net/bluetooth/l2cap_core.c:37:
> In function 'bacmp',
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> ./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>   347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'bacmp',
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
> ./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>   347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> git bisect pointed to 332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression").
> And, reverting that commit has fixed the build failure.
> 
> I will be happy to test any patch or provide any extra log if needed.
> 
> --
> Regards
> Sudip

