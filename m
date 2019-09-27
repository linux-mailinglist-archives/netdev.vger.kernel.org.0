Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E77BFE56
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfI0E6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:58:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38741 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfI0E6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 00:58:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id b20so1154006ljj.5
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 21:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4iU5US/PtNmLXy1Or8iadhw6slNMsSCpg+ZhfRPB2LQ=;
        b=B1xgIrOkcRJn9Z+Gh5PEdkMcD1iNx0NRYLol0iEsGIh9rrJd21uzKyzA0JyQzP2EF8
         45sbwL+QsUE42Gjrtn2jqhyTd44s7rsQHc5KYzQ4SatqWEphTMskH/ZZ+mTneFNp8joa
         +9WoFlutdHEbjnAhI+Jc5G8/y3/DOkeZt4EU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4iU5US/PtNmLXy1Or8iadhw6slNMsSCpg+ZhfRPB2LQ=;
        b=Fgrd+y9sJ90KdK1vYWRDkSVEpIgtIDdzYA09q6lJYko5WNHJ4NYxuHBIqZV6eQEuN+
         06ef2I7LjnSC+n2MDT2U9W8AXTByOdYAJGnLq7fID65b9nQhwfzwHfY8bG7GMXYpt65P
         8FgYQwKsHAKaNDQxYdjNZR1LrMvL/zRdRGaqXHQ5l7SR5/hsDNQQE0HjY1Xzwv8s2DB8
         HzfN/Y661teg3eFwouY88jrXfAN5Vvvnr6Tpf9KSBOeqCk1Vh/6IrlQ2uSyCA1SCf29d
         K9tjMeUGHakzx3V+8QRIDwyrR5tWm8nOcWY3+pZg9gaGA7L7rX/kTwyyFrufhOyI6OGc
         oHKg==
X-Gm-Message-State: APjAAAWuJ9DVFHaaCEVp3FYal9vMvKz6e1U2V+5vb5d9XC+nHnC5uYsj
        SOskRFlgrFsLQRN9W9ZcB+DhWA30kWRomeAnnjPlHQ==
X-Google-Smtp-Source: APXvYqwFNvB9+u/EU7/+K/FxeuhiuB0InjWTyAieKwn08Z9YolPby7krWKqfmo5aRpSZS7jqWcT4+dwLmLGnhvOCxTU=
X-Received: by 2002:a2e:4e12:: with SMTP id c18mr1294713ljb.47.1569560328583;
 Thu, 26 Sep 2019 21:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20190926122726.GE1864@lunn.ch>
In-Reply-To: <20190926122726.GE1864@lunn.ch>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Fri, 27 Sep 2019 10:28:36 +0530
Message-ID: <CAACQVJpgZz3Fb36=x_wPb+hAaXecHj6oVuUsD-GgEhz9yfRgKg@mail.gmail.com>
Subject: Re: [PATCH net] devlink: Fix error handling in param and info_get
 dumpit cb
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Sep 26, 2019 at 03:05:54PM +0530, Vasundhara Volam wrote:
> > If any of the param or info_get op returns error, dumpit cb is
> > skipping to dump remaining params or info_get ops for all the
> > drivers.
> >
> > Instead skip only for the param/info_get op which returned error
> > and continue to dump remaining information, except if the return
> > code is EMSGSIZE.
>
> Hi Vasundhara
>
> How do we get to see something did fail? If it failed, it failed for a
> reason, and we want to know.
>
> What is your real use case here? What is failing, and why are you
> O.K. to skip this failure?
>
>      Andrew
Hi Andrew,

Thank you for looking into the patch.

If any of the devlink parameter is returning error like EINVAL, then
current code is not displaying any further parameters for all the other
devices as well.

In bnxt_en driver case, some of the parameters are not supported in
certain configurations like if the parameter is not part of the
NVM configuration, driver returns EINVAL error to the stack. And devlink is
skipping to display all the remaining parameters for that device and others
as well.

I am trying to fix to skip only the error parameter and display the remaining
parameters.

Thanks,
Vasundhara
