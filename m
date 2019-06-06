Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648E136C08
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 08:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFFGFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 02:05:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfFFGFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 02:05:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x565vKPf042386
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 02:05:17 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sxuhavfhk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:05:17 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 6 Jun 2019 07:05:15 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 07:05:12 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5665BTq20513192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 06:05:11 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECEC0B2068;
        Thu,  6 Jun 2019 06:05:10 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C47B4B206A;
        Thu,  6 Jun 2019 06:05:10 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.226.118])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 06:05:10 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 1841416C15CF; Wed,  5 Jun 2019 23:05:11 -0700 (PDT)
Date:   Wed, 5 Jun 2019 23:05:11 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060606-0060-0000-0000-0000034CD5B4
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011222; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01213919; UDB=6.00638066; IPR=6.00994998;
 MB=3.00027202; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 06:05:15
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060606-0061-0000-0000-000049A75F2D
Message-Id: <20190606060511.GA28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060045
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 12:51:09PM +0800, Herbert Xu wrote:
> On Tue, Jun 04, 2019 at 10:44:18AM -0400, Alan Stern wrote:
> >
> > Currently the LKMM says the test is allowed and there is a data race, 
> > but this answer clearly is wrong since it would violate the RCU 
> > guarantee.
> 
> Thank you! This is what I tried to say all along in this thread
> but you expressed it in a much better way :)

In case you were wondering, the reason that I was giving you such
a hard time was that from what I could see, you were pushing for no
{READ,WRITE}_ONCE() at all.  ;-)

							Thanx, Paul

