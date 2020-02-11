Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F6F1599AA
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgBKTXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:23:35 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:38024 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbgBKTXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:23:34 -0500
Received: by mail-io1-f46.google.com with SMTP id s24so13091549iog.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 11:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=lT9xJ7SvN/dQd8seqFs4EtyAeHPxQPsBd/sPvJ0IIZ8=;
        b=j0s6RQVomPXFSzP83hhfAu8hg5Tur3hgjj0dfNEa9igprkqyK4F8NC1fmFsWVHpTq7
         UXjATsnGMfAtQePIcXrXLHfI6pJbgWYwJ+qsc6mc0dYbIXsGXlhiK0xAv3OnUya4rnZK
         8Rpp2dQ8Jxsouvdqk/+dz12d0lZiXeoFtl8cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=lT9xJ7SvN/dQd8seqFs4EtyAeHPxQPsBd/sPvJ0IIZ8=;
        b=kSj0pUaY2XaGgwZNd6VKFOw9p2amBhYHqZJEzieJ+Gmf3S+g7oWfZwdTwaEIdh79iw
         k+v5E5jv8vFHW62nFgh7gq3NXcU6WKfllbBiq9A45/gorqIbDV9jfrpp78PvxFCpj7vv
         bZXEXUMPF1dnV+6/EkePAx8SjH5fqQ8YUClzgJ3K6+8Bqsv5i5QusPopaAcgYEXwYx1L
         cmXiQVhYab7kEfB03itELBMBZYA3tT5eOaXfsHNnkc+rBf3kGR4gcj47Z+lEl1DUySPB
         ce63743KYcANvtjbY2eF6EaB0+StW0JoY60SXICB46ibGT0SOd6z9QhDIDzNvC0odayG
         qFGg==
X-Gm-Message-State: APjAAAVLxvSlCmDQ6s6OO8lksZkUJ0k67+KP/+++r1Iprwq/n4Kcjf5F
        eNjipm47p7cq0GnbHWtgize8a9E1osA=
X-Google-Smtp-Source: APXvYqzSsq4YmkTLAHh7ksPppgiLPQ9XjzbYKvsim7LItpteWZ6SaNrJXp6WMH0DSGUgFkaIUnI/7A==
X-Received: by 2002:a05:6602:241b:: with SMTP id s27mr15329487ioa.19.1581449013421;
        Tue, 11 Feb 2020 11:23:33 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id x10sm1243726ioh.11.2020.02.11.11.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Feb 2020 11:23:32 -0800 (PST)
Date:   Tue, 11 Feb 2020 19:23:31 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Gabriel Hartmann <ghartmann@netflix.com>,
        Rob Gulewich <rgulewich@netflix.com>,
        Bruce Curtis <brucec@netflix.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Deadlock in cleanup_net and addrconf_verify_work locks up workqueue
Message-ID: <20200211192330.GA9862@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've found a workqueue stall / deadlock. Our workload is a container-oriented
workload in which we utilize IPv6. Our container (namespace) churn is quite
frequent, and containers can be terminated before their networking is
even setup.

We're running 4.19.73 in production, and in investigation of the underlying
causes, I don't think that future versions of 4.19 fix it.

We've narrowed it down to a lockup between ipv6_addrconf, and cleanup_net.

crash> bt 8
PID: 8      TASK: ffff9a1072b50000  CPU: 24  COMMAND: "kworker/u192:0"
 #0 [ffffbfe2c00fbb70] __schedule at ffffffffa7f02bf7
 #1 [ffffbfe2c00fbc10] schedule at ffffffffa7f031e8
 #2 [ffffbfe2c00fbc18] schedule_timeout at ffffffffa7f0700e
 #3 [ffffbfe2c00fbc90] wait_for_completion at ffffffffa7f03b50
 #4 [ffffbfe2c00fbce0] __flush_work at ffffffffa76a2532
 #5 [ffffbfe2c00fbd58] rollback_registered_many at ffffffffa7dbcdf4
 #6 [ffffbfe2c00fbdc0] unregister_netdevice_many at ffffffffa7dbd31e
 #7 [ffffbfe2c00fbdd0] default_device_exit_batch at ffffffffa7dbd512
 #8 [ffffbfe2c00fbe40] cleanup_net at ffffffffa7dab970
 #9 [ffffbfe2c00fbe98] process_one_work at ffffffffa76a17c4
#10 [ffffbfe2c00fbed8] worker_thread at ffffffffa76a19dd
#11 [ffffbfe2c00fbf10] kthread at ffffffffa76a7fd3
#12 [ffffbfe2c00fbf50] ret_from_fork at ffffffffa80001ff

crash> bt 1369493
PID: 1369493  TASK: ffff9a03684d9600  CPU: 58  COMMAND: "kworker/58:1"
 #0 [ffffbfe30d68fd48] __schedule at ffffffffa7f02bf7
 #1 [ffffbfe30d68fde8] schedule at ffffffffa7f031e8
 #2 [ffffbfe30d68fdf0] schedule_preempt_disabled at ffffffffa7f0349a
 #3 [ffffbfe30d68fdf8] __mutex_lock at ffffffffa7f04aed
 #4 [ffffbfe30d68fe90] addrconf_verify_work at ffffffffa7e8d1aa
 #5 [ffffbfe30d68fe98] process_one_work at ffffffffa76a17c4
 #6 [ffffbfe30d68fed8] worker_thread at ffffffffa76a19dd
 #7 [ffffbfe30d68ff10] kthread at ffffffffa76a7fd3
 #8 [ffffbfe30d68ff50] ret_from_fork at ffffffffa80001ff



 struct -x mutex.owner.counter rtnl_mutex
  owner.counter = 0xffff9a1072b50001

0xffff9a1072b50001 & (~0x07) = 0xffff9a1072b50000

This points back to PID 8 / CPU 24. It is working on cleanup_net, and a part
of cleanup net involves calling ops_exit_list, and as part of that it calls
default_device_exit_batch. default_device_exit_batch takes the rtnl lock before
calling into unregister_netdevice_many, and rollback_registered_many.
rollback_registered_many calls flush_all_backlogs. This will never complete
because it is holding the rtnl lock, and PID 1369493 / CPU 58 is waiting
for rtnl_lock.

If relevant, the workqueue stalls themselves look something like:
BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=0 stuck for 3720s!
BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=-20 stuck for 3719s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x0
  pwq 32: cpus=16 node=0 flags=0x0 nice=0 active=2/256
    in-flight: 1274779:slab_caches_to_rcu_destroy_workfn slab_caches_to_rcu_destroy_workfn
workqueue events_highpri: flags=0x10
  pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
    pending: flush_backlog BAR(8)
workqueue events_power_efficient: flags=0x82
  pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
    in-flight: 1396446:check_lifetime
workqueue mm_percpu_wq: flags=0x8
  pwq 140: cpus=70 node=0 flags=0x0 nice=0 active=1/256
    pending: vmstat_update
workqueue netns: flags=0xe000a
  pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
    in-flight: 8:cleanup_net
    delayed: cleanup_net
workqueue writeback: flags=0x4e
  pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
    in-flight: 1334335:wb_workfn
workqueue kblockd: flags=0x18
  pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
    pending: blk_mq_run_work_fn
workqueue ipv6_addrconf: flags=0x40008
  pwq 116: cpus=58 node=0 flags=0x0 nice=0 active=1/1
    in-flight: 1369493:addrconf_verify_work
workqueue ena: flags=0xe000a
  pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
    in-flight: 7505:ena_fw_reset_device [ena]
