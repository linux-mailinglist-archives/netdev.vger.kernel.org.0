Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE8B57484
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFZWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:47:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33891 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726354AbfFZWrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 18:47:39 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5QMl9xf027338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 18:47:10 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9C2EC42002E; Wed, 26 Jun 2019 18:47:09 -0400 (EDT)
Date:   Wed, 26 Jun 2019 18:47:09 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190626224709.GH3116@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, davem@davemloft.net, eladr@mellanox.com,
        idosch@mellanox.com, jiri@mellanox.com, john.stultz@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <000000000000d3f34b058c3d5a4f@google.com>
 <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626210351.GF3116@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More details about what is going on.  First, it requires root, because
one of that is required is using sched_setattr (which is enough to
shoot yourself in the foot):

sched_setattr(0, {size=0, sched_policy=0x6 /* SCHED_??? */, sched_flags=0, sched_nice=0, sched_priority=0, sched_runtime=2251799813724439, sched_deadline=4611686018427453437, sched_period=0}, 0) = 0

This is setting the scheduler policy to be SCHED_DEADLINE, with a
runtime parameter of 2251799.813724439 seconds (or 26 days) and a
deadline of 4611686018.427453437 seconds (or 146 *years*).  This means
a particular kernel thread can run for up to 26 **days** before it is
scheduled away, and if a kernel reads gets woken up or sent a signal,
no worries, it will wake up roughly seven times the interval that Rip
Van Winkle spent snoozing in a cave in the Catskill Mountains (in
Washington Irving's short story).

We then kick off a half-dozen threads all running:

   sendfile(fd, fd, &pos, 0x8080fffffffe);

(and since count is a ridiculously large number, this gets cut down to):

   sendfile(fd, fd, &pos, 2147479552);

Is it any wonder that we are seeing RCU stalls?   :-)

      	  	      	     	    - Ted
