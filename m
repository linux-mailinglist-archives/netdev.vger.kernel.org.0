Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6639659448
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 03:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiL3Cv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 21:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiL3CvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 21:51:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F082638;
        Thu, 29 Dec 2022 18:51:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EB60B819EB;
        Fri, 30 Dec 2022 02:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD662C433EF;
        Fri, 30 Dec 2022 02:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672368682;
        bh=HulvsuCGLYDSm7wtBF1VVsTHpiI4VFtybnD2qVartKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gEjkS0Edbbzzgo0PBEc8bHzFvuuzTriMlUNpvDBx9QSLslr2QlObTgnXhMjZpxDfj
         uDkdgrFKVAHaog2pFkeFu1iExXYD5S6UNjr6+fa2SiPSbcXSAD9G2/C1TSw/atVdoi
         KKu5pMUWjnvqXWfU/SVZlKXg/UdwuuayfaeAL/kLeAjIba4n0OKv2RyFV6jDAyDp1b
         79y3ktxf9qZxOEKDfoDLQOy2NznVPdVZ8Rpy3fOwN8v7D6xTz8xJFyqJvzzMAOX1WA
         ufNejPvlw2h22s2psp5QvnUWoOj0/MZ6A5dOMBLYWuDX9cpRZoA/s99R/M7ciCQNpx
         ebotmWHyZ0IfQ==
Date:   Thu, 29 Dec 2022 18:51:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com, eperezma@redhat.com
Subject: Re: [PATCH 1/4] virtio-net: convert rx mode setting to use
 workqueue
Message-ID: <20221229185120.20f43a1b@kernel.org>
In-Reply-To: <6026e801-6fda-fee9-a69b-d06a80368621@redhat.com>
References: <20221226074908.8154-1-jasowang@redhat.com>
        <20221226074908.8154-2-jasowang@redhat.com>
        <20221227023447-mutt-send-email-mst@kernel.org>
        <6026e801-6fda-fee9-a69b-d06a80368621@redhat.com>
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

On Tue, 27 Dec 2022 17:06:10 +0800 Jason Wang wrote:
> > Hmm so user tells us to e.g enable promisc. We report completion
> > but card is still dropping packets. I think this
> > has a chance to break some setups.  
> 
> I think all those filters are best efforts, am I wrong?

Are the flags protected by the addr lock which needs BH, tho?

Taking netif_addr_lock_bh() to look at dev->flags seems a bit 
surprising to me.
