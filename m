Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B035427C0
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiFHHWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiFHGsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:48:51 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F03F1CC638;
        Tue,  7 Jun 2022 23:48:47 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2586mMmW007615;
        Wed, 8 Jun 2022 08:48:22 +0200
Date:   Wed, 8 Jun 2022 08:48:22 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        fengwei.yin@intel.com
Subject: Re: [tcp]  e926147618:  stress-ng.icmp-flood.ops_per_sec -8.7%
 regression
Message-ID: <20220608064822.GC7547@1wt.eu>
References: <20220608060802.GA22428@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608060802.GA22428@xsang-OptiPlex-9020>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 02:08:02PM +0800, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed a -8.7% regression of stress-ng.icmp-flood.ops_per_sec due to commit:
> 
> 
> commit: e9261476184be1abd486c9434164b2acbe0ed6c2 ("tcp: dynamically allocate the perturb table used by source ports")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> in testcase: stress-ng
> on test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz with 128G memory
> with following parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	class: network
> 	test: icmp-flood
> 	cpufreq_governor: performance
> 	ucode: 0xd000331
> 
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> To reproduce:
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         sudo bin/lkp install job.yaml           # job file is attached in this email
>         bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
>         sudo bin/lkp run generated-yaml-file
> 
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
> 
> =========================================================================================
> class/compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime/ucode:
>   network/gcc-11/performance/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/lkp-icl-2sp6/icmp-flood/stress-ng/60s/0xd000331
> 
> commit: 
>   ca7af04025 ("tcp: add small random increments to the source port")
>   e926147618 ("tcp: dynamically allocate the perturb table used by source ports")
> 
> ca7af0402550f9a0 e9261476184be1abd486c943416 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>  5.847e+08            -8.7%  5.337e+08        stress-ng.icmp-flood.ops
>    9745088            -8.7%    8894785        stress-ng.icmp-flood.ops_per_sec
(...)

I don't know much what to think about it, to be honest. We anticipated
a possible very tiny slowdown by moving the table from static to dynamic,
though that was not observed at all during extensive tests on real
hardware. But it was not acceptable to keep too large a table as static
anyway.

>     102391 ±  2%      -8.1%      94064        stress-ng.time.involuntary_context_switches
>       3069 ±  2%      -9.6%       2775 ±  4%  stress-ng.time.percent_of_cpu_this_job_got
>       1857 ±  2%      -9.3%       1685 ±  4%  stress-ng.time.system_time
>      47.67 ±  4%     -20.9%      37.70 ±  5%  stress-ng.time.user_time

Not sure what to think about these variations, nor how they may be related.

Thanks,
Willy
