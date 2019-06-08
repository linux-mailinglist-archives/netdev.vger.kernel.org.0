Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1203A077
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfFHPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:32:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbfFHPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:32:37 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x58FQlOJ042834
        for <netdev@vger.kernel.org>; Sat, 8 Jun 2019 11:32:36 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t09j59y91-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 11:32:36 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sat, 8 Jun 2019 16:32:34 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Jun 2019 16:32:30 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x58FWT7739125490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Jun 2019 15:32:29 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE3F2B2064;
        Sat,  8 Jun 2019 15:32:29 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCA16B2066;
        Sat,  8 Jun 2019 15:32:29 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.180.36])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  8 Jun 2019 15:32:29 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id E91A416C5D98; Sat,  8 Jun 2019 08:19:43 -0700 (PDT)
Date:   Sat, 8 Jun 2019 08:19:43 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20190606081657.GA4249@andrea>
 <Pine.LNX.4.44L0.1906061017200.1641-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1906061017200.1641-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060815-0052-0000-0000-000003CD34DB
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011234; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01215054; UDB=6.00638754; IPR=6.00996145;
 MB=3.00027235; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-08 15:32:34
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060815-0053-0000-0000-0000613D2590
Message-Id: <20190608151943.GD28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:19:43AM -0400, Alan Stern wrote:
> On Thu, 6 Jun 2019, Andrea Parri wrote:
> 
> > This seems a sensible change to me: looking forward to seeing a patch,
> > on top of -rcu/dev, for further review and testing!
> > 
> > We could also add (to LKMM) the barrier() for rcu_read_{lock,unlock}()
> > discussed in this thread (maybe once the RCU code and the informal doc
> > will have settled in such direction).
> 
> Yes.  Also for SRCU.  That point had not escaped me.

And it does seem pretty settled.  There are quite a few examples where
there are normal accesses at either end of the RCU read-side critical
sections, for example, the one in the requirements diffs below.

For SRCU, srcu_read_lock() and srcu_read_unlock() have implied compiler
barriers since 2006.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/Documentation/RCU/Design/Requirements/Requirements.html b/Documentation/RCU/Design/Requirements/Requirements.html
index 5a9238a2883c..080b39cc1dbb 100644
--- a/Documentation/RCU/Design/Requirements/Requirements.html
+++ b/Documentation/RCU/Design/Requirements/Requirements.html
@@ -2129,6 +2129,8 @@ Some of the relevant points of interest are as follows:
 <li>	<a href="#Hotplug CPU">Hotplug CPU</a>.
 <li>	<a href="#Scheduler and RCU">Scheduler and RCU</a>.
 <li>	<a href="#Tracing and RCU">Tracing and RCU</a>.
+<li>	<a href="#Accesses to User Mamory and RCU">
+Accesses to User Mamory and RCU</a>.
 <li>	<a href="#Energy Efficiency">Energy Efficiency</a>.
 <li>	<a href="#Scheduling-Clock Interrupts and RCU">
 	Scheduling-Clock Interrupts and RCU</a>.
@@ -2521,6 +2523,75 @@ cannot be used.
 The tracing folks both located the requirement and provided the
 needed fix, so this surprise requirement was relatively painless.
 
+<h3><a name="Accesses to User Mamory and RCU">
+Accesses to User Mamory and RCU</a></h3>
+
+<p>
+The kernel needs to access user-space memory, for example, to access
+data referenced by system-call parameters.
+The <tt>get_user()</tt> macro does this job.
+
+<p>
+However, user-space memory might well be paged out, which means
+that <tt>get_user()</tt> might well page-fault and thus block while
+waiting for the resulting I/O to complete.
+It would be a very bad thing for the compiler to reorder
+a <tt>get_user()</tt> invocation into an RCU read-side critical
+section.
+For example, suppose that the source code looked like this:
+
+<blockquote>
+<pre>
+ 1 rcu_read_lock();
+ 2 p = rcu_dereference(gp);
+ 3 v = p-&gt;value;
+ 4 rcu_read_unlock();
+ 5 get_user(user_v, user_p);
+ 6 do_something_with(v, user_v);
+</pre>
+</blockquote>
+
+<p>
+The compiler must not be permitted to transform this source code into
+the following:
+
+<blockquote>
+<pre>
+ 1 rcu_read_lock();
+ 2 p = rcu_dereference(gp);
+ 3 get_user(user_v, user_p); // BUG: POSSIBLE PAGE FAULT!!!
+ 4 v = p-&gt;value;
+ 5 rcu_read_unlock();
+ 6 do_something_with(v, user_v);
+</pre>
+</blockquote>
+
+<p>
+If the compiler did make this transformation in a
+<tt>CONFIG_PREEMPT=n</tt> kernel build, and if <tt>get_user()</tt> did
+page fault, the result would be a quiescent state in the middle
+of an RCU read-side critical section.
+This misplaced quiescent state could result in line&nbsp;4 being
+a use-after-free access, which could be bad for your kernel's
+actuarial statistics.
+Similar examples can be constructed with the call to <tt>get_user()</tt>
+preceding the <tt>rcu_read_lock()</tt>.
+
+<p>
+Unfortunately, <tt>get_user()</tt> doesn't have any particular
+ordering properties, and in some architectures the underlying <tt>asm</tt>
+isn't even marked <tt>volatile</tt>.
+And even if it was marked <tt>volatile</tt>, the above access to
+<tt>p-&gt;value</tt> is not volatile, so the compiler would not have any
+reason to keep those two accesses in order.
+
+<p>
+Therefore, the Linux-kernel definitions of <tt>rcu_read_lock()</tt>
+and <tt>rcu_read_unlock()</tt> must act as compiler barriers,
+at least for outermost instances of <tt>rcu_read_lock()</tt> and
+<tt>rcu_read_unlock()</tt> within a nested set of RCU read-side critical
+sections.
+
 <h3><a name="Energy Efficiency">Energy Efficiency</a></h3>
 
 <p>

