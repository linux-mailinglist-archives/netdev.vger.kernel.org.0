Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7200115DCB
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 18:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfLGRiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 12:38:12 -0500
Received: from correo.us.es ([193.147.175.20]:57128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfLGRiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Dec 2019 12:38:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D02BBAF08
        for <netdev@vger.kernel.org>; Sat,  7 Dec 2019 18:38:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F23A8DA712
        for <netdev@vger.kernel.org>; Sat,  7 Dec 2019 18:38:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7827DA709; Sat,  7 Dec 2019 18:38:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C9D1DA70B;
        Sat,  7 Dec 2019 18:38:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Dec 2019 18:38:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 20E9141E4800;
        Sat,  7 Dec 2019 18:38:05 +0100 (CET)
Date:   Sat, 7 Dec 2019 18:38:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Laura Abbott <labbott@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size
 for flow_overload_mangle
Message-ID: <20191207173805.jvunyfnijgefn3z5@salvia>
References: <20191203160345.24743-1-labbott@redhat.com>
 <20191203170114.GB377782@localhost.localdomain>
 <9bc4b04b-a3cc-4e58-4c73-1d77b7ed05da@redhat.com>
 <CAFxkdAraVz6mbQ3OFRGF3DmfWMDNzuXd+HJ14ypex6bMm-oCGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xqstvcc2mbtblrb2"
Content-Disposition: inline
In-Reply-To: <CAFxkdAraVz6mbQ3OFRGF3DmfWMDNzuXd+HJ14ypex6bMm-oCGw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xqstvcc2mbtblrb2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2019 at 04:58:30PM -0600, Justin Forbes wrote:
> On Tue, Dec 3, 2019 at 2:50 PM Laura Abbott <labbott@redhat.com> wrote:
> >
> > On 12/3/19 12:01 PM, Marcelo Ricardo Leitner wrote:
> > > On Tue, Dec 03, 2019 at 11:03:45AM -0500, Laura Abbott wrote:
> > >> The sizes for memcpy in flow_offload_mangle don't match
> > >> the source variables, leading to overflow errors on some
> > >> build configurations:
> > >>
> > >> In function 'memcpy',
> > >>      inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
> > >>      inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
> > >>      inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
> > >> ./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
> > >>    376 |    __read_overflow2();
> > >>        |    ^~~~~~~~~~~~~~~~~~
> > >> make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offload.o] Error 1
> > >>
> > >> Fix this by using the corresponding type.
> > >>
> > >> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> > >> Signed-off-by: Laura Abbott <labbott@redhat.com>
> > >> ---
> > >> Seen on a Fedora powerpc little endian build with -O3 but it looks like
> > >> it is correctly catching an error with doing a memcpy outside the source
> > >> variable.
> > >
> > > Hi,
> > >
> > > It is right but the fix is not. In that call trace:
> > >
> > > flow_offload_port_dnat() {
> > > ...
> > >          u32 mask = ~htonl(0xffff);
> > >          __be16 port;
> > > ...
> > >          flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> > >                                   (u8 *)&port, (u8 *)&mask);
> > > }
> > >
> > > port should have a 32b storage as well, and aligned with the mask.
> > >
> > >> ---
> > >>   net/netfilter/nf_flow_table_offload.c | 4 ++--
> > >>   1 file changed, 2 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > >> index c54c9a6cc981..526f894d0bdb 100644
> > >> --- a/net/netfilter/nf_flow_table_offload.c
> > >> +++ b/net/netfilter/nf_flow_table_offload.c
> > >> @@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
> > >>      entry->id = FLOW_ACTION_MANGLE;
> > >>      entry->mangle.htype = htype;
> > >>      entry->mangle.offset = offset;
> > >> -    memcpy(&entry->mangle.mask, mask, sizeof(u32));
> > >> -    memcpy(&entry->mangle.val, value, sizeof(u32));
> > >                                     ^^^^^         ^^^ which is &port in the call above
> > >> +    memcpy(&entry->mangle.mask, mask, sizeof(u8));
> > >> +    memcpy(&entry->mangle.val, value, sizeof(u8));
> > >
> > > This fix would cause it to copy only the first byte, which is not the
> > > intention.
> > >
> >
> > Thanks for the review. I took another look at fixing this and I
> > think it might be better for the maintainer or someone who is more
> > familiar with the code to fix this. I ended up down a rabbit
> > hole trying to get the types to work and I wasn't confident about
> > the casting.
> 
> Any update on this? It is definitely a problem on PPC LE.

I'm attaching a tentative patch to address this problem.

Thanks.

--xqstvcc2mbtblrb2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 30205d57226d..cfa5602f54f5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -336,23 +336,22 @@ static void flow_offload_port_snat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff0000);
-	__be16 port;
+	u32 mask = ~htonl(0xffff0000), port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
 		offset = 0; /* offsetof(struct tcphdr, source); */
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
 		return;
 	}
-
+	port = htonl(port << 16);
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    (u8 *)&port, (u8 *)&mask);
 }
@@ -363,23 +362,22 @@ static void flow_offload_port_dnat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff);
-	__be16 port;
+	u32 mask = ~htonl(0xffff), port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
 		offset = 0; /* offsetof(struct tcphdr, source); */
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
 		return;
 	}
-
+	port = htonl(port);
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    (u8 *)&port, (u8 *)&mask);
 }

--xqstvcc2mbtblrb2--
