Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BFD689DBB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbjBCPKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjBCPJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:09:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96903A145A;
        Fri,  3 Feb 2023 07:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WVeCTAFZrkMT1bjw8l1TFDAlVxNms+8mA7ykabtaeDg=; b=t9FEQ5rjC3OIn2nzgYy1gJw8Mr
        n53fGXsQMf+ehav4QQE5ZTAG8tGsjUiGEBVQYh2SDvUkP9IT5HI/OvK6+Vuq11BsHPccCsYlaVya8
        pSFtm+XG2ShLMfy3vd1SSr6c38wjVS0dXGNtGikvtcXOlAn4vjpa1DRXkf999sCWxsy5/DVR36uk5
        iqpwoO7N70bhXaz2L3OKdTWPG2CIMdaT/I9joJapJfQKQxfPZTsr5I5s2fspc63TJDqQDH58BYjKO
        tC7gYnap2gM8uy5sbPN/U8EX8p/ffgsOL0XlluLwFPxZAKLKhDgrpaYcRf0sLoH554FDB8S4FjEB0
        l9W1hitg==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxfM-002bR0-0P; Fri, 03 Feb 2023 15:07:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 21/23] sunrpc: use bvec_set_page to initialize bvecs
Date:   Fri,  3 Feb 2023 16:06:32 +0100
Message-Id: <20230203150634.3199647-22-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230203150634.3199647-1-hch@lst.de>
References: <20230203150634.3199647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Acked-by: Trond Myklebust <trond.myklebust@hammerspace.com>
---
 net/sunrpc/svcsock.c | 7 ++-----
 net/sunrpc/xdr.c     | 5 ++---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 815baf308236a9..91252adcae4696 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -252,11 +252,8 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqstp, size_t buflen,
 
 	clear_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
 
-	for (i = 0, t = 0; t < buflen; i++, t += PAGE_SIZE) {
-		bvec[i].bv_page = rqstp->rq_pages[i];
-		bvec[i].bv_len = PAGE_SIZE;
-		bvec[i].bv_offset = 0;
-	}
+	for (i = 0, t = 0; t < buflen; i++, t += PAGE_SIZE)
+		bvec_set_page(&bvec[i], rqstp->rq_pages[i], PAGE_SIZE, 0);
 	rqstp->rq_respages = &rqstp->rq_pages[i];
 	rqstp->rq_next_page = rqstp->rq_respages + 1;
 
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index f7767bf224069f..afe7ec02d23229 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -150,9 +150,8 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
 		if (!buf->bvec)
 			return -ENOMEM;
 		for (i = 0; i < n; i++) {
-			buf->bvec[i].bv_page = buf->pages[i];
-			buf->bvec[i].bv_len = PAGE_SIZE;
-			buf->bvec[i].bv_offset = 0;
+			bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
+				      0);
 		}
 	}
 	return 0;
-- 
2.39.0

