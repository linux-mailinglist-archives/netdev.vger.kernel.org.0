Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01795AD0EE
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 00:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbfIHWLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 18:11:49 -0400
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:54665 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730918AbfIHWLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 18:11:48 -0400
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id x88MASgM002202
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Sep 2019 00:10:28 +0200
Received: from ns3096276.ip-94-23-54.eu (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x88M9vw7178040
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Mon, 9 Sep 2019 00:10:23 +0200
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <894922a2-1150-366c-3f08-c8b759da0742@digikod.net>
Date:   Mon, 9 Sep 2019 00:09:57 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/07/2019 20:46, Mickaël Salaün wrote:
> 
> On 27/07/2019 03:40, Alexei Starovoitov wrote:
>> On Sun, Jul 21, 2019 at 11:31:12PM +0200, Mickaël Salaün wrote:
>>> FIXME: 64-bits in the doc
> 
> FYI, this FIXME was fixed, just not removed from this message. :)
> 
>>>
>>> This new map store arbitrary values referenced by inode keys.  The map
>>> can be updated from user space with file descriptor pointing to inodes
>>> tied to a file system.  From an eBPF (Landlock) program point of view,
>>> such a map is read-only and can only be used to retrieved a value tied
>>> to a given inode.  This is useful to recognize an inode tagged by user
>>> space, without access right to this inode (i.e. no need to have a write
>>> access to this inode).
>>>
>>> Add dedicated BPF functions to handle this type of map:
>>> * bpf_inode_htab_map_update_elem()
>>> * bpf_inode_htab_map_lookup_elem()
>>> * bpf_inode_htab_map_delete_elem()
>>>
>>> This new map require a dedicated helper inode_map_lookup_elem() because
>>> of the key which is a pointer to an opaque data (only provided by the
>>> kernel).  This act like a (physical or cryptographic) key, which is why
>>> it is also not allowed to get the next key.
>>>
>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>
>> there are too many things to comment on.
>> Let's do this patch.
>>
>> imo inode_map concept is interesting, but see below...
>>
>>> +
>>> +    /*
>>> +     * Limit number of entries in an inode map to the maximum number of
>>> +     * open files for the current process. The maximum number of file
>>> +     * references (including all inode maps) for a process is then
>>> +     * (RLIMIT_NOFILE - 1) * RLIMIT_NOFILE. If the process' RLIMIT_NOFILE
>>> +     * is 0, then any entry update is forbidden.
>>> +     *
>>> +     * An eBPF program can inherit all the inode map FD. The worse case is
>>> +     * to fill a bunch of arraymaps, create an eBPF program, close the
>>> +     * inode map FDs, and start again. The maximum number of inode map
>>> +     * entries can then be close to RLIMIT_NOFILE^3.
>>> +     */
>>> +    if (attr->max_entries > rlimit(RLIMIT_NOFILE))
>>> +            return -EMFILE;
>>
>> rlimit is checked, but no fd are consumed.
>> Once created such inode map_fd can be passed to a different process.
>> map_fd can be pinned into bpffs.
>> etc.
>> what the value of the check?
> 
> I was looking for the most meaningful limit for a process, and rlimit is
> the best I found. As the limit of open FD per processes, rlimit is not
> perfect, but I think the semantic is close here (e.g. a process can also
> pass FD through unix socket).
> 
>>
>>> +
>>> +    /* decorelate UAPI from kernel API */
>>> +    attr->key_size = sizeof(struct inode *);
>>> +
>>> +    return htab_map_alloc_check(attr);
>>> +}
>>> +
>>> +static void inode_htab_put_key(void *key)
>>> +{
>>> +    struct inode **inode = key;
>>> +
>>> +    if ((*inode)->i_state & I_FREEING)
>>> +            return;
>>
>> checking the state without take a lock? isn't it racy?
> 
> This should only trigger when called from security_inode_free(). I'll
> add a comment.
> 
>>
>>> +    iput(*inode);
>>> +}
>>> +
>>> +/* called from syscall or (never) from eBPF program */
>>> +static int map_get_next_no_key(struct bpf_map *map, void *key, void *next_key)
>>> +{
>>> +    /* do not leak a file descriptor */
>>
>> what this comment suppose to mean?
> 
> Because a key is a reference to an inode, a possible return value for
> this function could be a file descriptor pointing to this inode (the
> same way a file descriptor is use to add an element). For now, I don't
> want to implement a way for a process with such a map to extract such
> inode, which I compare to a possible leak (of information, not kernel
> memory nor object). This could be implemented in the future if there is
> value in it (and probably some additional safeguards), though.
> 
>>
>>> +    return -ENOTSUPP;
>>> +}
>>> +
>>> +/* must call iput(inode) after this call */
>>> +static struct inode *inode_from_fd(int ufd, bool check_access)
>>> +{
>>> +    struct inode *ret;
>>> +    struct fd f;
>>> +    int deny;
>>> +
>>> +    f = fdget(ufd);
>>> +    if (unlikely(!f.file))
>>> +            return ERR_PTR(-EBADF);
>>> +    /* TODO?: add this check when called from an eBPF program too (already
>>> +    * checked by the LSM parent hooks anyway) */
>>> +    if (unlikely(IS_PRIVATE(file_inode(f.file)))) {
>>> +            ret = ERR_PTR(-EINVAL);
>>> +            goto put_fd;
>>> +    }
>>> +    /* check if the FD is tied to a mount point */
>>> +    /* TODO?: add this check when called from an eBPF program too */
>>> +    if (unlikely(f.file->f_path.mnt->mnt_flags & MNT_INTERNAL)) {
>>> +            ret = ERR_PTR(-EINVAL);
>>> +            goto put_fd;
>>> +    }
>>
>> a bunch of TODOs do not inspire confidence.
> 
> I think the current implement is good, but these TODOs are here to draw
> attention on particular points for which I would like external review
> and opinion (hence the "?").
> 
>>
>>> +    if (check_access) {
>>> +            /*
>>> +            * must be allowed to access attributes from this file to then
>>> +            * be able to compare an inode to its map entry
>>> +            */
>>> +            deny = security_inode_getattr(&f.file->f_path);
>>> +            if (deny) {
>>> +                    ret = ERR_PTR(deny);
>>> +                    goto put_fd;
>>> +            }
>>> +    }
>>> +    ret = file_inode(f.file);
>>> +    ihold(ret);
>>> +
>>> +put_fd:
>>> +    fdput(f);
>>> +    return ret;
>>> +}
>>> +
>>> +/*
>>> + * The key is a FD when called from a syscall, but an inode address when called
>>> + * from an eBPF program.
>>> + */
>>> +
>>> +/* called from syscall */
>>> +int bpf_inode_fd_htab_map_lookup_elem(struct bpf_map *map, int *key, void *value)
>>> +{
>>> +    void *ptr;
>>> +    struct inode *inode;
>>> +    int ret;
>>> +
>>> +    /* check inode access */
>>> +    inode = inode_from_fd(*key, true);
>>> +    if (IS_ERR(inode))
>>> +            return PTR_ERR(inode);
>>> +
>>> +    rcu_read_lock();
>>> +    ptr = htab_map_lookup_elem(map, &inode);
>>> +    iput(inode);
>>> +    if (IS_ERR(ptr)) {
>>> +            ret = PTR_ERR(ptr);
>>> +    } else if (!ptr) {
>>> +            ret = -ENOENT;
>>> +    } else {
>>> +            ret = 0;
>>> +            copy_map_value(map, value, ptr);
>>> +    }
>>> +    rcu_read_unlock();
>>> +    return ret;
>>> +}
>>> +
>>> +/* called from kernel */
>>
>> wrong comment?
>> kernel side cannot call it, right?
> 
> This is called from bpf_inode_fd_htab_map_delete_elem() (code just
> beneath), and from
> kernel/bpf/syscall.c:bpf_inode_ptr_unlocked_htab_map_delet_elem() which
> can be called by security_inode_free() (hook_inode_free_security).
> 
>>
>>> +int bpf_inode_ptr_locked_htab_map_delete_elem(struct bpf_map *map,
>>> +            struct inode **key, bool remove_in_inode)
>>> +{
>>> +    if (remove_in_inode)
>>> +            landlock_inode_remove_map(*key, map);
>>> +    return htab_map_delete_elem(map, key);
>>> +}
>>> +
>>> +/* called from syscall */
>>> +int bpf_inode_fd_htab_map_delete_elem(struct bpf_map *map, int *key)
>>> +{
>>> +    struct inode *inode;
>>> +    int ret;
>>> +
>>> +    /* do not check inode access (similar to directory check) */
>>> +    inode = inode_from_fd(*key, false);
>>> +    if (IS_ERR(inode))
>>> +            return PTR_ERR(inode);
>>> +    ret = bpf_inode_ptr_locked_htab_map_delete_elem(map, &inode, true);
>>> +    iput(inode);
>>> +    return ret;
>>> +}
>>> +
>>> +/* called from syscall */
>>> +int bpf_inode_fd_htab_map_update_elem(struct bpf_map *map, int *key, void *value,
>>> +            u64 map_flags)
>>> +{
>>> +    struct inode *inode;
>>> +    int ret;
>>> +
>>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>>> +
>>> +    /* check inode access */
>>> +    inode = inode_from_fd(*key, true);
>>> +    if (IS_ERR(inode))
>>> +            return PTR_ERR(inode);
>>> +    ret = htab_map_update_elem(map, &inode, value, map_flags);
>>> +    if (!ret)
>>> +            ret = landlock_inode_add_map(inode, map);
>>> +    iput(inode);
>>> +    return ret;
>>> +}
>>> +
>>> +static void inode_htab_map_free(struct bpf_map *map)
>>> +{
>>> +    struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
>>> +    struct hlist_nulls_node *n;
>>> +    struct hlist_nulls_head *head;
>>> +    struct htab_elem *l;
>>> +    int i;
>>> +
>>> +    for (i = 0; i < htab->n_buckets; i++) {
>>> +            head = select_bucket(htab, i);
>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
>>> +                    landlock_inode_remove_map(*((struct inode **)l->key), map);
>>> +            }
>>> +    }
>>> +    htab_map_free(map);
>>> +}
>>
>> user space can delete the map.
>> that will trigger inode_htab_map_free() which will call
>> landlock_inode_remove_map().
>> which will simply itereate the list and delete from the list.
> 
> landlock_inode_remove_map() removes the reference to the map (being
> freed) from the inode (with an RCU lock).
> 
>>
>> While in parallel inode can be destoyed and hook_inode_free_security()
>> will be called.
>> I think nothing that protects from this race.
> 
> According to security_inode_free(), the inode is effectively freed after
> the RCU grace period. However, I forgot to call bpf_map_inc() in
> landlock_inode_add_map(), which would prevent the map to be freed
> outside of the security_inode_free(). I'll fix that.
> 
>>
>>> +
>>> +/*
>>> + * We need a dedicated helper to deal with inode maps because the key is a
>>> + * pointer to an opaque data, only provided by the kernel.  This really act
>>> + * like a (physical or cryptographic) key, which is why it is also not allowed
>>> + * to get the next key with map_get_next_key().
>>
>> inode pointer is like cryptographic key? :)
> 
> I wanted to highlight the fact that, contrary to other map key types,
> the value of this one should not be readable, only usable. A "secret
> value" is more appropriate but still confusing. I'll rephrase that.
> 
>>
>>> + */
>>> +BPF_CALL_2(bpf_inode_map_lookup_elem, struct bpf_map *, map, void *, key)
>>> +{
>>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>>> +    return (unsigned long)htab_map_lookup_elem(map, &key);
>>> +}
>>> +
>>> +const struct bpf_func_proto bpf_inode_map_lookup_elem_proto = {
>>> +    .func           = bpf_inode_map_lookup_elem,
>>> +    .gpl_only       = false,
>>> +    .pkt_access     = true,
>>
>> pkt_access ? :)
> 
> This slipped in with this rebase, I'll remove it. :)
> 
>>
>>> +    .ret_type       = RET_PTR_TO_MAP_VALUE_OR_NULL,
>>> +    .arg1_type      = ARG_CONST_MAP_PTR,
>>> +    .arg2_type      = ARG_PTR_TO_INODE,
>>> +};
>>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>>> index b2a8cb14f28e..e46441c42b68 100644
>>> --- a/kernel/bpf/syscall.c
>>> +++ b/kernel/bpf/syscall.c
>>> @@ -801,6 +801,8 @@ static int map_lookup_elem(union bpf_attr *attr)
>>>      } else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
>>>                 map->map_type == BPF_MAP_TYPE_STACK) {
>>>              err = map->ops->map_peek_elem(map, value);
>>> +    } else if (map->map_type == BPF_MAP_TYPE_INODE) {
>>> +            err = bpf_inode_fd_htab_map_lookup_elem(map, key, value);
>>>      } else {
>>>              rcu_read_lock();
>>>              if (map->ops->map_lookup_elem_sys_only)
>>> @@ -951,6 +953,10 @@ static int map_update_elem(union bpf_attr *attr)
>>>      } else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
>>>                 map->map_type == BPF_MAP_TYPE_STACK) {
>>>              err = map->ops->map_push_elem(map, value, attr->flags);
>>> +    } else if (map->map_type == BPF_MAP_TYPE_INODE) {
>>> +            rcu_read_lock();
>>> +            err = bpf_inode_fd_htab_map_update_elem(map, key, value, attr->flags);
>>> +            rcu_read_unlock();
>>>      } else {
>>>              rcu_read_lock();
>>>              err = map->ops->map_update_elem(map, key, value, attr->flags);
>>> @@ -1006,7 +1012,10 @@ static int map_delete_elem(union bpf_attr *attr)
>>>      preempt_disable();
>>>      __this_cpu_inc(bpf_prog_active);
>>>      rcu_read_lock();
>>> -    err = map->ops->map_delete_elem(map, key);
>>> +    if (map->map_type == BPF_MAP_TYPE_INODE)
>>> +            err = bpf_inode_fd_htab_map_delete_elem(map, key);
>>> +    else
>>> +            err = map->ops->map_delete_elem(map, key);
>>>      rcu_read_unlock();
>>>      __this_cpu_dec(bpf_prog_active);
>>>      preempt_enable();
>>> @@ -1018,6 +1027,22 @@ static int map_delete_elem(union bpf_attr *attr)
>>>      return err;
>>>  }
>>>
>>> +int bpf_inode_ptr_unlocked_htab_map_delete_elem(struct bpf_map *map,
>>> +                                            struct inode **key, bool remove_in_inode)
>>> +{
>>> +    int err;
>>> +
>>> +    preempt_disable();
>>> +    __this_cpu_inc(bpf_prog_active);
>>> +    rcu_read_lock();
>>> +    err = bpf_inode_ptr_locked_htab_map_delete_elem(map, key, remove_in_inode);
>>> +    rcu_read_unlock();
>>> +    __this_cpu_dec(bpf_prog_active);
>>> +    preempt_enable();
>>> +    maybe_wait_bpf_programs(map);
>>
>> if that function was actually doing synchronize_rcu() the consequences
>> would have been unpleasant. Fortunately it's a nop in this case.
>> Please read the code carefully before copy-paste.
>> Also what do you think the reason of bpf_prog_active above?
>> What is the reason of rcu_read_lock above?
> 
> The RCU is used as for every map modifications (usually from userspace).
> I wasn't sure about the other protections so I kept the same (generic)
> checks as in map_delete_elem() (just above) because this function follow
> the same semantic. What can I safely remove?
> 
>>
>> I think the patch set needs to shrink at least in half to be reviewable.
>> The way you tie seccomp and lsm is probably the biggest obstacle
>> than any of the bugs above.
>> Can you drop seccomp ? and do it as normal lsm ?
> 
> The seccomp/enforcement part is needed to have a minimum viable product,
> i.e. a process able to sandbox itself. Are you suggesting to first merge
> a version when it is only possible to create inode maps but not use them
> in an useful way (i.e. for sandboxing)? I can do it if it's OK with you,
> and I hope it will not be a problem for the security folks if it can
> help to move forward.

I talked with Kees Cook and James Morris at LSS NA, and I think the
better strategy to shrink this patch series is to tackle a much less
complex problem at first. Instead on focusing right now on file system,
the next version of this patch series will focus on memory protection,
which is also something desired. I'll then iterate with file system
support (i.e. inode maps) and other use cases once the basics of
Landlock are upstream. For this next series, the majority of the code
will be on the LSM side, while the eBPF part will mainly consist to add
a new program type. Because bpf-next is moving rapidly, I think it still
make sense to base this work on this tree (instead of linux-security).

Regards,
 Mickaël
