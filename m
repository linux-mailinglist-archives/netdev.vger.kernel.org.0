Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A966DD3B4
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjDKHK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKHKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:10:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B25F212F;
        Tue, 11 Apr 2023 00:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C766561AA2;
        Tue, 11 Apr 2023 07:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2443C4339B;
        Tue, 11 Apr 2023 07:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681197050;
        bh=ROgxfK0tfkKDRNzm6pTWDEkbhQa1R7Y9+J26fBX3PTw=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=essYIFx0AdDfqvXFoYBduOlHbYPb9XcIeHuH6b1fjw9yi357ey8w5DWuh+9z4WCTo
         P47l0AnDBxXf4cE6dg2YRXxFn0wMjUz2aaqdXADh3SHB+cSQPwVDXui8yxZmM9LPH9
         kn1HlF/AuwOJe+rtJ6xgSyBXXn+RTEddPz2yBwNFHak51+O7/EhYR323hoWJZLNhRi
         mPzkuwt0p3ltLBOQ1JIz/fgg7oTvP7CrOtdoozh05tshY66+n3m5JLEhe217DOOaCZ
         tmcQNhzeolb7BiNMhjA1s9pQV7Ynse3Haro+5n9hTSj2Jw5fs7991wFJik7LxwaeM0
         69KBHbw0JiykA==
From:   Simon Horman <horms@kernel.org>
Date:   Tue, 11 Apr 2023 09:10:39 +0200
Subject: [PATCH nf-next v2 1/4] ipvs: Update width of source for
 ip_vs_sync_conn_options
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230409-ipvs-cleanup-v2-1-204cd17da708@kernel.org>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
In-Reply-To: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ip_vs_sync_conn_v0() copy is made to struct ip_vs_sync_conn_options.
That structure looks like this:

struct ip_vs_sync_conn_options {
        struct ip_vs_seq        in_seq;
        struct ip_vs_seq        out_seq;
};

The source of the copy is the in_seq field of struct ip_vs_conn.  Whose
type is struct ip_vs_seq. Thus we can see that the source - is not as
wide as the amount of data copied, which is the width of struct
ip_vs_sync_conn_option.

The copy is safe because the next field in is another struct ip_vs_seq.
Make use of struct_group() to annotate this.

Flagged by gcc-13 as:

 In file included from ./include/linux/string.h:254,
                  from ./include/linux/bitmap.h:11,
                  from ./include/linux/cpumask.h:12,
                  from ./arch/x86/include/asm/paravirt.h:17,
                  from ./arch/x86/include/asm/cpuid.h:62,
                  from ./arch/x86/include/asm/processor.h:19,
                  from ./arch/x86/include/asm/timex.h:5,
                  from ./include/linux/timex.h:67,
                  from ./include/linux/time32.h:13,
                  from ./include/linux/time.h:60,
                  from ./include/linux/stat.h:19,
                  from ./include/linux/module.h:13,
                  from net/netfilter/ipvs/ip_vs_sync.c:38:
 In function 'fortify_memcpy_chk',
     inlined from 'ip_vs_sync_conn_v0' at net/netfilter/ipvs/ip_vs_sync.c:606:3:
 ./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
   529 |                         __read_overflow2_field(q_size_field, size);
       |

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
v2
* Correct spelling of 'conn' in subject
---
 include/net/ip_vs.h             | 6 ++++--
 net/netfilter/ipvs/ip_vs_sync.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 6d71a5ff52df..e20f1f92066d 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -630,8 +630,10 @@ struct ip_vs_conn {
 	 */
 	struct ip_vs_app        *app;           /* bound ip_vs_app object */
 	void                    *app_data;      /* Application private data */
-	struct ip_vs_seq        in_seq;         /* incoming seq. struct */
-	struct ip_vs_seq        out_seq;        /* outgoing seq. struct */
+	struct_group(sync_conn_opt,
+		struct ip_vs_seq  in_seq;       /* incoming seq. struct */
+		struct ip_vs_seq  out_seq;      /* outgoing seq. struct */
+	);
 
 	const struct ip_vs_pe	*pe;
 	char			*pe_data;
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 4963fec815da..d4fe7bb4f853 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -603,7 +603,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		struct ip_vs_sync_conn_options *opt =
 			(struct ip_vs_sync_conn_options *)&s[1];
-		memcpy(opt, &cp->in_seq, sizeof(*opt));
+		memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
 	}
 
 	m->nr_conns++;

-- 
2.30.2

