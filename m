Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5117F18C126
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCSUQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:16:58 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32918 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgCSUQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 16:16:58 -0400
Received: by mail-qt1-f193.google.com with SMTP id d22so3088169qtn.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 13:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JErCvWaKpcJG3GRh9rczgHuqJsPxETBAnwDOnv64wK0=;
        b=CrH1MwrL4RrmFjNPxD7z2Y8VGWOUV2eHnS1Dz5/oRHf3/qP6ZmugmO6PAscS7JQTN0
         4xIUYEPY5ddHhVGWELcl4LQU/JEdAW88JrrL+B3j7jzEMHq7Ss5z588mxphfl/p0E3ZS
         nUNmEHIqllbk9R9D8G9KyrWsuAUBgbrvvuQCDUXwcke5k6xXReDUdSnLPuxQPgFHsl20
         RljmyoItfoEAqzAlr78Ey/8Xi5+D9fb/a+1Dri/V+TM5UGOxXLYS3tMCxxrntIFWR16l
         MpQCAEwAQcH7Ie5T+dMvp2Eh1r+z7EyseRlWTzm9VrfGGCFkIU2nGFdvFXDoEdKuWRPD
         BW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JErCvWaKpcJG3GRh9rczgHuqJsPxETBAnwDOnv64wK0=;
        b=WnFN6No+QS7KP/pqDePR4Ys7AWz0PFQolqmKUjmIINTb3F8kNfyFu1w7CAr/rBFZ5a
         Db4f7/BGkEFBXaBiGwuEcYxF5wshI6lndOn/yPh3WT3aSVARbeAVQ5nFNbjsnf1IZleR
         Z8PYJgW4pZI+VE3GQ80MDM1qC/kxvsQSy6hVqypv2FQfvtzkgQNfwSdiQzby21xUz42X
         lCVU+sgFhOOfXLxgKPcgByscrK8nq5BtTGemEsY2iOR3K2r2vsDEkrxHHZFqySK7AopM
         ph+6jnaIOiM3nOLolIrY8IOEi5sIQQS9r0M0od/A1d/smypr9ZuBTY2JxRejoz3P25Sm
         CyxA==
X-Gm-Message-State: ANhLgQ2VfO2849RWAe+eKmsZhFCr7CYzcVgnVvAJ9VZInnKNGKweBNJy
        XzFRUB6KdQstsF8ZGEe9C9wVW3KA8J1JMT1PkeE=
X-Google-Smtp-Source: ADFU+vs7GC118FtEz6+r8jnFVGS6TDfUfRM7QYHZ4Smm31FdlI1W2KF5HqhPOU284HOi5sELLt60szfXabgIr/mRBKc=
X-Received: by 2002:ac8:708f:: with SMTP id y15mr4957349qto.35.1584649016647;
 Thu, 19 Mar 2020 13:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <557d411272605c1611a209389ee198c534efde56.1584099517.git.petrm@mellanox.com>
In-Reply-To: <557d411272605c1611a209389ee198c534efde56.1584099517.git.petrm@mellanox.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 19 Mar 2020 13:16:20 -0700
Message-ID: <CALDO+SYHvFY1ygvSEp05sEcN6pQ6+z=U4giaCv_j7viRgnFj+Q@mail.gmail.com>
Subject: Re: [PATCH net] net: ip_gre: Separate ERSPAN newlink / changelink callbacks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Meenakshi Vohra <mvohra@vmware.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 4:40 AM Petr Machata <petrm@mellanox.com> wrote:
>
> ERSPAN shares most of the code path with GRE and gretap code. While that
> helps keep the code compact, it is also error prone. Currently a broken
> userspace can turn a gretap tunnel into a de facto ERSPAN one by passing
> IFLA_GRE_ERSPAN_VER. There has been a similar issue in ip6gretap in the
> past.
>
> To prevent these problems in future, split the newlink and changelink code
> paths. Split the ERSPAN code out of ipgre_netlink_parms() into a new
> function erspan_netlink_parms(). Extract a piece of common logic from
> ipgre_newlink() and ipgre_changelink() into ipgre_newlink_encap_setup().
> Add erspan_newlink() and erspan_changelink().
>
> Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---

I found this already applied. Looks good to me, thanks!

William
