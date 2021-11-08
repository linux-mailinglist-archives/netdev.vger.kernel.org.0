Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB3449F06
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbhKHXeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhKHXeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 18:34:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD11061175;
        Mon,  8 Nov 2021 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636414290;
        bh=P2bBc0/n+Zd/hqg8awc2ShYNTCAACpZXxIz97sKBhjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T6GYXYhiDWKtuLAAOkyPgxJPw6wbPWGP6T1bdf3dR5QTDo4bbM75x14HuqzvT5iDx
         tUo09gjAsJjxcIOcLua7Jjj0Y6jabGVIgeNYcfhegbL93Rx8JOsrrQjvDefoRjME4J
         gHk50OpiHdiEUzyrmfzC6FZ2M4Nser4+gwNC8YVGvxcSljAvc49fodgqBV78hmtc8t
         6iU+I1T0Q0BT1jcRxk4zP1jE8IDV9vK27b0CONkoMJQdpJAZWS7IrCGy8LOCzMWE3b
         oZpbxfwRn2hc71+siq8x7ViaEG1qx9Wwb8T7d5wMbb1pbMJaHx74U24soEjbp7X9Xg
         HsS074d77rW6g==
Date:   Mon, 8 Nov 2021 15:31:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYmBbJ5++iO4MOo7@unreal>
References: <YYABqfFy//g5Gdis@nanopsycho>
        <YYBTg4nW2BIVadYE@shredder>
        <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 21:58:36 +0200 Leon Romanovsky wrote:
> > > > nfp will benefit from the simplified locking as well, and so will bnxt,
> > > > although I'm not sure the maintainers will opt for using devlink framework
> > > > due to the downstream requirements.    
> > > 
> > > Exactly why devlink should be fixed first.  
> > 
> > If by "fixed first" you mean it needs 5 locks to be added and to remove
> > any guarantees on sub-object lifetime then no thanks.  
> 
> How do you plan to fix pernet_ops_rwsem lock? By exposing devlink state
> to the drivers? By providing unlocked version of unregister_netdevice_notifier?
> 
> This simple scenario has deadlocks:
> sudo ip netns add n1
> sudo devlink dev reload pci/0000:00:09.0 netns n1
> sudo ip netns del n1

Okay - I'm not sure why you're asking me this. This is not related to
devlink locking as far as I can tell. Neither are you fixing this
problem in your own RFC.

You'd need to tell me more about what the notifier is used for (I see
RoCE in the call trace). I don't understand why you need to re-register 
a global (i.e. not per netns) notifier when devlink is switching name
spaces.
