Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D8F1B5E6E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgDWO55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:57:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWO55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587653875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYBzbsP476S3Wt3RY25PE11AiFNe3DiC7M/WE7OYU7E=;
        b=GRfs19mBZn/no1vfgfolO9t/pQnD5wxmPp1yWkVYUnnPBx8fFMEteS7PrISTX6l65dUsLt
        PMuweIz1TQk8fBC6eWrqOKkm4YcCRgvWx68JAZb6GUXkIZWP/dBmlv9WdeU7iPXkdyB6Id
        dNYtVdwD3F9ln12egj5r9yAxSnEhztM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-MimqlWKsPsC4MFQcmIG4sA-1; Thu, 23 Apr 2020 10:57:53 -0400
X-MC-Unique: MimqlWKsPsC4MFQcmIG4sA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E1741009440;
        Thu, 23 Apr 2020 14:57:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5D0460C81;
        Thu, 23 Apr 2020 14:57:46 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C7EE23063F604;
        Thu, 23 Apr 2020 16:57:45 +0200 (CEST)
Subject: [PATCH net-next 1/2] net: sched: report ndo_setup_tc failures via
 extack
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Date:   Thu, 23 Apr 2020 16:57:45 +0200
Message-ID: <158765386575.1613879.14529998894393984755.stgit@firesoul>
In-Reply-To: <158765382862.1613879.11444486146802159959.stgit@firesoul>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Help end-users of the 'tc' command to see if the drivers ndo_setup_tc
function call fails. Troubleshooting when this happens is non-trivial
(see full process here[1]), and results in net_device getting assigned
the 'qdisc noop', which will drop all TX packets on the interface.

[1]: https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_nxp_ls1088/nxp-board04-troubleshoot-qdisc.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/sched/cls_api.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55bd1429678f..11b683c45c28 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -735,8 +735,11 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	INIT_LIST_HEAD(&bo.cb_list);
 
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
-	if (err < 0)
+	if (err < 0) {
+		if (err != -EOPNOTSUPP)
+			NL_SET_ERR_MSG(extack, "Driver ndo_setup_tc failed");
 		return err;
+	}
 
 	return tcf_block_setup(block, &bo);
 }


