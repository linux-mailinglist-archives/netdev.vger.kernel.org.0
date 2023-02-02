Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993F46877EE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjBBIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBBIxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D8477522
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675327943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPaVjyoJuKENDwrdqNad/mRuPE82XGCumCLGtU8F6T4=;
        b=KPsMAy9NTqd8cu8jGIGJDlX+8iuD2VVdIo+I+WEUp9VFtiUkG82802nwk/2vSmLflfiyTa
        FLL8lgP1L4v+h2VjcAsCJqZf62cXL+m7N5S3IlbY+qKPv3v8tUo9y9Gg8UsD53eQfvsp02
        NtfH8Rdr/2pwXjbVlhzYIZgpR47s++o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-gtgcvS6pN1mxe0nsIXIGpA-1; Thu, 02 Feb 2023 03:52:18 -0500
X-MC-Unique: gtgcvS6pN1mxe0nsIXIGpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B8CB3C02584;
        Thu,  2 Feb 2023 08:52:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615FF140EBF6;
        Thu,  2 Feb 2023 08:52:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000b0b3c005f3a09383@google.com>
References: <000000000000b0b3c005f3a09383@google.com>
To:     jhubbard@nvidia.com, David Hildenbrand <david@redhat.com>
Cc:     syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>,
        dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        hch@lst.de, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <822862.1675327935.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 02 Feb 2023 08:52:15 +0000
Message-ID: <822863.1675327935@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John, David,

Could you have a look at this?

> syzbot found the following issue on:
> =

> HEAD commit:    80bd9028feca Add linux-next specific files for 20230131
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1468e3694800=
00
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D904dc2f450ea=
ad4a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Da440341a59e3b7=
142895
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binut=
ils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12c5d2be48=
0000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11259a794800=
00
> ...
> The issue was bisected to:
> =

> commit 920756a3306a35f1c08f25207d375885bef98975
> Author: David Howells <dhowells@redhat.com>
> Date:   Sat Jan 21 12:51:18 2023 +0000
> =

>     block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages
> =

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D170384f94=
80000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D148384f94=
80000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D108384f94800=
00
> ...
> general protection fault, probably for non-canonical address 0xdffffc000=
0000001: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 2838 Comm: kworker/u4:6 Not tainted 6.2.0-rc6-next-20230131-=
syzkaller-09515-g80bd9028feca #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/12/2023
> Workqueue: phy4 ieee80211_iface_work
> RIP: 0010:__skb_unlink include/linux/skbuff.h:2321 [inline]
> RIP: 0010:__skb_dequeue include/linux/skbuff.h:2337 [inline]
> RIP: 0010:skb_dequeue+0xf5/0x180 net/core/skbuff.c:3511

I don't think this is specifically related to anything networking.  I've r=
un
it a few times and weird stuff happens in various places.  I'm wondering i=
f
it's related to FOLL_PIN in some way.

The syzbot test in question does the following:

   #{"repeat":true,"procs":1,"slowdown":1,"sandbox":"none","sandbox_arg":0=
,"netdev":true,"cgroups":true,"close_fds":true,"usb":true,"wifi":true,"sys=
ctl":true,"tmpdir":true}
   socket(0x0, 0x2, 0x0)
   epoll_create(0x7)
   r0 =3D creat(&(0x7f0000000040)=3D'./bus\x00', 0x9)
   ftruncate(r0, 0x800)
   lseek(r0, 0x200, 0x2)
   r1 =3D open(&(0x7f0000000000)=3D'./bus\x00', 0x24000, 0x0)  <-- O_DIREC=
T
   sendfile(r0, r1, 0x0, 0x1dd00)

Basically a DIO splice from a file to itself.

I've hand-written my own much simpler tester (see attached).  You need to =
run
at least two copies in parallel, I think, to trigger the bug.  It's possib=
le
truncate is interfering somehow.

David
---
#define _GNU_SOURCE =

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/sendfile.h>
#include <sys/wait.h>

#define file_size 0x800
#define send_size 0x1dd00
#define repeat_count 1000

int main(int argc, char *argv[])
{
	int in, out, i, wt;

	if (argc !=3D 2 || !argv[1][0]) {
		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
		exit(2);
	}

	for (i =3D 0; i < repeat_count; i++) {
		switch (fork()) {
		case -1:
			perror("fork");
			exit(1);
		case 0:
			out =3D creat(argv[1], 0666);
			if (out < 0) {
				perror(argv[1]);
				exit(1);
			}

			if (ftruncate(out, file_size) < 0) {
				perror("ftruncate");
				exit(1);
			}

			if (lseek(out, file_size, SEEK_SET) < 0) {
				perror("lseek");
				exit(1);
			}

			in =3D open(argv[1], O_RDONLY | O_DIRECT | O_NOFOLLOW);
			if (in < 0) {
				perror("open");
				exit(1);
			}

			if (sendfile(out, in, NULL, send_size) < 0) {
				perror("sendfile");
				exit(1);
			}
			exit(0);

		default:
			if (wait(&wt) < 0) {
				perror("wait");
				exit(1);
			}
			break;
		}
	}

	exit(0);
}

