Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FD712D0A8
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfL3Ob1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:31:27 -0500
Received: from mail.dlink.ru ([178.170.168.18]:39334 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3Ob1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:31:27 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 07A8D1B205E4; Mon, 30 Dec 2019 17:31:22 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 07A8D1B205E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716283; bh=RwOI8oAxd+fijp+Xuc6Oa+5EbKzjW8W4KCZUcnbzQOs=;
        h=From:To:Cc:Subject:Date;
        b=AfD3z3gGGkGDyB8iUL7HkxTbdGP3pnAL7i9Q9EwC2vC5GbqRF7bSN/0kB1+VO2nRB
         JFg2AVQi0ZN9KLo4p2hwxgiIybR7VJR9YeSXtMtnGJC8Y7XUFG0qAKmAMKrSGeA0PY
         /987XTEF+cxaPYxezYI+xaoBmTqXEKpVYb43fgO8=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id C75FB1B205E4;
        Mon, 30 Dec 2019 17:31:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C75FB1B205E4
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CA84D1B229CB;
        Mon, 30 Dec 2019 17:31:01 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:01 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 00/20] net: dsa: add GRO support
Date:   Mon, 30 Dec 2019 17:30:08 +0300
Message-Id: <20191230143028.27313-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now, napi_gro_receive() in cases where the corresponding
device is installed as CPU port of DSA-driven switch is in fact
an overheaded version of netif_receive_skb{,_list}() with no
advantages over:

- dev_gro_receive() can't find packet_offload for ETH_P_XDSA type;
- so it immediately returns GRO_NORMAL;
- napi_skb_finish() passes skb to gro_normal_one() -> netstack.

This series adds a basic infrastructure to allow DSA taggers to
implement GRO callbacks and adds GRO support for 5 tagger drivers:
* tag_ar9331
* tag_gswip
* tag_lan9303
* tag_mtk
* tag_qca

I didn't make it for the rest because they are in fact way more
complicated (e.g. combined DSA + 802.1q tag etc.) and require
more familiarity with them and tests on the real hardware, which
is inaccesible for me at the moment.

This series also includes a bunch of random fixes in several tagger
drivers and some cleanup. I left them all in one place as they depend
on each other, but there's no problem for me to split this into
different series.

I mark this as RFC, and there are the key questions for maintainers,
developers, users etc.:
- Do we need GRO support for DSA at all?
- Which tagger protocols really need it and which don't?
- Are the actual changes correct in every single tagger code?
- Does this series bring any performance improvements on the
  affected systems?
- Would anybody mind if we'd add DSA support to napi_gro_frags()?
- Any code/other comments/notes.

I also would like to see more taggers with GRO callbacks, such as
DSA and EDSA, and the results of their addition.

Alexander Lobakin (20):
  net: dsa: make .flow_dissect() callback returning void
  net: dsa: add GRO support infrastructure
  net: dsa: tag_ar9331: add .flow_dissect() callback
  net: dsa: tag_ar9331: split out common tag accessors
  net: dsa: tag_ar9331: add GRO callbacks
  net: dsa: tag_gswip: fix typo in tag name
  net: dsa: tag_gswip: switch to bitfield helpers
  net: dsa: tag_gswip: add .flow_dissect() callback
  net: dsa: tag_gswip: split out common tag accessors
  net: dsa: tag_gswip: add GRO callbacks
  net: dsa: tag_lan9303: add .flow_dissect() callback
  net: dsa: tag_lan9303: split out common tag accessors
  net: dsa: tag_lan9303: add GRO callbacks
  net: dsa: tag_mtk: split out common tag accessors
  net: dsa: tag_mtk: add GRO callbacks
  net: dsa: tag_qca: fix doubled Tx statistics
  net: dsa: tag_qca: switch to bitfield helpers
  net: dsa: tag_qca: split out common tag accessors
  net: dsa: tag_qca: add GRO callbacks
  net: core: add (unlikely) DSA support in napi_gro_frags()

 include/net/dsa.h         |  10 ++-
 net/core/dev.c            |  11 ++-
 net/core/flow_dissector.c |   8 +-
 net/dsa/dsa.c             |  43 +++++++++-
 net/dsa/dsa2.c            |   1 +
 net/dsa/tag_ar9331.c      | 139 ++++++++++++++++++++++++++-----
 net/dsa/tag_dsa.c         |   5 +-
 net/dsa/tag_edsa.c        |   5 +-
 net/dsa/tag_gswip.c       | 126 +++++++++++++++++++++++-----
 net/dsa/tag_lan9303.c     | 139 ++++++++++++++++++++++++++-----
 net/dsa/tag_mtk.c         | 115 +++++++++++++++++++++-----
 net/dsa/tag_qca.c         | 167 ++++++++++++++++++++++++++++----------
 12 files changed, 629 insertions(+), 140 deletions(-)

-- 
2.24.1

