Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81732355386
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbhDFMVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbhDFMVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:21:24 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2B2C06174A;
        Tue,  6 Apr 2021 05:21:16 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id c24-20020a9d6c980000b02902662e210895so13905030otr.9;
        Tue, 06 Apr 2021 05:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9lAlLZr8tKO15BbkeX+4g0xdqCHrPXZs+uVHbHRyh8=;
        b=FeBKtoigdXaKyPCPoqmrVXazdfDOedaQmJ81boviv3VOItTFeUIP3rWbF8J4KRSTm6
         z8NSNYQ/8rPCw/BA6QaJVaH9BgA0QC3j7DQMnmw5w3Zkha/yPFV0fchK1HUtcic6+kkE
         Cm6o7jjznmuMghIYNMBSnKQ1/mDrVBm6M7xHqd/Lh/zxCBdQKIiPrtuUmqI4KOJtjghP
         aEeItxit4V0Om4r9qgOTZrmVSlGfgjJxEjj5yQFzX6//b823yh0sN9y+JbBeR1vI9siC
         VFtLA7vFRl4aTYo7PxEsTGyEGf0Na8/1pDlVHmIVUZIrIpY3YTopeXTzgaN68enh0naT
         8dPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9lAlLZr8tKO15BbkeX+4g0xdqCHrPXZs+uVHbHRyh8=;
        b=MwxsBTVN3PYrSgNANnE0roM7ZGUTPhr2ve347iB4f/a1bHyMDwEZrJwrhn+cbgDMNn
         ifVBwRrwYTQOLhVjI1kK9JIg++1PCMf2y366gq/zZTPHWS8k9+MJV15fJDJZL97aE70e
         BMlAZJwUhqWHUxKMSCaQuMub0iAhk4K9z8m+SnoIAppIjwsRGbrzp+GnwxQO+2CPT9/X
         L4ER+WIFaqoyCZ7sjH66HYhiWeVCFvQvT4/2L9ykZk9B+5bZF1VBvuCws6shOGzBFvXo
         +gT94rO4X9v/V3iWxlGFPpAMTue23KkRjEsSUIlESOt6lZU8glSX+xJH0SRWjW9B4Eb2
         iM/g==
X-Gm-Message-State: AOAM531Bjl0zaW6hhKbeNElQ2/5x8je7NFs1r8sd6ENEA78e2m+6wN2o
        Ljx2HskB8N5YpLndF5wder6pPxxdQBsclUV65n2PnRGW
X-Google-Smtp-Source: ABdhPJxjESgsYwy5aCjseX7IJhKXDdoJycZ5Ma5erPve/AgxPQ90x0GEZTH7irQQF6V5y8GMoLAzPi8BdFi9r/kB2eU=
X-Received: by 2002:a05:6830:111a:: with SMTP id w26mr19323837otq.329.1617711674983;
 Tue, 06 Apr 2021 05:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210405195744.19386-1-paskripkin@gmail.com>
In-Reply-To: <20210405195744.19386-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 6 Apr 2021 08:21:04 -0400
Message-ID: <CAB_54W7R-27cwOTUw1Db1+kbWTMTtRn0X2EW1_9nKuiAWpLFfA@mail.gmail.com>
Subject: Re: [PATCH] net: fix shift-out-of-bounds in nl802154_new_interface
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 5 Apr 2021 at 15:58, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> syzbot reported shift-out-of-bounds in nl802154_new_interface.
> The problem was in signed representation of enum nl802154_iftype
>
> enum nl802154_iftype {
>         /* for backwards compatibility TODO */
>         NL802154_IFTYPE_UNSPEC = -1,
> ...
>
> Since, enum has negative value in it, objects of this type
> will be represented as signed integer.
>
>         type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
>
> u32 will be casted to signed, which can cause negative value type.
>
> Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Yes, this patch will fix the issue but we discussed that the problem
is deeper than such a fix. The real problem is that we are using a -1
value which doesn't fit into the u32 netlink value and it gets
converted back and forward which we should avoid.

- Alex
