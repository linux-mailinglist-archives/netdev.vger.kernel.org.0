Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7128D6C9
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgJMXH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:07:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F269221D40;
        Tue, 13 Oct 2020 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630448;
        bh=6joR4pBGRAg5tGFdOrvMWsG0Um6ZshpuEjCr1yc/Zjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TvnttRJ/o1Zmv8zeGxaP4lDi2sFd2n1jkkTJIH9M8Xq+s4AHvV5MN1QwjxyYnYeFh
         HcgF4B352hXO/cPFTaR24HiYISNWNLwUMERio+CcJ6rJspKTFy3WWxSFqFqS741rY5
         cJ8ijgw085W4QiWIm5OmuUK45VotDGZLpeo53rHg=
Date:   Tue, 13 Oct 2020 16:07:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201013160726.367e3871@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013224009.77d6f746@carbon>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
        <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201010124402.606f2d37@carbon>
        <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201013224009.77d6f746@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 22:40:09 +0200 Jesper Dangaard Brouer wrote:
> > FWIW I took a quick swing at testing it with the HW I have and it did
> > exactly what hardware should do. The TX unit entered an error state 
> > and then the driver detected that and reset it a few seconds later.  
> 
> The drivers (i40e, mlx5, ixgbe) I tested with didn't entered an error
> state, when getting packets exceeding the MTU.  I didn't go much above
> 4K, so maybe I didn't trigger those cases.

You probably need to go above 16k to get out of the acceptable jumbo
frame size. I tested ixgbe by converting TSO frames to large TCP frames,
at low probability.
