Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDB71C9989
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgEGSpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGSpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:45:50 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD88C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 11:45:50 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id t3so1574964oou.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 11:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKXI3Z5lp062CxQ3udZQbmK+KBJfWzlKCPk8saoygmw=;
        b=KUZ1g8BhWwpAMmfdLYLvfSevbClWArEJ9XL9pt6e6hFfuHXg1lzcihnX9xjNJdfmNJ
         awiBc9rPIywkDFdeWCXVnYFRmZgaZviVP97tBOHhY4H7oErmFd4pVOQaI3Id9EWBTnlz
         Wus/ySbjWOTwNhV4r4Qk8Kcrz8ZbxkSTzjP6cy7kDMyveslgQd6TjON032Gon8YtwP8+
         cGjJNH+BjGCVxfRiwn1DLcLZbiuYw2F/PtoEyahAbbgvWNrIAaqIn/Vh+pyKT8iljQp0
         4ddKYlj32eVah888q5EEcYyNIF450mGf2bSnAjDH4mwdbzN5K1AqYBOGyH7CKPHC2DrV
         e9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKXI3Z5lp062CxQ3udZQbmK+KBJfWzlKCPk8saoygmw=;
        b=QhqjMSKMGcm0wRCg77z0ddzjQh5pIxAqscY7v/ks+h/NWH8HfogKgV9dY5yh/+rnYS
         RcGF3c/Wh6ljvshVfMZcA/cDu0FSIp2sbXF8ZYozucUo4rBa8gTEk9Vu77zOARSIVtBM
         6nViKqXlP7ZqfJX3Aps5crzQCLrRUwoksnpCNuiBdO/YID9ok38FTnz3K3WDQ+h0abQP
         G0NRaAXZIUOQ3UAbe+sT/soUSOKIh5RocGVk/22Fj6kqZ+Qg1cB8E0MRsXwW+izmIqFo
         tXFofT08zv9cmWAg1u1GjOCg+RXSSVBieKs0vbAVAfvH2dJq3msfT925nWHT10gVaBFH
         3yhw==
X-Gm-Message-State: AGi0PuYQmr1vlrP3hZV0AwiFDTTU0PWTJ3LDD3ElsU9aCihMaGcijG88
        VDPYEhJwxVnaht3/KwgXKZY9Qt+69/FIXvaPVhc=
X-Google-Smtp-Source: APiQypJmEvtplD/cC1MXC/ZqbpYbjYNfqWp8Pdumqhf+W8qjBgeE/Nt9aYSU3aCyXjCInMucbSUXhfZopqIEqUJXUG0=
X-Received: by 2002:a4a:5147:: with SMTP id s68mr8249503ooa.86.1588877149202;
 Thu, 07 May 2020 11:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200506194613.18342-1-xiyou.wangcong@gmail.com> <aa811b5e-9408-a078-59ea-2a20c9bff98f@cumulusnetworks.com>
In-Reply-To: <aa811b5e-9408-a078-59ea-2a20c9bff98f@cumulusnetworks.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 7 May 2020 11:45:37 -0700
Message-ID: <CAM_iQpXMZ1u+a+c1eNFThYar4eDFVs2G2F7otHHPK-zye+vzww@mail.gmail.com>
Subject: Re: [Patch net v2] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 1:31 PM Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
> The patch looks good, but note that __netdev_update_features() used to return -1
> before the commit in the Fixes tag above (between 6cb6a27c45ce and 00ee59271777).
> It only restored that behaviour.

Good point! But commit fd867d51f889 is the one which started
using netdev_update_features() in netdev_sync_lower_features(),
your commits 00ee59271777 and 17b85d29e82c are both after it,
and returning whatever doesn't matter before commit fd867d51f889,
therefore, commit fd867d51f889 is the right one to blame?

I will send V3 to just update this Fixes tag.

Thanks!
