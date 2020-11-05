Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DB72A8278
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgKEPpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgKEPpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 10:45:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF3B206FA;
        Thu,  5 Nov 2020 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604591113;
        bh=RYfcojP3xQPdgNO24dCEuSYbe3kFwBI9UaElG668AGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WUwkmm5MK3MfjMJKe/ZGRT7ERL++vJOrKm12aDuXQEi30a6pVcfAU6unoYTvoEOlF
         I+zYBqAGCEYm9vIR+7awtLUxv0p75nKTNY/qrgObV4Ns3gOD1775K0cM1XKiYZM6bd
         P6Pq35Qn0c69LObw3Lo2vkRNCDgGpXO27/tg2Q84=
Date:   Thu, 5 Nov 2020 07:45:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next 1/6] i40e: introduce lazy Tx completions for
 AF_XDP zero-copy
Message-ID: <20201105074511.6935e8b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ8uoz3-tjXekU=kR+HfMhGBcHtAFnKGq1ZvpFq99T_S-mknPg@mail.gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
        <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com>
        <20201104153320.66cecba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJ8uoz3-tjXekU=kR+HfMhGBcHtAFnKGq1ZvpFq99T_S-mknPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 15:17:50 +0100 Magnus Karlsson wrote:
> > I feel like this needs a big fat warning somewhere.
> >
> > It's perfectly fine to never complete TCP packets, but AF_XDP could be
> > used to implement protocols in user space. What if someone wants to
> > implement something like TSQ?  
> 
> I might misunderstand you, but with TSQ here (for something that
> bypasses qdisk and any buffering and just goes straight to the driver)
> you mean the ability to have just a few buffers outstanding and
> continuously reuse these? If so, that is likely best achieved by
> setting a low Tx queue size on the NIC. Note that even without this
> patch, completions could be delayed. Though this patch makes that the
> normal case. In any way, I think this calls for some improved
> documentation.

TSQ tries to limit the amount of data the TCP stack queues into TC/sched
and drivers. Say 1MB ~ 16 GSO frames. It will not queue more data until
some of the transfer is reported as completed. 

IIUC you're allowing up to 64 descriptors to linger without reporting
back that the transfer is done. That means that user space implementing
a scheme similar to TSQ may see its transfers stalled.
