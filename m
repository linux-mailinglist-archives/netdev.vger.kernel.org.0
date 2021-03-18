Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147633FCAB
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCRB2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhCRB2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 21:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9CE64F38;
        Thu, 18 Mar 2021 01:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616030910;
        bh=geZpfo1E/3cbyxuvGzLOrApyoWfBI1fwea5N/FAC2ZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ub55wJrOSfm6ol2SWRFWeTEt5STQecUoMH2cyFZOAnmLum4ePK/ToqmPPSipX0Bgr
         0N7cBXSkqNFk4xrMT6BGunCtR6SEpBRT4QsFolRzIfIJIV7i7ztbK/qKLgahG8ATTk
         S58Qk9Q42OpMIrwprD2+krfIJlaa8zWzQY3dla9CT7YEtb4UhOjyzDc8rVQD2QkIjh
         TRnWV27BiaFAhnAvhsdPRmgeicvgNu0GD692WGzMQ3d6BykgijwXmXzehSXJ2kx8sv
         ooDKaHVJrTmpS4OfM6XEa8HmOPT5sn5Q4a+y+2XVoJnD2v4VXDPjp+RQZy49SmAM8B
         dD1jVtkr9nHWQ==
Date:   Wed, 17 Mar 2021 18:28:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
Message-ID: <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
        <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
        <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Mar 2021 09:02:54 +0800 Huazhong Tan wrote:
> On 2021/3/16 4:04, Jakub Kicinski wrote:
> > On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:  
> >> From: Jian Shen <shenjian15@huawei.com>
> >>
> >> For device version V3, it supports queue bonding, which can
> >> identify the tuple information of TCP stream, and create flow
> >> director rules automatically, in order to keep the tx and rx
> >> packets are in the same queue pair. The driver set FD_ADD
> >> field of TX BD for TCP SYN packet, and set FD_DEL filed for
> >> TCP FIN or RST packet. The hardware create or remove a fd rule
> >> according to the TX BD, and it also support to age-out a rule
> >> if not hit for a long time.
> >>
> >> The queue bonding mode is default to be disabled, and can be
> >> enabled/disabled with ethtool priv-flags command.  
> > This seems like fairly well defined behavior, IMHO we should have a full
> > device feature for it, rather than a private flag.  
> 
> Should we add a NETIF_F_NTUPLE_HW feature for it?

It'd be better to keep the configuration close to the existing RFS
config, no? Perhaps a new file under

  /sys/class/net/$dev/queues/rx-$id/

to enable the feature would be more appropriate?

Otherwise I'd call it something like NETIF_F_RFS_AUTO ?

Alex, any thoughts? IIRC Intel HW had a similar feature?

> > Does the device need to be able to parse the frame fully for this
> > mechanism to work? Will it work even if the TCP segment is encapsulated
> > in a custom tunnel?  
> 
> no, custom tunnel is not supported.

Hm, okay, it's just queue mapping, if device gets it wrong not the end
of the world (provided security boundaries are preserved).
