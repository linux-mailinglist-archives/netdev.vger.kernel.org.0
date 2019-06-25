Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B49951FC2
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfFYAOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:42 -0400
Received: from mail.us.es ([193.147.175.20]:38008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfFYAMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A79C6C04B4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97F03DA70C
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8BF13DA706; Tue, 25 Jun 2019 02:12:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D4DADA708;
        Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 32C094265A2F;
        Tue, 25 Jun 2019 02:12:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/26] ipset: Fix memory accounting for hash types on resize
Date:   Tue, 25 Jun 2019 02:12:14 +0200
Message-Id: <20190625001233.22057-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

If a fresh array block is allocated during resize, the current in-memory
set size should be increased by the size of the block, not replaced by it.

Before the fix, adding entries to a hash set type, leading to a table
resize, caused an inconsistent memory size to be reported. This becomes
more obvious when swapping sets with similar sizes:

  # cat hash_ip_size.sh
  #!/bin/sh
  FAIL_RETRIES=10

  tries=0
  while [ ${tries} -lt ${FAIL_RETRIES} ]; do
  	ipset create t1 hash:ip
  	for i in `seq 1 4345`; do
  		ipset add t1 1.2.$((i / 255)).$((i % 255))
  	done
  	t1_init="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset create t2 hash:ip
  	for i in `seq 1 4360`; do
  		ipset add t2 1.2.$((i / 255)).$((i % 255))
  	done
  	t2_init="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset swap t1 t2
  	t1_swap="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"
  	t2_swap="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset destroy t1
  	ipset destroy t2
  	tries=$((tries + 1))

  	if [ ${t1_init} -lt 10000 ] || [ ${t2_init} -lt 10000 ]; then
  		echo "FAIL after ${tries} tries:"
  		echo "T1 size ${t1_init}, after swap ${t1_swap}"
  		echo "T2 size ${t2_init}, after swap ${t2_swap}"
  		exit 1
  	fi
  done
  echo "PASS"
  # echo -n 'func hash_ip4_resize +p' > /sys/kernel/debug/dynamic_debug/control
  # ./hash_ip_size.sh
  [ 2035.018673] attempt to resize set t1 from 10 to 11, t 00000000fe6551fa
  [ 2035.078583] set t1 resized from 10 (00000000fe6551fa) to 11 (00000000172a0163)
  [ 2035.080353] Table destroy by resize 00000000fe6551fa
  FAIL after 4 tries:
  T1 size 9064, after swap 71128
  T2 size 71128, after swap 9064

Reported-by: NOYB <JunkYardMail1@Frontier.com>
Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 01d51f775f12..623e0d675725 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -625,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
 					goto cleanup;
 				}
 				m->size = AHASH_INIT_SIZE;
-				extsize = ext_size(AHASH_INIT_SIZE, dsize);
+				extsize += ext_size(AHASH_INIT_SIZE, dsize);
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
-- 
2.11.0

