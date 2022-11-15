Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A99629138
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 05:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiKOElq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 23:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKOElp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 23:41:45 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879912DD2
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 20:41:43 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id b3so22661334lfv.2
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 20:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqQy12XFUgnRX9khT+cCXlW9/foyJ4blhF6LQ95A76o=;
        b=ymIiSOwr+xJ3hkk1bsxngM5c4I/NcP7YEEPNxG3Y0tSJVubX1CM7f9DK23Umg9yJ44
         NiwO7ZJOb3I09eUX9A+4FyeXqRy1lKcInvlXti9nkJYn6sJFNcKAS5qLW60M3oDcIYln
         aa69ezSd+XqwdoyMTmViJHv2l4lwwlwGJW6ltlJhfqoYjmwRZZ7e+YKwNRsCuucO+rKK
         lJ6Aj4ldHwdR80NXKzch3WnPjDLkHB8XGE9A6eTCdHB54VXSkN+L7ROyKXlQ1plT+yz+
         4wu9JXdR1406uHMAza5i/VlOolSdxPILa6+9GE69yaSpFlawxywxnVkAm6iauQiEJ30w
         fc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqQy12XFUgnRX9khT+cCXlW9/foyJ4blhF6LQ95A76o=;
        b=OJwX13IeBQG5gmlcKiVFCIgsHOkWPjNmKMFgP9gmQB4OsX95e5ZfmW+9AdzBm7vuTH
         YB4e+ilaLhc2IuVbkGcBPCO0xX7BrfIJHmQ642a81/zGXQP2URZzDv7+DtOh7dqM2Tnh
         5B6hDqJYMoUmmiYxoApf+zi6THMmXJHkqtrP6ac30jbQ8dIktfNy5K+BnLsRSK8FLvAK
         la/vqx29gYGRCO8TjFwumqvrVGqjff+1R7lO+UEPhlmEoEj/gg+pYCetfM/o4ebynM9L
         hnz9Q/UFFfYkxSJ0mBFPhA6dUvLfoC1nQ20nNBjQPLes/jW/3USbG3JorcblspKj0O1M
         qa6A==
X-Gm-Message-State: ANoB5pn5MQAyyGlPGLvsYsZA3upZC+zDarGyi/pXneW1mT9PrjAEmfp2
        mVVauNZi+RkkgaQdRNXyj9jtNRQeG57czNHZSbC28g==
X-Google-Smtp-Source: AA0mqf7PGbhFEQTgl170EIMeU+SkqzjqGlEjJt4q3rDzWM60/551o2ctSv2MQPBxypSrc9BWQUwB4qKfc1ReUxnAXpg=
X-Received: by 2002:a19:7411:0:b0:4b1:215b:167d with SMTP id
 v17-20020a197411000000b004b1215b167dmr5423887lfe.558.1668487301857; Mon, 14
 Nov 2022 20:41:41 -0800 (PST)
MIME-Version: 1.0
References: <CABymUCNq9yqhAS0zxg+-gsCjj0GgTd=wmT7TjOcRz2TTew8zDA@mail.gmail.com>
 <697a57bd-8507-1477-0176-e840b2e2f809@kernel.org>
In-Reply-To: <697a57bd-8507-1477-0176-e840b2e2f809@kernel.org>
From:   Jun Nie <jun.nie@linaro.org>
Date:   Tue, 15 Nov 2022 12:41:30 +0800
Message-ID: <CABymUCNd36Z6F3miBfSSeaXnyNT5OH_S1j6FBFM=aV_x3dfiug@mail.gmail.com>
Subject: Re: [BUG REPORT] f2fs: use-after-free during garbage collection
To:     Chao Yu <chao@kernel.org>
Cc:     jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lee Jones <joneslee@google.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chao Yu <chao@kernel.org> =E4=BA=8E2022=E5=B9=B411=E6=9C=8815=E6=97=A5=E5=
=91=A8=E4=BA=8C 00:02=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2022/11/14 9:47, Jun Nie wrote:
> > Hi  Chao & Jaegeuk,
> >
> > There is a KASAN report[0] that shows invalid memory
> > access(use-after-free) in f2fs garbage collection process, and this
> > issue is fixed by a recent f2fs patch set[1]. The KASAN report is cause=
d
> > by an abnormal sum->ofs_in_node value 0xc3f1 in the first check. And
> > the investigation indicates that the f2fs_summary_block address range
> > is not from f2fs_kzalloc() in build_curseg(). The memory
> > allocation/free happens in non-f2fs thread, such as network. So I
> > guess the f2fs subsystem is accessing memory that's not belong to f2fs
> > in some cases. With the below commit merged into mainline recently,
> > this  use-after-free issue disappears. But there is another thread
> > blocked issue as below. The patch c6ad7fd16657 check the valid
> > ofs_in_node and stop further gc. I am not sure whether it is expected
> > that the f2fs_summary_block address in gc thread is not from
> > allocation in build_curseg(). Because I am not familiar with f2fs.
> >
> > Could you help comment on my question and new issue? Is there any work
> > in progress to fix the new blocked issue? Thanks!
>
> Please check below patch:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/chao/linux.git/commit/?h=
=3Ddev-test&id=3D2272d08781a73b6d7039ed70f6d68d87ac82f256
>
Thanks for the patch! I cherry pick below 3 patches from your branch to mai=
nline
to test the bug. It is not reproduced any more.

b380cedda7c3 f2fs: fix to do sanity check on i_extra_isize in is_alive()
cdcb173c158e f2fs: Fix the race condition of resize flag between resizefs
c316fb60f5fb f2fs: should put a page when checking the summary info

BTW:  below log line is repeated endless if cdcb173c158e is missing.
[  142.766237][    T9] F2FS-fs (loop0): Inconsistent blkaddr offset:
base:9, ofs_in_node:50161, max:923, ino:8, nid:8

Regards,
Jun


> Thanks,
>
> >
> > [0] https://syzkaller.appspot.com/bug?id=3D4cbcff00422ea402c2e5be2bc041=
a8f4196d608c
> > [1] c6ad7fd16657 f2fs: fix to do sanity check on summary info
> >
