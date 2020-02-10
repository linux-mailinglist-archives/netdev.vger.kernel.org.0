Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029C3156E7C
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 05:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBJEno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 23:43:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34438 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJEno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 23:43:44 -0500
Received: by mail-qk1-f196.google.com with SMTP id a23so5345591qka.1
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 20:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfoBXSjIiP8bllXnjsNJlexmsGl/T8lS+3Z9r/hB9J4=;
        b=Or5PPChHnJb2WYfuYZQn5LcPcG+4S0oUa6CEBGa8uN7wSJTMgD83h8WvZ08To226Zh
         kmuWp343QTfT6s8FZjIMMAc/ejQoceVg7X/YPRp/Q1OBlL7gzQdPhk0BuX+5vFofG68j
         GDcd9EFzhMIZaY06JaFfNCL0zVKHbMPCK+oCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfoBXSjIiP8bllXnjsNJlexmsGl/T8lS+3Z9r/hB9J4=;
        b=n2J8Ill1W1LvEM0NMc4OtDW/ossoGAHxSTqbk2XLHiSqzyvv9RG7lOQ2I1wa0seKpU
         jmCKfnzNgUeFP+YQ2QXuDWJ6hBJ9CEz27RhDqAHf0bBen1WUdVMS11leQfq016Jh0EKS
         ur750AJTSspXWDnyejuCowQRDOiPSCKAdZnVNDUIziiO6lG0tV0PYnSwAr542KzkrgWO
         9+ScbTbOUKhXBsZ/LI3w/ohCzFSg6cicPwyJ0EADLbq/ApQv5Pc+4rvgtzWGV9c3i9MC
         tHnyaQRTUfRqevXTgKJW5rV03bzppPO23aKjONuuTK/fOM0XEcK4+MMg8LhoyfEvWm/J
         k+lQ==
X-Gm-Message-State: APjAAAWmmTXuZ59RO3ysXHsVdCJ/p/CrxdjNMGBMhy5O2VDZJpkjw4oQ
        ZrLwLr8iRgvc6HdfwAQX9p6/+aA40CfidQ83r1C1Yg==
X-Google-Smtp-Source: APXvYqw8dPSqQFU+D7xMcBArzOUhkZS2pJSS3gbAxOPmLzQy7t+t3RnKEOu+DRRxgzTC13CoGYNOrgikqc0vxnJJcH4=
X-Received: by 2002:a05:620a:b0f:: with SMTP id t15mr8941217qkg.135.1581309823409;
 Sun, 09 Feb 2020 20:43:43 -0800 (PST)
MIME-Version: 1.0
References: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <cover.1576629200.git.ethercflow@gmail.com> <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
 <51564b9e-35f0-3c73-1701-8e351f2482d7@iogearbox.net> <CABtjQmbh080cFr9e_V_vutb1fErRcCvw-bNNYeJHOcah-adFCA@mail.gmail.com>
 <20200116085943.GA270346@krava>
In-Reply-To: <20200116085943.GA270346@krava>
From:   Brendan Gregg <bgregg@netflix.com>
Date:   Sun, 9 Feb 2020 20:43:17 -0800
Message-ID: <CAJN39ogSo=bEEydp7s34AjtDVwXxw7_hQFrARWE4NXQwRZxSxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 12:59 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Dec 20, 2019 at 11:35:08AM +0800, Wenbo Zhang wrote:
> > > [ Wenbo, please keep also Al (added here) in the loop since he was providing
> > >    feedback on prior submissions as well wrt vfs bits. ]
> >
> > Get it, thank you!
>
> hi,
> is this stuck on review? I'd like to see this merged ;-)

Is this still waiting on someone? I'm writing some docs on analyzing
file systems via syscall tracing and this will be a big improvement.
Thanks,

Brendan

>
> we have bpftrace change using it already.. from that side:
>
> Tested-by: Jiri Olsa <jolsa@kernel.org>
>
> thanks,
> jirka
>


-- 
Brendan Gregg, Senior Performance Architect, Netflix
