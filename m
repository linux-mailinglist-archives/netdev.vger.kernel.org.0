Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C2A1363FE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgAIXr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:47:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgAIXr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:47:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009NccQb003715;
        Thu, 9 Jan 2020 23:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nRKnwHomok/PpPFwHMvZtyTJWnTH8Av6uYkXPJFr5L0=;
 b=A+1qXt2wKxmM3O0bCR4wk11/+OHX6zPymnH2xGsRDPxDOgPP36J7gWvT50+GAborHaRr
 orzlH4nhv17YJJZ1HUyBcRJBd5lQoRsr+SW68bga+0ez4jaFItUmrfPRU+7hOnoPk877
 Zi4WLc7wwbvqV/f4UCx80CugqpR9UEx7Hs5Cr0JynkTioE453a2Dw7u9+iijqk7AGlP4
 S7kclCvN7Tfb9M9TKQIyH+WXWGlb7G9rbVVJGssLyMxgGJ1dCgU+F9py4/iHPta9u/nl
 fs3NAZrv+JwM/acsSR+todj4Km0Ok/PckbiUPQC+IhFyH+1Sp5ISntCzDbNM1aJZvbQF WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xaj4ue8qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 23:46:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Nd1pj089807;
        Thu, 9 Jan 2020 23:46:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xdms0b9ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 23:46:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009NkKGp001333;
        Thu, 9 Jan 2020 23:46:20 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 15:46:20 -0800
Subject: Re: [RFC PATCH V2 01/11] xen/manage: keep track of the on-going
 suspend mode
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        jgross@suse.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        kamatam@amazon.com, sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        dwmw@amazon.co.uk, fllinden@amaozn.com
References: <20200107233720.GA17906@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <88721569-d425-8df3-2ab2-3aa9155b326c@oracle.com>
Date:   Thu, 9 Jan 2020 18:46:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200107233720.GA17906@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/20 6:37 PM, Anchal Agarwal wrote:
> +
> +static int xen_setup_pm_notifier(void)
> +{
> +	if (!xen_hvm_domain())
> +		return -ENODEV;

ARM guests are also HVM domains. Is it OK for them to register the 
notifier? The diffstat suggests that you are supporting ARM.

-boris

> +
> +	return register_pm_notifier(&xen_pm_notifier_block);
> +}
>

