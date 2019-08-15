Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E58F3D2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731174AbfHOSpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:45:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOSpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:45:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FIhXXE107614;
        Thu, 15 Aug 2019 18:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WLDd2r2MoB1afHQF9ZBYjTIhwOMS6/qWNuX/rgkqRU8=;
 b=dvMvJYIkj51ntmzyQg/EmgnM25LYvrZSMgbAnnq8yoL6PpUiZrc8vHCurfIGRtS8TlG7
 VvVRL7TGMkBaYmMeL/yBc1WHcolhIfDn+7gcUeXqY25Ql3hl87SQaLj3HRpC/bb75vpz
 JCHWQzM5ylTssWtImmmj4PVBz5uD+bG1IXPgX06fGAL+KMG9JZkRA4roMUwOvB1Up4/o
 CHqN0IO0qSN83PB/V1sa6XSVh/6Zss2LXNong/tSZVhG7EsEqpuC28DhMfkX11BbuRwP
 6POQfxLSvzr31WGnM7eU1kSu8p/zwyqzkT04yvi0KfmxnKfVAs82k7brXkYo6iILQvTf CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtvdc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 18:45:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FIhfxe176972;
        Thu, 15 Aug 2019 18:45:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ucmwk11yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 18:45:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FIj7t2002550;
        Thu, 15 Aug 2019 18:45:07 GMT
Received: from oracle.com (/23.233.26.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 11:45:07 -0700
Date:   Thu, 15 Aug 2019 14:45:05 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        "supporter:INTEL WIRELESS WIMAX CONNECTION 2400" 
        <linux-wimax@intel.com>, "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wimax/i2400m: fix a memory leak bug
Message-ID: <20190815184505.o7o2ojt7ag4shh7u@oracle.com>
Mail-Followup-To: Wenwen Wang <wenwen@cs.uga.edu>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        "supporter:INTEL WIRELESS WIMAX CONNECTION 2400" <linux-wimax@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1565892301-2812-1-git-send-email-wenwen@cs.uga.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565892301-2812-1-git-send-email-wenwen@cs.uga.edu>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Wenwen Wang <wenwen@cs.uga.edu> [190815 14:05]:
> In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
> to hold the original command line options. Then, the options are parsed.
> However, if an error occurs during the parsing process, 'options_orig' is
> not deallocated, leading to a memory leak bug. To fix this issue, free
> 'options_orig' before returning the error.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/wimax/i2400m/fw.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
> index e9fc168..6b36f6d 100644
> --- a/drivers/net/wimax/i2400m/fw.c
> +++ b/drivers/net/wimax/i2400m/fw.c
> @@ -342,6 +342,7 @@ int i2400m_barker_db_init(const char *_options)
>  				       "a 32-bit number\n",
>  				       __func__, token);
>  				result = -EINVAL;
> +				kfree(options_orig);
>  				goto error_parse;
>  			}
>  			if (barker == 0) {
> @@ -350,8 +351,10 @@ int i2400m_barker_db_init(const char *_options)
>  				continue;
>  			}
>  			result = i2400m_barker_db_add(barker);
> -			if (result < 0)
> +			if (result < 0) {
> +				kfree(options_orig);
>  				goto error_add;

I know that you didn't add this error_add label, but it seems like the
incorrect goto label.  Although looking at the caller indicates an add
failed, this label is used prior to and after the memory leak you are
trying to fix.  It might be better to change this label to something
like error_parse_add and move the kfree to the unwinding.  If a new
label is used, it becomes more clear as to what is being undone and
there aren't two jumps into an unwind from two very different stages of
the function.  Adding a new label also has the benefit of moving the
kfree to the unwind of error_parse.

Thanks,
Liam


> +			}
>  		}
>  		kfree(options_orig);
>  	}
> -- 
> 2.7.4
> 
