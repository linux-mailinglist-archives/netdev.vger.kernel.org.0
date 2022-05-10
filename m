Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8685209DD
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiEJASQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiEJASN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:18:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87FF5262643
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652141657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m/Cpn4znmGtPMU6JmBbESD0qm5X4CWqOjWVCzDX837U=;
        b=JfNK5CKgOMKbSJHpenud6wL2ykoIVFZ5rWlfOt8HLII66gsRfSUz9213fXIvXhl8rKUcHS
        irLrV8lZteSg6z2KGnwFAski4wAlVz5O22vitOhLT+Qh6Rurb98izhoTij5N6mNW9+QmDY
        vxgJ9VxEcsvw7Es1sONPUbbNgyFFq/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-VeKmZPTnMrGw1e9T0pqueA-1; Mon, 09 May 2022 20:14:13 -0400
X-MC-Unique: VeKmZPTnMrGw1e9T0pqueA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8FE9811E80;
        Tue, 10 May 2022 00:14:12 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD07840D1B9A;
        Tue, 10 May 2022 00:14:03 +0000 (UTC)
Date:   Tue, 10 May 2022 08:13:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [syzbot] KASAN: use-after-free Read in bio_poll
Message-ID: <YnmuRuO4yplt8p/p@T590>
References: <00000000000029572505de968021@google.com>
 <a72282ef-650c-143b-4b88-5185009c3ec2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a72282ef-650c-143b-4b88-5185009c3ec2@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 11:02:41AM -0600, Jens Axboe wrote:
> On 5/9/22 10:14 AM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c5eb0a61238d Linux 5.18-rc6
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=112bf03ef00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=79caa0035f59d385
> > dashboard link: https://syzkaller.appspot.com/bug?extid=99938118dfd9e1b0741a
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12311571f00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177a2e86f00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in bio_poll+0x275/0x3c0 block/blk-core.c:942
> > Read of size 4 at addr ffff8880751d92b4 by task syz-executor486/3607
> > 
> > CPU: 0 PID: 3607 Comm: syz-executor486 Not tainted 5.18.0-rc6-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
> >  print_report mm/kasan/report.c:429 [inline]
> >  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
> >  bio_poll+0x275/0x3c0 block/blk-core.c:942
> >  __iomap_dio_rw+0x10ee/0x1ae0 fs/iomap/direct-io.c:658
> >  iomap_dio_rw+0x38/0x90 fs/iomap/direct-io.c:681
> >  ext4_dio_write_iter fs/ext4/file.c:566 [inline]
> >  ext4_file_write_iter+0xe4d/0x1510 fs/ext4/file.c:677
> >  call_write_iter include/linux/fs.h:2050 [inline]
> >  do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
> >  do_iter_write+0x182/0x700 fs/read_write.c:852
> >  vfs_writev+0x1aa/0x630 fs/read_write.c:925
> >  do_pwritev+0x1b6/0x270 fs/read_write.c:1022
> >  __do_sys_pwritev2 fs/read_write.c:1081 [inline]
> >  __se_sys_pwritev2 fs/read_write.c:1072 [inline]
> >  __x64_sys_pwritev2+0xeb/0x150 fs/read_write.c:1072
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7f6846af7e69
> 
> Guys, should we just queue:
> 
> ommit 9650b453a3d4b1b8ed4ea8bcb9b40109608d1faf
> Author: Ming Lei <ming.lei@redhat.com>
> Date:   Wed Apr 20 22:31:10 2022 +0800
> 
>     block: ignore RWF_HIPRI hint for sync dio
> 
> up for 5.18 and stable?

I am fine with merging to 5.18 & stable.


Thanks,
Ming

