Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8385369D7
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiE1Bhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiE1Bhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:37:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EDF1271BA;
        Fri, 27 May 2022 18:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C94A61BE9;
        Sat, 28 May 2022 01:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC11C385A9;
        Sat, 28 May 2022 01:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653701852;
        bh=0A4GDS0/xoWk9h+94rvB7hZvdBuYFPiKZbBmCrPpur4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EgVunYxNG9zVa6HGSDa9fnF7jafFHulZ1dvn3cVJHIaOzxJZAlr72t4YipRYRBoVX
         3zucd9EkoB0vfJUyz4E6nrjEEnhXB0/qD2JE7l3hd6btX0Dbg2LsacvBGDKqK5c/9P
         e30Sl8s0yZJobB6wmWfJ8eL9l54f7tHvWLMCs3Mwp4xNINwE+4PPuBiVviGbP6Qitg
         eAUlIkZnSezAFJfBSLyQMHCV4SkXP5KmpcQff7ji57oihyLxhzeM3foi+jdeMUdyAo
         yMEKMHcPlSQrhKbPfoSqEF1xOgzyk3glcygsdfNVnyvKVKRQ6ppjXqHhbBktfRq9eD
         prh4uw7JjieGQ==
Date:   Fri, 27 May 2022 18:37:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Era Mayflower <mayflowerera@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Message-ID: <20220527183730.144bb400@kernel.org>
In-Reply-To: <AM9PR08MB67886ABF9BF353568A56B29BDBD99@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <AM9PR08MB67886ABF9BF353568A56B29BDBD99@AM9PR08MB6788.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 12:28:00 +0000 Carlos Fernandez wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet  <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni  <pabeni@redhat.com>, Era Mayflower <mayflowerera@gmail.com>,  "netdev@vger.kernel.org" <netdev@vger.kernel.org>,  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> CC: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before  offloading
> Date: Thu, 26 May 2022 12:28:00 +0000
> 
> From 149a8fbcf7a410ed6be0e660d5b83eb9f17decc6 Mon Sep 17 00:00:00 2001
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> Date: Tue, 24 May 2022 12:29:52 +0200
> Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
>  offloading
> 
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.

Now git can't detect the patch at all:

$ git pw series apply 645266
Patch is empty.
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

:(
