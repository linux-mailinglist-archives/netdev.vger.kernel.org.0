Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5B63C71D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiK2SXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiK2SXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:23:40 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A05FBA3;
        Tue, 29 Nov 2022 10:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=5ZSzUkPwSZlE7lwVIYK/zlxt6BpFN/kJRekUXyW8GJk=; b=VbJ+rXDlSrYHfgeC2Iew3PURBK
        big7AR0VqNOdMaZFqdekRc1hj8yZDPfKUV3Bgyfh459GvTU75BOsFViXpq++WtktoynNnhRJWkuEr
        xOnagvByYPCoCccB+zEcQiu+sH08VgdDYeI5ASOnTqwNwJWIeqEfj0sJM16aQDBjlQzhrxcwg7z/r
        t9gvX8sk7tbrIhKZa2hXc3qznZFSydt1FXtLLx012BVpZJVjMPyGn1A/w7ltbaVcqY5cFZGH48BLr
        Tsut2PsSYQ9uP1b144SzAoxU2QJGqQoAx5+xXoSQZO22gXe5qw69H0VvFTwaEq27Ve8IZy0TtC0dT
        rTN2Kp9+PhhMDVlKx6F28pbidKBIBTilA2HhLhh9x3A2Qe/Y/8zGob782F0tHNBPX+JA5Iy2qxiNt
        a3vYZrxgjSpGOxz7uNV+M3nIlgxHqtJdCRotI6zTkGgR2593+9afngf/qUhzXE+Qym9s5UW7Mv6Wm
        mwbI8FCuq8cp7tZJErIv+LQAnJk5tewABZYhUa7qpj+cNdcScG9ltGjJvLfAvtiwBRJv0RPY5lW2x
        GVpmU9tLuHKZCR1vgi7e7W71IKF809i1hCoWoGTKzDyod4WWY4VH/zJdqRkOxVrPeMoYo5d4ZzlMl
        KOnfagswQd05C7hznra6z0VDHn1kAxtvmR9M9P/1U=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Schspa Shi <schspa@gmail.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Tue, 29 Nov 2022 19:23:19 +0100
Message-ID: <4282856.sKfH6co6qd@silver>
In-Reply-To: <m2r0xlu3l9.fsf@gmail.com>
References: <20221129162251.90790-1-schspa@gmail.com> <m2r0xlu3l9.fsf@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, November 29, 2022 5:26:46 PM CET Schspa Shi wrote:
> 
> Schspa Shi <schspa@gmail.com> writes:
> 
> > The transport layer of fs does not fully support the cancel request.
> > When the request is in the REQ_STATUS_SENT state, p9_fd_cancelled
> > will forcibly delete the request, and at this time p9_[read/write]_work
> > may continue to use the request. Therefore, it causes UAF .
> >
> > There is the logs from syzbot.
> >
> > Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
> > 0x00 0x00 . . . . . . . . ] (in kfence-#110):
> >  p9_fcall_fini net/9p/client.c:248 [inline]
> >  p9_req_put net/9p/client.c:396 [inline]
> >  p9_req_put+0x208/0x250 net/9p/client.c:390
> >  p9_client_walk+0x247/0x540 net/9p/client.c:1165
> >  clone_fid fs/9p/fid.h:21 [inline]
> >  v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
> >  v9fs_xattr_set fs/9p/xattr.c:100 [inline]
> >  v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
> >  __vfs_setxattr+0x119/0x180 fs/xattr.c:182
> >  __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
> >  __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
> >  vfs_setxattr+0x143/0x340 fs/xattr.c:309
> >  setxattr+0x146/0x160 fs/xattr.c:617
> >  path_setxattr+0x197/0x1c0 fs/xattr.c:636
> >  __do_sys_setxattr fs/xattr.c:652 [inline]
> >  __se_sys_setxattr fs/xattr.c:648 [inline]
> >  __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
> >  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
> >  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
> >  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> >
> > Below is a similar scenario, the scenario in the syzbot log looks more
> > complicated than this one, but the root cause seems to be the same.
> >
> >      T21124               p9_write_work        p9 read_work
> > ======================== first trans =================================
> > p9_client_walk
> >   p9_client_rpc
> >     p9_client_prepare_req
> >     /* req->refcount == 2 */
> >     c->trans_mod->request(c, req);
> >       p9_fd_request
> >         req move to unsent_req_list
> >                             req->status = REQ_STATUS_SENT;
> >                             req move to req_list
> >                             << send to server >>
> >     wait_event_killable
> >     << get kill signal >>
> >     if (c->trans_mod->cancel(c, req))
> >        p9_client_flush(c, req);
> >          /* send flush request */
> >          req = p9_client_rpc(c, P9_TFLUSH, "w", oldtag);
> > 		 if (c->trans_mod->cancelled)
> >             c->trans_mod->cancelled(c, oldreq);
> >               /* old req was deleted from req_list */
> >               /* req->refcount == 1 */
> >   p9_req_put
> >     /* req->refcount == 0 */
> >     << preempted >>
> >                                        << get response, UAF here >>
> >                                        m->rreq = p9_tag_lookup(m->client, m->rc.tag);
> >                                          /* req->refcount == 1 */
> >                                        << do response >>
> >                                        p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
> >                                          /* req->refcount == 0 */
> >                                          p9_fcall_fini
> >                                          /* request have been freed */
> >     p9_fcall_fini
> >      /* double free */
> >                                        p9_req_put(m->client, m->rreq);
> >                                          /* req->refcount == 1 */
> >
> > To fix it, we can wait the request with status REQ_STATUS_SENT returned.

9p server might or might not send a reply on cancelled request. If 9p server
notices client's Tflush request early enough, then it would simply discard the
old=cancelled request and not send any reply on that old request. If server
notices Tflush too late, then server would send a response to the old request.

http://ericvh.github.io/9p-rfc/rfc9p2000.html#anchor28

However after sending Tflush client waits for the corresponding Rflush
response, and at this point situation should be clear; no further response
expected from server for old request at this point. And that's what Linux
client does.

Which server implementation caused that?

> >
> > Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
> >
> > Signed-off-by: Schspa Shi <schspa@gmail.com>
> > ---
> >  net/9p/client.c   |  2 +-
> >  net/9p/trans_fd.c | 12 ++++++++++++
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/9p/client.c b/net/9p/client.c
> > index aaa37b07e30a..963cf91aa0d5 100644
> > --- a/net/9p/client.c
> > +++ b/net/9p/client.c
> > @@ -440,7 +440,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
> >  	smp_wmb();
> >  	req->status = status;
> >  
> > -	wake_up(&req->wq);
> > +	wake_up_all(&req->wq);

Purpose?

> >  	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc.tag);
> >  	p9_req_put(c, req);
> >  }
> > diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > index eeea0a6a75b6..ee2d6b231af1 100644
> > --- a/net/9p/trans_fd.c
> > +++ b/net/9p/trans_fd.c
> > @@ -30,6 +30,7 @@
> >  #include <net/9p/transport.h>
> >  
> >  #include <linux/syscalls.h> /* killme */
> > +#include <linux/wait.h>
> >  
> >  #define P9_PORT 564
> >  #define MAX_SOCK_BUF (1024*1024)
> > @@ -728,6 +729,17 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
> >  		return 0;
> >  	}
> >  
> > +	/* If the request is been sent to the server, we need to wait for the
> > +	 * job to finish.
> > +	 */
> > +	if (req->status == REQ_STATUS_SENT) {
> > +		spin_unlock(&m->req_lock);
> > +		p9_debug(P9_DEBUG_TRANS, "client %p req %p wait done\n",
> > +			 client, req);
> > +		wait_event(req->wq, req->status >= REQ_STATUS_RCVD);
> > +
> > +		return 0;
> > +	}
> >  	/* we haven't received a response for oldreq,
> >  	 * remove it from the list.
> >  	 */
> 
> Add Christian Schoenebeck for bad mail address typo.
> 
> 




