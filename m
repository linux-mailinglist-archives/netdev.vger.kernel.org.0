Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50C240B28C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhINPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhINPJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 11:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F7B2610A6;
        Tue, 14 Sep 2021 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631632067;
        bh=rFbctYQV3lSubXAIKKognwcFjtYtHX8cUl/47qBUlbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fypzQKSPsqqLC2/2/W1S+p0+8zubkO/xfoIvN4MYGccNQ/F6V0M3/QAH8Vhdl6Np3
         5no9HYdCmqI5akxlX3baIoQ9HzymVncgB0QSIjRVZkPwtr1QDJFioXVwJBkxUk9qqY
         HTqyE85phLif1zz5AiTgmlaPc2s4vg4VGvUrMTm4+XGiIY/wryxjnmQxx0f+4Vcs3U
         TLI64Az9la7fGP9K2a4/Ek+3NHrg8tCp73tnPU+SdZOocmGX+9fht8LZ6wYxhM4Lm4
         iyZ/9QZHjY4BbwOngdnrK9Tnebl+UW7MMo0p6HCLs7g5TFJopJ99ghm9l4m5e4V3fQ
         2sMnCYptrw8Ug==
Date:   Tue, 14 Sep 2021 08:07:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <john.hurley@netronome.com>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Questioning requirement for ASSERT_RTNL in indirect code
Message-ID: <20210914080746.77ed3c7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210914145439.GA6722@mtl-vdi-166.wap.labs.mlnx>
References: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
        <20210914072629.3d486b6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210914145439.GA6722@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 17:54:39 +0300 Eli Cohen wrote:
> On Tue, Sep 14, 2021 at 07:26:29AM -0700, Jakub Kicinski wrote:
> > On Tue, 14 Sep 2021 09:05:00 +0300 Eli Cohen wrote:  
> > > I see the same assert and the same comment, "All callback list access
> > > should be protected by RTNL.", in the following locations
> > > 
> > > drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:1873
> > > drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:303
> > > drivers/net/ethernet/netronome/nfp/flower/offload.c:1770
> > > 
> > > I assume the source of this comment is the same. Can you guys explain
> > > why is this necessary?  
> > 
> > Because most drivers (all but mlx5?) depend on rtnl_lock for
> > serializing tc offload operations.
> >   
> 
> But the assert I am referring to is called as part of setting up the
> callback that will be used for offload operations, e.g. for adding a new
> filter with tc. It's not the actual filter insetion code.
> 
> And as far as I can see this call sequence is already serialized by
> flow_indr_block_lock.

Hm, indeed, should've looked at the code. There doesn't seem to be
anything on the driver side this is protecting. The assert was added
before the flow/nftables rewrite of the infra, perhaps that's the
answer. IOW the lock did not exist back then.
