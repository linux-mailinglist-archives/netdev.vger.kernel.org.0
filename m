Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8018839A991
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFCRy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhFCRy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C66861361;
        Thu,  3 Jun 2021 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622742793;
        bh=/4+zqLM/v5L+l1gJvmrPkAnFdvQifn4m+n1bUWinqI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S7L2kPDWr+/Us0lQm787aWEhcQTWzAzDl+4Q6HaptAcIY6rTylqwm8p2b/9VRu5Q4
         R4M4joTvINf9ts7vQqVSItcBFo3Li8HHGhQeoCvd0IKQz56xp76H7e4R+bhE3sNPBZ
         DvpxN0JhR8/qZhXOgKcULS+qBNBUvEuIbd6xX4WaBzPHzFvGVAOWn0xqODFv+BRprI
         2OGkbnLZbWIvPWslCIgQsz9g12OUn+gXpyu27nNhHlOcyu8q82uNgwD7PbXNIFR70d
         gZwxFBBmFu9+hb+1RtLJu9Ah1YFY6zVikab/z/TRxi864AcQnDB6fSc83QvWcq1xIr
         bTuZL/VrjDSPw==
Date:   Thu, 3 Jun 2021 10:53:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <20190301120358.7970f0ad@cakuba.netronome.com>
        <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190304174551.2300b7bc@cakuba.netronome.com>
        <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
        <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
        <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
        <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 11:46:43 +0800 Yunsheng Lin wrote:
> >> can devlink port be used to indicate different PF in the same ASIC,
> >> which already has the bus identifiers in it? It seems we need a
> >> extra identifier to indicate the ASIC?
> >>
> >> $ devlink port show
> >> ...
> >> pci/0000:03:00.0/61: type eth netdev sw1p1s0 split_group 0  
> > 
> > Ports can obviously be used, but which PCI device will you use to
> > register the devlink instance? Perhaps using just one doesn't matter 
> > if there is only one NIC in the system, but may be confusing with
> > multiple NICs, no?  
> 
> Yes, it is confusing, how about using the controler_id to indicate
> different NIC? we can make sure controler_id is unqiue in the same
> host, a controler_id corresponds to a devlink instance, vendor info
> or serial num for the devlink instance can further indicate more info
> to the system user?
> 
> pci/controler_id/0000:03:00.0/61

What is a "controller id" in concrete terms? Another abstract ID which
may change on every boot?

> >> Does it make sense if the PF first probed creates a auxiliary device,
> >> and the auxiliary device driver creates the devlink instance? And
> >> the PF probed later can connect/register to that devlink instance?  
> > 
> > I would say no, that just adds another layer of complication and
> > doesn't link the functions in any way.  
> 
> How about:
> The PF first probed creates the devlink instance? PF probed later can
> connect/register to that devlink instance created by the PF first probed.
> It seems some locking need to ensure the above happens as intended too.
> 
> About linking, the PF provide vendor info/serial number(or whatever is
> unqiue between different vendor) of a controller it belong to, if the
> controller does not exist yet, create one and connect/register to that
> devlink instance, otherwise just do the connecting/registering.

Sounds about right, but I don't understand why another ID is
necessary. Why not allow devlink instances to have multiple names, 
like we allow aliases for netdevs these days?
