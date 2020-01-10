Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1481364FE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 02:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgAJBqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 20:46:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35483 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730359AbgAJBqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 20:46:42 -0500
Received: by mail-lj1-f196.google.com with SMTP id j1so423854lja.2;
        Thu, 09 Jan 2020 17:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nu9o4Usn+XhhTssE2tuKwzbDJpJogNs10wYB6Hk9aLU=;
        b=QU9cVNOdIny75ExLkTUqV8qDXZ/gyefZ1Fg6cjZsPfdP6+jPMyUe7bkcquB0ZNATha
         dF/qlP6r1GXuoY+i57wUWM0ImXJ7pSxjNMI5k5pvShpLrZH3xU6pyqVpCRrwOvD2iRge
         AhunSMyaYLl4cHuEUhqU9a+uEcz3OuCKILZKZVvomunTkGsVMVPgtCy4uddpSxr0K7f3
         manUr48L9a5cWhy7QqRCXJ5ISzNdfzHmrrwXcn1ZbhrRLXeELKdkUKMyd1fGk0nwONUJ
         vUi2dYyCpCqJ+wClTsEUHSIM117xtvRGv9vIbC4G47eqI81ZHunQEg/+Kc1sZc0KkRan
         Bt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nu9o4Usn+XhhTssE2tuKwzbDJpJogNs10wYB6Hk9aLU=;
        b=CBTrKeBMfgVdWVte+ZCvDh1viufbtqH/8k1zHcEJv4FHPZBz99NHTF/If3mPmdTnQ5
         fW+YpgoQt4V4NKHbrgUNEx//8XPj0vn13C4gyIwPTPg+KMiDeAc95zao9l7zhAbd+jYi
         3xmAkCte3ry8qOF2IcALHLcANuOtRB1LoX79m1/GhM31f29337KpByT7uix0YLGAKS51
         ZN/gENi8IGrRP3pRgVkabHQiHnSWyI+Oes0d+lJCKjJK+0IeM3IcJhy71ruRAzprRs2B
         krfUIDB1g1u8vbB6FlzBNP9QvkKdYgg/gs+DwxaCgzhKfXrDQ3dWcBiHasxM4NVxnP+b
         YaEQ==
X-Gm-Message-State: APjAAAXWD3QqP0d8ApjIRcdzspENoXtz9AwskPWBBRqKGAFxBLXD2xzr
        0IiQjd1kS5ImDsPwcGt4Fkil7crF7pJKRD4ISFE=
X-Google-Smtp-Source: APXvYqzVnM+wRhqDPtLpDj9H9gWsgeafo8RLs3jkivqTevnFuaj9U8p0xL+qDorMdpoln4wIYrP5mVkUD5gTunyLiy8=
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr672128ljk.228.1578620800941;
 Thu, 09 Jan 2020 17:46:40 -0800 (PST)
MIME-Version: 1.0
References: <20191218173827.20584-1-cneirabustos@gmail.com>
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jan 2020 17:46:29 -0800
Message-ID: <CAADnVQKQLTLvND=249aR2tYm-SxcJ9BbVi-SQUwuoOpt01knZw@mail.gmail.com>
Subject: Re: [PATCH v16 0/5] BPF: New helper to obtain namespace data from
 current task
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 9:38 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> scripts but this helper returns the pid as seen by the root namespace which is
> fine when a bcc script is not executed inside a container.
> When the process of interest is inside a container, pid filtering will not work
> if bpf_get_current_pid_tgid() is used.
> This helper addresses this limitation returning the pid as it's seen by the current
> namespace where the script is executing.
>
> In the future different pid_ns files may belong to different devices, according to the
> discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> used to do pid filtering even inside a container.

I think the set looks like fine. Please respin against bpf-next
carrying over Yonghong's ack and I'll apply it.
Please squash patch 2 and 3 together.
Updates to tools/uapi/bpf.h don't need to be separated anymore.
Patch 5 can be squashed into them as well.
Could you also improve selftest from patch 4 to test new helper
both inside and outside of some container?
With unshare(CLONE_NEWPID) or something.
Do you have corresponding bcc change to show how it's going to be used?
