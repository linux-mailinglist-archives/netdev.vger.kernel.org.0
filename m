Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3011463911
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbhK3PHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:07:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35864 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243781AbhK3PFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:05:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD347CE1A0D
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1847C58319;
        Tue, 30 Nov 2021 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284551;
        bh=0kN/9BQRVHEDMrNttfyXfY7CCGBXBOODYJ/jPRFz3IY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cQM4CcxC5fsDZ1wHgXKQTzO/wIsuozF8VByVa5Xr8H5ODz14qnrLt1AzlLLeMjIlG
         99S61H8w4PRDjUlGb6273Zyr8MceDIjjeD/4v/bzsAAI9TLMogBP2Wp2qxzeAwn4FW
         cKb6oTjFd0zOIvUnSiAoeJVhbvxxAc9NI27YEAKb0UP0+633H30YtiNGoJyRkd76P/
         zN3wo20jHglC6zraSmfRZYZOeUTUXqtW/h5wHJci76zAyNjx5S54Wb8zmQO0cGcBdW
         fF+V1Vp2zb6RE4hN/4R3cnq5j4QEDdHDvJ2OyI9WIarv0143s1J8NXbtjRfnmLhJXL
         02HCseNBrmZJQ==
Date:   Tue, 30 Nov 2021 07:02:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     eric.dumazet@gmail.com, davem@davemloft.net, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
Message-ID: <20211130070230.73b4c5f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130090952.4089393-1-dvyukov@google.com>
References: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
        <20211130090952.4089393-1-dvyukov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 10:09:52 +0100 Dmitry Vyukov wrote:
> Hi Eric, Jakub,
> 
> How strongly do you want to make this work w/o KASAN?
> I am asking because KASAN will already memorize alloc/free stacks for every
> heap object (+ pids + 2 aux stacks with kasan_record_aux_stack()).
> So basically we just need to alloc struct list_head and won't need
> quarantine/quarantine_avail in ref_tracker_dir.
> If there are some refcount bugs, it may be due to a previous use-after-free,
> so debugging a refcount bug w/o KASAN may be waste of time.

I don't mind, I was primarily targeting syzbot instances which will
have KASAN enabled AFAIU.
