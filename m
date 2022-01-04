Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE74843E4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiADOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiADOzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:55:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F8C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 06:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA95B81125
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 14:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48ECC36AED;
        Tue,  4 Jan 2022 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641308150;
        bh=zdPAjaPwB4/ADv3QQvx/gX692gF8vG0cNKG05SyLIDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s+G/9DVixq235VF/MuU7sxObEjXtXDzotNMHhTHNlYgz6l97HnG+i4ztGAfqcKCwr
         /jZsSPojA9pZzgiyPfDcZOY87p8OHiLa6bJsQvvTNLLKMwAEOYBj5JqXDQj49xVd24
         dBPmArVnhyK9jHWqAVTVeIEow8qaxl81n4q1m7LX+f9Ol1QtSstEvyx89So1E+lfOv
         xW7ye4QBzE/ippbjafcjRx49eM+ES+gEkT2GJ1KGauQT7LrYG1daZdcbbj8wn95F4K
         uvzZlfgdkS6nQ+n9IAATngxoXkPQNntHUFjETnTZ7G1CeBczp9xCbejir0hNF4CUuF
         rVNJvHJduoPOg==
Date:   Tue, 4 Jan 2022 06:55:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220104065548.3845f255@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104082057.x34hxf7pf4tdo3zd@kgollan-pc>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
        <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
        <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
        <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
        <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
        <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220104082057.x34hxf7pf4tdo3zd@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 10:21:21 +0200 Lahav Schlesinger wrote:
> Hi Jakub, I just sent a V6 for this patch. Just wanted to note that I
> tried this approach of using unreg_list, but it caused issues with e.g.
> veth deletion - the dellink() of a veth peer automatically adds the
> other peer to the queued list. So if the list of ifindices contains
> both peers then when 'to_kill' is iterated, both the current device
> and the next pointer will have their 'unreg_list' moved to the other
> list, which later raised a page fault when 'to_kill' was further
> iterated upon.
> 
> Therefore instead I added a big flag in a "hole" inside struct
> net_device, as David suggested.

Ack. Thanks for trying it out.
