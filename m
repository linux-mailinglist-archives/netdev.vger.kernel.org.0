Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3F12FAB5
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgACQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:43:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgACQnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:43:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Gd9E5090064;
        Fri, 3 Jan 2020 16:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=m+v9tMiblOBlW7pvNddDYBEyRS7hXPsHeQ7lhPIlhK4=;
 b=N2M+sW4AV7HhzUpE9tQNc5TyoUmycUgORH4+Ib77PjfUUX7wFgMHUxzJ25RYTntRjaX9
 bdubWSrrVEmm0SK5vCS2OdQzsZucrELHetnhsl99Hm1cI+eBSCZl2t28VxRRZI2uNt1x
 qwJic12L9iYuDClDeWoa05XBO5G5NKWEBOdbNaaa5MZSpNmzkfASVn1MEVnuVAJUAUQS
 8YR16WNLKGarXenXY7gTHPy/Lvx4u08YqPdNOOYO/Fk8UbWv6B/GtmtnuwPDcp6UOF4S
 olA/OHVaWXSX5MewqF/gawtQf5ZkrE+H9vbyq+ijzNa62+qHBAikceY+VCdwqfXmpw0+ Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqw667-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:43:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003Gc78Y120391;
        Fri, 3 Jan 2020 16:43:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x9jm7ng5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:43:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003Gh4nY031267;
        Fri, 3 Jan 2020 16:43:04 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 08:43:03 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200103163606.GC9706@ziepe.ca>
Date:   Fri, 3 Jan 2020 18:42:59 +0200
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EFADA53B-CB84-44E2-922B-83C505D4AE8B@oracle.com>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
 <20200103133749.GA9706@ziepe.ca>
 <F7C45792-2F17-42AE-88A2-F744EEAD68A5@oracle.com>
 <20200103163606.GC9706@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3 Jan 2020, at 18:36, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Fri, Jan 03, 2020 at 06:31:18PM +0200, Liran Alon wrote:
>=20
>>> I am surprised that AMD is different here, the evolution of the WC
>>> feature on x86 was to transparently speed up graphics, so I'm pretty
>>> surprised AMD can get away with not ordering the same as Intel..
>>=20
>> Completely agree. I was very surprised to see this from AMD SDM and
>> Optimization Guide SDM.  It made sense to me too that graphics frame
>> buffer is written to WC memory and then is committed to GPU by
>> writing to some doorbell register mapped as UC memory.
>=20
> It is possible this manual is wrong or misleading?
>=20
> Having WC writes not strongly order after UC writes to the same
> device, on x86, seems very, very surprising to me. Everything is
> ordered on x86 :)
>=20
> Jason

I thought so the same at first. This is why I checked both AMD SDM and =
AMD Optimisation Guide
and made sure to quote relevant section this document. I will be glad to =
be corrected that=E2=80=99s solely
a mistake. But it seems very intentional and explicitly documented in =
multiple places.

Also note that WC memory is considered weakly-ordered in x86. E.g. =
non-temporal stores that
appear in program order after a previous store to WB memory, can =
complete before the store to
WB memory. In addition, a store to WC memory is considered complete once =
the stored data reach
the WC buffer, where it=E2=80=99s not globally visible. In contrast to =
stores to WB/UC memory that are globally
visible once they are complete (In contrast to retired).

But again, I agree this is very surprising and unexpected=E2=80=A6 To =
have a single arch have different caching
behaviour that needs to be considered based on CPU vendor...

-Liran

