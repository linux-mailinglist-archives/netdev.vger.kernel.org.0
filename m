Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC11AF32B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 01:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfIJXPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 19:15:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53816 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfIJXPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 19:15:08 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i7pLm-0007da-AP; Tue, 10 Sep 2019 23:15:06 +0000
Date:   Wed, 11 Sep 2019 00:15:06 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Yonghong Song <yhs@fb.com>
Cc:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190910231506.GL1131@ZenIV.linux.org.uk>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
 <20190909174522.GA17882@frodo.byteswizards.com>
 <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 10:35:09PM +0000, Yonghong Song wrote:
> 
> Carlos,
> 
> Discussed with Eric today for what is the best way to get
> the device number for a namespace. The following patch seems
> a reasonable start although Eric would like to see
> how the helper is used in order to decide whether the
> interface looks right.
> 
> commit bb00fc36d5d263047a8bceb3e51e969d7fbce7db (HEAD -> fs2)
> Author: Yonghong Song <yhs@fb.com>
> Date:   Mon Sep 9 21:50:51 2019 -0700
> 
>      nsfs: add an interface function ns_get_inum_dev()
> 
>      This patch added an interface function
>      ns_get_inum_dev(). Given a ns_common structure,
>      the function returns the inode and device
>      numbers. The function will be used later
>      by a newly added bpf helper.
> 
>      Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index a0431642c6b5..a603c6fc3f54 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
>          return ERR_PTR(-EINVAL);
>   }
> 
> +/* Get the device number for the current task pidns.
> + */
> +void ns_get_inum_dev(struct ns_common *ns, u32 *inum, dev_t *dev)
> +{
> +       *inum = ns->inum;
> +       *dev = nsfs_mnt->mnt_sb->s_dev;
> +}

Umm...  Where would it get the device number once we get (hell knows
what for) multiple nsfs instances?  I still don't understand what
would that be about, TBH...  Is it really per-userns?  Or something
else entirely?  Eric, could you give some context?
