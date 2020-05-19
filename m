Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A64B1DA528
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgESXKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgESXKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 19:10:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0AE20578;
        Tue, 19 May 2020 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589929820;
        bh=7Ep1MFTFzKnc0sOL3G5s22ZG0WZsNfbffvYvVKgxsLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WaA0MObQCTZquno/jHTNHwrBAMRQsC7SIofl8oCa4WJY/WKoBF1S+VkvjVisACT48
         sJXJS6S/t7MSAXF/oeLzEQ0yZQ93ratIMrfOyKdcvEJZokvq9oqrwOjwY3Q4pPHzEK
         d1u+Khm4ay6FhFZwnSzwWVXX+laDyxVTeBtg0/C8=
Date:   Tue, 19 May 2020 16:10:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net/tls: fix encryption error checking
Message-ID: <20200519161018.0f9be0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e4ec82ba-10e5-8b23-4da5-5883f3a89b92@novek.ru>
References: <1589883643-6939-1-git-send-email-vfedorenko@novek.ru>
        <20200519150420.485c800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e4ec82ba-10e5-8b23-4da5-5883f3a89b92@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 01:49:33 +0300 Vadim Fedorenko wrote:
> On 20.05.2020 01:04, Jakub Kicinski wrote:
> > On Tue, 19 May 2020 13:20:43 +0300 Vadim Fedorenko wrote:  
> >> bpf_exec_tx_verdict() can return negative value for copied
> >> variable. In that case this value will be pushed back to caller
> >> and the real error code will be lost. Fix it using signed type and
> >> checking for positive value.
> >>
> >> Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> >> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> >> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>  
> > If the error encountered is transient we will still drop some data from
> > the stream, because the record that was freed may have included data
> > from a previous send call. Still, cleaning up the error code seems like
> > an improvement.
> >
> > John, do you have an opinion on this?  
> 
> Jakub, maybe it is better to free only in case of fatal encryption error? I mean
> when sk->sk_err is EBADMSG. Because in case of ENOMEM we will iterate to
> alloc_payload and in case of ENOSPC we will return good return code and send
> open_rec again on next call. The EBADMSG state is the only fatal state that needs
> freeing of allocated record.

Sounds good!
