Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4781D8B98
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgERXXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgERXXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:23:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B4D20756;
        Mon, 18 May 2020 23:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589844225;
        bh=yBZxl1prXENQNFNuEJbH90mO2ojabttl7f6AX3e4vfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=prQWezZwc25ehGFmg/fn05A9cAj21qdxoZ4uqV+sbXx+Ki1REeYUtGNoJgbcdLFjS
         sLZ7jBTQo3GT5r4SAd2bqVmsIytMTpWrS5HTh78WfEkUhPGl3INcWJKja/FuLpeyNb
         G+HYt3+hmy0NwfDZtP8d8jyqeT7jblsZHYOcbRtQ=
Date:   Mon, 18 May 2020 16:23:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/tls: fix encryption error checking
Message-ID: <20200518162343.7685f779@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e26b157f-edc4-4a04-11ac-21485ed52f8a@novek.ru>
References: <20200517014451.954F05026DE@novek.ru>
        <20200518153005.577dfe99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANN+EMpn2ZkquAdK5WFC-bmioSoAbAtNvovXtgTyTHW+-eDPhw@mail.gmail.com>
        <e26b157f-edc4-4a04-11ac-21485ed52f8a@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 02:05:29 +0300 Vadim Fedorenko wrote:
> On 19.05.2020 01:30, Jakub Kicinski wrote:
> > > tls_push_record can return -EAGAIN because of tcp layer. In that
> > > case open_rec is already in the tx_record list and should not be
> > > freed.
> > > Also the record size can be more than the size requested to write
> > > in tls_sw_do_sendpage(). That leads to overflow of copied variable
> > > and wrong return code.
> > >
> > > Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> > > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru> =20
> >
> > Doesn't this return -EAGAIN back to user space? Meaning even tho we
> > queued the user space will try to send it again? =20
> Before patch it was sending negative value back to user space.
> After patch it sends the amount of data encrypted in last call. It is che=
cked
> by:
>  =C2=A0return (copied > 0) ? copied : ret;
> and returns -EAGAIN only if data is not sent to open record.

I see, you're fixing two different bugs in one patch. Could you please
split the fixes into two? (BTW no need for parenthesis around the
condition in the ternary operator.) I think you need more fixes tags,
too. Commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
already added one instance of the problem, right?

What do you think about Pooja's patch to consume the EAGAIN earlier?
There doesn't seem to be anything reasonable we can do with the error
anyway, not sure there is a point checking for it..
