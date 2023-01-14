Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851CF66A8F4
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjANDbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjANDbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:31:39 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8A8B769
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:37 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id j15so15209790qtv.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oGr5pRgrPJSxg2VeF9JvvIgpiBk3Igt8aRHYoOvUJ94=;
        b=jJveH62sp48S9qz7xVVj6zeatqQgdACridc6oyHrZepk2LhsvbWFjWR5v5BQArEi+e
         emCMr7y5i5fnoPAgekpabfwS79aaZEOp4+GMCBsTaokv6CHsdzQmX3hZv7S/ZWOsIGkS
         EO3B0UlMLm6Ng9r7ppVODbn9gXX1yXJcikKzDjziZB77QNjFQF+8ue84JvzQI4IdNaTp
         Krt1XrgRJaJM2/AYMie/E0eqstlVBpcZuir+4BG6jUy2/X6E9DaVKmbsAQ2J/q9M1zgh
         8XLeB0ARAFeVvWcc2y0osIMAIuB88Kn6VaJsHwSQERfx9YH3Nt/WQcwJMW85c4JGLmOw
         XTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGr5pRgrPJSxg2VeF9JvvIgpiBk3Igt8aRHYoOvUJ94=;
        b=2EMXRUOuFLyypC7sINYGEZdaEQ5+AkntUfLg5cJw5WBGZJZhUXZ9nrNruU+xoduFZB
         2qn8yqHMmuXP6Ai+hZLZDjgKqsoxcMRrSTP8SVPm3hU+98oJ7ugrjtU7eFLQ5mbDWrUU
         bsxzTmThaWo2yhVaoBzCrd7Q+2SYLHxmSxnG7bGlqRu6C6lcbU2rZ+QgGJjc3KgFvfQa
         coyKPSdIMjAIcE8ghYk10EsXXKjt5iX7/A5XiXYAzTfBzz0vC6mk2x6DmHnzgh76twX8
         8N4h3tDHsSGyuCOR6BSU0ZzTqY/p71eX8Rk0S2fogd+tZ3ol6Elio4IG1o9KRXeOdOY9
         V2xw==
X-Gm-Message-State: AFqh2krysOTDo+J0qyd4G7sJkTd3oF7RSsPNRjlGBHhN4q2XPrJD6DiU
        PeI3sp2KTU6Y7BmKHfFtRAIl9v4VL6fzJQ==
X-Google-Smtp-Source: AMrXdXtczqgwOsbqB/tr+QFxoDrdF4+Jod546JV420Rv0GUCICMYuWurCBfLw+8LN8TuoXgeFdSn2g==
X-Received: by 2002:a05:622a:59cb:b0:3a8:299a:9843 with SMTP id gc11-20020a05622a59cb00b003a8299a9843mr121665593qtb.39.1673667096823;
        Fri, 13 Jan 2023 19:31:36 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm7878846qtb.66.2023.01.13.19.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:31:36 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net-next 00/10] net: support ipv4 big tcp
Date:   Fri, 13 Jan 2023 22:31:24 -0500
Message-Id: <cover.1673666803.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to the BIG TCP patchset added by Eric for IPv6:

  https://lwn.net/Articles/895398/

Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
doesn't have exthdrs(options) for the BIG TCP packets' length. To make
it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
indicate this might be a BIG TCP packet and use skb->len as the real
IPv4 total length.

This will work safely, as all BIG TCP packets are GSO/GRO packets and
processed on the same host as they were created; There is no padding
in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
packet total length; Also, before implementing the feature, all those
places that may get iph tot_len from BIG TCP packets are taken care
with some new APIs:

Patch 1 adds some APIs for iph tot_len setting and getting, which are
used in all these places where IPv4 BIG TCP packets may reach in Patch
2-7, and Patch 8 implements this feature and Patch 10 adds a selftest
for it. Patch 9 is a fix in netfilter length_mt6 so that the selftest
can also cover IPv6 BIG TCP.

Note that the similar change as in Patch 2-7 are also needed for IPv6
BIG TCP packets, and will be addressed in another patchset.

The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
and 1.5K MTU:

No BIG TCP:
for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
168          322          337          3776.49
143          236          277          4654.67
128          258          288          4772.83
171          229          278          4645.77
175          228          243          4678.93
149          239          279          4599.86
164          234          268          4606.94
155          276          289          4235.82
180          255          268          4418.95
168          241          249          4417.82

Enable BIG TCP:
ip link set dev ens1f0np0 gro_max_size 128000 gso_max_size 128000
for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
161          241          252          4821.73
174          205          217          5098.28
167          208          220          5001.43
164          228          249          4883.98
150          233          249          4914.90
180          233          244          4819.66
154          208          219          5004.92
157          209          247          4999.78
160          218          246          4842.31
174          206          217          5080.99

Xin Long (10):
  net: add a couple of helpers for iph tot_len
  bridge: use skb_ip_totlen in br netfilter
  openvswitch: use skb_ip_totlen in conntrack
  net: sched: use skb_ip_totlen and iph_totlen
  netfilter: use skb_ip_totlen and iph_totlen
  cipso_ipv4: use iph_set_totlen in skbuff_setattr
  ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
  net: add support for ipv4 big tcp
  netfilter: get ipv6 pktlen properly in length_mt6
  selftests: add a selftest for big tcp

 drivers/net/ipvlan/ipvlan_core.c           |   2 +-
 include/linux/ip.h                         |  20 +++
 include/linux/ipv6.h                       |   9 ++
 include/net/netfilter/nf_tables_ipv4.h     |   4 +-
 include/net/route.h                        |   3 -
 net/bridge/br_netfilter_hooks.c            |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |   4 +-
 net/core/gro.c                             |   6 +-
 net/core/sock.c                            |  11 +-
 net/ipv4/af_inet.c                         |   7 +-
 net/ipv4/cipso_ipv4.c                      |   2 +-
 net/ipv4/ip_input.c                        |   2 +-
 net/ipv4/ip_output.c                       |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |   2 +-
 net/netfilter/nf_log_syslog.c              |   2 +-
 net/netfilter/xt_length.c                  |   5 +-
 net/openvswitch/conntrack.c                |   2 +-
 net/sched/act_ct.c                         |   2 +-
 net/sched/sch_cake.c                       |   2 +-
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/big_tcp.sh     | 157 +++++++++++++++++++++
 21 files changed, 212 insertions(+), 35 deletions(-)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh

-- 
2.31.1

