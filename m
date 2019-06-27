Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146F2586F7
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0QZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:25:26 -0400
Received: from smtp-out.ssi.gouv.fr ([86.65.182.90]:63556 "EHLO
        smtp-out.ssi.gouv.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0QZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:25:26 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2019 12:25:25 EDT
Received: from smtp-out.ssi.gouv.fr (localhost [127.0.0.1])
        by smtp-out.ssi.gouv.fr (Postfix) with ESMTP id 12E14D00073;
        Thu, 27 Jun 2019 18:18:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
        s=20160407; t=1561652296;
        bh=e/9/soaXxtPOLGylT6FEbrJeqf5CH04oQATLaTVtYYU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
        b=W6wClXcUUlkKnnGLJvw4aTCMWkm09TDrSTk9aM9xnwww4FBi0ejQRAcafStv5/PaJ
         TqrbxB0HJK5AlaMj+32Fv5C+eIXElxPDgSsWmy8WNE0FLMTpJKJCXCDNGJH1h32ujf
         j3MYKbBu4YcvZG46mgjJZp8EBFnFZqhYxuyHP8lyHu4ZI8r+dYtyn+iL/vL6YOtxyy
         QU6Mq5Q0bVZHHLEXz3klncr6GlMrRPDL9Tn4C2pQLuLAfn5TywxxeMwPSIi/Fs+lCq
         gy/tTNJzdYhegMvZKVrDR2iD1hhhEK7jXeI+DDvom0fHd4UcejWmedP6Ns5bAcnTlx
         feTNxO0qXLdaw==
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
To:     Al Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
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
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
Date:   Thu, 27 Jun 2019 18:18:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <20190625225201.GJ17978@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/06/2019 00:52, Al Viro wrote:
> On Tue, Jun 25, 2019 at 11:52:34PM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>> +/* must call iput(inode) after this call */
>> +static struct inode *inode_from_fd(int ufd, bool check_access)
>> +{
>> +    struct inode *ret;
>> +    struct fd f;
>> +    int deny;
>> +
>> +    f =3D fdget(ufd);
>> +    if (unlikely(!f.file || !file_inode(f.file))) {
>> +            ret =3D ERR_PTR(-EBADF);
>> +            goto put_fd;
>> +    }
>
> Just when does one get a NULL file_inode()?  The reason I'm asking is
> that arseloads of code would break if one managed to create such
> a beast...

I didn't find any API documentation about this guarantee, so I followed
a defensive programming approach. I'll remove the file_inode() check.

>
> Incidentally, that should be return ERR_PTR(-EBADF); fdput() is wrong the=
re.

Right, I'll fix that.

>
>> +    }
>> +    /* check if the FD is tied to a mount point */
>> +    /* TODO: add this check when called from an eBPF program too */
>> +    if (unlikely(!f.file->f_path.mnt
>
> Again, the same question - when the hell can that happen?

Defensive programming again, I'll remove it.

> If you are
> sitting on an exploitable roothole, do share it...
>
>  || f.file->f_path.mnt->mnt_flags &
>> +                            MNT_INTERNAL)) {
>> +            ret =3D ERR_PTR(-EINVAL);
>> +            goto put_fd;
>
> What does it have to do with mountpoints, anyway?

I want to only manage inodes tied to a userspace-visible file system
(this check may not be enough though). It doesn't make sense to be able
to add inodes which are not mounted, to this kind of map.

>
>> +/* called from syscall */
>> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode =
*key)
>> +{
>> +    struct inode_array *array =3D container_of(map, struct inode_array,=
 map);
>> +    struct inode *inode;
>> +    int i;
>> +
>> +    WARN_ON_ONCE(!rcu_read_lock_held());
>> +    for (i =3D 0; i < array->map.max_entries; i++) {
>> +            if (array->elems[i].inode =3D=3D key) {
>> +                    inode =3D xchg(&array->elems[i].inode, NULL);
>> +                    array->nb_entries--;
>
> Umm...  Is that intended to be atomic in any sense?

nb_entries is not used as a bound check but to avoid walking uselessly
through the (pre-allocated) array when adding a new element, but I'll
use an atomic to avoid inconsistencies anyway.

>
>> +                    iput(inode);
>> +                    return 0;
>> +            }
>> +    }
>> +    return -ENOENT;
>> +}
>> +
>> +/* called from syscall */
>> +int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
>> +{
>> +    struct inode *inode;
>> +    int err;
>> +
>> +    inode =3D inode_from_fd(*key, false);
>> +    if (IS_ERR(inode))
>> +            return PTR_ERR(inode);
>> +    err =3D sys_inode_map_delete_elem(map, inode);
>> +    iput(inode);
>> +    return err;
>> +}
>
> Wait a sec...  So we have those beasties that can have long-term
> references to arbitrary inodes stuck in them?  What will happen
> if you get umount(2) called while such a thing exists?

I though an umount would be denied but no, we get a self-destructed busy
inode and a bug!
What about wrapping the inode's superblock->s_op->destroy_inode() to
first remove the element from the map and then call the real
destroy_inode(), if any?
Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
if it is set, and set it when such inode is referenced by a map?
Or maybe I could hold the referencing file in the map and then wrap its
f_op?


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
