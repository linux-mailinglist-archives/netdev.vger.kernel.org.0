Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AC43E4D7B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhHIT7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:59:45 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:58706 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhHIT7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:59:44 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDBOU-009LTu-ST; Mon, 09 Aug 2021 19:57:06 +0000
Date:   Mon, 9 Aug 2021 19:57:06 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
Message-ID: <YRGIkv/dw+Bfq7BK@zeniv-ca.linux.org.uk>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 12:16:27PM -0700, Shoaib Rao wrote:
> 
> On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
> > On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
> > > This seems like a false positive. 1) The function will not sleep because
> > > it only calls copy routine if the byte is present. 2). There is no
> > > difference between this new call and the older calls in
> > > unix_stream_read_generic().
> > Hi Shoaib,
> > 
> > Thanks for looking into this.
> > Do you have any ideas on how to fix this tool's false positive? Tools
> > with false positives are order of magnitude less useful than tools w/o
> > false positives. E.g. do we turn it off on syzbot? But I don't
> > remember any other false positives from "sleeping function called from
> > invalid context" checker...
> 
> Before we take any action I would like to understand why the tool does not
> single out other calls to recv_actor in unix_stream_read_generic(). The
> context in all cases is the same. I also do not understand why the code
> would sleep, Let's assume the user provided address is bad, the code will
> return EFAULT, it will never sleep, if the kernel provided address is bad
> the system will panic. The only difference I see is that the new code holds
> 2 locks while the previous code held one lock, but the locks are acquired
> before the call to copy.
> 
> So please help me understand how the tool works. Even though I have
> evaluated the code carefully, there is always a possibility that the tool is
> correct.

Huh???

What do you mean "address is bad"?  "Address is inside an area mmapped from
NFS file".  And it bloody well will sleep on attempt to read the page.

You should never, ever do copy_{to,from}_user() or equivalents while holding
a spinlock, period.
