Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1273E179EA4
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 05:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgCEEeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 23:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgCEEeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 23:34:12 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B84D208CD;
        Thu,  5 Mar 2020 04:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583382852;
        bh=4hFzFICOZmaSh1SoGG48FKAkmeTpvW0kGM9+awXa00c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sxz16/8QRZDQI9O4z4Pc/Bj1FTgmGW9NTj/bhCOKmsP0mIK9gpKtij6uS3suW+XC6
         4LMdN+3p0iebOhTgp+FVEtlfTW54d/kdc/4yK56xa3pzXO4tc0LucyEVO4nAJMRT/v
         Nzz6GpT9mi4PgUjCpcYy4XL6ipo5TA2BTYOkJkj4=
Date:   Wed, 4 Mar 2020 20:34:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304203409.23987c58@kicinski-fedora-PC1C0HJN>
In-Reply-To: <443c085ff3bcc06ad15c34f44f0407a0861dadeb.camel@linux.intel.com>
References: <20200304043354.716290-1-kuba@kernel.org>
        <20200304043354.716290-2-kuba@kernel.org>
        <20200304075926.GH4264@unicorn.suse.cz>
        <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
        <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
        <20200304102705.192d3b0a@kicinski-fedora-PC1C0HJN>
        <443c085ff3bcc06ad15c34f44f0407a0861dadeb.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Mar 2020 10:50:57 -0800 Alexander Duyck wrote:
> I just figured that by making in an enum it becomes less error prone since
> you can't accidentally leave a gap or end up renumbering things
> unintentionally.

True. That said the API will remain frozen for a little bit
longer - until the netlink conversion of this op.

> Combine that with some logic to take care of the bit
> shifting and it wouldn't differ much from how we handle the netdev feature
> flags and the like.

To be honest it was netdev features that made me dislike the model
slightly :)

Drivers sometimes print features as a hex u64 and trying to decode
that with the automatically assigned bits takes extra effort :S

With straight up defines I can do:

for i in `seq 0 32`; do 
	[ $((x & (1<<i))) -ne 0 ] && git grep "ETHTOOL_COALESCE_.*BIT($i)"
done

where x is set to whatever the driver printed. E.g.:

$ x=0xc37c0; for i in `seq 0 22`; do [ $((x & (1<<i))) -ne 0 ] && git grep  "ETHTOOL_COALESCE_.*BIT($i)"; done
include/linux/ethtool.h:#define ETHTOOL_COALESCE_TX_USECS_IRQ           BIT(6)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ      BIT(7)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_STATS_BLOCK_USECS      BIT(8)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_USE_ADAPTIVE_RX        BIT(9)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_USE_ADAPTIVE_TX        BIT(10)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_RX_USECS_LOW           BIT(12)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW      BIT(13)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH     BIT(18)
include/linux/ethtool.h:#define ETHTOOL_COALESCE_TX_USECS_HIGH          BIT(19)

With enum there are no explicit numbers so nothing to grep for.
I could probably squeeze this information out of debug info, but 
debug info incantations don't stick in my memory.

IDK if that's a sane or valid reason, LMK if you feel strongly and
I'll convert. We'll probably revisit this anyway when netlink comes
with the attribute presence checking.
