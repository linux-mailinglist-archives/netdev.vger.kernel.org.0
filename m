Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27B63D2C09
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhGVSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 14:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhGVSBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 14:01:06 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8DEC06175F
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 11:41:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id o5so117590ejy.2
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 11:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KuzkAEH8jX8VBFDHnw1v9dX7As+btch3ek3bDh5Lw68=;
        b=vDJ3EGbHFnC0Z7Q+k9LtMEXwbYlXYGYaeJRqQYTNWlpVFNYY6NIPU/y+QnatVFdntR
         pppGarNbbiF/tWeeGFOiXcBfwjzSzl4efb+9TkulXj2+098WR8o1cxqW2Dlmq/QgxQp2
         ix6PlhQXW4Gg6tPb1S+YHMkFcXDEyUYqQ10miar0SIpi5bc3uo/GE+CIwfC7Lg66QnUm
         jCpSVHvcmd+DiX7jt4gCItiSzC2i5yAod66PItIVB/+/tcwFW+IOhxI2LgrHLH/I6JXY
         LEVO+aXwc+KgsjikCureyfHrvsGVGvLLOGe3OY9xBBXn49bO1L+vm/xvwtA4mArfkwQZ
         XQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KuzkAEH8jX8VBFDHnw1v9dX7As+btch3ek3bDh5Lw68=;
        b=mRZYgQq6An+fs0fbPq/wU4iGmxVh3R/0WrOjH6K67uFDRRdtMEU5cmPhp64Z73kssQ
         PiB0BSXTXkJz+gjHwLp5xQjAqYkZAX6rU4q9qsF1Oky3TWKk8AW+pU5RICnwY90VxEOD
         nu1pIdjSZn/JQm3pvynYz31UfFOtfhuCwGpKEQgMibqw5DOTFNMWuS9FyWu1/JTBgi7J
         vE1WvR5GMp4S2vd25SZcQ+TBPXgXFUCBfK3j9ouqejdQ73iELdCPGtX56vf6nNDekaPN
         jgcp3c0Dy5BI1L05/Mmgzs4lPJfexJmv1E8gY+Th+qFfN75zjGa/HjtZ9/FGURlrYf7l
         6YbQ==
X-Gm-Message-State: AOAM5338X+iPRCvSkOEZYKzzN/CnQRyvzL5GlrTDzZ/1+UU/ZyeEQ1SO
        wxm2I8cQuCT3bOUkZ7IbvbOSiEv+pbfifJ4e2iwz
X-Google-Smtp-Source: ABdhPJxqoxfFgf3e3FcjWkstfzi/EqMzJDQjp97NqjBVXjABGxgpSGclyrXhJ58bh/vrWIVxU2F3iwKduRd6nGCzUoY=
X-Received: by 2002:a17:906:b794:: with SMTP id dt20mr1120746ejb.431.1626979299101;
 Thu, 22 Jul 2021 11:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1626879395.git.pabeni@redhat.com> <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com> <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
In-Reply-To: <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 22 Jul 2021 14:41:30 -0400
Message-ID: <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Paolo Abeni <pabeni@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 12:59 PM Paolo Abeni <pabeni@redhat.com> wrote:
> On Thu, 2021-07-22 at 09:04 -0700, Casey Schaufler wrote:
> > On 7/22/2021 12:10 AM, Paolo Abeni wrote:
> > > On Wed, 2021-07-21 at 11:15 -0700, Casey Schaufler wrote:
> > > > On 7/21/2021 9:44 AM, Paolo Abeni wrote:
> > > > > This is a very early draft - in a different world would be
> > > > > replaced by hallway discussion at in-person conference - aimed at
> > > > > outlining some ideas and collect feedback on the overall outlook.
> > > > > There are still bugs to be fixed, more test and benchmark need, etc.
> > > > >
> > > > > There are 3 main goals:
> > > > > - [try to] avoid the overhead for uncommon conditions at GRO time
> > > > >   (patches 1-4)
> > > > > - enable backpressure for the veth GRO path (patches 5-6)
> > > > > - reduce the number of cacheline used by the sk_buff lifecycle
> > > > >   from 4 to 3, at least in some common scenarios (patches 1,7-9).
> > > > >   The idea here is avoid the initialization of some fields and
> > > > >   control their validity with a bitmask, as presented by at least
> > > > >   Florian and Jesper in the past.
> > > > If I understand correctly, you're creating an optimized case
> > > > which excludes ct, secmark, vlan and UDP tunnel. Is this correct,
> > > > and if so, why those particular fields? What impact will this have
> > > > in the non-optimal (with any of the excluded fields) case?
> > > Thank you for the feedback.
> >
> > You're most welcome. You did request comments.
> >
> > > There are 2 different relevant points:
> > >
> > > - the GRO stage.
> > >   packets carring any of CT, dst, sk or skb_ext will do 2 additional
> > > conditionals per gro_receive WRT the current code. My understanding is
> > > that having any of such field set at GRO receive time is quite
> > > exceptional for real nic. All others packet will do 4 or 5 less
> > > conditionals, and will traverse a little less code.
> > >
> > > - sk_buff lifecycle
> > >   * packets carrying vlan and UDP will not see any differences: sk_buff
> > > lifecycle will stil use 4 cachelines, as currently does, and no
> > > additional conditional is introduced.
> > >   * packets carring nfct or secmark will see an additional conditional
> > > every time such field is accessed. The number of cacheline used will
> > > still be 4, as in the current code. My understanding is that when such
> > > access happens, there is already a relevant amount of "additional" code
> > > to be executed, the conditional overhead should not be measurable.
> >
> > I'm responsible for some of that "additonal" code. If the secmark
> > is considered to be outside the performance critical data there are
> > changes I would like to make that will substantially improve the
> > performance of that "additional" code that would include a u64
> > secmark. If use of a secmark is considered indicative of a "slow"
> > path, the rationale for restricting it to u32, that it might impact
> > the "usual" case performance, seems specious. I can't say that I
> > understand all the nuances and implications involved. It does
> > appear that the changes you've suggested could negate the classic
> > argument that requires the u32 secmark.
>
> I see now I did not reply to one of you questions - why I picked-up
>  vlan, tunnel secmark fields to move them at sk_buff tail.
>
> Tow main drivers on my side:
> - there are use cases/deployments that do not use them.
> - moving them around was doable in term of required changes.
>
> There are no "slow-path" implications on my side. For example, vlan_*
> fields are very critical performance wise, if the traffic is tagged.
> But surely there are busy servers not using tagget traffic which will
> enjoy the reduced cachelines footprint, and this changeset will not
> impact negatively the first case.
>
> WRT to the vlan example, secmark and nfct require an extra conditional
> to fetch the data. My understanding is that such additional conditional
> is not measurable performance-wise when benchmarking the security
> modules (or conntrack) because they have to do much more intersting
> things after fetching a few bytes from an already hot cacheline.
>
> Not sure if the above somehow clarify my statements.
>
> As for expanding secmark to 64 bits, I guess that could be an
> interesting follow-up discussion :)

The intersection between netdev and the LSM has a long and somewhat
tortured past with each party making sacrifices along the way to get
where we are at today.  It is far from perfect, at least from a LSM
perspective, but it is what we've got and since performance is usually
used as a club to beat back any changes proposed by the LSM side, I
would like to object to these changes that negatively impact the LSM
performance without some concession in return.  It has been a while
since Casey and I have spoken about this, but I think the prefered
option would be to exchange the current __u32 "sk_buff.secmark" field
with a void* "sk_buff.security" field, like so many other kernel level
objects.  Previous objections have eventually boiled down to the
additional space in the sk_buff for the extra bits (there is some
additional editorializing that could be done here, but I'll refrain),
but based on the comments thus far in this thread it sounds like
perhaps we can now make a deal here: move the LSM field down to a
"colder" cacheline in exchange for converting the LSM field to a
proper pointer.

Thoughts?

-- 
paul moore
www.paul-moore.com
