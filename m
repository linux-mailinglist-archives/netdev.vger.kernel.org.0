Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B91613D8E2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 12:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgAPLYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 06:24:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39481 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgAPLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 06:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579173853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rQ8ILGdkeDAnX6ru6DSvx74Y8T+PgBbA+5w3vPuC4I=;
        b=gdwQhbzKHxSAHXegTY1uSyoslR0bbpSqvDQrkYA2DXjDM9Ejeo0lUVoTvIiwgJXrjg9vC2
        9XwzbK92CbRcNs4EP+CCRoMSnVWR8lp6RHNMDu4NRH/Yfd+raX+T19RaQYP/d3xzYIVerO
        quCfNoTusZ1f76D8dyHRSpCNi5uoDaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-cRf3JjuDM36tOTW9L6amNg-1; Thu, 16 Jan 2020 06:24:11 -0500
X-MC-Unique: cRf3JjuDM36tOTW9L6amNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC9F51800D48;
        Thu, 16 Jan 2020 11:24:09 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FB0F19C5B;
        Thu, 16 Jan 2020 11:24:01 +0000 (UTC)
Date:   Thu, 16 Jan 2020 12:24:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct
 net_device
Message-ID: <20200116122400.499c2b1e@carbon>
In-Reply-To: <87imlctlo6.fsf@toke.dk>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
        <157893905569.861394.457637639114847149.stgit@toke.dk>
        <20200115211734.2dfcffd4@carbon>
        <87imlctlo6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 23:11:21 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Mon, 13 Jan 2020 19:10:55 +0100
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> > =20
> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> index da9c832fc5c8..030d125c3839 100644
> >> --- a/kernel/bpf/devmap.c
> >> +++ b/kernel/bpf/devmap.c =20
> > [...] =20
> >> @@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, =
u32 flags)
> >>  out:
> >>  	bq->count =3D 0;
> >> =20
> >> -	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
> >> -			      sent, drops, bq->dev_rx, dev, err);
> >> +	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err); =
=20
> >
> > Hmm ... I don't like that we lose the map_id and map_index identifier.
> > This is part of our troubleshooting interface. =20
>=20
> Hmm, I guess I can take another look at whether there's a way to avoid
> that. Any ideas?

Looking at the code and the other tracepoints...

I will actually suggest to remove these two arguments, because the
trace_xdp_redirect_map tracepoint also contains the ifindex'es, and to
troubleshoot people can record both tracepoints and do the correlation
themselves.

When changing the tracepoint I would like to keep member 'drops' and
'sent' at the same struct offsets.  As our xdp_monitor example reads
these and I hope we can kept it working this way.

I've coded it up, and tested it.  The new xdp_monitor will work on
older kernels, but the old xdp_monitor will fail attaching on newer
kernels. I think this is fair enough, as we are backwards compatible.


[PATCH] devmap: adjust tracepoing after Tokes changes

From: Jesper Dangaard Brouer <brouer@redhat.com>

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/trace/events/xdp.h     |   29 ++++++++++++-----------------
 kernel/bpf/devmap.c            |    2 +-
 samples/bpf/xdp_monitor_kern.c |    8 +++-----
 3 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index cf568a38f852..f1e64689ce94 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -247,43 +247,38 @@ TRACE_EVENT(xdp_cpumap_enqueue,
=20
 TRACE_EVENT(xdp_devmap_xmit,
=20
-	TP_PROTO(const struct bpf_map *map, u32 map_index,
-		 int sent, int drops,
-		 const struct net_device *from_dev,
-		 const struct net_device *to_dev, int err),
+	TP_PROTO(const struct net_device *from_dev,
+		 const struct net_device *to_dev,
+		 int sent, int drops, int err),
=20
-	TP_ARGS(map, map_index, sent, drops, from_dev, to_dev, err),
+	TP_ARGS(from_dev, to_dev, sent, drops, err),
=20
 	TP_STRUCT__entry(
-		__field(int, map_id)
+		__field(int, from_ifindex)
 		__field(u32, act)
-		__field(u32, map_index)
+		__field(int, to_ifindex)
 		__field(int, drops)
 		__field(int, sent)
-		__field(int, from_ifindex)
-		__field(int, to_ifindex)
 		__field(int, err)
 	),
=20
 	TP_fast_assign(
-		__entry->map_id		=3D map ? map->id : 0;
+		__entry->from_ifindex	=3D from_dev->ifindex;
 		__entry->act		=3D XDP_REDIRECT;
-		__entry->map_index	=3D map_index;
+		__entry->to_ifindex	=3D to_dev->ifindex;
 		__entry->drops		=3D drops;
 		__entry->sent		=3D sent;
-		__entry->from_ifindex	=3D from_dev->ifindex;
-		__entry->to_ifindex	=3D to_dev->ifindex;
 		__entry->err		=3D err;
 	),
=20
 	TP_printk("ndo_xdp_xmit"
-		  " map_id=3D%d map_index=3D%d action=3D%s"
+		  " from_ifindex=3D%d to_ifindex=3D%d action=3D%s"
 		  " sent=3D%d drops=3D%d"
-		  " from_ifindex=3D%d to_ifindex=3D%d err=3D%d",
-		  __entry->map_id, __entry->map_index,
+		  " err=3D%d",
+		  __entry->from_ifindex, __entry->to_ifindex,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
 		  __entry->sent, __entry->drops,
-		  __entry->from_ifindex, __entry->to_ifindex, __entry->err)
+		  __entry->err)
 );
=20
 /* Expect users already include <net/xdp.h>, but not xdp_priv.h */
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index db32272c4f77..1b4bfe4e06d6 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -340,7 +340,7 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u=
32 flags)
 out:
 	bq->count =3D 0;
=20
-	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err);
+	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 	bq->dev_rx =3D NULL;
 	__list_del_clearprev(&bq->flush_node);
 	return 0;
diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
index ad10fe700d7d..39458a44472e 100644
--- a/samples/bpf/xdp_monitor_kern.c
+++ b/samples/bpf/xdp_monitor_kern.c
@@ -222,14 +222,12 @@ struct bpf_map_def SEC("maps") devmap_xmit_cnt =3D {
  */
 struct devmap_xmit_ctx {
 	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
+	int from_ifindex;	//	offset:8;  size:4; signed:1;
 	u32 act;		//	offset:12; size:4; signed:0;
-	u32 map_index;		//	offset:16; size:4; signed:0;
+	int to_ifindex; 	//	offset:16; size:4; signed:1;
 	int drops;		//	offset:20; size:4; signed:1;
 	int sent;		//	offset:24; size:4; signed:1;
-	int from_ifindex;	//	offset:28; size:4; signed:1;
-	int to_ifindex;		//	offset:32; size:4; signed:1;
-	int err;		//	offset:36; size:4; signed:1;
+	int err;		//	offset:28; size:4; signed:1;
 };
=20
 SEC("tracepoint/xdp/xdp_devmap_xmit")

