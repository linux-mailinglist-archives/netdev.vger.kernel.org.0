Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1065C1ED
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbjACO0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237956AbjACO0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:26:40 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C8DF
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 06:26:40 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 188so16848493ybi.9
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 06:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FFGk1QfTUzSOTmAj0L/1BIpIb8oyBY1kW9Dn9LI/luw=;
        b=jfRpLHjRAE1pwPoM3rLV4XUk/f7G0QkYgbf2EQRqbOOlJ5Za5MebZ0IGoFeOKypQUk
         H7O9Cxi/7XBGpcUuLmF6SB+beHZeCvvjQMmJQ/5tmROTMOye2V89WRm+WGrRxXQyVXOP
         +8uIk+A151mxSA15CsYw88/e5Q6eEMt2F5kPMf3Vc1rUmarR+9OyJQUmwc5lA5pwDizy
         ynu5drL9f2lM3tJeBn9rcaj5q4YWPGxPt3smbEdYleQTfBRSh5fht2n84OaqMTGgo+Qh
         OkO8zpTKUTwJWLKVtZ3Qvi04eXxnO/MIi6WhtBI6iQuzTdnCKVnRj4g6Bk0D+Tfo8fjs
         uXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFGk1QfTUzSOTmAj0L/1BIpIb8oyBY1kW9Dn9LI/luw=;
        b=it4gXMfTrIQgCPCsgX25R5gKvwTka9Rr04R4cFG0ndtYqE0D3gaHSfdm+/Bs+8NpTu
         NFmC2thfxpIaPzW/0WBgiNUPyepd4AI7EpG5vj87tPcPNt5F7LgKs0uq+iq4qUpZhvkS
         9JjWDTyBKw2/1jFR7PDyfb/U195rfHkbHhEoAkdzMEs1yU3Jy3D5DlzVKne5hzmFsP4t
         VuQYNV8KFJx+vup6joJNRBB6a1r/8ah9dzROSVmHXqWAUAuQWgvgWUukP8PqyG+VT6ai
         JPfUvGHElacQD9x7EgCbKrN7DquaUa5945rhSTeKKzD1BbgXW51wXqI3NyF34rf6f2Zb
         EIjg==
X-Gm-Message-State: AFqh2kpPzE5iqMFLzm2fEK81E+AH8frqtIcI5XNEzvb8Er+0dYWNSvbz
        RsTLNClnqZql+wXFsIbrtG+Nlvtg2h4+OOWSymLuyg==
X-Google-Smtp-Source: AMrXdXuZHI3JmkwdqzrV6jyWXVrJ7/4N7EciBSeG4sX4tnAnz1U7VnTIZcuMQaZx0jZc7G1zAy8aymOxBTK1lMsC2rI=
X-Received: by 2002:a25:2fc5:0:b0:706:bafd:6f95 with SMTP id
 v188-20020a252fc5000000b00706bafd6f95mr3550286ybv.55.1672755999048; Tue, 03
 Jan 2023 06:26:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1671194454.git.bcodding@redhat.com> <ceaf7a4b035e78cdbdde4e9a4ab71ba61a5e5457.1671194454.git.bcodding@redhat.com>
In-Reply-To: <ceaf7a4b035e78cdbdde4e9a4ab71ba61a5e5457.1671194454.git.bcodding@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Jan 2023 15:26:27 +0100
Message-ID: <CANn89iKik8uMO6=ztufPwYdg1qRPsxToz0Nu-uaZWkE63bKSUQ@mail.gmail.com>
Subject: Re: [PATCH net v4 2/3] Treewide: Stop corrupting socket's task_frag
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 1:45 PM Benjamin Coddington <bcodding@redhat.com> wrote:
>
> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> GFP_NOIO flag on sk_allocation which the networking system uses to decide
> when it is safe to use current->task_frag.  The results of this are
> unexpected corruption in task_frag when SUNRPC is involved in memory
> reclaim.
>
> The corruption can be seen in crashes, but the root cause is often
> difficult to ascertain as a crashing machine's stack trace will have no
> evidence of being near NFS or SUNRPC code.  I believe this problem to
> be much more pervasive than reports to the community may indicate.
>
> Fix this by having kernel users of sockets that may corrupt task_frag due
> to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> situation for users that still set sk_allocation allows them to convert to
> memalloc_nofs_save/restore without the same unexpected corruptions that are
> sure to follow, unlikely to show up in testing, and difficult to bisect.
>

I am back from PTO.

It seems inet_ctl_sock_create() has been forgotten.

Without following fix, ICMP messages sent from softirq would corrupt
innocent thread task_frag.

(I will submit this patch formally a bit later today)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ab4a06be489b5d410cec603bf56248d31dbc90dd..6c0ec27899431eb56e2f9d0c3a936b77f44ccaca
100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1665,6 +1665,7 @@ int inet_ctl_sock_create(struct sock **sk,
unsigned short family,
        if (rc == 0) {
                *sk = sock->sk;
                (*sk)->sk_allocation = GFP_ATOMIC;
+               (*sk)->sk_use_task_frag = false;
                /*
                 * Unhash it so that IP input processing does not even see it,
                 * we do not wish this socket to see incoming packets.
