Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C863431D138
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhBPTxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBPTxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:53:05 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BD3C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 11:52:25 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cl8so6338820pjb.0
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 11:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OSqBVhiQ+FvusgjRiaAvgy+CC4dTFRNxHUXuJV2iRU4=;
        b=ZptNYNErMQQyOGxP+EwG6Imbk4K0tSZPt7U5CkoSEhHQ+6K8liOGkZkG7ACmj07V9M
         fTHzizzrV63fdz2kIK5N6mcDWbcWny9b9LexAm0KIQzZi/bjijyGzrnFje+IvhUKV3KC
         gr1ni5vdz+0B4G1S8NT3jWDzu/tsV0mGDJqRzZE3txgwPtN9en6/Wdw88TPsEfJYijeV
         0mLQCJG0re0642txK2eVpaCZBcObgwZhzpgdTU8Z85XYQMxjmqKeslkVYMuWMI05rcsN
         wmNBE9FOPB0N8Cx/HWDYXZ8uWZ3+PKU97NsuXBdqM8VIrt6QDxxSfe7fZZsBEKeoWkZw
         8oUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OSqBVhiQ+FvusgjRiaAvgy+CC4dTFRNxHUXuJV2iRU4=;
        b=gDF1YjPX5CNRhbPJ+bu0udIUvRhBvB9pivIPM4XMcExE4Jq69VfiB4n3Bc3eVVB3Sg
         3YYuvZP0KvDpUZibibW0pQy6vIftRbewzNcd5gh2+vqrXix+4qOK39TSMd4nm7qIZH+a
         k4Jd9pxSULsyjmQA7fbwhG5sf01Vqa4qIfO76RQeNyAmYBDiADJDpxxw5pf0YnBsVNRf
         Cfs6b2AbG0LEc7M8KQABddqoJ5FAcWOxARTz/ujv2e2Q32XwVVm60ylzwq1QDrRgY1z2
         qcOiLoUb4IoFQy8ktYHyobgvPJmZQyEPMgvmzyxYLw9gSJwSDHKOB6Ymj3NciNJW08dh
         gdrw==
X-Gm-Message-State: AOAM531DOEcEzRGs503Dv6Gv/Tx8HSJSehVBom+b+DKd3KSQmmuiF0H0
        qtIi4/3DPsQLG0+LTxOSP4TmyEprOnIBqnaOH7lhfGri+N0=
X-Google-Smtp-Source: ABdhPJzMjvQlLrYhnemrCiEEQsJ82e2A5kRuvmIUnECq2sgecqxoj7j/mxy4KeTTvEzoaPlucj6LjID358ei8i97VLw=
X-Received: by 2002:a17:903:114:b029:e2:f8fb:b6a1 with SMTP id
 y20-20020a1709030114b02900e2f8fbb6a1mr21063371plc.77.1613505143917; Tue, 16
 Feb 2021 11:52:23 -0800 (PST)
MIME-Version: 1.0
References: <YCwfQn21MdZmE3CO@mwanda>
In-Reply-To: <YCwfQn21MdZmE3CO@mwanda>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Feb 2021 11:52:12 -0800
Message-ID: <CAM_iQpXb1oUXUEtVxXh8yVKgArx4ANJ3jcMNAOLz+pX2OPxNqw@mail.gmail.com>
Subject: Re: [bug report] net: fix dev_ifsioc_locked() race condition
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Cong Wang ." <cong.wang@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 11:40 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Cong Wang,
>
> The patch 3b23a32a6321: "net: fix dev_ifsioc_locked() race condition"
> from Feb 11, 2021, leads to the following static checker warning:
>
>         drivers/net/tap.c:1095 tap_ioctl()
>         warn: check that 'sa.sa_family' doesn't leak information
>
> drivers/net/tap.c
>   1084
>   1085          case SIOCGIFHWADDR:
>   1086                  rtnl_lock();
>   1087                  tap = tap_get_tap_dev(q);
>   1088                  if (!tap) {
>   1089                          rtnl_unlock();
>   1090                          return -ENOLINK;
>   1091                  }
>   1092                  ret = 0;
>   1093                  dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
>
> How do you want to handle errors from dev_get_mac_address()?

I did have a check there but it turns out unnecessary, because the only
error can happen is when the device name is not found, but here
we already have tap->dev, therefore its name is always there and valid.

Thanks.
