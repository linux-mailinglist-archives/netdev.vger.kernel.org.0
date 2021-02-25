Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6CD3248A1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhBYBlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhBYBla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:41:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A410D64EF1;
        Thu, 25 Feb 2021 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614217249;
        bh=kranxg891wVGpTo56EBRdIfihyCbnhuG8gHWHcykXDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WC3J70Sl9jpD7Moo7hyOYJsqN2auWHkI/a6sGfV29PfmyVpvupFhkrVLnubanpZNd
         n5qVFRpIpVNRJYWt8vK/0cpu57oyWLsDfVQqEqmYqckAx2JLJ8Wszb8o1HaoSH25/5
         KQ3+civujk8DKUxqi1Y1ipR2FcEVDaiEYZf3Ez6FclurXIj/tS+HCn5x2OmaoKwwLZ
         zrJtcwn5t255V2HWDZsLYNB/Y9J9XkyYUNsOa0ZF9BxkDpkSzL5B49buRdaM9ws1zI
         7JJGcnoOEe870fO+2RE5PQYBqyIl0w51Dyx6XwTdRczP7T6dOJafQ7LdfGeLnXLNhl
         yg0jmH1FaSv0w==
Date:   Wed, 24 Feb 2021 17:40:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224174045.77b970cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_CN9UzGvLKoX8Y=D49p4N+rgWPWtg0haXJ3T0HP+gJvxA@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
        <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com>
        <20210224164946.2822585d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CN9UzGvLKoX8Y=D49p4N+rgWPWtg0haXJ3T0HP+gJvxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 17:06:13 -0800 Wei Wang wrote:
> I really have a hard time reproducing the warning Martin was seeing in
> his setup. The difference between my setup and his is that mine uses
> mlx4 driver, while Martin is using ixgbe driver.
> 
> To keep everyone up to date with Martin's previous email, with this
> patch applied to 5.11.1, the following warning is triggered when
> enabling threaded mode without enabling busy poll:
> echo 1 > /sys/class/net/eth0/threaded
> echo 1 > /sys/class/net/eth1/threaded
> echo 1 > /sys/class/net/eth2/threaded
> echo 1 > /sys/class/net/eth3/threaded
> 
> Warning message:
> [...]
> 
> This is the line in net/core/dev.c:6993
>  WARN_ON(!list_empty(&napi->poll_list));
> in napi_threaded wait()
> 
> Martin, do you think the driver version you are using could be at fault here?

We do kthread_run() meaning the thread gets immediately woken up, even
when sirq is polling the NAPI and owns it. Right?
