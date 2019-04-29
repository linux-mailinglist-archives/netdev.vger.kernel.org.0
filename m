Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85099E0FB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfD2LAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:00:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50376 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727710AbfD2LAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:00:13 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id E14D728008D;
        Mon, 29 Apr 2019 11:00:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 04:00:07 -0700
Subject: Re: [PATCH] rds: ib: force endiannes annotation
To:     Nicholas Mc Guire <hofrat@osadl.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <linux-kernel@vger.kernel.org>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
Date:   Mon, 29 Apr 2019 12:00:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-4.279000-4.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hcOwH4pD14DsPHkpkyUphL9LC92/N1OWlkCJwlu5sh0qPlY
        oV6p/cSxnvxAs02MrVHZj9bX58WOAtrx1weWCpUF9Ib/6w+1lWRzd7C7BtJobplWFHP5R0I96F2
        xWH9ZAxvo0cmq7QOKCJE7C19CEuIWhlahuHmDw1YwmhCbeOj6aY/8SyGg0rIRY0DjZWmXtn6jxY
        yRBa/qJUl4W8WVUOR/9xS3mVzWUuAojN1lLei7Rd/CUQwie/Fo7Mq1xmO35qw8xi0U5YNGcJ4n9
        vxgOV3iHkqjqrZMW0AEbTwwTTJVcrjaVpzLE/5p34yXMiKxtsZMv+p+q89pYtQ17CngTb9OBKmZ
        VgZCVnezGTWRXUlrx+EijnvekEIH
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.279000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556535612-qOvS5RxvVGZd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 07:09, Nicholas Mc Guire wrote:
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index 7055985..a070a2d 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -824,7 +824,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
>  	}
>  
>  	/* the congestion map is in little endian order */
> -	uncongested = le64_to_cpu(uncongested);
> +	uncongested = le64_to_cpu((__force __le64)uncongested);
>  
>  	rds_cong_map_updated(map, uncongested);
>  }
Again, a __force cast doesn't seem necessary here.  It looks like the
 code is just using the wrong types; if all of src, dst and uncongested
 were __le64 instead of uint64_t, and the last two lines replaced with
 rds_cong_map_updated(map, le64_to_cpu(uncongested)); then the semantics
 would be kept with neither sparse errors nor __force.

__force is almost never necessary and mostly just masks other bugs or
 endianness confusion in the surrounding code.  Instead of adding a
 __force, either fix the code to be sparse-clean or leave the sparse
 warning in place so that future developers know there's something not
 right.

-Ed
