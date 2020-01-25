Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C4D149255
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgAYAnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:43:35 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37679 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387405AbgAYAnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 19:43:35 -0500
Received: by mail-ot1-f68.google.com with SMTP id d3so3107339otp.4
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 16:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4+Ycv4d3Ya+2+iEbUk6OfRgbmoWhrcwxexxYlBRAIAs=;
        b=ADUj1xHwW29/xy37LSOcFuICzo+/9L7DZ3jNuqOgV1B/m/FAqVr7hhJIXJBVld+UZ6
         jAdVsxCB5MDam6TFedq2hz6QQVpNvbFCa3nKkPe52QgR8+mcWYAFo1r8eR72N+s9xAzg
         ghovPqxWjeoqxqxu3pNdLIwmxUzZZh+koE5kmBDlJVQL06hkgLFEUnTPSifuZvGtmRB9
         UB7hpm9SEx/8VigUR5WgFCKDKHWuG60QfZ9fJhylJkJ2VGTEW2NWxVEp4Vxtg5XWYnWC
         NSL3KP+7P5sSX6qZGU8DkuFfPaQ2MBfuoZL6SSdG04hqle9U2ED1rcGQTdfwioqHQWS4
         iSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4+Ycv4d3Ya+2+iEbUk6OfRgbmoWhrcwxexxYlBRAIAs=;
        b=cCE0Tvn4MNCSZPsjZU9r26g1hIN4c4ZQEzM0Rjp+sSD/w7h7hvzRh/T1In2uICysUm
         pMfudyOyc2DThgayHPhoDid1gvfbgjxY+MBoAboRfNoJDEubqrTxeZp9H8Wd94RpHogH
         vHP80TnQiUe/Zhtfw9rl1AiLAuBxcBiedDzM3G4nwR7+NegOcehzkKVm4J4F0tQEwsXS
         213VUfLfvSeT3MU+SFUuK516vImAixb1YyBsrLIsrNyjmuOMwA87Q35f1RyUad6ltffN
         5/RR+2V0xaXPzG+YQdUqTJg2Nk0BpNfsvPCOk+asz0EM8wHRf2zsOu4nbkzaQzanTY1p
         Iehg==
X-Gm-Message-State: APjAAAXONF7XNAeGTp/afnWV+x3I5AesAdwWCyXc3BEwUQuOTFy4wkeF
        mIoCAHcz5rmFuFWV7QH6e+LBslmuPB6JlSB2OZQ=
X-Google-Smtp-Source: APXvYqxj99Fvmto5LmsPlf3s3eRhN6vgSVJ1emLx+Hv6dqw06Qpx9WsA+BwFO2/4CX293YnF71lWW6QfnswzCadeGBA=
X-Received: by 2002:a9d:62c7:: with SMTP id z7mr4649556otk.189.1579913014222;
 Fri, 24 Jan 2020 16:43:34 -0800 (PST)
MIME-Version: 1.0
References: <20200124225720.150449-1-edumazet@google.com>
In-Reply-To: <20200124225720.150449-1-edumazet@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Jan 2020 16:43:23 -0800
Message-ID: <CAM_iQpU+nA0pM+dC89DvZXWUzp4rnPBOxnHFY+25=F-UHBgS3g@mail.gmail.com>
Subject: Re: [PATCH net] net_sched: ematch: reject invalid TCF_EM_SIMPLE
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 2:57 PM Eric Dumazet <edumazet@google.com> wrote:
>
> It is possible for malicious userspace to set TCF_EM_SIMPLE bit
> even for matches that should not have this bit set.
>
> This can fool two places using tcf_em_is_simple()
>
> 1) tcf_em_tree_destroy() -> memory leak of em->data
>    if ops->destroy() is NULL
>
> 2) tcf_em_tree_dump() wrongly report/leak 4 low-order bytes
>    of a kernel pointer.

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
