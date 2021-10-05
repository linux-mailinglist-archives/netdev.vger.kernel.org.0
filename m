Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70389421EBE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhJEGPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231752AbhJEGPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AA36120C;
        Tue,  5 Oct 2021 06:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633414402;
        bh=68uJEZOoCThhXBOwX444y4tIygakaLMjcplKfatuAK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmAJaRd/6jEiS4tHFoI5uKbc3CI9Jwm2Ox1xK0lR9GxB70O6IQK4jQCOLq9X+j+Za
         8oGe3FPyHuQytoohsuh5Soynqlmjq1rQUYo3qohWD6LOCvxWdsNZ6WlWYXdyovbMLj
         eFKrbJIJJyyBYHKYps1DpPUbeensSe9EnVW3UKCBPc5Uwqv4pQ6igw5rX2PnJCuWr7
         VrVtkxEi8ErnL8scjZUPGnsvVQUPVB57DN1+ZSKTkLl6BTUYXlNT0xg/caRKmdzGRf
         DbfhQWP1otD3Wgo3qJWNnnvRyUSSYiIOp91phrL8l9KXKrvQjUCQhZdQ+NDitfyKpH
         tSUk+NccvbXsA==
Date:   Tue, 5 Oct 2021 09:13:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 1/5] devlink: Reduce struct devlink exposure
Message-ID: <YVvs/kNqxumdoVjR@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <d21ebe6fde8139d5630ef4ebc9c5eb6ed18b0e3b.1633284302.git.leonro@nvidia.com>
 <20211004163808.437ea8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004163808.437ea8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 04:38:08PM -0700, Jakub Kicinski wrote:
> On Sun,  3 Oct 2021 21:12:02 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The declaration of struct devlink in general header provokes the
> > situation where internal fields can be accidentally used by the driver
> > authors. In order to reduce such possible situations, let's reduce the
> > namespace exposure of struct devlink.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> 100% subjective but every time I decided to hide a structure definition
> like this I came to regret it later. The fact there is only one minor
> infraction in drivers poking at members seems to prove this is not in
> fact needed.

Yes, it is subjective, my experience is completely opposite :). Every
time the internals were exposed, they were abused.

IMHO, the one user that poked into the struct devlink internals is a pure
luck together with lack of devlink adoption outside of the netdev which
limited number of devlink API users. The more devlink will be used, the
more creative usage will be.

For example, ionic had internal logic based on internal devlink_port state:
 * c2255ff47768 ("ionic: cleanly release devlink instance")
 * d7907a2b1a3b ("devlink: Remove duplicated registration check")

However, this patch was written not because of having right software
abstraction, but because of the next patch, where I needed to have
declaration of "struct devlink_ops" before struct devlink itself.

Without this patch, I would need to heavily reshuffle include/net/devlink.h
to have structs declarations written in different order. So a lot of
churn for something that needs to be fixed anyway (in my opinion).

Thanks
