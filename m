Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC9F6B84B1
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCMWWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCMWWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4DC5CC12;
        Mon, 13 Mar 2023 15:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58AC3614F1;
        Mon, 13 Mar 2023 22:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591C9C433D2;
        Mon, 13 Mar 2023 22:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678746144;
        bh=aygbQCxyJ4fatt7+ZqsUd549F2zsSt/14EUnRscn9FM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEOHeOosEwdDvYpF8CW/m50pjFGLn6W3QbTH1tvL3XsMO5ffmoda3CpYHupIiOt8N
         Nm62xd1Lt3qbXmxdDwGUJ1AMoegsdCsLA5Bciy/b4V6OgbhSrQbWXFYZJciuj94gth
         bG1D7Bq7d5/IBOPich5LJ8zA100tsth/2W5Va+1I98U1CkapPih0kRV6syuaAim7x+
         ET5NJfWRK47woWkPuIw0yfgT7Ln1POxbvDroLNThnBorYaDdZEo/SPHfWyvuKKC3n5
         RZXdg4lIQvD8iSjj24vmZClCEeMpPrDFr1rrOflOBl4pGgpZQGwWstHgZZja7U2iCe
         iuqWao/wnwJ0A==
Date:   Mon, 13 Mar 2023 15:22:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Danila Chernetsov <listdansp@mail.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: dsa: vsc73xxx: Fix uninitalized 'val' in
 vsc73xx_adjust_link
Message-ID: <20230313152223.6ce53395@kernel.org>
In-Reply-To: <ZA9yj1FT7eLOCU34@corigine.com>
References: <20230312155008.7830-1-listdansp@mail.ru>
        <ZA9yj1FT7eLOCU34@corigine.com>
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

On Mon, 13 Mar 2023 19:59:27 +0100 Simon Horman wrote:
> On Sun, Mar 12, 2023 at 03:50:08PM +0000, Danila Chernetsov wrote:
> > Using uninitialized variable after calls vsc73xx_read 
> > without error checking may cause incorrect driver behavior.  
> 
> I wonder if it is:
> a) intentional that these calls are not checked for errors
> b) errors can occur in these call paths

At the very least we should handle the error rather than silencing 
the static checker complain by picking a semi-random init value for 
the entire function.
