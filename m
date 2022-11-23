Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF0634FEA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbiKWGBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKWGBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:01:33 -0500
X-Greylist: delayed 100926 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 22:01:28 PST
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2110FF2439;
        Tue, 22 Nov 2022 22:01:27 -0800 (PST)
Received: from XMCDN1207038 (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltAAHT0s0t31jFbsAAA--.977S2;
        Wed, 23 Nov 2022 14:01:25 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'John Fastabend'" <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Jakub Sitnicki'" <jakub@cloudflare.com>,
        "'Lorenz Bauer'" <lmb@cloudflare.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com> <1669082309-2546-3-git-send-email-yangpc@wangsu.com> <637d8d5bd4e27_2b649208eb@john.notmuch>
In-Reply-To: <637d8d5bd4e27_2b649208eb@john.notmuch>
Subject: Re: [PATCH RESEND bpf 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
Date:   Wed, 23 Nov 2022 14:01:24 +0800
Message-ID: <000001d8ff01$053529d0$0f9f7d70$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGntG3gSsG5fexUwyK4ofUjVybadQE5HE+MAYsC+QCumHN5YA==
Content-Language: zh-cn
X-CM-TRANSID: SyJltAAHT0s0t31jFbsAAA--.977S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1kCF4DAry7XF15Gw48WFg_yoW5GFW5pF
        1vyaySkFWxCry2gw1SqFs5XFWxuw18tFyjkr1Ik3Wft34kKr1rtrn5GFy3ZFn5trs7Cw4S
        qF4UWFZ8CrW3ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> wrote:
> 
> Pengcheng Yang wrote:
> > When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
> > flag from the msg->flags. If apply_bytes is used and it is larger than
> > the current data being processed, sk_psock_msg_verdict() will not be
> > called when sendmsg() is called again. At this time, the msg->flags is 0,
> > and we lost the BPF_F_INGRESS flag.
> >
> > So we need to save the BPF_F_INGRESS flag in sk_psock and assign it to
> > msg->flags before redirection.
> >
> > Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > ---
> >  include/linux/skmsg.h | 1 +
> >  net/core/skmsg.c      | 1 +
> >  net/ipv4/tcp_bpf.c    | 1 +
> >  net/tls/tls_sw.c      | 1 +
> >  4 files changed, 4 insertions(+)
> >
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index 48f4b64..e1d463f 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -82,6 +82,7 @@ struct sk_psock {
> >  	u32				apply_bytes;
> >  	u32				cork_bytes;
> >  	u32				eval;
> > +	u32				flags;
> >  	struct sk_msg			*cork;
> >  	struct sk_psock_progs		progs;
> >  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 188f855..ab2f8f3 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -888,6 +888,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
> >  		if (psock->sk_redir)
> >  			sock_put(psock->sk_redir);
> >  		psock->sk_redir = msg->sk_redir;
> > +		psock->flags = msg->flags;
> >  		if (!psock->sk_redir) {
> >  			ret = __SK_DROP;
> >  			goto out;
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index ef5de4f..1390d72 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -323,6 +323,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
> >  		break;
> >  	case __SK_REDIRECT:
> >  		sk_redir = psock->sk_redir;
> > +		msg->flags = psock->flags;
> >  		sk_msg_apply_bytes(psock, tosend);
> >  		if (!psock->apply_bytes) {
> >  			/* Clean up before releasing the sock lock. */
>                  ^^^^^^^^^^^^^^^
> In this block reposted here with the rest of the block
> 
> 
> 		if (!psock->apply_bytes) {
> 			/* Clean up before releasing the sock lock. */
> 			eval = psock->eval;
> 			psock->eval = __SK_NONE;
> 			psock->sk_redir = NULL;
> 		}
> 
> Now that we have a psock->flags we should clera that as
> well right?

According to my understanding, it is not necessary (but can) to clear
psock->flags here, because psock->flags will be overwritten by msg->flags
at the beginning of each redirection (in sk_psock_msg_verdict()).

