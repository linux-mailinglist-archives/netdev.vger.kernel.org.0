Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D6E1F5D40
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgFJUdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJUdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:33:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E56C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:33:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so4091109ejc.3
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3duwPjVge1QT36mZAd+ftqEzkC7id+2L48L/c8NMj2g=;
        b=H8P3o1nzqcuxd8x+15CJpCrlGb96KK4JPtMaebgIV2jdFb/6blDoVLL85r2EB7tNUm
         Fe9OrJHvD3svSNzGIZajYhi+df6diovdNqT+iwZNa9SZAOkrWXk+EVYxdfWnjtQiNCl7
         wdhGEEIZAdUSR5M0ZZMXb4cDIe81trNgY6zN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3duwPjVge1QT36mZAd+ftqEzkC7id+2L48L/c8NMj2g=;
        b=HRzpCNdgdwQTnhbeUt+RLqIszkBNmv+w+PKJO+8YLVrtDDfwPLzS3rFxmuOg2aHCXv
         gW+J4+C89M51WViLHIeBk6iZFxiD+g8jAG5pWaWdZUSHWgq1UeCS7EK0vCeE5KBjVyKP
         kiFQk75fTA9eImZisD7qRF4Au6/EFJAYkgRzpt6L7e4A4cbUCMPcexsvxHYWQkJPFOJN
         9TYoS2w9MmsezKOUasSFFDFOUQzYW0+n4CY1r7Ip69nQtjOXlMcfevtcgJ2cSm2zlq+0
         L+WDij7A8YpMpRymkpH6gbQfSllSJ+3w4oLC28YCU6vu3x6ErbEtTS4lAuO0GSj8frLJ
         TGJA==
X-Gm-Message-State: AOAM530yOlUferQIfEzEzGC7K2QYQVWxUSJ83JWgtp9w5Qh01d3s9MTI
        dso/FWIQ2HTQRmanxFG6Ol8SsGuVw/QXSY+R4nYwMCXp
X-Google-Smtp-Source: ABdhPJxLMlkAQaayj+M3nx635J6bwqZZ0vjPMUc9YwNSlthvtqt4e/2Il/79lTmmE7iL8my6P0lssW3VKWxMm8tXo6g=
X-Received: by 2002:a17:906:66d0:: with SMTP id k16mr5286550ejp.293.1591821232411;
 Wed, 10 Jun 2020 13:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200609025443.19409-1-dsahern@kernel.org>
In-Reply-To: <20200609025443.19409-1-dsahern@kernel.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 10 Jun 2020 13:33:41 -0700
Message-ID: <CAJieiUiMccp8yXETq6XGdWkKYYtO1XqS+KXfOOYiZAbXCoJiGA@mail.gmail.com>
Subject: Re: [PATCH v2 net] nexthop: Fix fdb labeling for groups
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 7:54 PM David Ahern <dsahern@kernel.org> wrote:
>
> fdb nexthops are marked with a flag. For standalone nexthops, a flag was
> added to the nh_info struct. For groups that flag was added to struct
> nexthop when it should have been added to the group information. Fix
> by removing the flag from the nexthop struct and adding a flag to nh_group
> that mirrors nh_info and is really only a caching of the individual types.
> Add a helper, nexthop_is_fdb, for use by the vxlan code and fixup the
> internal code to use the flag from either nh_info or nh_group.
>
> v2
> - propagate fdb_nh in remove_nh_grp_entry
>
> Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

nice cleanups. Thanks David.

looks like the patches were just applied, FWIW,
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
