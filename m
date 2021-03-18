Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624FC340D62
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhCRSmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:42:44 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:22084 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbhCRSmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:42:36 -0400
Date:   Thu, 18 Mar 2021 18:42:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616092954; bh=uga/a2V2PAZhoIbIvMFpYDGIy1+3tARpQIkiT76KT3w=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=g+3uQ5rbOLP8AEv2fyaFf/ESl7FCCuqGZ4kYFQ5fg7g6BHeobyHW4uYMyLMPrFwT8
         93lfmMvjWSm4Iij/A+3wYYovZDDdEkurVnsdWd6yCqK3gSX5iNfRAmQxXt4E4v2LtT
         5901nfIkdM6UmnxfI8pDeGtOfnGl84JMVQLh6ka2uqvo+SzvCQYa6gwpQB9v2Lr3ah
         zLa3mb5+NrEkW3IqGvJQbqSP05UnuSnJyGbZbTkAjGJA5xiyjaFY5vs9pxGwggyUJR
         r6FSgbcTPY7HZ/GDWnLoChC6TRgtofpGmt8t1eMrrprRTXVF0vOgshekcKGhpjPxz6
         vBDiHSI7DWZmg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 1/4] gro: make net/gro.h self-contained
Message-ID: <20210318184157.700604-2-alobakin@pm.me>
In-Reply-To: <20210318184157.700604-1-alobakin@pm.me>
References: <20210318184157.700604-1-alobakin@pm.me>
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

If some source file includes <net/gro.h>, but doesn't include
<linux/indirect_call_wrapper.h>:

In file included from net/8021q/vlan_core.c:7:
./include/net/gro.h:6:1: warning: data definition has no type or storage cl=
ass
    6 | INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct l=
ist_head *,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
./include/net/gro.h:6:1: error: type defaults to =E2=80=98int=E2=80=99 in d=
eclaration of =E2=80=98INDIRECT_CALLABLE_DECLARE=E2=80=99 [-Werror=3Dimplic=
it-int]

[...]

Include <linux/indirect_call_wrapper.h> directly. It's small and
won't pull lots of dependencies.
Also add some incomplete struct declarations to be fully stacked.

Fixes: 04f00ab2275f ("net/core: move gro function declarations to separate =
header ")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/net/gro.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/gro.h b/include/net/gro.h
index 8a6eb5303cc4..27c38b36df16 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -3,6 +3,11 @@
 #ifndef _NET_IPV6_GRO_H
 #define _NET_IPV6_GRO_H

+#include <linux/indirect_call_wrapper.h>
+
+struct list_head;
+struct sk_buff;
+
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_hea=
d *,
 =09=09=09=09=09=09=09   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
--
2.31.0


