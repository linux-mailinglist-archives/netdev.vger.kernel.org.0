Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E93A1DBFF2
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgETUMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgETUMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:12:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5EA8207F9;
        Wed, 20 May 2020 20:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590005549;
        bh=VsVClakRPy6bGHvaGlANEDqYRriY8y9RpxmChK/x+YA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0imO1Vk6PRg7NQ7LjGO2L4xQ9+twoTEJYqJaGHCmrN0XSOdDuvIofkVwzRS1/STHv
         MUfpQvL8OgkrxTjqE9XJhvtIOT1NrOz7txuYr1gaxJEi4orQeCLXUF+DLJrqgR9bL4
         aC5U5UAyIZZPbNoyPK9DJrjn9eme0Mf2n2xQjeIQ=
Date:   Wed, 20 May 2020 13:12:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        Pooja Trivedi <pooja.trivedi@stackpath.com>
Subject: Re: [PATCH net] net/tls(TLS_SW): Fix integrity issue with
 non-blocking sw KTLS request
Message-ID: <20200520131227.6f4301ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOrEds=e62EnDiB5b-5Btukp83OASVaVgBG28GkxSBw1F8sLSQ@mail.gmail.com>
References: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
        <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOrEds=Mo4YHm1CPrgVmPhsJagUAQ0PzyDPk9Cq3URq-7vfCWA@mail.gmail.com>
        <20200519144255.3a7416c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOrEds=e62EnDiB5b-5Btukp83OASVaVgBG28GkxSBw1F8sLSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 15:56:56 -0400 Pooja Trivedi wrote:
> On Tue, May 19, 2020 at 5:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 19 May 2020 13:21:56 -0400 Pooja Trivedi wrote:  
> > > On Mon, May 18, 2020 at 6:50 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > On Sun, 17 May 2020 16:26:36 +0000 Pooja Trivedi wrote:  
> > > > > In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
> > > > > encrypted record) gets treated as error, subtracts the offset, and
> > > > > returns to application. Because of this, application sends data from
> > > > > subtracted offset, which leads to data integrity issue. Since record is
> > > > > already encrypted, ktls module marks it as partially sent and pushes the
> > > > > packet to tcp layer in the following iterations (either from bottom half
> > > > > or when pushing next chunk). So returning success in case of EAGAIN
> > > > > will fix the issue.
> > > > >
> > > > > Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
> > > > > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> > > > > Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> > > > > Reviewed-by: Josh Tway <josh.tway@stackpath.com>  
> > > >
> > > > This looks reasonable, I think. Next time user space calls if no new
> > > > buffer space was made available it will get a -EAGAIN, right?  
> > >
> > > Yes, this fix should only affect encrypted record. Plain text calls from
> > > user space should be unaffected.  
> >
> > AFAICS if TCP layer is full next call from user space should hit
> > sk_stream_wait_memory() immediately and if it has MSG_DONTWAIT set
> > exit with EAGAIN. Which I believe to be correct behavior.
> >  
> 
> The flow is tls_sw_sendmsg/tls_sw_do_sendpage --> bpf_exec_tx_verdict -->
> tls_push_record --> tls_tx_records --> tls_push_sg --> do_tcp_sendpages
> 
> do_tcp_sendpages() sends partial record, 'retry:' label is exercised wherein
> do_tcp_sendpages gets called again and returns -EAGAIN.
> tls_push_sg sets partially_sent_record/partially_sent_offset and
> returns -EAGAIN. -EAGAIN bubbles up to bpf_exec_tx_verdict.
> In bpf_exec_tx_verdict, the following code causes 'copied' variable to
> get updated to a negative value and returns -EAGAIN.
> 
>                 err = tls_push_record(sk, flags, record_type);
>                 if (err && err != -EINPROGRESS) {
>                         *copied -= sk_msg_free(sk, msg);
>                         tls_free_open_rec(sk);
>                 }
>                 return err;
> 
> -EAGAIN returned by bpf_exec_tx_verdict causes
> tls_sw_sendmsg/tls_sw_do_sendpage to 'continue' in the while loop and
> call sk_stream_wait_memory(). sk_stream_wait_memory returns -EAGAIN
> also and control reaches the 'send_end:' label. The following return
> statement causes a negative 'copied' variable value to be returned to the
> user space.
> 
>         return copied ? copied : ret;
> 
> User space applies this negative value as offset for the next send, causing
> part of the record that was already sent to be pushed again.
> 
> Hope this clarifies it.

Oh yes, sorry I was talking about the behavior _after_ your patch, on
the _next_ sendmsg/sendpage call.

It should now work like this:

	bpf_exec_tx_verdict() returns success, next iteration of the
	sendmsg/sendpage loop hits sk_stream_wait_memory(), we return
	positive copied which is counts the entire record, even though
	some of it is still in partially_sent_record. If user space
	calls sendmsg again we will hit sk_stream_wait_memory() ->
	send_end -> this time copied is 0, so user space will see
	-EAGAIN.

If I'm still not making sense don't worry about it, I think it should
be easy to explain based on the selftest.
