Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA722309C23
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhAaMuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:50:39 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:30892 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhAaMMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:12:40 -0500
Date:   Sun, 31 Jan 2021 12:11:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612095114; bh=k4GmHXZWhLsxhmf6TA7kT97uyu8L/XM/o770SPV6Jso=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=S3+SybR6yJJC/jYt2WFCuYCGx0BAiH67Qf9QkW448q1RFTW8j81mTYOxr6H+eqX3I
         7YclmedVVG6x+FabYgajZO55X7DXkUO1O5NJtYRr0cs/W6PvORnV0LlsFmlw+T05Co
         +RQsgjmPA/R39zKqeVxQZPLHCEHfFvy/xb8Seg62cM7wRIlC4EDhtbKB6lsqandzw3
         Yp15pWB3pg8d8+QKtK/OG8HpUJpSWwT0As6jgaglJiVU1Q/D03IW4scyF9UVtEzldJ
         +wo0vNGG42zUMbbcIs2KQn9YD+sBg5nM9bXTeCBhNoK/LSahXX3QVEfW9buQ+Sm0AL
         EJoeoXC9oc4aQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 3/5] net: introduce common dev_page_is_reusable()
Message-ID: <20210131120844.7529-4-alobakin@pm.me>
In-Reply-To: <20210131120844.7529-1-alobakin@pm.me>
References: <20210131120844.7529-1-alobakin@pm.me>
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

A bunch of drivers test the page before reusing/recycling for two
common conditions:
 - if a page was allocated under memory pressure (pfmemalloc page);
 - if a page was allocated at a distant memory node (to exclude
   slowdowns).

Introduce a new common inline for doing this, with likely() already
folded inside to make driver code a bit simpler.

Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/skbuff.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b027526da4f9..0e42c53b8ca9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2938,6 +2938,22 @@ static inline struct page *dev_alloc_page(void)
 =09return dev_alloc_pages(0);
 }
=20
+/**
+ * dev_page_is_reusable - check whether a page can be reused for network R=
x
+ * @page: the page to test
+ *
+ * A page shouldn't be considered for reusing/recycling if it was allocate=
d
+ * under memory pressure or at a distant memory node.
+ *
+ * Returns false if this page should be returned to page allocator, true
+ * otherwise.
+ */
+static inline bool dev_page_is_reusable(const struct page *page)
+{
+=09return likely(page_to_nid(page) =3D=3D numa_mem_id() &&
+=09=09      !page_is_pfmemalloc(page));
+}
+
 /**
  *=09skb_propagate_pfmemalloc - Propagate pfmemalloc if skb is allocated a=
fter RX page
  *=09@page: The page that was allocated from skb_alloc_page
--=20
2.30.0


