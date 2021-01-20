Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6A2FC89A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbhATDRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733120AbhATCod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DBC230FE;
        Wed, 20 Jan 2021 02:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611110631;
        bh=0MMyI2z98JvqPupBrcpqvKMGv3G31lByXOs4PyfXTEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zjs5p+Jfg1VjtnTr/pAO+b8Z1CSrnpxSHE1o9ZQNar81FQuMBY14aD50E7xUWmvoq
         lTjQtl19MyEjL6g4IaZ1/+VyD5rWWLvB4l6UhywcxKXpT2xnYFWQN5+ttPrHexGVv3
         ZDX7lU5ICIKZZRsFzvlFGykqPsKNi7r3usjONvsd70N7ZU9BzHQjK45q6iu+9xuKo9
         pV2WHydCwlP4rSPUCU194rJSojiXueuztVEa60qfG6Yk2hc03seKtxQu1lqY382oO2
         XsjWUlhkwdBNB7Qk8FXfpABEyGL5x7+d08c6yO61CML8t6e0Xxz+HqfNCKyV2U/yx8
         KtIgTkdrKGPIg==
Date:   Tue, 19 Jan 2021 18:43:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH v2 net-next] net: fix GSO for SG-enabled devices.
Message-ID: <20210119184349.493981e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADvbK_ddoLTOH2q2v1NJW1igXaD2pN9SpWQJ3Td9S3Dx0h0n-Q@mail.gmail.com>
References: <861947c2d2d087db82af93c21920ce8147d15490.1611074818.git.pabeni@redhat.com>
        <CADvbK_ddoLTOH2q2v1NJW1igXaD2pN9SpWQJ3Td9S3Dx0h0n-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 10:17:44 +0800 Xin Long wrote:
> On Wed, Jan 20, 2021 at 12:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > The commit dbd50f238dec ("net: move the hsize check to the else
> > block in skb_segment") introduced a data corruption for devices
> > supporting scatter-gather.
> >
> > The problem boils down to signed/unsigned comparison given
> > unexpected results: if signed 'hsize' is negative, it will be
> > considered greater than a positive 'len', which is unsigned.
> >
> > This commit addresses resorting to the old checks order, so that
> > 'hsize' never has a negative value when compared with 'len'.
> >
> > v1 -> v2:
> >  - reorder hsize checks instead of explicit cast (Alex)
> >
> > Bisected-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Fixes: dbd50f238dec ("net: move the hsize check to the else block in skb_segment")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>  
> Reviewed-by: Xin Long <lucien.xin@gmail.com>

I'm hitting this as well, so applied, thanks!

> > ---
> Reviewed-by: Xin Long <lucien.xin@gmail.com>

One review tag is enough ;) apparently patchwork doesn't know to dedup
them :S
