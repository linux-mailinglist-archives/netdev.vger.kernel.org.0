Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8C235117
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 10:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgHAIA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 04:00:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58748 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgHAIA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 04:00:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0717wTFw026356;
        Sat, 1 Aug 2020 08:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JcmYWttSgHbw7qmGDRTSvtOA/0p07IlseUnTuNrFNjc=;
 b=v/0FkYbVaBTZHtmsPt81t2LxiXsh0E24AS2oPVkso964b5B5DXK85h8T1RZCzpD+qI4x
 eK9e51amSGeWeddjOl6FYD30GRjrEfH3oyckeRbi/Le+mL7HZOH1vklRd3uE6MPEZJSJ
 I1Y3dP/wa6iWOT/WEovib+rDatLM37z+SX+vBI1AnY1prLuE95IqNcuZ78qyvw9/0+pZ
 nBtFb3BJrp5Tq0ZK2nh/QYZsvPKoWo79Wb9N1TOsSpjjOlp4gFM0o6R36cD9GGzbOMhe
 W2vkOivca/j4VnEy+QUlcMzxX25lLqb4n8/Xo0b01bJKNHepm88iQp43QEsJEpLlZwwg gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32n0bkrcrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 01 Aug 2020 08:00:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0717wlk5023636;
        Sat, 1 Aug 2020 08:00:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 32myqgqq4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 01 Aug 2020 08:00:43 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07180g11028919;
        Sat, 1 Aug 2020 08:00:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32myqgqq41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Aug 2020 08:00:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07180c7b019130;
        Sat, 1 Aug 2020 08:00:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 01 Aug 2020 01:00:37 -0700
Date:   Sat, 1 Aug 2020 11:00:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200801080026.GJ5493@kadam>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200731182712.GI24045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731182712.GI24045@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9699 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 phishscore=0 impostorscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008010062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 03:27:12PM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 31, 2020 at 07:19:24PM +0200, Greg Kroah-Hartman wrote:
> 
> > > I tried for a bit and didn't find a way to get even old gcc 4.4 to not
> > > initialize the holes.
> > 
> > Odd, so it is just the "= {0};" that does not zero out the holes?
> 
> Nope, it seems to work fine too. I tried a number of situations and I
> could not get the compiler to not zero holes, even back to gcc 4.4
> 
> It is not just accidental either, take this:
> 
> 	struct rds_rdma_notify {
> 		unsigned long user_token;
> 		unsigned char status;
> 		unsigned long user_token1 __attribute__((aligned(32)));
> 	} foo = {0};
> 
> Which has quite a big hole, clang generates:
> 
> 	movq	$0, 56(%rdi)
> 	movq	$0, 48(%rdi)
> 	movq	$0, 40(%rdi)
> 	movq	$0, 32(%rdi)
> 	movq	$0, 24(%rdi)
> 	movq	$0, 16(%rdi)
> 	movq	$0, 8(%rdi)
> 	movq	$0, (%rdi)
> 
> Deliberate extra instructions to fill both holes. gcc 10 does the
> same, older gcc's do create a rep stosq over the whole thing.
> 
> Some fiddling with godbolt shows quite a variety of output, but I
> didn't see anything that looks like a compiler not filling
> padding. Even godbolt's gcc 4.1 filled the padding, which is super old.
> 
> In several cases it seems the aggregate initializer produced better
> code than memset, in other cases it didn't
> 
> Without an actual example where this doesn't work right it is hard to
> say anything more..

Here is the example that set off the recent patches:

https://lkml.org/lkml/2020/7/27/199

Another example is commit 5ff223e86f5a ("net: Zeroing the structure
ethtool_wolinfo in ethtool_get_wol()").  I tested this one with GCC 7.4
at the time and it was a real life bug.

The rest of these patches were based on static analysis from Smatch.
They're all "theoretical" bugs based on the C standard but it's
impossible to know if and when they'll turn into real life bugs.

It's not a super long list of code that's affected because we've known
that the bug was possible for a few years.  It was only last year when
I saw that it had become a real life bug.

regards,
dan carpenter

