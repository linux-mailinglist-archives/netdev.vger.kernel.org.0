Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75539C913
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfHZGRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:17:16 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37089 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHZGRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:17:16 -0400
Received: by mail-yw1-f68.google.com with SMTP id u141so6292591ywe.4
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 23:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZalkVlmXpHMIwUhtIlDwMSMoo8aZf245JnsCZRVy4c=;
        b=V/D5VJVIdkt3SVw0YAtkW+EW6EMnhBS/7jJFbZz6OmMjVpR3UgmXWJrBTUCnJWpF+Y
         //uOKiR8WPGkaHC/n8ONDlZD7MJveS3Hgw7fL3psh4rz+5MNnQWVaH7qHNduaGjlC9F7
         L72j5TTyM528vLLqrB3/DKKsLJj96qh6+o6u0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZalkVlmXpHMIwUhtIlDwMSMoo8aZf245JnsCZRVy4c=;
        b=XXCnsK4D0EmBeGMhZCWnzxyLYlP1leAGLCLvJh2wzireqlYjYSkNUbTk9H2jp44GsI
         V2n4MZGpTCEvg2Nc4BZW+hrpk+NazX+5o+u9BVGc6+Ayc4e9EeTlGgW6RAfNaWkrlHUe
         U8trNCvSjyeOnwcRkaLOJFfkUzGoykW4sr1YBUgjnHYFdOSSM8kIZfHvJ7z5tfa4wOYm
         lDahmgiNg77kyZwiQ3JvyiKK8Qu0z3wmdF7tPL18uotkEHujh8z7uAdaGX6NzX3gbrgM
         +G1XV1piv2g09qINFYvhHG+OXTuoehabJdPKmal9f3M5kMw+5VfhwrGPNiBEKU6mMB89
         2mCA==
X-Gm-Message-State: APjAAAXpILeKbUwH3pkzjMqDXuBECRk3elyx1zmKsX3lsvZnFUjWDHwi
        Y92o0JMkHgWOo9Jc6MCOnscnZyn4JfM4HXVTM1t7yA==
X-Google-Smtp-Source: APXvYqyIs3t/ZggFumA7RWm24ff92yVpVgbepAfPkJiynpnnjh6AFeAQ527fDp0nI5iiwNvdZ6EaUG24kl68Qw97edQ=
X-Received: by 2002:a0d:d907:: with SMTP id b7mr10994752ywe.276.1566800235327;
 Sun, 25 Aug 2019 23:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-2-git-send-email-michael.chan@broadcom.com> <20190825.221507.1465677703637201643.davem@davemloft.net>
In-Reply-To: <20190825.221507.1465677703637201643.davem@davemloft.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 25 Aug 2019 23:17:04 -0700
Message-ID: <CACKFLi=v1-CtkAT0TR17pVoB+_RORt3YWE3xq5C6UfDt8BB_sQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/14] bnxt_en: Suppress all error messages in
 hwrm_do_send_msg() in silent mode.
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, Ray Jui <ray.jui@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 10:15 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Sun, 25 Aug 2019 23:54:52 -0400
>
> > If the silent parameter is set, suppress all messages when there is
> > no response from firmware.  When polling for firmware to come out of
> > reset, no response may be normal and we want to suppress the error
> > messages.  Also, don't poll for the firmware DMA response if Bus Master
> > is disabled.  This is in preparation for error recovery when firmware
> > may be in error or reset state or Bus Master is disabled.
> >
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>
> The function bnxt_hwrm_do_send_msg() seems to be an interesting mix of return
> values, what are the semantics?
>
> It seems to use 0 for success, some error codes, and -1.  Does -1 have special
> meaning?
>
> Just curious, and really this unorthodox return value semantic should
> be documented into a comment above the function.

Sadly, it was coded initially to return firmware defined error codes.
But in some cases, the return code gets propagated all the way back to
userspace.  The long term goal is to convert to standard error codes
and so we try to use standard error codes whenever we add new patches
related to this function.  I will see what I can do to make this
better in v2.  Thanks.
