Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9A59CCB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfF1NQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:16:58 -0400
Received: from smtp-out.ssi.gouv.fr ([86.65.182.90]:54792 "EHLO
        smtp-out.ssi.gouv.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfF1NQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:16:58 -0400
Received: from smtp-out.ssi.gouv.fr (localhost [127.0.0.1])
        by smtp-out.ssi.gouv.fr (Postfix) with ESMTP id BECDAD0006F;
        Fri, 28 Jun 2019 15:17:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
        s=20160407; t=1561727823;
        bh=4QpdD3Fv+j/DUToNpr9bdvINCY1lm/nwotSarRRnLoo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
        b=V4oH5XMUGscMi8Gq1v5kREK8lTOsGXMNBJTpC+fp5yU/eKSBiSb1w/b9EhX95Jktz
         23y4Ybyo+tnUbieYEDaGeYUlNE1cHJ6RJtZA3MPIpycNccHkUiBXMBanxf2uAAHmJh
         Ft7/MNqWnvCVcuWJXvjzRin9RRW2xBP5gPWF9Yt/dfXGtYhG/ut4j7KHBwST+N6T9t
         owuJLIZt1jkyJ3osKMCyBGjh9DKTRFVkcm1jdz3BA4PyPUp4bUoD1GIffCvvgBdkd6
         wbBdiaGoCggKhAHyhC1FygajiYABF0pYSEW8ruWL6BWs/IF2x3k95+enXclwpBtyxP
         oOEynOlKBS30Q==
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
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
        <kernel-hardening@lists.openwall.com>, <linux-api@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
 <20190625225201.GJ17978@ZenIV.linux.org.uk>
 <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
 <20190627165640.GQ17978@ZenIV.linux.org.uk>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <9dbe8d9c-d7a7-5bf2-dda2-7dd72c44be2d@ssi.gouv.fr>
Date:   Fri, 28 Jun 2019 15:17:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <20190627165640.GQ17978@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/06/2019 18:56, Al Viro wrote:
> On Thu, Jun 27, 2019 at 06:18:12PM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>
>>>> +/* called from syscall */
>>>> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inod=
e *key)
>>>> +{
>>>> +    struct inode_array *array =3D container_of(map, struct inode_arra=
y, map);
>>>> +    struct inode *inode;
>>>> +    int i;
>>>> +
>>>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>>>> +    for (i =3D 0; i < array->map.max_entries; i++) {
>>>> +            if (array->elems[i].inode =3D=3D key) {
>>>> +                    inode =3D xchg(&array->elems[i].inode, NULL);
>>>> +                    array->nb_entries--;
>>>
>>> Umm...  Is that intended to be atomic in any sense?
>>
>> nb_entries is not used as a bound check but to avoid walking uselessly
>> through the (pre-allocated) array when adding a new element, but I'll
>> use an atomic to avoid inconsistencies anyway.
>
>
>>> Wait a sec...  So we have those beasties that can have long-term
>>> references to arbitrary inodes stuck in them?  What will happen
>>> if you get umount(2) called while such a thing exists?
>>
>> I though an umount would be denied but no, we get a self-destructed busy
>> inode and a bug!
>> What about wrapping the inode's superblock->s_op->destroy_inode() to
>> first remove the element from the map and then call the real
>> destroy_inode(), if any?
>
> What do you mean, _the_ map?  I don't see anything to prevent insertion
> of references to the same inode into any number of those...

Indeed, the current design needs to check for duplicate inode references
to avoid unused entries (until a reference is removed). I was planning
to use an rbtree but I'm working on using a hash table instead (cf.
bpf/hashtab.c), which will solve the issue anyway.

>
>> Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
>> if it is set, and set it when such inode is referenced by a map?
>> Or maybe I could hold the referencing file in the map and then wrap its
>> f_op?
>
> First of all, anything including the word "wrap" is a non-starter.
> We really don't need the headache associated with the locking needed
> to replace the method tables on the fly, or with the code checking that
> ->f_op points to given method table, etc.  That's not going to fly,
> especially since you'd end up _chaining_ those (again, the same reference
> can go in more than once).
>
> Nothing is allowed to change the method tables of live objects, period.
> Once a struct file is opened, its ->f_op is never going to change and
> it entirely belongs to the device driver or filesystem it resides on.
> Nothing else (not VFS, not VM, not some LSM module, etc.) has any busines=
s
> touching that.  The same goes for inodes, dentries, etc.
>
> What kind of behaviour do you want there?  Do you want the inodes you've
> referenced there to be forgotten on e.g. memory pressure?  The thing is,
> I don't see how "it's getting freed" could map onto any semantics that
> might be useful for you - it looks like the wrong event for that.

At least, I would like to be able to compare an inode with the reference
one if this reference may be accessible somewhere on the system. Being
able to keep the inode reference as long as its superblock is alive
seems to solve the problem. This enable for example to compare inodes
from two bind mounts of the same file system even if one mount point is
unmounted.

Storing and using the device ID and the inode number bring a new problem
when an inode is removed and when its number is recycled. However, if I
can be notified when such an inode is removed (preferably without using
an LSM hook) and if I can know when the backing device go out of the
scope of the (live) system (e.g. hot unplugging an USB drive), this
should solve the problem and also enable to keep a reference to an inode
as long as possible without any dangling pointer nor wrapper.


--
Micka=C3=ABl Sala=C3=BCn
ANSSI/SDE/ST/LAM

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
