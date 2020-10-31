Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB122A1A90
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgJaUjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgJaUjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 16:39:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C20820723;
        Sat, 31 Oct 2020 20:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604176751;
        bh=2IxDiNfwRCXuBIQooHsPIFpcohcR6EDRRHUp1Obm3XM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Isn0UN9yX16ODLKwN/2EudJAln3WDgPBFwIvxy5wfBPcn9TvNEcs3uj8k8egu4UUX
         INdpaXKb1md7Gs7BKhYUKGzNiNvMGxRwJdkhA8gazpGTf79b/8bpPUQ6I3tkAcM58F
         +W7SdQv2Y6a1MMgvH+wflZkV48bptjfWcXTyjUOU=
Date:   Sat, 31 Oct 2020 13:39:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next v6 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
Message-ID: <20201031133910.7f7e0d72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+FuTSfkMBow-2xvY1SKuiQQVicbxYSD0agCdGwr_h8ceXA8Fw@mail.gmail.com>
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
        <20201031004918.463475-2-xie.he.0141@gmail.com>
        <CA+FuTSfKzKZ02st-enPfsgaQwTunPrmyK2x2jobZrWGb16KN0w@mail.gmail.com>
        <CAJht_EOhnrBG3R8vJS559nugtB0rHVNBdM_ypJWiAN_kywevrg@mail.gmail.com>
        <CAJht_EMgt4RF_Y1fV7_6VdzbMu0Fn8o+yW8C2RfnSsLjqsm_cg@mail.gmail.com>
        <CA+FuTSfkMBow-2xvY1SKuiQQVicbxYSD0agCdGwr_h8ceXA8Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 15:47:28 -0400 Willem de Bruijn wrote:
> On Sat, Oct 31, 2020 at 12:02 PM Xie He <xie.he.0141@gmail.com> wrote:
> > On Sat, Oct 31, 2020 at 8:18 AM Xie He <xie.he.0141@gmail.com> wrote:  
> > > > Especially without that, I'm not sure this and the follow-on patch add
> > > > much value. Minor code cleanups complicate backports of fixes.  
> > >
> > > To me this is necessary, because I feel hard to do any development on
> > > un-cleaned-up code. I really don't know how to add my code without
> > > these clean-ups, and even if I managed to do that, I would not be
> > > happy with my code.  
> 
> That is the reality of working in this space, I think. I have
> frequently restructured code, fixed a bug and then worked backwards to
> create a *minimal* bugfix that applies to the current code as well as
> older stable branches.
> 
> Obviously this is more of a concern for stable fixes than for new
> code. But we have to keep in mind that every code churn will make
> future bug fixes harder to roll out to users. That is not to say that
> churn should be avoided, just that we need to balance a change's
> benefit against this cost.
> 
> > And always keeping the user interface and even the code unchanged
> > contradicts my motivation of contributing to the Linux kernel. All my
> > contributions are motivated by the hope to clean things up. I'm not an
> > actual user of any of the code I contribute. If we adhere to the
> > philosophy of not doing any clean-ups, my contributions would be
> > meaningless.  
> 
> There are cleanups and cleanups. Dead code removal and deduplication
> of open coded logic, for instance, are very valuable. As is, for
> instance, your work in making sense of hard_header_len.

Or removing the buggy uses of IFF_TX_SKB_SHARING, for that matter
(which at this point I agree we should just remove from ether_setup, 
and let people who care re-enable it).

> Returning code in branches vs an error jump label seems more of a
> personal preference, and to me does not pass the benefit/cost threshold.

I must agree.
