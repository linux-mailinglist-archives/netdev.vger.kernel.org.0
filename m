Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13681337F73
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 22:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhCKVNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 16:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhCKVNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 16:13:09 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439E9C061574;
        Thu, 11 Mar 2021 13:12:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t37so3671058pga.11;
        Thu, 11 Mar 2021 13:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzvYjKyt62IHiCr5kkB4Gy+4y5xhft1EvZve9BUvvPg=;
        b=nK76W7i+GqBliQ0em41v8QQPefEcafvPmbHVqWHH2+G0wKCus9aXEXbpnWfbmMy0dZ
         YYGPGwzKrguSGJ5ZsWHJ7SaH9K9h1ABpjbVbsyEXmO1FsBKxW42M/6d23yte3w0Qxi/+
         JBWMAvEc5ENsJ304hNUUkQC5AZjEK2eLoV4b9s0130ocKdWjdPs768nkBiZ9GaMeG1jT
         ebZzedR4hW/wKy6+ISW0nqc/QP7uHo3Aa+RgKhXd3MBzH+yDEIMfZu0GRKQKms81YJLs
         /T7lle7lXvPf+vBNXfMj6gjmg3w9bL/r6hLqy7wZYlJ2h0Uy+r+6u0clNL/WeLBfVS8s
         KbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzvYjKyt62IHiCr5kkB4Gy+4y5xhft1EvZve9BUvvPg=;
        b=pIqclEtM1U5qgVRof+f39YJ/XeKPypLAli6FrU1myxNlZrl/OqNfixocH5aBgnJjAS
         yulujeENsrzdf0FxRpkxRQxCep+fGSe9BIVeDWXCvViVq+xbr6wB7IMmD8fronzA98OZ
         gkDS0iaTeuMfiN6JHlsenvFVyeU1LIKsxWFF1gjoyx21aE8R5tKPqk9SyeD/GZgoPTcX
         tdOu55qjIGOzMo5G6zEMUxh5Don3l2OcYAoEVE0qtwjJ69j8uWJDT1NZMEMsJNkz1rdc
         qLdpA21/yM65I+3MtDESE4ZDLEHS/tr4OYgAtSZSobkVVENxKtOQWN68lM6Uk5ewscNS
         KaQA==
X-Gm-Message-State: AOAM533ria4m692u9ohFnm+AYyoB0ZeKZ/3y4yNChqpyp9omr44tNLMT
        sWdFqAQdSb1o0SDi0Ilai45azFYfyKz/cnVvJS0=
X-Google-Smtp-Source: ABdhPJzusGCSOu+jTBZ4AycWfxtC/PM/JzhkZn9Osc6HFh4pBeYCHJTg/oqxvnhimdW/7m/S7v7Z8Qa6zs7tOoKBrm4=
X-Received: by 2002:aa7:8498:0:b029:1f6:8a25:7ade with SMTP id
 u24-20020aa784980000b02901f68a257ademr9214656pfn.76.1615497156695; Thu, 11
 Mar 2021 13:12:36 -0800 (PST)
MIME-Version: 1.0
References: <20210311072311.2969-1-xie.he.0141@gmail.com> <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 11 Mar 2021 13:12:25 -0800
Message-ID: <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Is this a theoretical issues or do you see a path where it triggers?
>
> Who are the callers sending frames to a device which went down?

This is a theoretical issue. I didn't see this issue in practice.

When "__dev_queue_xmit" and "sch_direct_xmit" call
"dev_hard_start_xmit", there appears to be no locking mechanism
preventing the netif from going down while "dev_hard_start_xmit" is
doing its work.

David once confirmed in an email that a driver's "ndo_stop" function
would indeed race with its "ndo_start_xmit" function:
https://lore.kernel.org/netdev/20190520.200922.2277656639346033061.davem@davemloft.net/
