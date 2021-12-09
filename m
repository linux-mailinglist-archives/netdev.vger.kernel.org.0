Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5DF46F48B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhLIUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhLIUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:07:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9007C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 12:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F7CB82453
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D0C004DD;
        Thu,  9 Dec 2021 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639080224;
        bh=6MM+katv4ZfyakREWs/UkHP5p9bja+zcqwSg/Bit0tA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Abw5es0OcBkAemjtYOweI4P8eFMBzqS7UBHVmTHAFB6MkO6ERn9MxBfPiIVvRyZnG
         7tUe0iOx3W9xOwnfNMnsGiOSTnhZQpPPQGKIWoiJNKvayoLqHgt72V9yRclURvn8yA
         rcviEDS6ZnF3e2/HfYY/yM6ueAxqewWTTx6H+LSp9uSxfWxmkJDHQKWcx926wnBPLQ
         Ob96XJPlhm6E/1vtL0iA0AEN3Jd61+Jy7wLAXihdjX7pRpNbICLr965XNTI3lEIDm6
         vAcXbKU7efqP06CGCHhBtrK7HGt2SoAkiBzZGdMBr++MhZ+vcNYRCugkDVgxj2LBpV
         ocAl+lrSValXQ==
Date:   Thu, 9 Dec 2021 12:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/17] net: netns refcount tracking series
Message-ID: <20211209120343.3a6de4f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 16:51:25 -0800 Eric Dumazet wrote:
> We have 100+ syzbot reports about netns being dismantled too soon,
> still unresolved as of today.
> 
> We think a missing get_net() or an extra put_net() is the root cause.
> 
> In order to find the bug(s), and be able to spot future ones,
> this patch adds CONFIG_NET_NS_REFCNT_TRACKER and new helpers
> to precisely pair all put_net() with corresponding get_net().
> 
> To use these helpers, each data structure owning a refcount
> should also use a "netns_tracker" to pair the get() and put().
> 
> Small sections of codes where the get()/put() are in sight
> do not need to have a tracker, because they are short lived,
> but in theory it is also possible to declare an on-stack tracker.

Ugh, I realized after a week of waiting that vfs / sunrpc / audit folks
are not even CCed here. I think we should give them the courtesy of
being able to ack the patches.. Can you split out 1-4,6,7 for immediate
merging and repost the rest with the right CCs?
