Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9730D2B2A47
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKNBBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgKNBBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 20:01:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465E222254;
        Sat, 14 Nov 2020 01:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605315714;
        bh=FBelx2mOwdKe0Kdyhjx2yz0PqZaMpZ7QaxWE9Qy3gA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vzNwIKmNr79Cm0FxUlj5RD5fVP1nop+Zb2BVAwaWCV5++l3hzlUcvYu8hu9CHwGux
         mmvVxS0zSQ/Sg0gwBvHDYQLkQMxfrcACNS1xBnVap1yQSkCExmFlRskrG5gtpsBip+
         bDuOVnK3jWrUgEsoSXiXSxQRoMMMT0sHT1zZhOgE=
Date:   Fri, 13 Nov 2020 17:01:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        pieter.jansenvanvuuren@netronome.com, netdev@vger.kernel.org,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH] ip_tunnels: Set tunnel option flag when tunnel metadata
 is present
Message-ID: <20201113170153.6ce31890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63d717ab-be9b-8b75-e4a0-7cac98facd14@iogearbox.net>
References: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
        <20201113161359.77559aa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <63d717ab-be9b-8b75-e4a0-7cac98facd14@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 01:46:04 +0100 Daniel Borkmann wrote:
> On 11/14/20 1:13 AM, Jakub Kicinski wrote:
> > On Tue, 10 Nov 2020 16:16:40 -0800 Yi-Hung Wei wrote:  
> >> Currently, we may set the tunnel option flag when the size of metadata
> >> is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
> >> no matter the geneve option is present or not.  As this may result in
> >> issues on the tunnel flags consumers, this patch fixes the issue.
> >>
> >> Related discussion:
> >> * https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u
> >>
> >> Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
> >> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>  
> > 
> > Seems fine to me, however BPF (and maybe Netfilter?) can set options
> > passed by user without checking if they are 0 length.
> > 
> > Daniel, Pablo, are you okay with this change or should we limit it to
> > just fixing the GENEVE oddness?  
> 
> Verifier will guarantee that buffer passed into helper is > 0, so seems
> okay from BPF side.

Okay then, the potential change for netfilter is limited to GENEVE
so doesn't move the needle.

Applied, thanks!
