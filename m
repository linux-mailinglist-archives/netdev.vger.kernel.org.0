Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C3B587C6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF0Q5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:57:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47906 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0Q5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:57:17 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hgXhQ-00066m-Ks; Thu, 27 Jun 2019 16:56:40 +0000
Date:   Thu, 27 Jun 2019 17:56:40 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>
Cc:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
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
Message-ID: <20190627165640.GQ17978@ZenIV.linux.org.uk>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
 <20190625225201.GJ17978@ZenIV.linux.org.uk>
 <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 06:18:12PM +0200, Mickaël Salaün wrote:

> >> +/* called from syscall */
> >> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
> >> +{
> >> +    struct inode_array *array = container_of(map, struct inode_array, map);
> >> +    struct inode *inode;
> >> +    int i;
> >> +
> >> +    WARN_ON_ONCE(!rcu_read_lock_held());
> >> +    for (i = 0; i < array->map.max_entries; i++) {
> >> +            if (array->elems[i].inode == key) {
> >> +                    inode = xchg(&array->elems[i].inode, NULL);
> >> +                    array->nb_entries--;
> >
> > Umm...  Is that intended to be atomic in any sense?
> 
> nb_entries is not used as a bound check but to avoid walking uselessly
> through the (pre-allocated) array when adding a new element, but I'll
> use an atomic to avoid inconsistencies anyway.


> > Wait a sec...  So we have those beasties that can have long-term
> > references to arbitrary inodes stuck in them?  What will happen
> > if you get umount(2) called while such a thing exists?
> 
> I though an umount would be denied but no, we get a self-destructed busy
> inode and a bug!
> What about wrapping the inode's superblock->s_op->destroy_inode() to
> first remove the element from the map and then call the real
> destroy_inode(), if any?

What do you mean, _the_ map?  I don't see anything to prevent insertion
of references to the same inode into any number of those...

> Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
> if it is set, and set it when such inode is referenced by a map?
> Or maybe I could hold the referencing file in the map and then wrap its
> f_op?

First of all, anything including the word "wrap" is a non-starter.
We really don't need the headache associated with the locking needed
to replace the method tables on the fly, or with the code checking that
->f_op points to given method table, etc.  That's not going to fly,
especially since you'd end up _chaining_ those (again, the same reference
can go in more than once).

Nothing is allowed to change the method tables of live objects, period.
Once a struct file is opened, its ->f_op is never going to change and
it entirely belongs to the device driver or filesystem it resides on.
Nothing else (not VFS, not VM, not some LSM module, etc.) has any business
touching that.  The same goes for inodes, dentries, etc.

What kind of behaviour do you want there?  Do you want the inodes you've
referenced there to be forgotten on e.g. memory pressure?  The thing is,
I don't see how "it's getting freed" could map onto any semantics that
might be useful for you - it looks like the wrong event for that.
