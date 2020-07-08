Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764F22184A0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgGHKEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbgGHKEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:04:37 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77A3C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 03:04:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a02:8010:6359:1:21b:21ff:fe6a:7e96])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 2A9B795348;
        Wed,  8 Jul 2020 11:04:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1594202675; bh=LPv9Q5wnMXNdR2ALhzagJtJWjc+TAdZQIEpPn0O7czc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCsuLSF/Dfs5fmoF9ysvDQhQ1ijo04ISotwFJb6AkhdH5iMyM+PsbtsRGeefcxw0G
         yHYSZ/hErxc0d/NwQXEJleFJJFZO8mPxH9lnpSPwbWrP262QeJBHadHFGahIDpEPow
         XvpmVjX2IkYJMKNuw5Rnkt2fVvexpoE33abe/f+oCJBbHxjlqzhOnmLXjjnKrJKpqo
         WT6Q0/L8Qr0uMDUkYpMvEcCpO3QZQT6GvYCHg6VQkW6DfZZTmlKXrJgtxGC3Nv6h37
         0w6SV7UyPsa5ReIz8/x6Vw3ImifK7/Dyl2oZRTdv53Zb5mQGQOU1w96mWltlE/7JW/
         I85Smdcky8R+Q==
Date:   Wed, 8 Jul 2020 11:04:34 +0100
From:   James Chapman <jchapman@katalix.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
Message-ID: <20200708100434.GA26371@katalix.com>
References: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
 <20200707172408.GA22308@katalix.com>
 <CADvbK_eGefF8ZZE74=GenWknj-ws4y6D95jji5e-FiRt36m-nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eGefF8ZZE74=GenWknj-ws4y6D95jji5e-FiRt36m-nA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On  Wed, Jul 08, 2020 at 04:08:09 +0800, Xin Long wrote:
> On Wed, Jul 8, 2020 at 1:24 AM James Chapman <jchapman@katalix.com> wrote:
> >
> > On  Tue, Jul 07, 2020 at 02:02:32 +0800, Xin Long wrote:
> > > In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
> > > skb's dst. However, it will eventually call inet6_csk_xmit() or
> > > ip_queue_xmit() where skb's dst will be overwritten by:
> > >
> > >    skb_dst_set_noref(skb, dst);
> > >
> > > without releasing the old dst in skb. Then it causes dst/dev refcnt leak:
> > >
> > >   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> > >
> > > This can be reproduced by simply running:
> > >
> > >   # modprobe l2tp_eth && modprobe l2tp_ip
> > >   # sh ./tools/testing/selftests/net/l2tp.sh
> > >
> > > So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
> > > should be dropped. This patch is to fix it by removing skb_dst_set()
> > > from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().
> > >
> > > Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> > > Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/l2tp/l2tp_core.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > > index fcb53ed..df133c24 100644
> > > --- a/net/l2tp/l2tp_core.c
> > > +++ b/net/l2tp/l2tp_core.c
> > > @@ -1028,6 +1028,7 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
> > >
> > >       /* Queue the packet to IP for output */
> > >       skb->ignore_df = 1;
> > > +     skb_dst_drop(skb);
> > >  #if IS_ENABLED(CONFIG_IPV6)
> > >       if (l2tp_sk_is_v6(tunnel->sock))
> > >               error = inet6_csk_xmit(tunnel->sock, skb, NULL);
> > > @@ -1099,10 +1100,6 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
> > >               goto out_unlock;
> > >       }
> > >
> > > -     /* Get routing info from the tunnel socket */
> > > -     skb_dst_drop(skb);
> > > -     skb_dst_set(skb, sk_dst_check(sk, 0));
> > > -
> > >       inet = inet_sk(sk);
> > >       fl = &inet->cork.fl;
> > >       switch (tunnel->encap) {
> > > --
> > > 2.1.0
> > >
> >
> > This patch doesn't seem right.
> 
> Hi James,
> >
> > For ipv4, the skb dst is used by skb_rtable. In ip_queue_xmit, if
> > skb_rtable returns a route, it follows the packet_routed label and
> > skb_dst_set_noref isn't done. Your patch is forcing every ipv4 l2tp
> > packet to be routed, which isn't what we want.
> Without this patch,
> it does skb_dst_drop() in l2tp_xmit_skb(),
> then do:
> skb_dst_set(skb, sk_dst_check(sk, 0));
> 
> With this patch:
> it does skb_dst_drop() in l2tp_xmit_core()
> 
> then in ip_queue_xmit(), it will do:
> rt = (struct rtable *)__sk_dst_check(sk, 0);
> skb_dst_set_noref(skb, &rt->dst);
> 
> so I don't think this patch drops any useful dst for ipv4.

You're right. My mistake.

Thanks for reporting and fixing this!

> >
> > I ran l2tp.sh and found that the issue happens only for l2tp tests
> > that use IPv6 IPSec in a routed topology.
> >
> > Perhaps the real problem is that l2tp shouldn't be using
> > inet6_csk_xmit and should instead use ip6_xmit?
> >
> > Please hold off on applying this patch while I look into it.

Acked-by: James Chapman <jchapman@katalix.com>
Tested-by: James Chapman <jchapman@katalix.com>
