Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0D8109FED
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKZOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:09:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47753 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfKZOJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:09:14 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iZbWW-0007pr-Jy; Tue, 26 Nov 2019 09:09:08 -0500
Date:   Tue, 26 Nov 2019 09:08:59 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: get netns from asoc and ep base
Message-ID: <20191126140859.GA21200@hmswarspite.think-freely.org>
References: <836cbb3768d75ddcf2eabe5f2682a5486a5afe7e.1574654390.git.lucien.xin@gmail.com>
 <20191125132440.GA14928@hmswarspite.think-freely.org>
 <CADvbK_e6qDC7OobXROnxyzjXAC1ZpfiVZ5LK+93paORYcdNj=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_e6qDC7OobXROnxyzjXAC1ZpfiVZ5LK+93paORYcdNj=A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 04:27:20PM +0800, Xin Long wrote:
> On Mon, Nov 25, 2019 at 9:24 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Mon, Nov 25, 2019 at 11:59:50AM +0800, Xin Long wrote:
> > > Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
> > > in asoc and ep base since they're created, and it will never change.
> > > It's a better way to get netns from asoc and ep base, comparing to
> > > calling sock_net().
> > >
> > > This patch is to replace them.
> > >
> > I don't see anything expressly wrong with this, but I'm not sure I see it as
> > better either.  It makes things more consistent with commit 312434617cb1, sure,
> > but both sock_net, and its called read_pnet are both static inline functions, so
> > it should reduce to the same thing.
> >
> > In fact, I think it may be better to ammend the fix from 312434617cb1, to,
> > instead of caching the net structure in the ep_common struct, instead, update
> > sctp_assoc_migrate so that the new value base.sk is atomically exchanged before
> > any calls to sock_put/sock_hold are made, so that the rhashtable lookup is
> > consistent.  That would allow us to consistently use sock_net the way other
> > protocols do
> why is "before any calls to sock_put/sock_hold are made"?
> 
It was my understanding that the problem in commit 312434617cb1 was that the
rhashtable lookup that ended in sctp_hash_obj was running in parallel with
sctp_assoc_migrate, and the result was that the socket pointer in the hash table
was getting freed on a sock_put while it was being accessed by the
rehash_operation

But as I look closer, thats not actually whats happening (I don't think), it
appears that KCSAN is just reporting that a read and write operation is
happening in parallel between the two, which could potentially lead to a
corruption.


> I was thinking to use rcu_assign_pointer() and rcu_dereference() for base.sk,
> but looks troublesome to replace all places.
> do you think it would work for atomic exchange? or you have some better idea?
> 
I'm not sure.  I get that rcu is going to be cumbersome here, since
sctp_assoc_migrate is the only location we seem to be writing the value of
base.sk while its present in the hash table, and we don't want to annotate all
the other read sites with rcu tags.  However, we don't really want to use
cmpxchg either, since we just want to read it on one side and write it in the
other.

It seems, like given the rhashtable api, the expectation is that, for a given
element in the hashtable, if that element changes, we would want to replace the
element with a new copy using rhashtable_replace_fast, which follows all the
internal locking protocols of the hashtable and allows for a quick update
safely, but we don't really want to do that, we just want to replace a field in
a structure thats pointed to by the transport structs which are whats really in
the hash table.

I wonder if there isn't a need here for an addition to the rhashtable api.
Something like rhashtable_lock(struct rhashtable *ht) and
rhashtable_unlock(struct rhashtable *ht), which respectively would just lock and
unlock the ht->mutex.  Since the rht_deferred_worker isn't exposed in any way
via the api, it seems like there is no way to really know when its safe to
update those pointers, because we never know if the rhashtable workers are
running in parallel with us.  If we had api access to the ht->mutex, we could
block the forward progress of any async workers in the hash table, which would
allow us to safely update any member pointers.  And then we wouldn't need to
cache the net struct.

What do you think?

Neil

> 
> >
> > Neil
> >
> > > Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/sctp/associola.c         | 10 +++++-----
> > >  net/sctp/chunk.c             |  2 +-
> > >  net/sctp/endpointola.c       |  6 +++---
> > >  net/sctp/input.c             |  5 ++---
> > >  net/sctp/output.c            |  2 +-
> > >  net/sctp/outqueue.c          |  6 +++---
> > >  net/sctp/sm_make_chunk.c     |  7 +++----
> > >  net/sctp/sm_sideeffect.c     | 16 ++++++----------
> > >  net/sctp/sm_statefuns.c      |  2 +-
> > >  net/sctp/socket.c            | 12 +++++-------
> > >  net/sctp/stream.c            |  3 +--
> > >  net/sctp/stream_interleave.c | 23 ++++++++++-------------
> > >  net/sctp/transport.c         |  2 +-
> > >  net/sctp/ulpqueue.c          | 15 +++++++--------
> > >  14 files changed, 49 insertions(+), 62 deletions(-)
> > >
> > > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > > index 41839b8..a725f53 100644
> > > --- a/net/sctp/associola.c
> > > +++ b/net/sctp/associola.c
> > > @@ -579,7 +579,6 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
> > >                                          const gfp_t gfp,
> > >                                          const int peer_state)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > >       struct sctp_transport *peer;
> > >       struct sctp_sock *sp;
> > >       unsigned short port;
> > > @@ -609,7 +608,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
> > >               return peer;
> > >       }
> > >
> > > -     peer = sctp_transport_new(net, addr, gfp);
> > > +     peer = sctp_transport_new(asoc->base.net, addr, gfp);
> > >       if (!peer)
> > >               return NULL;
> > >
> > > @@ -978,7 +977,7 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
> > >       struct sctp_association *asoc =
> > >               container_of(work, struct sctp_association,
> > >                            base.inqueue.immediate);
> > > -     struct net *net = sock_net(asoc->base.sk);
> > > +     struct net *net = asoc->base.net;
> > >       union sctp_subtype subtype;
> > >       struct sctp_endpoint *ep;
> > >       struct sctp_chunk *chunk;
> > > @@ -1446,7 +1445,8 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
> > >  /* Should we send a SACK to update our peer? */
> > >  static inline bool sctp_peer_needs_update(struct sctp_association *asoc)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > > +     struct net *net = asoc->base.net;
> > > +
> > >       switch (asoc->state) {
> > >       case SCTP_STATE_ESTABLISHED:
> > >       case SCTP_STATE_SHUTDOWN_PENDING:
> > > @@ -1580,7 +1580,7 @@ int sctp_assoc_set_bind_addr_from_ep(struct sctp_association *asoc,
> > >       if (asoc->peer.ipv6_address)
> > >               flags |= SCTP_ADDR6_PEERSUPP;
> > >
> > > -     return sctp_bind_addr_copy(sock_net(asoc->base.sk),
> > > +     return sctp_bind_addr_copy(asoc->base.net,
> > >                                  &asoc->base.bind_addr,
> > >                                  &asoc->ep->base.bind_addr,
> > >                                  scope, gfp, flags);
> > > diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> > > index cc0405c..064675b 100644
> > > --- a/net/sctp/chunk.c
> > > +++ b/net/sctp/chunk.c
> > > @@ -227,7 +227,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
> > >       if (msg_len >= first_len) {
> > >               msg->can_delay = 0;
> > >               if (msg_len > first_len)
> > > -                     SCTP_INC_STATS(sock_net(asoc->base.sk),
> > > +                     SCTP_INC_STATS(asoc->base.net,
> > >                                      SCTP_MIB_FRAGUSRMSGS);
> > >       } else {
> > >               /* Which may be the only one... */
> > > diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> > > index 3067deb..6e7e0d3 100644
> > > --- a/net/sctp/endpointola.c
> > > +++ b/net/sctp/endpointola.c
> > > @@ -244,7 +244,7 @@ struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *ep,
> > >       struct sctp_endpoint *retval = NULL;
> > >
> > >       if ((htons(ep->base.bind_addr.port) == laddr->v4.sin_port) &&
> > > -         net_eq(sock_net(ep->base.sk), net)) {
> > > +         net_eq(ep->base.net, net)) {
> > >               if (sctp_bind_addr_match(&ep->base.bind_addr, laddr,
> > >                                        sctp_sk(ep->base.sk)))
> > >                       retval = ep;
> > > @@ -292,8 +292,8 @@ bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
> > >                                const union sctp_addr *paddr)
> > >  {
> > >       struct sctp_sockaddr_entry *addr;
> > > +     struct net *net = ep->base.net;
> > >       struct sctp_bind_addr *bp;
> > > -     struct net *net = sock_net(ep->base.sk);
> > >
> > >       bp = &ep->base.bind_addr;
> > >       /* This function is called with the socket lock held,
> > > @@ -384,7 +384,7 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
> > >               if (asoc && sctp_chunk_is_data(chunk))
> > >                       asoc->peer.last_data_from = chunk->transport;
> > >               else {
> > > -                     SCTP_INC_STATS(sock_net(ep->base.sk), SCTP_MIB_INCTRLCHUNKS);
> > > +                     SCTP_INC_STATS(ep->base.net, SCTP_MIB_INCTRLCHUNKS);
> > >                       if (asoc)
> > >                               asoc->stats.ictrlchunks++;
> > >               }
> > > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > > index 4d2bcfc..efaaefc 100644
> > > --- a/net/sctp/input.c
> > > +++ b/net/sctp/input.c
> > > @@ -937,7 +937,7 @@ int sctp_hash_transport(struct sctp_transport *t)
> > >       if (t->asoc->temp)
> > >               return 0;
> > >
> > > -     arg.net   = sock_net(t->asoc->base.sk);
> > > +     arg.net   = t->asoc->base.net;
> > >       arg.paddr = &t->ipaddr;
> > >       arg.lport = htons(t->asoc->base.bind_addr.port);
> > >
> > > @@ -1004,12 +1004,11 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
> > >                               const struct sctp_endpoint *ep,
> > >                               const union sctp_addr *paddr)
> > >  {
> > > -     struct net *net = sock_net(ep->base.sk);
> > >       struct rhlist_head *tmp, *list;
> > >       struct sctp_transport *t;
> > >       struct sctp_hash_cmp_arg arg = {
> > >               .paddr = paddr,
> > > -             .net   = net,
> > > +             .net   = ep->base.net,
> > >               .lport = htons(ep->base.bind_addr.port),
> > >       };
> > >
> > > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > > index dbda7e7..1441eaf 100644
> > > --- a/net/sctp/output.c
> > > +++ b/net/sctp/output.c
> > > @@ -282,7 +282,7 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
> > >                                       sctp_chunk_free(sack);
> > >                                       goto out;
> > >                               }
> > > -                             SCTP_INC_STATS(sock_net(asoc->base.sk),
> > > +                             SCTP_INC_STATS(asoc->base.net,
> > >                                              SCTP_MIB_OUTCTRLCHUNKS);
> > >                               asoc->stats.octrlchunks++;
> > >                               asoc->peer.sack_needed = 0;
> > > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > > index 0dab62b..a031d11 100644
> > > --- a/net/sctp/outqueue.c
> > > +++ b/net/sctp/outqueue.c
> > > @@ -279,7 +279,7 @@ void sctp_outq_free(struct sctp_outq *q)
> > >  /* Put a new chunk in an sctp_outq.  */
> > >  void sctp_outq_tail(struct sctp_outq *q, struct sctp_chunk *chunk, gfp_t gfp)
> > >  {
> > > -     struct net *net = sock_net(q->asoc->base.sk);
> > > +     struct net *net = q->asoc->base.net;
> > >
> > >       pr_debug("%s: outq:%p, chunk:%p[%s]\n", __func__, q, chunk,
> > >                chunk && chunk->chunk_hdr ?
> > > @@ -533,7 +533,7 @@ void sctp_retransmit_mark(struct sctp_outq *q,
> > >  void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
> > >                    enum sctp_retransmit_reason reason)
> > >  {
> > > -     struct net *net = sock_net(q->asoc->base.sk);
> > > +     struct net *net = q->asoc->base.net;
> > >
> > >       switch (reason) {
> > >       case SCTP_RTXR_T3_RTX:
> > > @@ -1884,6 +1884,6 @@ void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 ctsn)
> > >
> > >       if (ftsn_chunk) {
> > >               list_add_tail(&ftsn_chunk->list, &q->control_chunk_list);
> > > -             SCTP_INC_STATS(sock_net(asoc->base.sk), SCTP_MIB_OUTCTRLCHUNKS);
> > > +             SCTP_INC_STATS(asoc->base.net, SCTP_MIB_OUTCTRLCHUNKS);
> > >       }
> > >  }
> > > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > > index 48d6395..09050c1 100644
> > > --- a/net/sctp/sm_make_chunk.c
> > > +++ b/net/sctp/sm_make_chunk.c
> > > @@ -2307,7 +2307,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> > >                     const union sctp_addr *peer_addr,
> > >                     struct sctp_init_chunk *peer_init, gfp_t gfp)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > >       struct sctp_transport *transport;
> > >       struct list_head *pos, *temp;
> > >       union sctp_params param;
> > > @@ -2363,8 +2362,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> > >        * also give us an option to silently ignore the packet, which
> > >        * is what we'll do here.
> > >        */
> > > -     if (!net->sctp.addip_noauth &&
> > > -          (asoc->peer.asconf_capable && !asoc->peer.auth_capable)) {
> > > +     if (!asoc->base.net->sctp.addip_noauth &&
> > > +         (asoc->peer.asconf_capable && !asoc->peer.auth_capable)) {
> > >               asoc->peer.addip_disabled_mask |= (SCTP_PARAM_ADD_IP |
> > >                                                 SCTP_PARAM_DEL_IP |
> > >                                                 SCTP_PARAM_SET_PRIMARY);
> > > @@ -2491,9 +2490,9 @@ static int sctp_process_param(struct sctp_association *asoc,
> > >                             const union sctp_addr *peer_addr,
> > >                             gfp_t gfp)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > >       struct sctp_endpoint *ep = asoc->ep;
> > >       union sctp_addr_param *addr_param;
> > > +     struct net *net = asoc->base.net;
> > >       struct sctp_transport *t;
> > >       enum sctp_scope scope;
> > >       union sctp_addr addr;
> > > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > > index e52b212..20b0281 100644
> > > --- a/net/sctp/sm_sideeffect.c
> > > +++ b/net/sctp/sm_sideeffect.c
> > > @@ -516,8 +516,6 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
> > >                                        struct sctp_transport *transport,
> > >                                        int is_hb)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > > -
> > >       /* The check for association's overall error counter exceeding the
> > >        * threshold is done in the state function.
> > >        */
> > > @@ -544,10 +542,10 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
> > >        * is SCTP_ACTIVE, then mark this transport as Partially Failed,
> > >        * see SCTP Quick Failover Draft, section 5.1
> > >        */
> > > -     if (net->sctp.pf_enable &&
> > > -        (transport->state == SCTP_ACTIVE) &&
> > > -        (transport->error_count < transport->pathmaxrxt) &&
> > > -        (transport->error_count > transport->pf_retrans)) {
> > > +     if (asoc->base.net->sctp.pf_enable &&
> > > +         transport->state == SCTP_ACTIVE &&
> > > +         transport->error_count < transport->pathmaxrxt &&
> > > +         transport->error_count > transport->pf_retrans) {
> > >
> > >               sctp_assoc_control_transport(asoc, transport,
> > >                                            SCTP_TRANSPORT_PF,
> > > @@ -793,10 +791,8 @@ static int sctp_cmd_process_sack(struct sctp_cmd_seq *cmds,
> > >       int err = 0;
> > >
> > >       if (sctp_outq_sack(&asoc->outqueue, chunk)) {
> > > -             struct net *net = sock_net(asoc->base.sk);
> > > -
> > >               /* There are no more TSNs awaiting SACK.  */
> > > -             err = sctp_do_sm(net, SCTP_EVENT_T_OTHER,
> > > +             err = sctp_do_sm(asoc->base.net, SCTP_EVENT_T_OTHER,
> > >                                SCTP_ST_OTHER(SCTP_EVENT_NO_PENDING_TSN),
> > >                                asoc->state, asoc->ep, asoc, NULL,
> > >                                GFP_ATOMIC);
> > > @@ -829,7 +825,7 @@ static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,
> > >                                 struct sctp_association *asoc,
> > >                                 struct sctp_association *new)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > > +     struct net *net = asoc->base.net;
> > >       struct sctp_chunk *abort;
> > >
> > >       if (!sctp_assoc_update(asoc, new))
> > > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > > index 4ab8208..42558fa 100644
> > > --- a/net/sctp/sm_statefuns.c
> > > +++ b/net/sctp/sm_statefuns.c
> > > @@ -1320,7 +1320,7 @@ static int sctp_sf_check_restart_addrs(const struct sctp_association *new_asoc,
> > >                                      struct sctp_chunk *init,
> > >                                      struct sctp_cmd_seq *commands)
> > >  {
> > > -     struct net *net = sock_net(new_asoc->base.sk);
> > > +     struct net *net = new_asoc->base.net;
> > >       struct sctp_transport *new_addr;
> > >       int ret = 1;
> > >
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index ffd3262..5e0efbc 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -436,8 +436,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> > >  static int sctp_send_asconf(struct sctp_association *asoc,
> > >                           struct sctp_chunk *chunk)
> > >  {
> > > -     struct net      *net = sock_net(asoc->base.sk);
> > > -     int             retval = 0;
> > > +     int retval = 0;
> > >
> > >       /* If there is an outstanding ASCONF chunk, queue it for later
> > >        * transmission.
> > > @@ -449,7 +448,7 @@ static int sctp_send_asconf(struct sctp_association *asoc,
> > >
> > >       /* Hold the chunk until an ASCONF_ACK is received. */
> > >       sctp_chunk_hold(chunk);
> > > -     retval = sctp_primitive_ASCONF(net, asoc, chunk);
> > > +     retval = sctp_primitive_ASCONF(asoc->base.net, asoc, chunk);
> > >       if (retval)
> > >               sctp_chunk_free(chunk);
> > >       else
> > > @@ -2428,9 +2427,8 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
> > >       int error;
> > >
> > >       if (params->spp_flags & SPP_HB_DEMAND && trans) {
> > > -             struct net *net = sock_net(trans->asoc->base.sk);
> > > -
> > > -             error = sctp_primitive_REQUESTHEARTBEAT(net, trans->asoc, trans);
> > > +             error = sctp_primitive_REQUESTHEARTBEAT(trans->asoc->base.net,
> > > +                                                     trans->asoc, trans);
> > >               if (error)
> > >                       return error;
> > >       }
> > > @@ -5308,7 +5306,7 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
> > >               if (!sctp_transport_hold(t))
> > >                       continue;
> > >
> > > -             if (net_eq(sock_net(t->asoc->base.sk), net) &&
> > > +             if (net_eq(t->asoc->base.net, net) &&
> > >                   t->asoc->peer.primary_path == t)
> > >                       break;
> > >
> > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > index e83cdaa..df60b5e 100644
> > > --- a/net/sctp/stream.c
> > > +++ b/net/sctp/stream.c
> > > @@ -218,10 +218,9 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
> > >  static int sctp_send_reconf(struct sctp_association *asoc,
> > >                           struct sctp_chunk *chunk)
> > >  {
> > > -     struct net *net = sock_net(asoc->base.sk);
> > >       int retval = 0;
> > >
> > > -     retval = sctp_primitive_RECONF(net, asoc, chunk);
> > > +     retval = sctp_primitive_RECONF(asoc->base.net, asoc, chunk);
> > >       if (retval)
> > >               sctp_chunk_free(chunk);
> > >
> > > diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> > > index 40c40be..6b13f73 100644
> > > --- a/net/sctp/stream_interleave.c
> > > +++ b/net/sctp/stream_interleave.c
> > > @@ -241,9 +241,8 @@ static struct sctp_ulpevent *sctp_intl_retrieve_partial(
> > >       if (!first_frag)
> > >               return NULL;
> > >
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > -                                          &ulpq->reasm, first_frag,
> > > -                                          last_frag);
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
> > > +                                          first_frag, last_frag);
> > >       if (retval) {
> > >               sin->fsn = next_fsn;
> > >               if (is_last) {
> > > @@ -326,7 +325,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled(
> > >
> > >       pd_point = sctp_sk(asoc->base.sk)->pd_point;
> > >       if (pd_point && pd_point <= pd_len) {
> > > -             retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
> > > +             retval = sctp_make_reassembled_event(asoc->base.net,
> > >                                                    &ulpq->reasm,
> > >                                                    pd_first, pd_last);
> > >               if (retval) {
> > > @@ -337,8 +336,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled(
> > >       goto out;
> > >
> > >  found:
> > > -     retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
> > > -                                          &ulpq->reasm,
> > > +     retval = sctp_make_reassembled_event(asoc->base.net, &ulpq->reasm,
> > >                                            first_frag, pos);
> > >       if (retval)
> > >               retval->msg_flags |= MSG_EOR;
> > > @@ -630,7 +628,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_partial_uo(
> > >       if (!first_frag)
> > >               return NULL;
> > >
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
> > >                                            &ulpq->reasm_uo, first_frag,
> > >                                            last_frag);
> > >       if (retval) {
> > > @@ -716,7 +714,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled_uo(
> > >
> > >       pd_point = sctp_sk(asoc->base.sk)->pd_point;
> > >       if (pd_point && pd_point <= pd_len) {
> > > -             retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
> > > +             retval = sctp_make_reassembled_event(asoc->base.net,
> > >                                                    &ulpq->reasm_uo,
> > >                                                    pd_first, pd_last);
> > >               if (retval) {
> > > @@ -727,8 +725,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled_uo(
> > >       goto out;
> > >
> > >  found:
> > > -     retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
> > > -                                          &ulpq->reasm_uo,
> > > +     retval = sctp_make_reassembled_event(asoc->base.net, &ulpq->reasm_uo,
> > >                                            first_frag, pos);
> > >       if (retval)
> > >               retval->msg_flags |= MSG_EOR;
> > > @@ -814,7 +811,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_first_uo(struct sctp_ulpq *ulpq)
> > >               return NULL;
> > >
> > >  out:
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
> > >                                            &ulpq->reasm_uo, first_frag,
> > >                                            last_frag);
> > >       if (retval) {
> > > @@ -921,7 +918,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_first(struct sctp_ulpq *ulpq)
> > >               return NULL;
> > >
> > >  out:
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
> > >                                            &ulpq->reasm, first_frag,
> > >                                            last_frag);
> > >       if (retval) {
> > > @@ -1159,7 +1156,7 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
> > >
> > >       if (ftsn_chunk) {
> > >               list_add_tail(&ftsn_chunk->list, &q->control_chunk_list);
> > > -             SCTP_INC_STATS(sock_net(asoc->base.sk), SCTP_MIB_OUTCTRLCHUNKS);
> > > +             SCTP_INC_STATS(asoc->base.net, SCTP_MIB_OUTCTRLCHUNKS);
> > >       }
> > >  }
> > >
> > > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> > > index 7235a60..f4de064 100644
> > > --- a/net/sctp/transport.c
> > > +++ b/net/sctp/transport.c
> > > @@ -334,7 +334,7 @@ void sctp_transport_update_rto(struct sctp_transport *tp, __u32 rtt)
> > >               pr_debug("%s: rto_pending not set on transport %p!\n", __func__, tp);
> > >
> > >       if (tp->rttvar || tp->srtt) {
> > > -             struct net *net = sock_net(tp->asoc->base.sk);
> > > +             struct net *net = tp->asoc->base.net;
> > >               /* 6.3.1 C3) When a new RTT measurement R' is made, set
> > >                * RTTVAR <- (1 - RTO.Beta) * RTTVAR + RTO.Beta * |SRTT - R'|
> > >                * SRTT <- (1 - RTO.Alpha) * SRTT + RTO.Alpha * R'
> > > diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> > > index b6536b7..1c6c640 100644
> > > --- a/net/sctp/ulpqueue.c
> > > +++ b/net/sctp/ulpqueue.c
> > > @@ -486,10 +486,9 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
> > >               cevent = sctp_skb2event(pd_first);
> > >               pd_point = sctp_sk(asoc->base.sk)->pd_point;
> > >               if (pd_point && pd_point <= pd_len) {
> > > -                     retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
> > > +                     retval = sctp_make_reassembled_event(asoc->base.net,
> > >                                                            &ulpq->reasm,
> > > -                                                          pd_first,
> > > -                                                          pd_last);
> > > +                                                          pd_first, pd_last);
> > >                       if (retval)
> > >                               sctp_ulpq_set_pd(ulpq);
> > >               }
> > > @@ -497,7 +496,7 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
> > >  done:
> > >       return retval;
> > >  found:
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
> > >                                            &ulpq->reasm, first_frag, pos);
> > >       if (retval)
> > >               retval->msg_flags |= MSG_EOR;
> > > @@ -563,8 +562,8 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_partial(struct sctp_ulpq *ulpq)
> > >        * further.
> > >        */
> > >  done:
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > -                                     &ulpq->reasm, first_frag, last_frag);
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
> > > +                                          first_frag, last_frag);
> > >       if (retval && is_last)
> > >               retval->msg_flags |= MSG_EOR;
> > >
> > > @@ -664,8 +663,8 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
> > >        * further.
> > >        */
> > >  done:
> > > -     retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
> > > -                                     &ulpq->reasm, first_frag, last_frag);
> > > +     retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
> > > +                                          first_frag, last_frag);
> > >       return retval;
> > >  }
> > >
> > > --
> > > 2.1.0
> > >
> > >
> 
