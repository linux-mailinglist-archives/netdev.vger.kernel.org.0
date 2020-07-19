Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C1E22503E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgGSHXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGSHXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554CFC0619D2;
        Sun, 19 Jul 2020 00:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eRMsE6xRJtlZFD3MWcVjK8F4RNihLRwBQjgoO3VHBxE=; b=jZefwWMH3uBB3KlgI+6szHqt7v
        ycIfYlGXXybSlFRZNLlf0CNkj0X/PLKPdw+KCx46d3Bh5zZnbpfHyxeo+M00lUDyA5FpvRvNS3xN5
        g2FdbxmO1rCDIHfM9/7RF/Ljdv3yoG4tk6PrTbzIKKSNMKRNxi+Tt0a0Yd32mMv2vbbF729usN9lf
        K63luTPA0nsUgVdyMPV+OMcsARxx2RWX/6/OkTVR7hgYYor1eVnlV59FOJmt3WfoN2zG//VJvOaON
        zUS+ExjM/IsVitByNtvBjmlfTGD9Dm/ITUBNUbbAygNmf0TySPbvYBiRNtLecgZTDamefP58tHB38
        nyg5+sLg==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fc-0000ZF-C8; Sun, 19 Jul 2020 07:23:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 51/51] sctp: remove the out_nounlock label in sctp_setsockopt
Date:   Sun, 19 Jul 2020 09:22:28 +0200
Message-Id: <20200719072228.112645-52-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just used once, and a direct return for the redirect to the AF
case is much easier to follow than jumping to the end of a very long
function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f2d4f8a0c426bb..9a767f35971865 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4444,8 +4444,8 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	 */
 	if (level != SOL_SCTP) {
 		struct sctp_af *af = sctp_sk(sk)->pf->af;
-		retval = af->setsockopt(sk, level, optname, optval, optlen);
-		goto out_nounlock;
+
+		return af->setsockopt(sk, level, optname, optval, optlen);
 	}
 
 	if (optlen > 0) {
@@ -4635,8 +4635,6 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
 	release_sock(sk);
 	kfree(kopt);
-
-out_nounlock:
 	return retval;
 }
 
-- 
2.27.0

