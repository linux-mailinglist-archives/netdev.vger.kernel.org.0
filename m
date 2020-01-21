Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0211214469D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgAUVqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:46:30 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38111 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgAUVqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:46:30 -0500
Received: by mail-qt1-f195.google.com with SMTP id c24so3994796qtp.5;
        Tue, 21 Jan 2020 13:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhrdhaIEG5bafgeKHJLWIBPWKeJ3SArX4MAGPufEfhY=;
        b=nLNluw+JdlS4hiqmbBx0wnwY6jECy1KDzcqoPn4SByuikWs8s2/h9bX5c0vuhieChM
         sWadJBUNCPWX2cxHMDRp5P4oBY/TwRReKlwm5xVrk9VWGNuSScEYEZ6BeehDIx7FIlyI
         lYMMYvfliv3btcou7DKkjiPxI3lRAxGlMROHvE86DTpV5fBVevNZM/DTfY0j9mRrSQcx
         MqKMMApt4ApIDasho/rPjCKFcEa2NZLmpFgvNPXN/jx36oYRsLdSMCUJabWDDfIdtcXL
         cWLeEXBMTgxd0vjxaPnjCb5nklUf939AVrzCeysnhVw+RkBSHcr4cp4e34ZnAAT8nl7R
         ssPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhrdhaIEG5bafgeKHJLWIBPWKeJ3SArX4MAGPufEfhY=;
        b=Lnh/p9XN9Wc/854/km63gLRNG+CpP8qxF152rSqo1ZZtSqLXadBORA45JpxGOyCQeU
         mcmLvksNC5ygntzS5TdVbWV8M9UcDe1afL8gl08rpT0DYe6IvDSsUQAUTy1pf3cTwQdV
         jwb8nrDOg9ttx11WVoLKIcg11IWNvPsI+oxG0xlK+sjzav5tmYzz+1DVxJVfFTOBIReh
         m1vE6jbOBHzKn2VOGpRTr9qZ/cWikTc1TJ7YWKJut9mtHUnihomvCbZgCnRydFTJ+nZr
         JPsaBPDYnRFWlpewuDolkMUnZBzJYR6vwok5F7mdtIP/g3B5/8d+Pu5Z8TOQUtMhH2Kk
         EJ8g==
X-Gm-Message-State: APjAAAUBHQKYAgNIOzZzlAmz9IoE97MWc3OKI3dE5WEE3orEvOE5Dvq+
        fUCwFHHktfasjrVjaPRJTml1Hc4niaxdmyJipTE=
X-Google-Smtp-Source: APXvYqz3Ule+p0b80zk0GkVM2vtekmrqltyACG++ZoO8vuFUfRLQewDmv3T8n59LAHhIJ9YRd77ym1kBX+lZW9u174g=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr6473744qtq.93.1579643189445;
 Tue, 21 Jan 2020 13:46:29 -0800 (PST)
MIME-Version: 1.0
References: <20200121150431.GA240246@chrisdown.name> <CAEf4BzZj4PEamHktYLHqHrau0_pkr_q-J85MPCzFbe7mtLQ_+Q@mail.gmail.com>
 <20200121202916.GA204956@chrisdown.name>
In-Reply-To: <20200121202916.GA204956@chrisdown.name>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jan 2020 13:46:18 -0800
Message-ID: <CAEf4BzZ5wR_jTEbwYVU-z3ZBP+06p9ZTOeF_DNxqe_nQW493CA@mail.gmail.com>
Subject: Re: [PATCH] bpf: btf: Always output invariant hit in pahole DWARF to
 BTF transform
To:     Chris Down <chris@chrisdown.name>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:29 PM Chris Down <chris@chrisdown.name> wrote:
>
> Andrii Nakryiko writes:
> >> --- a/scripts/link-vmlinux.sh
> >> +++ b/scripts/link-vmlinux.sh
> >> @@ -108,13 +108,15 @@ gen_btf()
> >>         local bin_arch
> >>
> >>         if ! [ -x "$(command -v ${PAHOLE})" ]; then
> >> -               info "BTF" "${1}: pahole (${PAHOLE}) is not available"
> >> +               printf 'BTF: %s: pahole (%s) is not available\n' \
> >> +                       "${1}" "${PAHOLE}" >&2
> >
> >any reason not to use echo instead of printf? would be more minimal change
>
> I generally avoid using echo because it has a bunch of portability gotchas
> which printf mostly doesn't have. If you'd prefer echo, that's fine though,
> just let me know and I can send v2.

The rest of the script is using echo for errors, so let's stick to it
for consistency. Thanks!
