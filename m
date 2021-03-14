Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8245833A46E
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhCNLMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:12:16 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:62483 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbhCNLLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:11:49 -0400
Date:   Sun, 14 Mar 2021 11:11:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615720308; bh=OtoaEa4C9A8M8IjnX8ICb3j9vVq3aPxG0RyT+eIX9OU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=PtqoU39fzNRS64KXipSkH/EEkC2cvGVmoElaAFxa9hDw2z1wnW5DRewaBcKQq/X4x
         ds8nrAsdpwJdnr0PvehU93XmH3+It1yXN95rGiYcMsymzpQTqXo2HWjUC1ZsTiryIv
         xnqnYim2AFwUmEsKvOF7jteUj3ElKlxBcjOSApo6iTx+rInJTmSeV8/Oc2ImPByOiJ
         jsnpOzRNOg37RRO0Uqup8hVWAcWgsh5jbbQWiqNS4zMVMBto8suLPe2//jy8Tuf1FG
         TnHJyW2Pwq6oWZMCJV1Bpq/H/IjcYPEIttWrFrrUJ1vnla8SLhWpKihFRbqQhvfmep
         89D57l8unT9/Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 5/6] ethernet: constify eth_get_headlen()'s data argument
Message-ID: <20210314111027.7657-6-alobakin@pm.me>
In-Reply-To: <20210314111027.7657-1-alobakin@pm.me>
References: <20210314111027.7657-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's used only for flow dissection, which now takes constant data
pointers.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/etherdevice.h | 2 +-
 net/ethernet/eth.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index bcb2f81baafb..330345b1be54 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -29,7 +29,7 @@ struct device;
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
-u32 eth_get_headlen(const struct net_device *dev, void *data, unsigned int=
 len);
+u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 le=
n);
 __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
 extern const struct header_ops eth_header_ops;

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4106373180c6..e01cf766d2c5 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL(eth_header);
  * Make a best effort attempt to pull the length for all of the headers fo=
r
  * a given frame in a linear buffer.
  */
-u32 eth_get_headlen(const struct net_device *dev, void *data, unsigned int=
 len)
+u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 le=
n)
 {
 =09const unsigned int flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
 =09const struct ethhdr *eth =3D (const struct ethhdr *)data;
--
2.30.2


