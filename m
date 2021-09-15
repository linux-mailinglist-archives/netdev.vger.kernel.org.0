Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4240CD0D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 21:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhIOTSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 15:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhIOTSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 15:18:11 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C64C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:16:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so5012226otf.6
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 12:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gh4bn35Ad0vdVDHCviL3VyTRYieJBj2Evni8i7+DXt8=;
        b=RCtJ/Ww8JUDNqMB8/lBzwfKbEuvyuMvQfVHucjMXFjAQ/enuCZqYlrBNhbdVCr0oKu
         9iFp65oC4NyHtVKs/aCybXOTk4NxoScw/jBy6nsLNNlV9XG+lEtdpOOKQB9uA3yNymCX
         ri0s4ZJi5XGqIVcyKBsKKH9FrgvpI6afMzC71bYyjQ9ZF6bbT33NmlQ5Kft5+JApYC4C
         ju6+IaA8gnJDNMELuoFDSm3f4CGDRO+dRf13dS8Fi3T8EQJCBsHcdtYApR5ydswGeiF4
         kdcASjvWSTMooo/Lc6BnpGW4S6QB+u4/ug4LsP5DVpEHF9+NVv5x/Y+E0qvzdziZqdRb
         fFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gh4bn35Ad0vdVDHCviL3VyTRYieJBj2Evni8i7+DXt8=;
        b=r9ckE7N79N59A/N9kDH/TjWjgHoWvJy1TOHW6VcOxcmfqIgFdqYdJSqYVQcrrr4QEH
         Zlk+9t4jdNWxXz1FCZYYSicNpWuAKEWXbTppucur5/vMB+PQlgHazOcOD6rcyib/fWof
         0qJxolwga1WfBezisZXmZJSZEJa88Fh+YdDAY3EbYUfNRkeJtY+Fk4vdQy9bRbS1Fs5/
         wkIWYypkGABynzEAl7I4c2UYwx8LV9aC8AL45G+V0HVgT8wCN0Tr2OP4ZXhRpvHHQ4Rp
         Ft8hBOowIXW0YjcGxYMIrtI9Cq2nY2D7YidSvYddyCSXp6FDI3e08+vS2gO0br282qG2
         kWLA==
X-Gm-Message-State: AOAM5335/jRE0Ojs5ZQBH0Gcv8rmK2RzbcgkXgLdYjGz1Ckfr7HYK4yE
        Rgl0egbmd9bU99d0HFk+TGO1lqSww2SE9GSvejE=
X-Google-Smtp-Source: ABdhPJz9bs25IokICEolN5gSBqRcr2YDZADfY9nkr/HTiobh0+i8sLP1f90mgZ/ELxIDPa+3LTzvKopt9MtFjpisbSM=
X-Received: by 2002:a05:6830:2b2c:: with SMTP id l44mr1451640otv.238.1631733411803;
 Wed, 15 Sep 2021 12:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
In-Reply-To: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
Date:   Wed, 15 Sep 2021 12:16:40 -0700
Message-ID: <CAEuXFExDWaQwJHHQLcMjbFSP-621KUi16BNg=VH-Y5KLk6dhCA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under rtnl
To:     Jiri Benc <jbenc@redhat.com>
Cc:     NetDEV list <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 1:55 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> The loop in i40e_get_capabilities can never end. The problem is that
> although i40e_aq_discover_capabilities returns with an error if there's
> a firmware problem, the returned error is not checked. There is a check for
> pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
> firmware problems.
>
> When i40e_aq_discover_capabilities encounters a firmware problem, it will
> enocunter the same problem on its next invocation. As the result, the loop
> becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but looking
> at the code, it can happen with a range of other firmware errors.
>
> I don't know what the correct behavior should be: whether the firmware
> should be retried a few times, or whether pf->hw.aq.asq_last_status should
> be always set to the encountered firmware error (but then it would be
> pointless and can be just replaced by the i40e_aq_discover_capabilities
> return value). However, the current behavior with an endless loop under the
> rtnl mutex(!) is unacceptable and Intel has not submitted a fix, although we
> explained the bug to them 7 months ago.
>
> This may not be the best possible fix but it's better than hanging the whole
> system on a firmware bug.
>
> Fixes: 56a62fc86895 ("i40e: init code and hardware support")
> Tested-by: Stefan Assmann <sassmann@redhat.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>


Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thanks!
