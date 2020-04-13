Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366121A62C1
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 07:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDMFyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 01:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgDMFyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 01:54:54 -0400
X-Greylist: delayed 339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Apr 2020 22:54:53 PDT
Received: from shells.gnugeneration.com (shells.gnugeneration.com [66.240.222.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77A2C0A3BE0;
        Sun, 12 Apr 2020 22:54:53 -0700 (PDT)
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 752141A402DF; Sun, 12 Apr 2020 22:49:14 -0700 (PDT)
Date:   Sun, 12 Apr 2020 22:49:14 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     =?utf-8?B?UsOpbWk=?= Denis-Courmont <remi@remlab.net>
Cc:     netdev@vger.kernel.org, courmisch@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/phonet/socket.c:LINE!
Message-ID: <20200413054914.euz7g2fcxsr74lfm@shells.gnugeneration.com>
References: <00000000000062b41d05a2ea82b0@google.com>
 <20200411004320.py2cashe4edsjdzp@shells.gnugeneration.com>
 <1806223.auBmcZeozp@basile.remlab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1806223.auBmcZeozp@basile.remlab.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 10:36:59AM +0300, Rémi Denis-Courmont wrote:
> 	Hi,
> 
> Le lauantaina 11. huhtikuuta 2020, 3.43.20 EEST Vito Caputo a écrit :
> > I stared a bit at the code surrounding this report, and maybe someone more
> > familiar with the network stack can clear something up for me real quick:
> > > RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
> > 
> > net/phonet/socket.c:
> > 202 static int pn_socket_autobind(struct socket *sock)
> > 203 {
> > 204         struct sockaddr_pn sa;
> > 205         int err;
> > 206
> > 207         memset(&sa, 0, sizeof(sa));
> > 208         sa.spn_family = AF_PHONET;
> > 209         err = pn_socket_bind(sock, (struct sockaddr *)&sa,
> > 210                                 sizeof(struct sockaddr_pn));
> > 211         if (err != -EINVAL)
> > 212                 return err;
> > 213         BUG_ON(!pn_port(pn_sk(sock->sk)->sobject));
> > 214         return 0; /* socket was already bound */
> > 215 }
> > 
> > line 213 is the BUG_ON for !sock->sk->sobject, a phonet-specific member:
> > 
> > include/net/phonet/phonet.h:
> >  23 struct pn_sock {
> >  24         struct sock     sk;
> >  25         u16             sobject;
> >  26         u16             dobject;
> >  27         u8              resource;
> >  28 };
> > 
> > pn_socket_autobind() expects that to be non-null whenever pn_socket_bind()
> > returns -EINVAL, which seems odd, but the comment claims it's already bound,
> > let's look at pn_socket_bind():
> > 
> > net/phonet/socket.c:
> > 156 static int pn_socket_bind(struct socket *sock, struct sockaddr *addr,
> > int len) 157 {
> > 158         struct sock *sk = sock->sk;
> > 159         struct pn_sock *pn = pn_sk(sk);
> > 160         struct sockaddr_pn *spn = (struct sockaddr_pn *)addr;
> > 161         int err;
> > 162         u16 handle;
> > 163         u8 saddr;
> > 164
> > 165         if (sk->sk_prot->bind)
> > 166                 return sk->sk_prot->bind(sk, addr, len);
> > 167
> > 168         if (len < sizeof(struct sockaddr_pn))
> > 169                 return -EINVAL;
> > 170         if (spn->spn_family != AF_PHONET)
> > 171                 return -EAFNOSUPPORT;
> > 172
> > 173         handle = pn_sockaddr_get_object((struct sockaddr_pn *)addr);
> > 174         saddr = pn_addr(handle);
> > 175         if (saddr && phonet_address_lookup(sock_net(sk), saddr))
> > 176                 return -EADDRNOTAVAIL;
> > 177
> > 178         lock_sock(sk);
> > 179         if (sk->sk_state != TCP_CLOSE || pn_port(pn->sobject)) {
> > 180                 err = -EINVAL; /* attempt to rebind */
> > 181                 goto out;
> > 182         }
> > 183         WARN_ON(sk_hashed(sk));
> > 184         mutex_lock(&port_mutex);
> > 185         err = sk->sk_prot->get_port(sk, pn_port(handle));
> > 186         if (err)
> > 187                 goto out_port;
> > 188
> > 189         /* get_port() sets the port, bind() sets the address if
> > applicable */ 190         pn->sobject = pn_object(saddr,
> > pn_port(pn->sobject));
> > 191         pn->resource = spn->spn_resource;
> > 192
> > 193         /* Enable RX on the socket */
> > 194         err = sk->sk_prot->hash(sk);
> > 195 out_port:
> > 196         mutex_unlock(&port_mutex);
> > 197 out:
> > 198         release_sock(sk);
> > 199         return err;
> > 200 }
> > 
> > 
> > The first return branch in there simply hands off the bind to and
> > indirection sk->sk_prot->bind() if present.  This smells ripe for breaking
> > the assumptions of that BUG_ON().
> 
> I believe that this is in line with the design of the socket stack within the 
> Linux kernel. 'struct proto_ops' carries the protocol family operations, then 
> 'struct proto' carries the protocol operations.
> 
> Admittedly, Phonet only had one datagram and one stream protocol ever written, 
> as the hardware development ceased. So in practice, there is a 1:1 mapping 
> between the two, and sk_prot.bind is always NULL.
> 
> > I'm assuming there's no point for such an indirection if not to enable a
> > potentially non-phonet-ops hook, otherwise we'd just be do the bind.
> 
> In my understanding, that's *not* what sk_prot is for, no. It's rather meant 
> to specialize the socket calls on a per-protocol basis.
> 
> For instance, UDP and UDP-Lite share their address family 'struct proto_ops' 
> (either inet_dgram_ops or inet6_dgram_ops) but they have different 
> 'struct proto'.
> 
> > If not, isn't this plain recursive?  Color me confused.  Will other bind()
> > implementations return -EINVAL when already bound with sobject set? no.
> 
> As far as I can find, there are no cases where the bind pointer would not be 
> NULL in upstream kernel. This can only happen if an out-of-tree module defines 
> its own protocol within the Phonet family.
> 

Ok, so we can disregard that bit as benign apparently.

> > Furthermore, -EINVAL is also returned when len < sizeof(struct sockaddr_pn),
> > maybe the rebind case should return -EADDRINUSE instead of -EINVAL?
> 
> bind() semantics require returning EINVAL if the socket address size is, well, 
> invalid.
> 
> If we are to distinguish the two error scenarii, then it's the rebind  case 
> that needs a different error, but EINVAL is consistent with INET.
> 

Isn't the existing code is bugged if treating -EINVAL as valid and a rebind?

The invalid size will return a NULL sobject but -EINVAL, triggering the BUG_ON.

Thanks,
Vito Caputo
