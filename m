Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71977115D91
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLGQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 11:41:17 -0500
Received: from correo.us.es ([193.147.175.20]:40888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfLGQlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Dec 2019 11:41:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7187EDA855
        for <netdev@vger.kernel.org>; Sat,  7 Dec 2019 17:41:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6528BDA714
        for <netdev@vger.kernel.org>; Sat,  7 Dec 2019 17:41:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58040DA70A; Sat,  7 Dec 2019 17:41:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1264CDA705;
        Sat,  7 Dec 2019 17:41:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Dec 2019 17:41:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A16F04265A5A;
        Sat,  7 Dec 2019 17:41:10 +0100 (CET)
Date:   Sat, 7 Dec 2019 17:41:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: nf_flow on big-endian (was: Re: linux-next: build warning after
 merge of the net-next tree)
Message-ID: <20191207164111.fpnpoipaiadaxyde@salvia>
References: <20191121183404.6e183d06@canb.auug.org.au>
 <CAMuHMdX8QyGkpPXfwS0EJhC6hR+gpYfvdpGWqdb=bSwJGmF7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wbq7vzsidly2hz2h"
Content-Disposition: inline
In-Reply-To: <CAMuHMdX8QyGkpPXfwS0EJhC6hR+gpYfvdpGWqdb=bSwJGmF7Ew@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wbq7vzsidly2hz2h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Geert,

On Tue, Nov 26, 2019 at 12:06:03PM +0100, Geert Uytterhoeven wrote:
> On Thu, Nov 21, 2019 at 8:36 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the net-next tree, today's linux-next build (powerpc
> > allyesconfig) produced this warning:
> >
> > net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
> > net/netfilter/nf_flow_table_offload.c:80:21: warning: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Woverflow]
> >    80 |   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
> >       |                     ^~~~~~~~~~~~
> >
> > Introduced by commit
> >
> >   c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> 
> This is now upstream, and must be completely broken on big-endian
> platforms.
> 
> The other user of the flags field looks buggy, too
> (net/core/flow_dissector.c:__skb_flow_dissect_tcp()[*]):
> 
>      key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));
> 
> Disclaimer: I'm not familiar with the code or protocol, so below are just
> my gut feelings.
> 
>      struct flow_dissector_key_tcp {
>             __be16 flags;
>     };
> 
> Does this have to be __be16, i.e. does it go over the wire?
> If not, this should probably be __u16, and set using
> "be32_to_cpu(flags) >> 16"?
> If yes, "cpu_to_be16(be32_to_cpu(flags) >> 16)"?
> (Ugh, needs convenience macros)
> 
> [*] ac4bb5de27010e41 ("net: flow_dissector: add support for dissection
> of tcp flags")

I'm attaching a tentative patch, please let me know this is fixing up
this issue there.

Thanks.

--wbq7vzsidly2hz2h
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index b8c20e9f343e..30ad4e07ff52 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -189,10 +189,17 @@ struct flow_dissector_key_eth_addrs {
 
 /**
  * struct flow_dissector_key_tcp:
- * @flags: flags
+ * @flags: TCP flags (16-bit, including the initial Data offset field bits)
+ * @word: Data offset + reserved bits + TCP flags + window
  */
 struct flow_dissector_key_tcp {
-	__be16 flags;
+	union {
+		struct {
+			__be16 flags;
+			__be16 __pad;
+		};
+		__be32	flag_word;
+	};
 };
 
 /**
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ca871657a4c4..83af4633f306 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -756,7 +756,7 @@ __skb_flow_dissect_tcp(const struct sk_buff *skb,
 	key_tcp = skb_flow_dissector_target(flow_dissector,
 					    FLOW_DISSECTOR_KEY_TCP,
 					    target_container);
-	key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));
+	key_tcp->flag_word = tcp_flag_word(th);
 }
 
 static void
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c94ebad78c5c..30205d57226d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -87,8 +87,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 
 	switch (tuple->l4proto) {
 	case IPPROTO_TCP:
-		key->tcp.flags = 0;
-		mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
+		key->tcp.flag_word = 0;
+		mask->tcp.flag_word = TCP_FLAG_RST | TCP_FLAG_FIN;
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:

--wbq7vzsidly2hz2h--
