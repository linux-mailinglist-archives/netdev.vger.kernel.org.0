Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B939BC13F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 07:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408653AbfIXFN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 01:13:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38864 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404357AbfIXFN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 01:13:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so573273pgi.5
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 22:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOYOJU9SkZ4s5di4+Iqk5kHSUgwz+SeX8s4QQNrqWbw=;
        b=TB5AtLMBeJigVPhocy83+GaFuNeCrZn7oUP+0XRWSR8i48EN72I3Os+jJ68ODokHbB
         k/5ReFWPDl9IZJ/OCs94r66yK8LStSrziCwHJ4ErazQ1ufybHWLMB7F4bG+VVz4FQlaj
         0YClCADaNli6Hs8nkgEKUaMPjk0aGLN5kYAgmmpkdMO3JMUuibhT5OTEPMD73gVnpbRt
         WOkRCjXD7WWKuzT0Iqbq2ZnBkm7vm1us/bEekLOn+QAc/6NE0GV2v7oo++jB3BDZcKE9
         g4dSfHHxhZxhSKyQrB7h9TmdCV63cDwRN+eCuusQAo6uVe96jn/ZKqrepIEOV3Ce0UCy
         t6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOYOJU9SkZ4s5di4+Iqk5kHSUgwz+SeX8s4QQNrqWbw=;
        b=fRwoVR8przPr3Bkc6VKmOEfbsGvQ974ZrcJllLA5RBzuWJWvsgDD+rexhXFlCuHZvc
         qFocRMesIwW5LTrWRXIveMFka6dzFfdF/3nz0wMIUIrkXjH34FgtqFUTmaSLJchfIkqa
         wLyDczIEjDWy4slx5ymaNacK9EQENynyIjA/SLo54PLRk/LTXdpVIoVJr9qDn+SYPD1U
         /6UjIu/F7+sVF2wDTCIYxaZrMW7nQSDf1Bflelu2zC3Zf1xFFGMmjhvxW22jgWa0snf0
         URlWSSgiymzs6UuIuzggYRD1YupuvDxufOAEV3OKIHzjAngOudu9BeX+mOmQjM+ZIpTY
         yfrg==
X-Gm-Message-State: APjAAAVXp9B0vayD4eoie51KY+Hwjt9GdDPYE2ih6JdM3Ohane1JpSfr
        M6I/Lkdmn7SIINySJ0V6MgQO0EgdqovlfausMcY=
X-Google-Smtp-Source: APXvYqwGJdEDmGmFTPkuTVOnUHloh7Bug2pf2qlo7J1sZr6FZJF03O2mMPwsrYKZGMFXyLgD9G41iDZyMDLnI/Cp5AE=
X-Received: by 2002:a65:404b:: with SMTP id h11mr1274565pgp.237.1569302036024;
 Mon, 23 Sep 2019 22:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190924050458.14223-1-vinicius.gomes@intel.com>
In-Reply-To: <20190924050458.14223-1-vinicius.gomes@intel.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Sep 2019 22:13:44 -0700
Message-ID: <CAM_iQpULcemS9QQTrYH_FVCjik1E_=LqxEKbX3YH11W8i3t=bg@mail.gmail.com>
Subject: Re: [PATCH net v3] net/sched: cbs: Fix not adding cbs instance to list
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 10:04 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> When removing a cbs instance when offloading is enabled, the crash
> below can be observed.
>
> The problem happens because that when offloading is enabled, the cbs
> instance is not added to the list.
>
> Also, the current code doesn't handle correctly the case when offload
> is disabled without removing the qdisc: if the link speed changes the
> credit calculations will be wrong. When we create the cbs instance
> with offloading enabled, it's not added to the notification list, when
> later we disable offloading, it's not in the list, so link speed
> changes will not affect it.
>
> The solution for both issues is the same, add the cbs instance being
> created unconditionally to the global list, even if the link state
> notification isn't useful "right now".
>
...
> Fixes: e0a7683 ("net/sched: cbs: fix port_rate miscalculation")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
