Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6027E11DB44
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfLMAtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 19:49:01 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43202 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730883AbfLMAtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:49:01 -0500
Received: by mail-il1-f196.google.com with SMTP id u16so614378ilg.10;
        Thu, 12 Dec 2019 16:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXMfdGtpPwo1nM9kkoN12NplXgpmiYVMokpj1wCUqnI=;
        b=C82E5s4pRIUwQbm0UuzY7t9EJw8vRJpQLibE2K6+OTEhvb/97vKx0+v2Vt1vaufkV8
         xvVirfJzjvKCwRfqIN2ilj9Bhv4jgameRLMwFNHJNQRs1A/rJ8l2G374RmaXeI9tU3o7
         A9w1LXQJ9kg0Z0OwDDZk3BwY5kFQ/OV3G7Nceg84WHk5njwnCcS+0HzVnegcBzuA4Gga
         8hz9BG1QCTZggxmT9B4j3LHzSMZFYZ25Zi/IH+ytSDLOusjir48JF0XohfFPW9UTAtmU
         604x2Apj2xxlmHhJJwZ/0HTKuw7EAhFcB5xZKRVIO0iJQVFey8u4hPQg3eDzwTpVvBh/
         zaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXMfdGtpPwo1nM9kkoN12NplXgpmiYVMokpj1wCUqnI=;
        b=Ypf7l7B8zk7IZ7Jw5IOkpLBpzkeyhTTFRnNa/KxWsldz5TksjUL7Ak3Sz17oDZCHR/
         gkTZnMSVQgO/n2WVr+Q9PbcveCk0rJ/BekW5U6wA1APmQNYzbfFEQsr7iNLElnQ91zAO
         WMSmAKRcfKb4hZQDPa/PkXoiRCzyis4bGJK0+WofJa8AifMHbpnZJoCCrYzc5nT1e7EZ
         2pxICtRQdZS7M9Obq8qZRnGNe46Q1eXmHn4H5lg2EtliGvHbJ4o7ShITigOjgGaTtj3d
         bCYluMO4LAxpMnUbotXYLFlMu0NeF65UALySF0VE7rcfmgv60d/k3ZzuYIixVxteNFQs
         Z9KA==
X-Gm-Message-State: APjAAAWscoGvb0tU56BS63lTlLYhfYMPJ5j9nCDITfMya3JpR5vlK1YW
        PI+bnumEWu4Gi+s0MotZIhfi9bwaoWakzjJc05gpWw==
X-Google-Smtp-Source: APXvYqxvMYOFRr6KT5lk7SC1D52QaM/O5Dt1mVrz2PTIjrnRB0zIovZeqMEuIpnZCrVKVy1gdr39Tfssc+qgeqbjuig=
X-Received: by 2002:a92:d081:: with SMTP id h1mr10340696ilh.97.1576198140191;
 Thu, 12 Dec 2019 16:49:00 -0800 (PST)
MIME-Version: 1.0
References: <20191212105847.16488-1-gomonovych@gmail.com>
In-Reply-To: <20191212105847.16488-1-gomonovych@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Dec 2019 16:48:49 -0800
Message-ID: <CAKgT0UeTgGmQGEaJ3ePmCoEW5r5KDMmE0c0jrBGGeb-uzbq=3A@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] igb: index regs_buff array via index variable
To:     Vasyl Gomonovych <gomonovych@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 2:58 AM Vasyl Gomonovych <gomonovych@gmail.com> wrote:
>
> This patch is just a preparation for additional register dump in regs_buff.
> To make new register insertion in the middle of regs_buff array easier
> change array indexing to use local counter reg_ix.
>
> ---
>
> Basically this path is just a subject to ask
> How to add a new register to dump from dataseet
> Because it is logically better to add an additional register
> in the middle of an array but that will break ABI.
> To not have the ABI problem we should just add it at the
> end of the array and increase the array size.

So I am pretty sure the patch probably breaks ABI. The reasons for the
fixed offsets is because this driver supports multiple parts that have
different register sets so we cannot have them overlapping.

We cannot change the register locations because it will break the
interface with ethtool. If you need to add additional registers you
will need to add them to the end of the array.
