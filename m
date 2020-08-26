Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246B3253913
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 22:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHZUXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 16:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHZUXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 16:23:46 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20257C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 13:23:46 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k20so2650684qtq.11
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q7CIavqzl4prPwTgKPP8K9Tv1D7qPz52rBnVD0rJLe0=;
        b=hUToxT9EHUFqY09eIsUAQTC+b1SVG7eJG0JC38xx4VQIpMI01IXZCcIuQOsXIfdUth
         6yhhtT2BiZZ1bXt8LDDMAYWW/ULsJXK8yIu+dtnT1c9ZV41Q+TC6ZbxsDAipnTNmvg94
         b/jRIT296Ubn/Gp8gkRtoHM3c5h5BF9PUgAyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q7CIavqzl4prPwTgKPP8K9Tv1D7qPz52rBnVD0rJLe0=;
        b=qZYcabJYZUNeU23rg3mronNEG7+o00QiOQJLJxjnhHQS5Hi03b/5BZdjZBJ5Bnmwlp
         4Cx8XmgWIxghyI1T1Jpd3qyrGtmQ8khq3CQGYTMSb33cSiSjlsmDVqaFCU5FXHpGebM8
         uLsWgV4NqRD312xIRNzx3cDoDDdbyUCwXuqb2Yz4SAaU80a57s6+9bSOSS+QBPqAgDa7
         QT8sNw9DmpK+4iakjzSuNgMGhFJBeyqN5y3qkg0C1LFH/yyHdy0Lqo8UhY5FlHWndUl8
         sXxsEHHHhNafJjV0y4wnIOTfMLcvHwlCz9AZt1TR+fZGhRBO0daNroseKI+f4ZNm2jXM
         iB0A==
X-Gm-Message-State: AOAM533e11elAvxDaRFiQbIUUwVyniX5GsDlN8KrzI+zDR4ehB9cLXuw
        EviNSdmI8VypY2nVjCAIz57MQpH+fdVyj+HIEIgPbNaWN4A=
X-Google-Smtp-Source: ABdhPJxmcV7uBn31iFczRsYBV9D9TK39WHzX0xCoBQLj9Zod99yjWnPmmVP1T+WKwYiMs6M+jk9GpdAL4POaHoW5koA=
X-Received: by 2002:ac8:4815:: with SMTP id g21mr16138226qtq.148.1598473425094;
 Wed, 26 Aug 2020 13:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200826194007.1962762-1-kuba@kernel.org> <20200826194007.1962762-3-kuba@kernel.org>
In-Reply-To: <20200826194007.1962762-3-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 26 Aug 2020 13:23:33 -0700
Message-ID: <CACKFLineN=vFwJ3QnwKL4cPgv_JVx1r9fCQ9XyWgcyJe2ei2HA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bnxt: don't enable NAPI until rings are ready
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, Rob Sherwood <rsher@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 12:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Netpoll can try to poll napi as soon as napi_enable() is called.
> It crashes trying to access a doorbell which is still NULL:
>
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  CPU: 59 PID: 6039 Comm: ethtool Kdump: loaded Tainted: G S                5.9.0-rc1-00469-g5fd99b5d9950-dirty #26
>  RIP: 0010:bnxt_poll+0x121/0x1c0
>  Code: c4 20 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 8b 86 a0 01 00 00 41 23 85 18 01 00 00 49 8b 96 a8 01 00 00 0d 00 00 00 24 <89> 02
> 41 f6 45 77 02 74 cb 49 8b ae d8 01 00 00 31 c0 c7 44 24 1a
>   netpoll_poll_dev+0xbd/0x1a0
>   __netpoll_send_skb+0x1b2/0x210
>   netpoll_send_udp+0x2c9/0x406
>   write_ext_msg+0x1d7/0x1f0
>   console_unlock+0x23c/0x520
>   vprintk_emit+0xe0/0x1d0
>   printk+0x58/0x6f
>   x86_vector_activate.cold+0xf/0x46
>   __irq_domain_activate_irq+0x50/0x80
>   __irq_domain_activate_irq+0x32/0x80
>   __irq_domain_activate_irq+0x32/0x80
>   irq_domain_activate_irq+0x25/0x40
>   __setup_irq+0x2d2/0x700
>   request_threaded_irq+0xfb/0x160
>   __bnxt_open_nic+0x3b1/0x750
>   bnxt_open_nic+0x19/0x30
>   ethtool_set_channels+0x1ac/0x220
>   dev_ethtool+0x11ba/0x2240
>   dev_ioctl+0x1cf/0x390
>   sock_do_ioctl+0x95/0x130
>
> Reported-by: Rob Sherwood <rsher@fb.com>
> Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
