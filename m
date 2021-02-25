Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505823248BE
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhBYCE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236586AbhBYCEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 21:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E46CB64EBA;
        Thu, 25 Feb 2021 02:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614218614;
        bh=R96pzaUJmP4LXO9LQNrmqJhnP0Bv454enSAxEnTE2Zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V2dq2cHQCIeMUmvw2vDdT5YPZl1GMiQsf9Md4i7ea/P5xiqnXrhYRSdliUMjW85H5
         7YE/XA44gPMZNEnrpMhxE4QGjv9xStsdNKL9U+IoQcsYa50OZd3DFj2GJXJ2eISweb
         iC1n/4azrIFkO8Rg0vWRxVwQ9LNP19RB+5/EnpGP+w1G0w5SWDk3DgnzICR4GX1I+Q
         jQs2qQUcvFBNcM/YSynvCYzlHXP4lUjVm5DpYS1vawyHmvMkFAWJoZ1LLdwEkYWVp3
         HgDypSi1jHggCQ5kBAywscuAfWyNg/GRsOXahdxt4ikbtBpDZ2yHrbCBD7qfRdIMGB
         mr9AlXsGGUSVA==
Date:   Wed, 24 Feb 2021 18:03:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 01:22:08 +0000 Alexander Duyck wrote:
> Yeah, that was the patch Wei had done earlier. Eric complained about the extra set_bit atomic operation in the threaded path. That is when I came up with the idea of just adding a bit to the busy poll logic so that the only extra cost in the threaded path was having to check 2 bits instead of 1.

Maybe we can set the bit only if the thread is running? When thread
comes out of schedule() it can be sure that it has an NAPI to service.
But when it enters napi_thread_wait() and before it hits schedule()
it must be careful to make sure the NAPI is still (or already in the
very first run after creation) owned by it.
