Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18D2DA9E5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLOJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:15:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51932 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgLOJPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:15:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BF9E5Hc149147;
        Tue, 15 Dec 2020 09:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QTr9uNr7ii2CFktvUpD4C/m814MZe6sSbFaDTHiN46s=;
 b=Fkyi3/n9DUBQFJo65Z7mZWx3xDrAOIPfYAsbGHyltczTEU1cBlFx1+Zpmbbih3webVhr
 DYAhx++YpuFWYFzuiqrI2ISY2mOQazsntUegr2Q2iXbIk4I+eKERsDjcmjNISbSs5P7g
 //AXwGiVpC+HsBiASWI4swzFuzBLsfHZRzyGFaCsFRUczlb68QRgfWeg2Cu+l3vu77iS
 IfLdZUijOr6ejWOaieB7/sWFc1ZWZRI+Wru0uEDE/ypx/ylvvAvfuD3YpJtuaH2FRAwU
 VQtQsF3WilLy8Ysb5XiWkWOJAmgIhZoxB7RyeUnH9Fhu9lc6E7Qi9eg1AIdcqSm7XXyr MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcb9jyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 09:14:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BF94wZH034720;
        Tue, 15 Dec 2020 09:12:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35e6eq5chg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:12:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BF9C50e031675;
        Tue, 15 Dec 2020 09:12:07 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 01:12:04 -0800
Date:   Tue, 15 Dec 2020 12:11:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, kuba@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
Message-ID: <20201215091153.GH2809@kadam>
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215085655.ddacjfvogc3e33vz@gilmour>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
> Hi,
> 
> On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
> > 'irq_of_parse_and_map()' should be balanced by a corresponding
> > 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.
> 
> Do you have a source to back that? It's not clear at all from the
> documentation for those functions, and couldn't find any user calling it
> from the ten-or-so random picks I took.

It looks like irq_create_of_mapping() needs to be freed with
irq_dispose_mapping() so this is correct.

regards,
dan carpenter

