Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D73432A69
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhJRXth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRXtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D468610A2;
        Mon, 18 Oct 2021 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634600844;
        bh=01BPMbgtbStc/w2jmHs+Cl4JpYePhsSi4xXQi+Zivuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G73rTtzXWhdjN2L1DKYpdB4Hhn5ONabQ1EcQb9LZ+mEry1ZStEAh17GiIiwP5Iu+b
         /QCQ/uouR9RfkV6n6TLJ/Cw27Q4CpsHteqJsuNNE7WzH/L6hOhOZu3vuNMam8WI3YY
         3CigrhJghU0R4ECTCTL4ZcDBex1SFKN7WYOvbfkc41jraElRualsuJK4loh5XSSYMM
         DbjBR77B1TzuJ8xw9BqYqdem9cbAMNhHdVN5yx6FpXNjzV2vRyyrJlab6MXvgyudU3
         vP5PPs79dAEDsHNfmzupQxjhAl5b5fynbPlaf36PJnAyaFRO/0Ts6KOpnKnaX+JBkk
         MSmsme7i2v75g==
Date:   Mon, 18 Oct 2021 16:47:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20211018164723.02919102@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
        <YW3t8AGxW6p261hw@us.ibm.com>
        <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 16:36:36 -0700 Dany Madden wrote:
> > The BUG_ON() is here to make sure that when napi_enable() is called the
> > napi instance was dormant, i.e. disabled. We have "STATE_SCHED" bit set
> > on disabled NAPIs because that bit means ownership. Whoever disabled
> > the NAPI owns it.
> > 
> > That BUG_ON() could have been taken outside of the loop, there's no
> > point re-checking on every try.
> > 
> > Are you seeing NAPI-related failures? We had at least 3 reports in the
> > last two weeks of strange failures which look like NAPI state getting
> > corrupted on net-next...  
> 
> We hit two napi related crashes while attempting mtu size change.

Is it reproducible or happens rarely and randomly?
