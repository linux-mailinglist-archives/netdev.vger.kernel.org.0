Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331353B6FF5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 11:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhF2JQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 05:16:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50232 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232719AbhF2JQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 05:16:35 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T9BZxs019108;
        Tue, 29 Jun 2021 09:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3uiZYuUOjauVOsZgzfaYSUWXb+SRYERHDQtIEya4rTw=;
 b=csUjMjQlJfXZqkpMZWLmjHpH4yY2ksJs47jEg3ulUw8pZpTKZmtx0OB3COestD5vWuOD
 zIlQUkxCXTQgui2w5qhbm9CJQwv+lSbEWOJeCmxuHci5GfQrIISkFmATctg5lBIPiwzB
 4o1hT9P6eGZD9pMqIuFQU2ZOyIhzslGQ0gWgbrm7BG6KbDfw+KRLaf6t9ErRP1XcX6mj
 lWYlqqhhLSLxhSOlg4PzKVtBYoia6wEZH024PeXVQE9OXtYSVI+RqdbX8+1fDsqPJ3/J
 ZoM59inP/skrIevczX+9eBU3oz36VnnZzHiiwuto5yo8oitTdokqKu6y4jBrugOVZuch 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39fpu2h188-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 09:13:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T95p6x080641;
        Tue, 29 Jun 2021 09:13:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 39dv257v0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 09:13:18 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15T99AMB090054;
        Tue, 29 Jun 2021 09:13:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 39dv257v0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 09:13:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15T9DAtM032729;
        Tue, 29 Jun 2021 09:13:10 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Jun 2021 02:13:10 -0700
Date:   Tue, 29 Jun 2021 12:13:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andreas Fink <afink@list.fink.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] sctp: prevent info leak in sctp_make_heartbeat()
Message-ID: <20210629091302.GP2040@kadam>
References: <YNrXoNAiQama8Us8@mwanda>
 <886e4daf-c239-c1ce-da52-4b4684449908@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <886e4daf-c239-c1ce-da52-4b4684449908@list.fink.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: LtB3j_nw1p3r7RQTzOflNbk3kZRiH54U
X-Proofpoint-ORIG-GUID: LtB3j_nw1p3r7RQTzOflNbk3kZRiH54U
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 10:23:49AM +0200, Andreas Fink wrote:
> Does that gcc extension work with all compilers, especially clang?
> 

I had to look up the thread where this was discussed.

https://lore.kernel.org/lkml/20200731045301.GI75549@unreal/

I was wrong.  It started as a GCC extension but was made part of the
standard in C11.  So we should be good.

https://lore.kernel.org/lkml/20200731140452.GE24045@ziepe.ca/

regards,
dan carpenter
