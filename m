Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6422B0F0B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKLU2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgKLU2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:28:38 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23199C0613D1;
        Thu, 12 Nov 2020 12:28:38 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdJCn-004XlE-Ed; Thu, 12 Nov 2020 20:28:29 +0000
Date:   Thu, 12 Nov 2020 20:28:29 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Florent Revest <revest@chromium.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, yhs@fb.com, andrii@kernel.org, kpsingh@chromium.org,
        jackmanb@chromium.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>, netdev@vger.kernel.org
Subject: saner sock_from_file() calling conventions (was Re: [PATCH] bpf:
 Expose a bpf_sock_from_file helper to tracing programs)
Message-ID: <20201112202829.GD3576660@ZenIV.linux.org.uk>
References: <20201112200944.2726451-1-revest@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112200944.2726451-1-revest@chromium.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 09:09:44PM +0100, Florent Revest wrote:
> From: Florent Revest <revest@google.com>
> 
> eBPF programs can already check whether a file is a socket using
> file->f_op == &socket_file_ops but they can not convert file->private_data
> into a struct socket with BTF information. For that, we need a new
> helper that is essentially just a wrapper for sock_from_file.
> 
> sock_from_file can set an err value but this is only set to -ENOTSOCK
> when the return value is NULL so it's useless superfluous information.

That's a wrong way to handle that kind of stuff.  *IF* sock_from_file()
really has no need to return an error, its calling conventions ought to
be changed.  OTOH, if that is not the case, your API is a landmine.

That needs to be dealt with by netdev folks, rather than quietly papered
over in BPF code.

It does appear that there's no realistic cause to ever need other errors
there (well, short of some clown attaching a hook, pardon the obscenity),
so I would recommend something like the patch below (completely untested):

sanitize sock_from_file() calling conventions

deal with error value (always -ENOTSOCK) in the callers

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3b20e21604e7..07b33c1f34a9 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -168,7 +168,6 @@ EXPORT_SYMBOL(seq_read);
 ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct seq_file *m = iocb->ki_filp->private_data;
-	size_t size = iov_iter_count(iter);
 	size_t copied = 0;
 	size_t n;
 	void *p;
@@ -208,14 +207,11 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	}
 	/* if not empty - flush it first */
 	if (m->count) {
-		n = min(m->count, size);
-		if (copy_to_iter(m->buf + m->from, n, iter) != n)
-			goto Efault;
+		n = copy_to_iter(m->buf + m->from, m->count, iter);
 		m->count -= n;
 		m->from += n;
-		size -= n;
 		copied += n;
-		if (!size)
+		if (!iov_iter_count(iter) || m->count)
 			goto Done;
 	}
 	/* we need at least one record in buffer */
@@ -249,6 +245,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	goto Done;
 Fill:
 	/* they want more? let's try to get some more */
+	/* m->count is positive and there's space left in iter */
 	while (1) {
 		size_t offs = m->count;
 		loff_t pos = m->index;
@@ -263,7 +260,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 			err = PTR_ERR(p);
 			break;
 		}
-		if (m->count >= size)
+		if (m->count >= iov_iter_count(iter))
 			break;
 		err = m->op->show(m, p);
 		if (seq_has_overflowed(m) || err) {
@@ -273,16 +270,14 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 	}
 	m->op->stop(m, p);
-	n = min(m->count, size);
-	if (copy_to_iter(m->buf, n, iter) != n)
-		goto Efault;
+	n = copy_to_iter(m->buf, m->count, iter);
 	copied += n;
 	m->count -= n;
 	m->from = n;
 Done:
-	if (!copied)
-		copied = err;
-	else {
+	if (unlikely(!copied)) {
+		copied = m->count ? -EFAULT : err;
+	} else {
 		iocb->ki_pos += copied;
 		m->read_pos += copied;
 	}
@@ -291,9 +286,6 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 Enomem:
 	err = -ENOMEM;
 	goto Done;
-Efault:
-	err = -EFAULT;
-	goto Done;
 }
 EXPORT_SYMBOL(seq_read_iter);
 
