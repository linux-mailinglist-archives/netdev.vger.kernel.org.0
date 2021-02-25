Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620423247F6
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhBYAdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhBYAdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:33:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7766A64DE9;
        Thu, 25 Feb 2021 00:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614213182;
        bh=TrfaM+SX+mnu9TMf5/GNT/FWwmDYFBS6aMLJfe9agyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MKcp923Pdywd+oeWiutmydJ9LFfIcEGE1KIVBqvi457pZhwano4D072ndbktDvuk2
         FPy9kP+gw/mmy5biaEqJ7bDRbf5W/R5+RMwP972ugB+9lipQe6e3NRJK05R9WDGCoD
         +LK7IkMXT8/xcCfXLLoyoVcEGQZIPWiBQrHU9vBoOryf4KuV//YghA6ci138kyltFq
         zga4YOefAYYU/D90adTHl+UYOvAW3b8GhQYn+HWtTZPz0qyew5jxaROj6EyHLOMYkG
         jnGGACELrzocAWQ29j7bfMe2MTKeUdZGU+lBC9OcOn/QVBKrS5MtSsJGgsB/B/LXJB
         5ZTnK8+fl3llg==
Date:   Wed, 24 Feb 2021 16:32:57 -0800
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
Message-ID: <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 16:16:58 -0800 Wei Wang wrote:
> On Wed, Feb 24, 2021 at 4:11 PM Alexander Duyck <alexanderduyck@fb.com> wrote:
> >
> > The problem with adding a bit for SCHED_THREADED is that you would
> > have to heavily modify napi_schedule_prep so that it would add the
> > bit. That is the reason for going with adding the bit to the busy
> > poll logic because it added no additional overhead. Adding another
> > atomic bit setting operation or heavily modifying the existing one
> > would add considerable overhead as it is either adding a
> > complicated conditional check to all NAPI calls, or adding an
> > atomic operation to the path for the threaded NAPI.  
> 
> Please help hold on to the patch for now. I think Martin is still
> seeing issues on his setup even with this patch applied. I have not
> yet figured out why. But I think we should not merge this patch until
> the issue is cleared. Will update this thread with progress.

If I'm looking right __busy_poll_stop() is only called if the last
napi poll used to re-enable IRQs consumed full budget. You need to
clear your new bit in busy_poll_stop(), not in __busy_poll_stop().
That will fix the case when hand off back to the normal poller (sirq, 
or thread) happens without going thru __napi_schedule().
