Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E648DD8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfFQTRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:17:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFQTR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:17:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HJDblY117470;
        Mon, 17 Jun 2019 19:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=N0fZ/pjg81/eD/DCiE/Dh3t4JVgGmGh6DJ1D5AK3Z3Q=;
 b=VJvdI4tE4D/3ZymNHHArHH/jlE8zJGuCXu4vIJnrNn4uTKYkE2Fy2wfCXYCehc/MU59c
 s2Fut7gx4dYV5eVgbDHUthGgxIhhVUKyIXqvrN19IvvQML8XqdlyYWvFF2fEO0cQCPlW
 MajN4wuAEWwcD+RHuuTlrK2ieId0HOijUDcB5JY2dvT+MMogmbHMGQacVeA/SsprrROp
 wumbb14BZPZ2EL+Fw8Wy+8tJhF/19bpUXiLw+A1gfDnScj+VkRu+ozqKzXE/6RPIcw+U
 ibhFBW0fZINkMFl2v/QyZygvgVIsaaWI4wD0LujG1BAeA2HZoJ0K2J2UvR3xvRoPbgIF Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t4rmp09fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 19:17:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HJGPBS155680;
        Mon, 17 Jun 2019 19:17:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t5mgbhd9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 19:17:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HJHG0a003467;
        Mon, 17 Jun 2019 19:17:16 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 12:17:16 -0700
Date:   Mon, 17 Jun 2019 22:17:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] net: lio_core: fix potential sign-extension overflow
 on large shift
Message-ID: <20190617191708.GI28859@kadam>
References: <20190617161249.28846-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617161249.28846-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 05:12:49PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Left shifting the signed int value 1 by 31 bits has undefined behaviour
> and the shift amount oq_no can be as much as 63.  Fix this by using
> BIT_ULL(oq_no) instead.
> 
> Addresses-Coverity: ("Bad shift operation")
> Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Looks good.  Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

