Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6743B6F28
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 10:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhF2IWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 04:22:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16776 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232308AbhF2IWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 04:22:53 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T8IBad021323;
        Tue, 29 Jun 2021 08:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=T73nHEN9/0mVEhiMXnpbAfPJaE649Q3WTjYrbNLmFeQ=;
 b=OhPq+zQpxXOIvUrY41dzimBGGE1tPa5Es7YKyHueUDd73owzmALSI1p0bEY0RDmAQjkJ
 LSRoWYEW3a1KIIvwuSkiWhfETJKH8ZmLXb+tRLn235odHGv8QPH61kzb51D61Hm7tlJg
 RxVYMVy0akjTLeEADeChlc6UZBIDmiJe4VebIZWQVZNYmcIwif42Cpvmfb7KKETQCKeB
 Tk5LuXl3mFw25dAPZ1aVcgo3y4s7unNQD3BpnOaNnt5BRLjp04JWMFto7QjOHXOnIbon
 NUTuneRFVdes8D4FqdOPbs1cU3U6mO2Cxmco5X2uQoBQ0FV/gNL/sacVh1BJ9dh5aj1J 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqawv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 08:19:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T8G2wX165599;
        Tue, 29 Jun 2021 08:19:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 39dt9e9tm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 08:19:55 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15T8JthL175286;
        Tue, 29 Jun 2021 08:19:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 39dt9e9tk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 08:19:55 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15T8JqiN023507;
        Tue, 29 Jun 2021 08:19:52 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jun 2021 01:19:52 -0700
Date:   Tue, 29 Jun 2021 11:19:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] sctp: prevent info leak in sctp_make_heartbeat()
Message-ID: <YNrXoNAiQama8Us8@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: FF0gmXRVk0hhoiqxMpJ7aKd-AqjutkXi
X-Proofpoint-ORIG-GUID: FF0gmXRVk0hhoiqxMpJ7aKd-AqjutkXi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "hbinfo" struct has a 4 byte hole at the end so we have to zero it
out to prevent stack information from being disclosed.

Fixes: fe59379b9ab7 ("sctp: do the basic send and recv for PLPMTUD probe")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Btw = {} is the newest way to initialize holes.

In the past we have debated whether = {} will *always* zero out struct
holes and it wasn't clear from the C standard.  But it turns out that
"= {}" is not part of the standard but is instead a GCC extension and it
does clear the holes.  In GCC (not the C standard) then = {0}; is also
supposed to initialize holes in there was a bug in one version where it
didn't.

So that's nice, because adding memset()s to zero everywhere was ugly.

 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 587fb3cb88e2..3a290f620e96 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1162,7 +1162,7 @@ struct sctp_chunk *sctp_make_new_encap_port(const struct sctp_association *asoc,
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport)
 {
-	struct sctp_sender_hb_info hbinfo;
+	struct sctp_sender_hb_info hbinfo = {};
 	struct sctp_chunk *retval;
 
 	retval = sctp_make_control(asoc, SCTP_CID_HEARTBEAT, 0,
-- 
2.30.2

