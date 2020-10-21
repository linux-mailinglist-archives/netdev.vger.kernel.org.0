Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF1A29518A
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503523AbgJURan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:30:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39170 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438020AbgJUR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 13:29:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LHOt0x156367;
        Wed, 21 Oct 2020 17:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=muK+U1fy4dBwslTM9OeVZaRGpOw/htGPwrUhs0+HCLc=;
 b=ObVV3nOo6oKZlk+uYw8e8ohDZliV43Vd+4KBEhlw1PUlsiMV11nMGY2mqJVvNvEpBsxS
 4O6mTXHX5Br+XA55Pylw91CdC7VsENXiU9IhaNhwWMZL4MjSJCZN08/f7BwPR+RzQ/V8
 VRYGtnxd6z26CT5xgUvTGfm555AsfZh/QmLkInrXmyL13TYLb9xqCAbra7VousSrBpwa
 Mmpo/FRNIwTgsvnqdIwoaUwFhd4KpYXsb9zsbZyHvyaRkkNUAbQ3nM1TUqIrCklGnskg
 94jStKwYCkIGNiKU4fFrulRuVKjDv2Oc2B4em7Qk4Tz1KlHq3wjGWenssGm5cAJ/W8lm ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4b1wwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 17:29:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LHOxqp091169;
        Wed, 21 Oct 2020 17:29:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 348ahxu9e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 17:29:21 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09LHTExc019855;
        Wed, 21 Oct 2020 17:29:17 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 10:29:14 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] SUNRPC: fix copying of multiple pages in
 gss_read_proxy_verf()
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <8ed0fa80-cc75-88ec-6b17-3f9cc300e9bb@prodrive-technologies.com>
Date:   Wed, 21 Oct 2020 13:29:12 -0400
Cc:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Neil Brown <neilb@suse.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9B2DD62-E16C-4781-9EFD-FD8661642E24@oracle.com>
References: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
 <20201019152301.GC32403@fieldses.org>
 <834dc52b-34fc-fee5-0274-fdc8932040e6@prodrive-technologies.com>
 <20201019220439.GC6692@fieldses.org>
 <8ed0fa80-cc75-88ec-6b17-3f9cc300e9bb@prodrive-technologies.com>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 20, 2020, at 3:16 AM, Martijn de Gouw =
<martijn.de.gouw@prodrive-technologies.com> wrote:
>=20
> Hi,
>=20
> On 20-10-2020 00:04, J. Bruce Fields wrote:
>> On Mon, Oct 19, 2020 at 03:46:39PM +0000, Martijn de Gouw wrote:
>>> Hi
>>>=20
>>> On 19-10-2020 17:23, J. Bruce Fields wrote:
>>>> On Mon, Oct 19, 2020 at 01:42:27PM +0200, Martijn de Gouw wrote:
>>>>> When the passed token is longer than 4032 bytes, the remaining =
part
>>>>> of the token must be copied from the rqstp->rq_arg.pages. But the
>>>>> copy must make sure it happens in a consecutive way.
>>>>=20
>>>> Thanks.  Apologies, but I don't immediately see where the copy is
>>>> non-consecutive.  What exactly is the bug in the existing code?
>>>=20
>>> In the first memcpy 'length' bytes are copied from argv->iobase, but
>>> since the header is in front, this never fills the whole first page =
of
>>> in_token->pages.
>>>=20
>>> The memcpy in the loop copies the following bytes, but starts =
writing at
>>> the next page of in_token->pages. This leaves the last bytes of page =
0
>>> unwritten.
>>>=20
>>> Next to that, the remaining data is in page 0 of =
rqstp->rq_arg.pages,
>>> not page 1.
>>=20
>> Got it, thanks.  Looks like the culprit might be a patch from a year =
ago
>> from Chuck, 5866efa8cbfb "SUNRPC: Fix svcauth_gss_proxy_init()"?  At
>> least, that's the last major patch to touch this code.

It's likely that we didn't have a test scenario at bake-a-thon that
presents large tokens, so that new tail copy logic was never properly
exercised.


> I found this issue when setting up NFSv4 with Active Directory as KDC=20=

> and gssproxy. Users with many groups where not able to access the NFS=20=

> shares, while others could access them just fine. During debugging I=20=

> found that the token was not the same on both sides.
>=20
> I do not have the HW to setup a rdma version of NFSv4, so I'm unable =
to=20
> test if it still works via rdma.

You don't need special HW to get NFS/RDMA with Linux working, though.
Linux now has soft iWARP, and NFS/RDMA works fine with that.

As stated in the patch description for commit 5866efa8cbfb, the original
issue won't appear with Linux clients, because they use TCP to handle
the ACCEPT_SEC_CONTEXT handshake. You'd need to have both Solaris and
RDMA to test it. Maybe we can scrounge something up, but that would only
be enough to ensure that your patch doesn't regress the Solaris NFS/RDMA
with Kerberos setup when using small tokens.


--
Chuck Lever



