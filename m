Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A616435871
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhJUBvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 21:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJUBvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:51:19 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E45C06161C;
        Wed, 20 Oct 2021 18:49:04 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id x1so27009623iof.7;
        Wed, 20 Oct 2021 18:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F8i24HkaoIEfH0KIiAP2xmE50SVVRPGmgxng9YFCm3w=;
        b=EJ1Ii606IDL3waAbKwNi+0gqeUM11VYA7bQEqPKh8UqxM/zHTU7AEUGWdT2PlGm5RH
         D7jnSVyZJsrCSjjRFh4SxF2EA27XZXG+++xtKmICt83oaFG48TQashh4O00BJbJkgN3A
         5AhqqppG5Zu5Bn1MIm+Bjx8tguevTwT/ZZAFRj3w9rAxVZ3FzVRRshuZFZOI4unlY/x4
         YLr+iDE5e3suFEPow8ETMAuaDDLK8RhK5jmagSkvQlBdRz0Wm4D4AeoLOS8LgvZYdTTZ
         U0DCYZHMu3jznROry+1zXOQDOejhCMcFHJv4GH4ujuB1X9RJ5xFmX0cFc7njmGYbEr8u
         OMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F8i24HkaoIEfH0KIiAP2xmE50SVVRPGmgxng9YFCm3w=;
        b=d4yHXtROhtMW1QR2KrMN/OWDt96j6zBtFSv7T1cw/nJ89BbyufGJZLm6QySkVPKog4
         unhXZPj/IXV0BQCRMCyUD212qHiBNeqXE5V3s3HUh70TGAZ39Qn9FHyVQZ+FeDV8K5OL
         GA4n8BcS/ciLnabtOxtj7TzOY/8C8r6esmH6UqxisE3f6kPu5sQL2OpscVaDv61UcTxC
         B37Zgcev20cH7LkNaTYxzfZjAboktUIeKivhIUg6DP/088jOgZ4Qw265Gz3WiQO6WwLb
         B4I4/J9bW/yMymMM/6Pxo/Bw9lGupfWgQsWxOHfSHLp9bH3LPbNGjQ/usHfKhYXzrdCi
         eG/g==
X-Gm-Message-State: AOAM5334ikJEwGeirSgvouWq/d33KAKRMbpfPY4wmqwD/QiAdOeGNlBZ
        ImAYLUBgsR05LnYmjCGrPuqModHUqvNkwKuAcZ0=
X-Google-Smtp-Source: ABdhPJybobrhwD1ECPVAbJeZqQEBoyANTyR5DCwvXKb4Eb/1tLLBL/mErAlL+4WmBfyHW+Cp+8u6GKCK6U+8jQfAUdU=
X-Received: by 2002:a02:a18c:: with SMTP id n12mr1890279jah.130.1634780943320;
 Wed, 20 Oct 2021 18:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211020232447.9548-1-jmaxwell37@gmail.com> <CANn89i+e3n6RveyuOhdfnQdJESdFvjgkgMjXSHCyuTRDB-E8Bw@mail.gmail.com>
In-Reply-To: <CANn89i+e3n6RveyuOhdfnQdJESdFvjgkgMjXSHCyuTRDB-E8Bw@mail.gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Thu, 21 Oct 2021 12:48:27 +1100
Message-ID: <CAGHK07AP3Em02rvuON0x__cWYxqCSkbDtxWatKScnZ6KU4wrGQ@mail.gmail.com>
Subject: Re: [net-next] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 12:11 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Oct 20, 2021 at 4:25 PM Jon Maxwell <jmaxwell37@gmail.com> wrote:
> >
> > A customer reported sockets stuck in the CLOSING state. A Vmcore reveal=
ed that
> > the write_queue was not empty as determined by tcp_write_queue_empty() =
but the
> > sk_buff containing the FIN flag had been freed and the socket was zombi=
ed in
> > that state. Corresponding pcaps show no FIN from the Linux kernel on th=
e wire.
> >
> > Some instrumentation was added to the kernel and it was found that ther=
e is a
> > timing window where tcp_sendmsg() can run after tcp_send_fin().
> >
> > tcp_sendmsg() will hit an error, for example:
> >
> > 1269 =E2=96=B9       if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN=
))=E2=86=A9
> > 1270 =E2=96=B9       =E2=96=B9       goto do_error;=E2=86=A9
> >
> > tcp_remove_empty_skb() will then free the FIN sk_buff as "skb->len =3D=
=3D 0". The
> > TCP socket is now wedged in the FIN-WAIT-1 state because the FIN is nev=
er sent.
> >
> > If the other side sends a FIN packet the socket will transition to CLOS=
ING and
> > remain that way until the system is rebooted.
> >
> > Fix this by checking for the FIN flag in the sk_buff and don't free it =
if that
> > is the case. Testing confirmed that fixed the issue.
> >
> > Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error c=
ases")
> > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >  net/ipv4/tcp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index c2d9830136d2..d2b06d8f0c37 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -938,7 +938,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, i=
nt flags)
> >   */
> >  void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
> >  {
> > -       if (skb && !skb->len) {
> > +       if (skb && !skb->len && !TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FI=
N) {
> >                 tcp_unlink_write_queue(skb, sk);
> >                 if (tcp_write_queue_empty(sk))
> >                         tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> >
>
> Very nice catch !
>

Thanks Eric.

> The FIN flag is a really special case here.
>
> What we need is to make sure the skb is 'empty' .
>
> What about using a single condition ?
>
> if (skb && TCP_SKB_CB(skb)->seq =3D=3D TCP_SKB_CB(skb)->end_seq)

Good call as the end_seq will be +1 for a FIN. So that's better.

Let me give the customer a kernel with your idea:

--- net/ipv4/tcp.c 2021-10-20 22:50:35.836001950 +0530
+++ net/ipv4/tcp.c.patch 2021-10-21 01:42:08.493569483 +0530
@@ -955,7 +955,7 @@
  */
 void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
- if (skb && !skb->len) {
+ if (skb && TCP_SKB_CB(skb)->seq =3D=3D TCP_SKB_CB(skb)->end_seq) {
  tcp_unlink_write_queue(skb, sk);
  if (tcp_write_queue_empty(sk))
  tcp_chrono_stop(sk, TCP_CHRONO_BUSY);

I'll ask the customer to confirm that the v1 patch as above also resolves
the issue. Although I expect it will.

Then I'll resubmit a v1 patch with your suggestion probably early next week=
.

Regards

Jon
