Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC27A55BA6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfFYWwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:52:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40498 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:52:16 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfuID-0001yb-63; Tue, 25 Jun 2019 22:52:01 +0000
Date:   Tue, 25 Jun 2019 23:52:01 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Message-ID: <20190625225201.GJ17978@ZenIV.linux.org.uk>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190625215239.11136-6-mic@digikod.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:52:34PM +0200, Mickaël Salaün wrote:
> +/* must call iput(inode) after this call */
> +static struct inode *inode_from_fd(int ufd, bool check_access)
> +{
> +	struct inode *ret;
> +	struct fd f;
> +	int deny;
> +
> +	f = fdget(ufd);
> +	if (unlikely(!f.file || !file_inode(f.file))) {
> +		ret = ERR_PTR(-EBADF);
> +		goto put_fd;
> +	}

Just when does one get a NULL file_inode()?  The reason I'm asking is
that arseloads of code would break if one managed to create such
a beast...

Incidentally, that should be return ERR_PTR(-EBADF); fdput() is wrong there.

> +	}
> +	/* check if the FD is tied to a mount point */
> +	/* TODO: add this check when called from an eBPF program too */
> +	if (unlikely(!f.file->f_path.mnt

Again, the same question - when the hell can that happen?  If you are
sitting on an exploitable roothole, do share it...

 || f.file->f_path.mnt->mnt_flags &
> +				MNT_INTERNAL)) {
> +		ret = ERR_PTR(-EINVAL);
> +		goto put_fd;

What does it have to do with mountpoints, anyway?

> +/* called from syscall */
> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
> +{
> +	struct inode_array *array = container_of(map, struct inode_array, map);
> +	struct inode *inode;
> +	int i;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	for (i = 0; i < array->map.max_entries; i++) {
> +		if (array->elems[i].inode == key) {
> +			inode = xchg(&array->elems[i].inode, NULL);
> +			array->nb_entries--;

Umm...  Is that intended to be atomic in any sense?

> +			iput(inode);
> +			return 0;
> +		}
> +	}
> +	return -ENOENT;
> +}
> +
> +/* called from syscall */
> +int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
> +{
> +	struct inode *inode;
> +	int err;
> +
> +	inode = inode_from_fd(*key, false);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +	err = sys_inode_map_delete_elem(map, inode);
> +	iput(inode);
> +	return err;
> +}

Wait a sec...  So we have those beasties that can have long-term
references to arbitrary inodes stuck in them?  What will happen
if you get umount(2) called while such a thing exists?
