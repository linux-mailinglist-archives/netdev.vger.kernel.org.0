Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173976D76AD
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbjDEITd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbjDEITc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB43A1BE9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680682724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L9CXlkWxa5SdW4THJZQP2BBn3FZZ8UI6SlqgD7wH/ew=;
        b=UbvpM0wXW1DzXZXzYdh0UX3KOe6v9N+v0DRxgpgeUKxKM1mYYOf+4BJLtUWuZX1OEBZx+f
        aOnDsIVsz3oKjbpi8kcHEHs2pM0Zq5Ug8aO0JP931fbAoEIyXdPrMEHB8nqXpbMXWUygYg
        q9aNLM5PPo1DyidgC8GOGdTzKAzWW+A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-nUYnXXrKNLKOkXBWn5--hQ-1; Wed, 05 Apr 2023 04:18:41 -0400
X-MC-Unique: nUYnXXrKNLKOkXBWn5--hQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2C1B3813F40;
        Wed,  5 Apr 2023 08:18:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DC842027061;
        Wed,  5 Apr 2023 08:18:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <SA0PR15MB3919AD9D232B3CA789A3FD6F99939@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <SA0PR15MB3919AD9D232B3CA789A3FD6F99939@SA0PR15MB3919.namprd15.prod.outlook.com> <20230331160914.1608208-1-dhowells@redhat.com> <20230331160914.1608208-39-dhowells@redhat.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Talpey <tom@talpey.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v3 38/55] siw: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage to transmit
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2904968.1680682716.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 05 Apr 2023 09:18:36 +0100
Message-ID: <2904969.1680682716@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Metzler <BMT@zurich.ibm.com> wrote:

> >  	if (c_tx->state =3D=3D SIW_SEND_HDR) {
> >  		if (c_tx->use_sendpage) {
> > @@ -457,10 +350,15 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx,
> > struct socket *s)
> > =

> =

> Couldn't we now collapse the two header handling paths
> into one, avoiding extra =

> 'if (c_tx->use_sendpage) {} else {}' conditions?

Okay, see the attached incremental change.

Note that the calls to page_frag_memdup() I previously added are probably =
not
going to be necessary as copying unspliceable data is now done in the
protocols (TCP, IP/UDP, UNIX, etc.).  See patch 08 for the TCP version.

David
---
diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw=
/siw/siw_qp_tx.c
index 28076832da20..edf66a97cf5f 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -335,7 +335,7 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struc=
t socket *s)
 	struct siw_sge *sge =3D &wqe->sqe.sge[c_tx->sge_idx];
 	struct bio_vec bvec[MAX_ARRAY];
 	struct msghdr msg =3D { .msg_flags =3D MSG_DONTWAIT | MSG_EOR };
-	void *trl, *t;
+	void *trl;
 =

 	int seg =3D 0, do_crc =3D c_tx->do_crc, is_kva =3D 0, rv;
 	unsigned int data_len =3D c_tx->bytes_unsent, hdr_len =3D 0, trl_len =3D=
 0,
@@ -343,25 +343,11 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, str=
uct socket *s)
 		     pbl_idx =3D c_tx->pbl_idx;
 =

 	if (c_tx->state =3D=3D SIW_SEND_HDR) {
-		if (c_tx->use_sendpage) {
-			rv =3D siw_tx_ctrl(c_tx, s, MSG_DONTWAIT | MSG_MORE);
-			if (rv)
-				goto done;
+		void *hdr =3D &c_tx->pkt.ctrl + c_tx->ctrl_sent;
 =

-			c_tx->state =3D SIW_SEND_DATA;
-		} else {
-			const void *hdr =3D &c_tx->pkt.ctrl + c_tx->ctrl_sent;
-			void *h;
-
-			rv =3D -ENOMEM;
-			hdr_len =3D c_tx->ctrl_len - c_tx->ctrl_sent;
-			h =3D page_frag_memdup(NULL, hdr, hdr_len, GFP_NOFS,
-					     ULONG_MAX);
-			if (!h)
-				goto done;
-			bvec_set_virt(&bvec[0], h, hdr_len);
-			seg =3D 1;
-		}
+		hdr_len =3D c_tx->ctrl_len - c_tx->ctrl_sent;
+		bvec_set_virt(&bvec[0], hdr, hdr_len);
+		seg =3D 1;
 	}
 =

 	wqe->processed +=3D data_len;
@@ -466,12 +452,7 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, stru=
ct socket *s)
 		trl =3D &c_tx->trailer.pad[c_tx->ctrl_sent];
 		trl_len =3D MAX_TRAILER - c_tx->ctrl_sent;
 	}
-
-	rv =3D -ENOMEM;
-	t =3D page_frag_memdup(NULL, trl, trl_len, GFP_NOFS, ULONG_MAX);
-	if (!t)
-		goto done_crc;
-	bvec_set_virt(&bvec[seg], t, trl_len);
+	bvec_set_virt(&bvec[seg], trl, trl_len);
 =

 	data_len =3D c_tx->bytes_unsent;
 =

@@ -480,7 +461,6 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struc=
t socket *s)
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, bvec, seg + 1,
 		      hdr_len + data_len + trl_len);
 	rv =3D sock_sendmsg(s, &msg);
-
 	if (rv < (int)hdr_len) {
 		/* Not even complete hdr pushed or negative rv */
 		wqe->processed -=3D data_len;
@@ -541,10 +521,6 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, stru=
ct socket *s)
 	}
 done_crc:
 	c_tx->do_crc =3D 0;
-	if (c_tx->state =3D=3D SIW_SEND_HDR)
-		folio_put(page_folio(bvec[0].bv_page));
-	folio_put(page_folio(bvec[seg].bv_page));
-done:
 	return rv;
 }
 =

