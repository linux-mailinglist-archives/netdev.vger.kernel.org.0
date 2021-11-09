Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB0B44AF4E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhKIOUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237622AbhKIOUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 969E2600CD;
        Tue,  9 Nov 2021 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636467453;
        bh=rXBu4BjCjfe2WnUmVMqs6dfvqqWqixQG/xs79QcduXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=foM500EyrOnCO2lkaYXPW8zzkutMAI5vFIN1YcnV6dCpMsN327P1esCsaMHqm6M5C
         OZAAPirSQxJURA8lRmmKjPhdQVo78SfbXMMUL2FJ3TWedRSJJdOGD9V5oMtD1ipMfn
         Cyw3VPzoMs9BSbdB4ZhMZKiA9DKierGd3sGem28gGEeNXQTxXxforJJ/vfBxBIMZsk
         Av/Eq1KGgjd7q06oGgSbC98r4nbVNO0jTgZXh3CJ8gG9hwMccPF+0JAQRaUe0FECJ7
         s7PFI+SN4viaplWv+83FLJsfhdBWA9w5fYT1E6GFlcERyR92XeaXMSjQuZQIo+XhQI
         6t3q4d9+faTpw==
Date:   Tue, 9 Nov 2021 06:17:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109061729.32f20616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYqB0VZcWnmtSS91@unreal>
References: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
        <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYqB0VZcWnmtSS91@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 16:12:33 +0200 Leon Romanovsky wrote:
> > You'd need to tell me more about what the notifier is used for (I see
> > RoCE in the call trace). I don't understand why you need to re-register 
> > a global (i.e. not per netns) notifier when devlink is switching name
> > spaces.  
> 
> RDMA subsystem supports two net namespace aware scenarios.
> 
> We need global netdev_notifier for shared mode. This is legacy mode where
> we listen to all namespaces. We must support this mode otherwise we break
> whole RDMA world.
> 
> See commit below:
> de641d74fb00 ("Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"")

But why re-reg? To take advantage of clean event replay?

IIUC the problem is that the un-reg is called from the reload_down path.
