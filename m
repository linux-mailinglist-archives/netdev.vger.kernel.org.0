Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B868E4A5771
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbiBAHCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:02:18 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37918 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbiBAHCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 02:02:17 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2022 02:02:17 EST
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E8AD82052E;
        Tue,  1 Feb 2022 07:52:10 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H0gHnvcPIx3j; Tue,  1 Feb 2022 07:52:10 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78E66204A4;
        Tue,  1 Feb 2022 07:52:10 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 7120580004A;
        Tue,  1 Feb 2022 07:52:10 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 07:52:10 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 1 Feb
 2022 07:52:09 +0100
Date:   Tue, 1 Feb 2022 07:51:57 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH] xfrm: fix the if_id check in changelink
Message-ID: <ca25f9904d2a4acebdc02b1c054aaeab25d99cc5.1643698195.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <20220126215937.GA31158@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220126215937.GA31158@duo.ucw.cz>
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_id will be always 0, because it was not yet initialized.

Fixes: 8dce43919566 ("xfrm: interface with if_id 0 should return error")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..4e3c62d1ad9e 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -673,12 +673,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};

+	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");
 		return -EINVAL;
 	}

-	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);
--
2.30.2

