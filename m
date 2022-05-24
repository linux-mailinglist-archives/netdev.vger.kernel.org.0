Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC70532A17
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiEXMME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiEXMMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:12:01 -0400
Received: from corp-front10-corp.i.nease.net (corp-front10-corp.i.nease.net [42.186.62.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C56747074;
        Tue, 24 May 2022 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=0LlBPM9QdYgYaS/Bo0svH8k7In3MeG2EXH
        PPS6sVHEc=; b=i0aW0TRajjz/UuxyPZTKyz5AKzArqo+Kt0eScHrF1BVgFqh30A
        m1QVzL8Xdx9mcXCpwug3WWHWgin9p2mhdkc2Yny2hoX2MDQnPTXfSIHRF2WFhaHW
        Y+DbXvrjmvXFboOX1ofanve7hZB17QBda+XMas9sdwnwbkemzZrjDJtV8=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front10-corp.i.nease.net (Coremail) with SMTP id aIG_CgCXCw9_y4xizrAhAA--.4401S2;
        Tue, 24 May 2022 20:11:43 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Date:   Tue, 24 May 2022 20:11:43 +0800
Message-Id: <20220524121143.635372-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <YozE8GrQEKMjjsI4@TonyMac-Alibaba>
References: <YozE8GrQEKMjjsI4@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aIG_CgCXCw9_y4xizrAhAA--.4401S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4ktF4DCF15ur43JF4fZrb_yoWrCrWDpr
        1aqF1UKFW8JryDXw1ktw17CryrKFnxAFy5Wrn3Wr1rAF1293WUXr1UXrW2gry5Xr1Fgr42
        qw4DJ3Zayw1kAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUpIb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sFP3VYkVW5Jr1DJw4U
        KVWUGwAawVCFI7vE04vSzxk24VAqrcv_Gr1UXr18M2vj6xkI62vS6c8GOVWUtr1rJFyle2
        I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIE
        c7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMx02cVAKzwCY0x0Ix7I2Y4AK64vIr41l42
        xK82IYc2Ij64vIr41l4x8a64kIII0Yj41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY624l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
        Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
        yTuYvjTRMuWlUUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAQCVt761lFGAABsS
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > >> This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
> > > >> is called. But nevertheless, it is a problem.
> > > >>
> > > >> Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
> > > >> processing. This change also conflicts with a patch that is already on net-next (3aba1030).
> > > > 
> > > > Do you mean put the ref to smc->sk during all fallback processing unconditionally and remove 
> > > > the fallback branch sock_put() in __smc_release()?
> > > 
> > > What I had in mind was to eventually call sock_put() in __smc_release() even if sk->sk_state == SMC_INIT
> > > (currently the extra check in the if() for sk->sk_state != SMC_INIT prevents the sock_put()), but only
> > > when it is sure that we actually reached the sock_hold() in smc_connect() before.
> > > 
> > > But maybe we find out that the sock_hold() is not needed for fallback sockets, I don't know...
> > 
> > I do think the sock_hold()/sock_put() for smc->sk is a bit complicated, Emm, I'm not sure if it 
> > can be simplified..
> > 
> > In fact, I'm sure there must be another ref count issue in my environment,but I haven't caught it yet.
> 
> I am wondering the issue of this ref count. If it is convenient, would
> you like to provide some more details?
> 
> syzkaller has reported some issues about ref count, but syzkaller and
> others' bot don't have RDMA devices, they cannot cover most of the code
> routines in SMC. We are working on it to provide SMC fuzz test with RDMA
> environment. So it's very nice to have real world issues.
> 
> Thanks,
> Tony Lu

I have encountered two types of problems. However, I cannot reproduce it stably.

case 1. After closing the app (>> TIME_WAIT), 'lsmod' shows that the smc module ref count is still greater than 0.
case 2 [rare]. 'lsmod' shows smc module ref count is less than 0.

Some clues of case 2 are as follows:

kernel: [67166.688386] ------------[ cut here ]------------
  kernel: [67166.693658] cache_from_obj: Wrong slab cache. SMC but object is from SMC
  kernel: [67166.701136] WARNING: CPU: 47 PID: 176961 at mm/slab.h:469 kmem_cache_free+0x329/0x410
  ......
  kernel: [67166.846819] CPU: 47 PID: 176961 Comm: redis-server Kdump: loaded Tainted: G  R B      OE     5.10.0-0.bpo.9-amd64 #1 Debian 5.10.70-1~bpo10+1
  kernel: [67166.860915] Hardware name: Inspur SA5280M6/SA5280M6, BIOS 06.00.01 10/09/2021
  kernel: [67166.868747] RIP: 0010:kmem_cache_free+0x329/0x410
  kernel: [67166.874168] Code: ff 0f 0b 48 8d b8 f0 9d 02 00 e9 e4 fe ff ff 48 8b 57 60 49 8b 4f 60 48 c7 c6 30 86 63 a4 48 c7 c7 f8 e6 8f a4 e8 89 63 5c 00 <0f> 0b 48 89 de 4c
89 ff e8 1a ad ff ff 48 8b 0d 63 34 ef 00 e9 49
  kernel: [67166.894360] RSP: 0018:ffffbd450f527e18 EFLAGS: 00010286
  kernel: [67166.900306] RAX: 0000000000000000 RBX: ffffa00fa4548d00 RCX: 0000000000000000
  kernel: [67166.908169] RDX: ffffa04c7f7e8760 RSI: ffffa04c7f7d8a00 RDI: ffffa04c7f7d8a00
  kernel: [67166.916027] RBP: ffffa01024548d00 R08: 0000000000000000 R09: c0000000ffffbfff
  kernel: [67166.923860] R10: 0000000000000001 R11: ffffbd450f527c20 R12: 0000000000000000
  kernel: [67166.931713] R13: 0000000000000000 R14: ffffa00fa4548f28 R15: ffffa02d3366bf00
  kernel: [67166.939564] FS:  00007fe131c80f40(0000) GS:ffffa04c7f7c0000(0000) knlGS:0000000000000000
  kernel: [67166.948361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  kernel: [67166.954817] CR2: 00007fe12f477000 CR3: 00000004874be003 CR4: 0000000000770ee0
  kernel: [67166.962662] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  kernel: [67166.970498] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  kernel: [67166.978306] PKRU: 55555554
  kernel: [67166.981695] Call Trace:
  kernel: [67166.985017]  __sk_destruct+0x12c/0x1e0
  kernel: [67166.989449]  smc_release+0x19a/0x230 [smc]
  kernel: [67166.994325]  __sock_release+0x3d/0xa0
  kernel: [67166.998656]  sock_close+0x11/0x20
  kernel: [67167.002637]  __fput+0x93/0x240
  kernel: [67167.006347]  task_work_run+0x76/0xb0
  kernel: [67167.010569]  exit_to_user_mode_prepare+0x129/0x130
  kernel: [67167.016000]  syscall_exit_to_user_mode+0x28/0x140
  kernel: [67167.021339]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

