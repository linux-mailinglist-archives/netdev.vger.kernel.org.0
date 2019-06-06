Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451E737415
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfFFM1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:27:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727961AbfFFM1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 08:27:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56CQuKm116057
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 08:27:32 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy13ndm4a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 08:27:32 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 6 Jun 2019 13:27:31 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 13:27:28 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56CRR8220840842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 12:27:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D9EBB206A;
        Thu,  6 Jun 2019 12:27:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0A31B205F;
        Thu,  6 Jun 2019 12:27:26 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.209.205])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 12:27:26 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id BE67916C5D9E; Thu,  6 Jun 2019 03:58:17 -0700 (PDT)
Date:   Thu, 6 Jun 2019 03:58:17 -0700
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
 <20190606060511.GA28207@linux.ibm.com>
 <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
 <20190606090619.GC28207@linux.ibm.com>
 <20190606092855.dfeuvyk5lbvm4zbf@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606092855.dfeuvyk5lbvm4zbf@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060612-2213-0000-0000-0000039AFC7C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011223; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214047; UDB=6.00638142; IPR=6.00995126;
 MB=3.00027206; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 12:27:31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060612-2214-0000-0000-00005EBDB038
Message-Id: <20190606105817.GE28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=957 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 05:28:55PM +0800, Herbert Xu wrote:
> On Thu, Jun 06, 2019 at 02:06:19AM -0700, Paul E. McKenney wrote:
> >
> > Or is your point instead that given the initial value of "a" being
> > zero and the value stored to "a" being one, there is no way that
> > any possible load and store tearing (your slicing and dicing) could
> > possibly mess up the test of the value loaded from "a"?
> 
> Exactly.  If you can dream up of a scenario where the compiler can
> get this wrong I'm all ears.

I believe that this is safe in practice, as long as you exercise
constant vigilance.  (OK, OK, I might be overdramatizing...)

I cannot immediately think of a way that the compiler could get this
wrong even in theory, but similar code sequences can be messed up.
The reason for this is that in theory, the compiler could use the
stored-to location as temporary storage, like this:

	a = whatever;	// Compiler uses "a" as a temporary
	do_something();
	whatever = a;
	a = 1;		// Intended store

The compiler is allowed to do this (again, in theory and according to a
strict interpretation of the standard) because you haven't told it that
anything else is paying attention to variable "a".  As a result, the
compiler is within its rights to use "a" as temporary storage immediately
prior to any plain C-language store to "a".  

In practice, I don't know of any compilers that actually do this, nor
have I heard anyone suggesting that they might soon actually do this.

And even if they could, your example would still work because your example
doesn't care about anything other than zero and non-zero, so wouldn't
get confused by the compiler storing a temporary value of 42 or whatever.

> > > But I do concede that in the general RCU case you must have the
> > > READ_ONCE/WRITE_ONCE calls for rcu_dereference/rcu_assign_pointer.
> > 
> > OK, good that we are in agreement on this part, at least!  ;-)
> 
> Well only because we're allowing crazy compilers that can turn
> a simple word-aligned word assignment (a = b) into two stores.

In my experience, the insanity of compilers increases with time,
but yes.

							Thanx, Paul

