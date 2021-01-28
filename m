Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862AF306A9C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhA1BoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhA1Bnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:43:41 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4381BC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:42:54 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id c132so3235116pga.3
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMXOaJFdBcSLDjr7rOQY4WcvdRci/lvulv/TTIPH1Ng=;
        b=F8DkdO9lc28r6qKbpOeriW3J82ZBgr02Y+FfZg7WGTVzZ2PuMjIMz8qI9chUHzI62s
         uZNC6GIRMgUqLQ7rmM5ZHOEpSdmKkhFJ+UNAg5X8iSFm6I2qgkqJCWlDa3BObwd8JEo5
         B/VSYuPSDHVA3lguLcInFovh5KucEvk3jMWvLKlx7B5itD0ncGce2r31YnIE5Ml320rN
         bnSRKKqQfFJirdi1sT9ZepTlsICh+jqOWsL6ZCKb8hxxgSU4GyqM52GNt9eNjcsFP/Bb
         +Pvy/pTbFmuRj7m5JIFIwTRcbQQlTBBs/xEHj/KndDGMTBYNde0/wgdpuUEcG6mabSLJ
         EYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMXOaJFdBcSLDjr7rOQY4WcvdRci/lvulv/TTIPH1Ng=;
        b=GPHZxE5GYpNbh0iHrDvkizhkSLR6XGsMUJtNLhMpFaXnGknehxY8BRHmr5Jl2RHCYR
         lAfqagMhSdb4zXCVwdK0mCGWlgKXRM5DCrXFtgjxW0mEulWLxBrxY2q98I++uKcinws6
         1OlAo0rffvqlmpHW1mCprdPiBHmW/bSlwpftwwlhIyb23nxsuU+gHKQaEBSdneiLc5HF
         whZIj/oQzsNrZM5WoyfNK/nWNmJeGDjnnI7UEMuI8mxvrO3xyPyb0tAajTI0cI3KEPwm
         DQOrFWpIAMOMSNmi1sHCwI33RGw77gARMggkCxv+kjmuyx/ChK68xDkHPBTBOiklbJFY
         Vgpg==
X-Gm-Message-State: AOAM531rIhWvyP0G9FWrYSOjiOyx/5K0u4SZxfjuRwrf2RY3tDV7Chj2
        fRFE08GCgaJw03S6kI33kkmr5gr7m3mbHotpNQQ=
X-Google-Smtp-Source: ABdhPJz9w3EdXcG1jIIW+zmaMeRGv7ygATTxP/w1QGW1QT4G52O9/c+rX3jO9IDOGIFSOcjPoOSvOVUm3qvjKGwMBkU=
X-Received: by 2002:a62:ac18:0:b029:1c0:4398:33b5 with SMTP id
 v24-20020a62ac180000b02901c0439833b5mr13969592pfe.10.1611798173487; Wed, 27
 Jan 2021 17:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com> <261CE3E8-20D1-47E8-98B9-AC685A32C3E1@purdue.edu>
In-Reply-To: <261CE3E8-20D1-47E8-98B9-AC685A32C3E1@purdue.edu>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 27 Jan 2021 17:42:42 -0800
Message-ID: <CAM_iQpUGG2co65Yp379_X=DbyAnUn68nqfKZ4AX4Qb9gWXqU4g@mail.gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:43 AM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
> Hi,
>
> We also found another pair of writer and reader that may suffer the same problem.
>
> A data race may also happen on the variable netdev->dev_addr when functions e1000_set_mac() and packet_getname() run in parallel, eventually it could return a partially updated MAC address to the user, as shown below:

Yeah, this one requires a separate patch, because at least
it uses an index instead of a name to lookup the devices.

Thanks.
