Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA8C29611A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368183AbgJVOq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:46:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60176 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368134AbgJVOq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:46:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MEeFLv153609;
        Thu, 22 Oct 2020 14:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5MMQ9s7NbinOSa0vtN3O3cVolnzIqMHYuIHjJVq9p1o=;
 b=V+vrPNEmtrH7FJhlWmGsYLPG14Z57VQR6G3fOEN5W1yB4vNiwrWsMeiInbdo4dJEGusJ
 9NlMgal4YWcrrjzHPn5XqN14YzUgoYYB9T68ZVpdikO1RlaNbgrOObtTYBXyQw3m4cs2
 NTRrMT2HvXB+DFXCzYM10+pBDBVWnWyDPT1TMqSlHWfGi74ANzWiph2ne5HEYE6ohnp6
 zquNAXmTyYWexW01KvkSuq+AB5UepJbGtcUL0AXb02BvS+Yt5Du65XX9yePvET9zQTUQ
 Oo4G8Lj2MxlZoskOS9X0KCLj4OdhiXxuF5V88hZ191OMYZH7LTMave7zE78zohocAGqF rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34ak16pmnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 14:46:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MEeAME040280;
        Thu, 22 Oct 2020 14:44:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 348a6qnynp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 14:44:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MEiY4t004600;
        Thu, 22 Oct 2020 14:44:34 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 07:44:33 -0700
Date:   Thu, 22 Oct 2020 17:44:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     isdn@linux-pingi.de
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] mISDN: hfcpci: Fix a use after free in hfcmulti_tx()
Message-ID: <20201022144426.GC18329@kadam>
References: <20201022070739.GB2817762@mwanda>
 <0ee243a9-9937-ad26-0684-44b18e772662@linux-pingi.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee243a9-9937-ad26-0684-44b18e772662@linux-pingi.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=3 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 04:24:00PM +0200, isdn@linux-pingi.de wrote:
> Hi Dan,
> 
> that looks wrong to me and never was a use after free.
> 
> sp is set either to the address containing the pointer to the actual
> D-channel SKB or to the actual B-channel SKB. This address is not freed
> and will not change in this context. The dev_kfree(*sp) will delete the
> old SKB and the call to  get_next_[bd]frame(), if returning true, will
> place a new SKB into this address, so (*sp) point to this new SKB.
> The len of course need to be the length of the new SKB, not the old one,
> which would be the result of this patch.
> 

Oh, wow.  You're absolutely right.  That's pretty subtle.  Thanks for
catching it.

regards,
dan carpenter


> Best regards
> Karsten
> 
> On 10/22/20 9:07 AM, Dan Carpenter wrote:
> > This frees "*sp" before dereferencing it to get "len = (*sp)->len;".
> > 
> > Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/isdn/hardware/mISDN/hfcmulti.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > index 7013a3f08429..ce6c160e0df4 100644
> > --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> > +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> > @@ -2152,16 +2152,14 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
> >  		HFC_wait_nodebug(hc);
> >  	}
> >  
> > +	len = (*sp)->len;
> >  	dev_kfree_skb(*sp);
> >  	/* check for next frame */
> > -	if (bch && get_next_bframe(bch)) {
> > -		len = (*sp)->len;
> > +	if (bch && get_next_bframe(bch))
> >  		goto next_frame;
> > -	}
> > -	if (dch && get_next_dframe(dch)) {
> > -		len = (*sp)->len;
> > +
> > +	if (dch && get_next_dframe(dch))
> >  		goto next_frame;
> > -	}
> >  
> >  	/*
> >  	 * now we have no more data, so in case of transparent,
> > 
