Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0290F53127D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiEWOrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiEWOrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:47:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16F3DA45
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 07:47:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8B5AB20299;
        Mon, 23 May 2022 16:47:03 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xUpcKLc9-tBi; Mon, 23 May 2022 16:47:03 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0F246201E2;
        Mon, 23 May 2022 16:47:03 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 09E7080004A;
        Mon, 23 May 2022 16:47:03 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 23 May 2022 16:47:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 23 May
 2022 16:47:02 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 40C973182B34; Mon, 23 May 2022 16:47:02 +0200 (CEST)
Date:   Mon, 23 May 2022 16:47:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
CC:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "Linux Network Development Mailing List" <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lina Wang <lina.wang@mediatek.com>
Subject: Re: [PATCH] xfrm: do not set IPv4 DF flag when encapsulating IPv6
 frames <= 1280 bytes.
Message-ID: <20220523144702.GY680067@gauss3.secunet.de>
References: <20220518210548.2296546-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220518210548.2296546-1-zenczykowski@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 02:05:48PM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> One may want to have DF set on large packets to support discovering
> path mtu and limiting the size of generated packets (hence not
> setting the XFRM_STATE_NOPMTUDISC tunnel flag), while still
> supporting networks that are incapable of carrying even minimal
> sized IPv6 frames (post encapsulation).
> 
> Having IPv4 Don't Frag bit set on encapsulated IPv6 frames that
> are not larger than the minimum IPv6 mtu of 1280 isn't useful,
> because the resulting ICMP Fragmentation Required error isn't
> actionable (even assuming you receive it) because IPv6 will not
> drop it's path mtu below 1280 anyway.  While the IPv4 stack
> could prefrag the packets post encap, this requires the ICMP
> error to be successfully delivered and causes a loss of the
> original IPv6 frame (thus requiring a retransmit and latency
> hit).  Luckily with IPv4 if we simply don't set the DF flag,
> we'll just make further fragmenting the packets some other
> router's problems.
> 
> We'll still learn the correct IPv4 path mtu through encapsulation
> of larger IPv6 frames.
> 
> I'm still not convinced this patch is entirely sufficient to make
> everything happy... but I don't see how it could possibly
> make things worse.
> 
> See also recent:
>   4ff2980b6bd2 'xfrm: fix tunnel model fragmentation behavior'
> and friends
> 
> Bug: 203183943

To what does this bug number refer to? Bugzilla? Please make that clear
if you want to have this number in the commit message.

Thanks!

