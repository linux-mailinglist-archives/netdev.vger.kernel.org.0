Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97DB247921
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgHQVtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbgHQVtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:49:15 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1A2C061389;
        Mon, 17 Aug 2020 14:49:15 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v4so19196054ljd.0;
        Mon, 17 Aug 2020 14:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6hY9MBbvJRUHoHfTmmW2H8ZYdzIhb3NO63D1Fz9USM=;
        b=JeDB23xEJNjHzgpMA9o5nIWPBadltgHdBr/NIMexx5w28hm7SJforW5cax798gKokK
         KIRKfvNncSZKShC1sc+LqK2IGjnvxCgDf6nnBaPjGZZfXcVE/JqsE8Z21MvnNpg3cejo
         HDfu+/o9i+/I5udW/Eb1gb4Yr5g3lUs/qdj2y4VyE+/bBhIaVZONs8zN5Ec6NlDA+OlI
         TDRgQKTbuJXQ7Xuuh4kAG1RAbGqCpNe1g+eyYg7v5/w+cvnwacfb7a3nf1bLgtZnrXhr
         kZ+ikjXnoALhuwLql9bn21XXlO3LG7GNzCJvu4k+I4niGxkQKTeaZkgHbi8jDc6IiryN
         ya/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6hY9MBbvJRUHoHfTmmW2H8ZYdzIhb3NO63D1Fz9USM=;
        b=aVlQR7LLt6s94SvlxW/7ejeQDGiHdm9VYVr3e1Lduyl8NQc+Cm6TNjcL88+R7hpnhW
         rdIA4237TUWvLVh54BTWS8dt2rYYnDxbtnZlw5nEYOmEYvCBG2Bzw3PFRSZtUliVtDiU
         dgw9QJUtZFTPP2A5KUYkGI9Gz5AYNa7k/lnGNbmLTD0Xd2Lcgvh7qxQhgNxGeGl4Eeou
         btSNXwa7Fllp+bpsUHCCxbJ9U9RIUZg2qtrS5OF5X2LYnCAMy2m+hx5FUCVH88U+MKzw
         Mpc1f/CdNqk25LcyG6/9TlnZs8Skp2LgSlrJXQ93b3RYwhJGVJwcKEtVSm3qkhsFAopR
         S7XA==
X-Gm-Message-State: AOAM533cvTBAV3B/YCoYJdldKDkaK6xBQuJGoOu6PfA6rqo6CmKJqyAE
        emF6qaOIqFf+ooJG6aqhjbSn9Clzpgp7vf8Sb/er4+pd
X-Google-Smtp-Source: ABdhPJyHXpG3O1wD09bXW5hvav2CBeJHa/qxIWoUITkCz/n5Qx9JX3J2E7zF5RQC2mFs2I563E6NFoIU1NVeZtSHCII=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr7790565ljk.290.1597700953482;
 Mon, 17 Aug 2020 14:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200817174214.252601-1-yhs@fb.com> <b1254561-4530-f2d8-bd10-98cb426a727d@toxicpanda.com>
In-Reply-To: <b1254561-4530-f2d8-bd10-98cb426a727d@toxicpanda.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Aug 2020 14:49:02 -0700
Message-ID: <CAADnVQJBCWYm-CiYiJMCLVT03kquZKqdTRMJP7CmL_BWr2Cpnw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: use get_file_rcu() instead of get_file() for
 task_file iterator
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 11:27 AM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On 8/17/20 1:42 PM, Yonghong Song wrote:
> > With latest `bpftool prog` command, we observed the following kernel
> > panic.
> >      BUG: kernel NULL pointer dereference, address: 0000000000000000
> >
> > This patch used get_file_rcu() which only grabs a file if the
> > file->f_count is not zero. This is to ensure the file pointer
> > is always valid. The above reproducer did not fail for more
> > than 30 minutes.
> >
> > Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> > Suggested-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Applied. Thanks
