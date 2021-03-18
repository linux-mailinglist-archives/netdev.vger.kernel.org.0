Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04C340D5F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhCRSmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:42:42 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:58342 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhCRSm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:42:26 -0400
Date:   Thu, 18 Mar 2021 18:42:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616092944; bh=RWcHWkX72BpuDYzZ08uRHn5rh75TT354Si0UcCXl5bM=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=JGb9Dek/wtBRJlXX2AKbbZ9HObgopvd0FQC6vRYmU4zTAPGEnnyqBYbcfr/YjYt9A
         tQg6cnSsuUBiF/Elxk0hA4LQVOsAwdGaI7tIFrcEoVPbqddEY4YizR49U0FphPscfr
         kzz1cWmTMKejqWI3h6tfwpvUb2V/C1rd6SBAgRVrkLFeiuGBICvzc3ULtMIPDYB/Hk
         vM37tvnXWXHa5s4tsf0taIS7wQ5oKdBIt5eS+jyPVp3xmB8TpgylORNXwbYaSaxOZ1
         CkCQ+QUxJSaW6jhsmpGvS15J/HdmZNt2sHgSZLvo24/0mXfQM9Iv5sX/72Nf3nd+Cz
         nuByuUulN8cRg==
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
Subject: [PATCH net-next 0/4] net: avoid retpoline overhead on VLAN and TEB GRO
Message-ID: <20210318184157.700604-1-alobakin@pm.me>
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

dev_gro_receive() uses indirect calls for IP GRO functions, but
it works only for the outermost headers and untagged frames.
Simple VLAN tag before an IP header restores the performance hit.
This simple series straightens the GRO calls for IP headers going
after VLAN tag or inner Ethernet header (GENEVE, NvGRE, VxLAN)
for retpolined kernels.

Alexander Lobakin (4):
  gro: make net/gro.h self-contained
  gro: add combined call_gro_receive() + INDIRECT_CALL_INET() helper
  vlan/8021q: avoid retpoline overhead on GRO
  ethernet: avoid retpoline overhead on TEB (GENEVE, NvGRE, VxLAN) GRO

 include/net/gro.h     | 13 +++++++++++++
 net/8021q/vlan_core.c | 10 ++++++++--
 net/ethernet/eth.c    | 11 ++++++++---
 3 files changed, 29 insertions(+), 5 deletions(-)

--
2.31.0


