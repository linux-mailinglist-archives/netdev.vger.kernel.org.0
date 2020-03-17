Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7A188C06
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCQR3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:29:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20514 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgCQR3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:29:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rVQlkij6I5xHfbasruFFj7SzHDLIXfVbaQI2OF3x3tE=;
        b=XnqaELffCHUzipEEpCihJeEwqjnf+XFyf5K63igY3MA8d/r8VavfBprq9d9+K7H+6uv33y
        a1D9ZywRTFIfcLxTFQ9c/PPsslb9tOeRpXu1b6WcsQVHohGbCrrt0LnammH108o3trKL1p
        1oqCYjyb/Wi6/oI2hM+SCsTqX6UU+ME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-YNz80-B3PLihGs_qT-yX5Q-1; Tue, 17 Mar 2020 13:29:35 -0400
X-MC-Unique: YNz80-B3PLihGs_qT-yX5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DC301926DD9;
        Tue, 17 Mar 2020 17:29:30 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE4B55C28E;
        Tue, 17 Mar 2020 17:29:18 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D8C5630740457;
        Tue, 17 Mar 2020 18:29:17 +0100 (CET)
Subject: [PATCH RFC v1 02/15] mvneta: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     thomas.petazzoni@bootlin.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:17 +0100
Message-ID: <158446615781.702578.17438189744745816482.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This marvell driver mvneta uses PAGE_SIZE frames, which makes it
really easy to convert.  It also only updated rxq and now frame_sz
once per NAPI call.

Cc: thomas.petazzoni@bootlin.com
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1c391f63a26f..e6c6524f63a5 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2310,6 +2310,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(pp->xdp_prog);
 	xdp_buf.rxq = &rxq->xdp_rxq;
+	xdp_buf.frame_sz = PAGE_SIZE;
 
 	/* Fairness NAPI loop */
 	while (rx_proc < budget && rx_proc < rx_todo) {


