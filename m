Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F365587D7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiFWSwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiFWSwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:52:21 -0400
Received: from out20-51.mail.aliyun.com (out20-51.mail.aliyun.com [115.124.20.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182D5FE017;
        Thu, 23 Jun 2022 10:57:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04520515|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.192979-0.00344398-0.803577;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.OBQTixF_1656006676;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.OBQTixF_1656006676)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 01:51:17 +0800
Date:   Fri, 24 Jun 2022 01:51:22 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
In-Reply-To: <0292A2FC-7725-47FC-8F08-CCB8500D8E1D@oracle.com>
References: <20220623170218.7874.409509F4@e16-tech.com> <0292A2FC-7725-47FC-8F08-CCB8500D8E1D@oracle.com>
Message-Id: <20220624015121.06F3.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > On Jun 23, 2022, at 5:02 AM, Wang Yugui <wangyugui@e16-tech.com> wrote:
> > 
> > Hi,
> > 
> >>> On Jun 22, 2022, at 3:04 PM, Chuck Lever III <chuck.lever@oracle.com> wrote:
> >>>> On Jun 22, 2022, at 2:36 PM, Wang Yugui <wangyugui@e16-tech.com> wrote:
> >>>> 
> >>>> Hi,
> >>>> 
> >>>> fstests generic/531 triggered a panic on kernel 5.19.0-rc3 with this
> >>>> patchset.
> >>> 
> >>> As I mention in the cover letter, I haven't tried running generic/531
> >>> yet -- no claim at all that this is finished work and that #386 has
> >>> been fixed at this point. I'm merely interested in comments on the
> >>> general approach.
> >>> 
> >>> 
> >>>> [ 405.478056] BUG: kernel NULL pointer dereference, address: 0000000000000049
> >>> 
> >>> The "RIP: " tells the location of the crash. Notice that the call
> >>> trace here does not include that information. From your attachment:
> >>> 
> >>> [ 405.518022] RIP: 0010:nfsd_do_file_acquire+0x4e1/0xb80 [nfsd]
> >>> 
> >>> To match that to a line of source code:
> >>> 
> >>> [cel@manet ~]$ cd src/linux/linux/
> >>> [cel@manet linux]$ scripts/faddr2line ../obj/manet/fs/nfsd/filecache.o nfsd_do_file_acquire+0x4e1
> >>> nfsd_do_file_acquire+0x4e1/0xfc0:
> >>> rht_bucket_insert at /home/cel/src/linux/linux/include/linux/rhashtable.h:303
> >>> (inlined by) __rhashtable_insert_fast at /home/cel/src/linux/linux/include/linux/rhashtable.h:718
> >>> (inlined by) rhashtable_lookup_get_insert_key at /home/cel/src/linux/linux/include/linux/rhashtable.h:982
> >>> (inlined by) nfsd_file_insert at /home/cel/src/linux/linux/fs/nfsd/filecache.c:1031
> >>> (inlined by) nfsd_do_file_acquire at /home/cel/src/linux/linux/fs/nfsd/filecache.c:1089
> >>> [cel@manet linux]$
> >>> 
> >>> This is an example, I'm sure my compiled objects don't match yours.
> >>> 
> >>> And, now that I've added observability, you should be able to do:
> >>> 
> >>> # watch cat /proc/fs/nfsd/filecache
> >>> 
> >>> to see how many items are in the hash and LRU list while the test
> >>> is running.
> >>> 
> >>> 
> >>>> [ 405.608016] Call Trace:
> >>>> [ 405.608016] <TASK>
> >>>> [ 405.613020] nfs4_get_vfs_file+0x325/0x410 [nfsd]
> >>>> [ 405.618018] nfsd4_process_open2+0x4ba/0x16d0 [nfsd]
> >>>> [ 405.623016] ? inode_get_bytes+0x38/0x40
> >>>> [ 405.623016] ? nfsd_permission+0x97/0xf0 [nfsd]
> >>>> [ 405.628022] ? fh_verify+0x1cc/0x6f0 [nfsd]
> >>>> [ 405.633025] nfsd4_open+0x640/0xb30 [nfsd]
> >>>> [ 405.638025] nfsd4_proc_compound+0x3bd/0x710 [nfsd]
> >>>> [ 405.643017] nfsd_dispatch+0x143/0x270 [nfsd]
> >>>> [ 405.648019] svc_process_common+0x3bf/0x5b0 [sunrpc]
> >> 
> >> I was able to trigger something that looks very much like this crash.
> >> If you remove this line from fs/nfsd/filecache.c:
> >> 
> >> 	.max_size		= 131072, /* buckets */
> >> 
> >> things get a lot more stable for generic/531.
> >> 
> >> I'm looking into the issue now.
> > 
> > Yes. When '.max_size = 131072' is removed, fstests generic/531 passed.
> 
> Great! Are you comfortable with this general approach for bug #386?

It seems a good result for #386.

fstests generic/531(file-max: 1M) performance result:
base(5.19.0-rc3, 12 bits hash, serialized nfsd_file_gc): 222s
this patchset(.min_size=4096): 59s
so, a good improvement for #386.

It seems a good(acceptable) result for #387 too.
the period of 'text busy(exec directly from the back-end of nfs-server)'
is about 4s.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/06/24


