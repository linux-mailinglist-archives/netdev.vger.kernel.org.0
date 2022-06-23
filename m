Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD62556F58
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244112AbiFWAVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245440AbiFWAVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:21:39 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B14D341612;
        Wed, 22 Jun 2022 17:21:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 50A0B5ECBDE;
        Thu, 23 Jun 2022 10:21:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4AbE-009tg3-Hl; Thu, 23 Jun 2022 10:21:32 +1000
Date:   Thu, 23 Jun 2022 10:21:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Wang Yugui <wangyugui@e16-tech.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Message-ID: <20220623002132.GE1098723@dread.disaster.area>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <20220623023645.F914.409509F4@e16-tech.com>
 <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b3b210
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=rNkiPHGBACb3STtxGGMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 07:04:39PM +0000, Chuck Lever III wrote:
> > more detail in attachment file(531.dmesg)
> > 
> > local.config of fstests:
> > 	export NFS_MOUNT_OPTIONS="-o rw,relatime,vers=4.2,nconnect=8"
> > changes of generic/531
> > 	max_allowable_files=$(( 1 * 1024 * 1024 / $nr_cpus / 2 ))
> 
> Changed from:
> 
> 	max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))
> 
> For my own information, what's $nr_cpus in your test?
> 
> Aside from the max_allowable_files setting, can you tell how the
> test determines when it should stop creating files? Is it looking
> for a particular error code from open(2), for instance?
> 
> On my client:
> 
> [cel@morisot generic]$ cat /proc/sys/fs/file-max
> 9223372036854775807
> [cel@morisot generic]$

$ echo $((2**63 - 1))
9223372036854775807

i.e. LLONG_MAX, or "no limit is set".

> I wonder if it's realistic to expect an NFSv4 server to support
> that many open files. Is 9 quintillion files really something
> I'm going to have to engineer for, or is this just a crazy
> test?

The test does not use the value directly - it's a max value for
clamping:

max_files=$((50000 * LOAD_FACTOR))
max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))
test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
        max_files=$max_allowable_files
ulimit -n $max_files

i.e. the result should be

max_files = max(50000, max_allowable_files)

So the test should only be allowing 50,000 open unlinked files to be
created before unmounting. Which means there's lots of silly
renaming going on at the client and so the server is probably seeing
100,000 unique file handles across the test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
