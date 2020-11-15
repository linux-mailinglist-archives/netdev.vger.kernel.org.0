Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE96F2B38F5
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 21:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgKOUFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 15:05:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgKOUFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 15:05:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFK43b1047047;
        Sun, 15 Nov 2020 20:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bmoZX8u1q0Upqf5t/0ploFSERTNgOdg02qf028mJeBE=;
 b=GYAiWZNttqNOK74hRQEBF7OE4rozOOgldgLTTDIo28kZ/Kg/QGT9lbiHi2Hp/9kg3afv
 JUHHg4SlP6hJp1T9Lt4vZclaGcbgveOqVG82SD21zQc0PPQteswcIX/kddfm7YTyUE9w
 vJZ1KZ2GgQWAtC7kcJ+luVT4B6fVsKTcDunpwGXpz6fXoP7SiyQfAEtr/mxtJqDIhBo4
 1Dq/ixPrErNz6KYjcIfZW94tYw6GkyCutXEW8bn47s0P15cmA33VUl/e6Wc7ezJc9AXc
 kjcKFPL0AmajHcO6oBz2E075MU5dYrXoFeJrYOOeBPYQHJ7Tc1TOjcjTNAo2R0auzVCx 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76kjqr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 20:04:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFJxTsN048469;
        Sun, 15 Nov 2020 20:04:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34trtjwg5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 20:04:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AFK4nlU032208;
        Sun, 15 Nov 2020 20:04:49 GMT
Received: from [10.159.225.239] (/10.159.225.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Nov 2020 12:04:49 -0800
Subject: Re: [PATCH v2 1/1] page_frag: Recover from memory pressure
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, edumazet@google.com, vbabka@suse.cz
References: <20201115065106.10244-1-dongli.zhang@oracle.com>
 <20201115121828.GQ17076@casper.infradead.org>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <aca0ba1d-6090-045a-5051-df296bbfdacf@oracle.com>
Date:   Sun, 15 Nov 2020 12:04:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115121828.GQ17076@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=911 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=925
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/20 4:18 AM, Matthew Wilcox wrote:
> On Sat, Nov 14, 2020 at 10:51:06PM -0800, Dongli Zhang wrote:
>> +		if (nc->pfmemalloc) {
> 
> You missed the unlikely() change that Eric recommended.
> 

Thank you very much. I missed that email.

I will send v3.

Dongli Zhang
