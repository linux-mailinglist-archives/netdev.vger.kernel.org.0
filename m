Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42D8199614
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgCaMOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbgCaMOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 08:14:44 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BE720714;
        Tue, 31 Mar 2020 12:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585656884;
        bh=zMWOFFv4ct6bAsND3kQvkxIGAcQNiNWGobm31SRZOKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvN3gzNKla8HX54j+mWh1lP9C5LxT9buw08aRf86vWDaELxDR9AcbD9GXzXPLrBVu
         xAK9iUT/Q+wzL3cFak4C3PbLEj2CNdU4n1HXjjw7D8NrtTuoyKGz8ELWtkO8Zf61EF
         YuxUKaOLvEHNfHTHbiCtL8Ow0n4n3fZeKW2Oi8NY=
Date:   Tue, 31 Mar 2020 13:14:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC PATCH] tun: Don't put_page() for all negative return values
 from XDP program
Message-ID: <20200331121438.GA30061@willie-the-truck>
References: <20200330161234.12777-1-will@kernel.org>
 <fd4d792f-32df-953a-a076-c09ed5dea573@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd4d792f-32df-953a-a076-c09ed5dea573@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 10:59:01AM +0800, Jason Wang wrote:
> On 2020/3/31 上午12:12, Will Deacon wrote:
> > When an XDP program is installed, tun_build_skb() grabs a reference to
> > the current page fragment page if the program returns XDP_REDIRECT or
> > XDP_TX. However, since tun_xdp_act() passes through negative return
> > values from the XDP program, it is possible to trigger the error path by
> > mistake and accidentally drop a reference to the fragments page without
> > taking one, leading to a spurious free. This is believed to be the cause
> > of some KASAN use-after-free reports from syzbot [1], although without a
> > reproducer it is not possible to confirm whether this patch fixes the
> > problem.
> > 
> > Ensure that we only drop a reference to the fragments page if the XDP
> > transmit or redirect operations actually fail.
> > 
> > [1] https://syzkaller.appspot.com/bug?id=e76a6af1be4acd727ff6bbca669833f98cbf5d95
> 
> 
> I think the patch fixes the issue reported. Since I can see the warn of bad
> page state in put_page().

[...]

> Acked-by: Jason Wang <jasowang@redhat.com>

Thanks, Jason. In which case, I'll add this tag along with:

Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")

Will
