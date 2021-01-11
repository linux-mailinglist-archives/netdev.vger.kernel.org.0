Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E852F2084
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391336AbhAKUQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:16:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390481AbhAKUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:16:21 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BK2bZ5080532;
        Mon, 11 Jan 2021 15:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=g9b2r2ULiJX+NO4AAw0QW9M2S8qCs3YANR/7x5Y5uq4=;
 b=HZr+IRyqYL39FTEuBtr9g+Ki9xtWRJD0Yer9j/ZGS4+jLI1F5CfOYEO43DaZmBdoXxkC
 +louV9vquVSMYBZVESGizp1cgeUFKx493XaTN2oUhr13XgzbU/3YVXZELnP5eT2CixKe
 Flf5WASciA8gSKf2B9vX6v7ZD6EdmmbzEfjiYFw7Ax8AlOLqdWFBeKChmAwwJM/rwGsI
 cf+iNXbEvCI/wWlpoq/mzhSXSzZTYZyV2KgPJmKak6FEYISdr2J6Nb1LJkE18Ka0UmT2
 h993r2YVxNdN6lmUUZwkJ571NjzvLe4RYWXfEYz5dJFwdRJv4tGGKxtvjKcJP8QK1IQ8 tQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360t0gf51x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 15:15:39 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BK7u4Z024088;
        Mon, 11 Jan 2021 20:15:38 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 35y448wcbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 20:15:38 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BKFb4122282664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 20:15:37 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEFEC112065;
        Mon, 11 Jan 2021 20:15:37 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97952112062;
        Mon, 11 Jan 2021 20:15:37 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.154.19])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 20:15:37 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 855C32E2874; Mon, 11 Jan 2021 12:15:34 -0800 (PST)
Date:   Mon, 11 Jan 2021 12:15:34 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 5/7] ibmvnic: use a lock to serialize remove/reset
Message-ID: <20210111201534.GB178503@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
 <20210108071236.123769-6-sukadev@linux.ibm.com>
 <20210109194146.7c8ac5ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210111035225.GB165065@us.ibm.com>
 <20210111114309.6de6a281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111114309.6de6a281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Sun, 10 Jan 2021 19:52:25 -0800 Sukadev Bhattiprolu wrote:
> > Jakub Kicinski [kuba@kernel.org] wrote:
> > > On Thu,  7 Jan 2021 23:12:34 -0800 Sukadev Bhattiprolu wrote:  
> > > > Use a separate lock to serialze ibmvnic_reset() and ibmvnic_remove()
> > > > functions. ibmvnic_reset() schedules work for the worker thread and
> > > > ibmvnic_remove() flushes the work before removing the adapter. We
> > > > don't want any work to be scheduled once we start removing the
> > > > adapter (i.e after we have already flushed the work).  
> > > 
> > > Locking based on functions, not on data being accessed is questionable
> > > IMO. If you don't want work to be scheduled isn't it enough to have a
> > > bit / flag that you set to let other flows know not to schedule reset?  
> > 
> > Maybe I could improve the description, but the "data" being protected
> > is the work queue. Basically don't add to the work queue while/after
> > it is (being) flushed.
> > 
> > Existing code is checking for the VNIC_REMOVING state before scheduling
> > the work but without a lock. If state goes to REMOVING after we check,
> > we could schedule work after the flush?
> 
> I see, and you can't just use the state_lock because it has to be a
> spin_lock? If that's the case please just update the commit message 
> and comments to describe the data protected.

Yes, has to be spin lock. Will update description.

Thanks,

Sukadev
