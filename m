Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F91D057E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgEMDZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:25:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110ADC061A0C;
        Tue, 12 May 2020 20:25:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w18so3554445ilm.13;
        Tue, 12 May 2020 20:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2hpSCEA71CdBoR8zyCf5TsQFdbDC/7JhU+YtBp8w/M=;
        b=SD72C28YR1ZFgOrMY4hBeDisEq8Cnui1Bt30cjyF5urT9CHr5KTC5UShjWOESwR3kB
         3hk9XToUwnUHuKcLDHEi0dnkVNfTjSd9LiZORhnINQAIG7MVwUSSELI2w17/oB7MVDOk
         YPKjrnVJ4knRlH+2bfIfseuh4PFPk0afcJtvYtSMjAAdc4JmLgyoh63IZxQuvCv0sxYM
         CXRV6eRr4uH1cNvQFVVv4+dYS7Uy4tcxChEFhPifECmVL2N43p92irilI3FQ1BC6hd9U
         mf3f0LZrFEHim7woJiNc//I44ebLpS+mzG2NCUACpP50L0nYzFG85lCnMTxSUdCpP7Qz
         vvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2hpSCEA71CdBoR8zyCf5TsQFdbDC/7JhU+YtBp8w/M=;
        b=lmh/66GemW4v4XTGU/9A6qn/TDMPNqyr+oGWVplsRE2jeCO+DS3hcT0wORDJDR2E7u
         HiI8gnaKbvx2+15wA063/eX5cJJyq7yl6x3+XGQETuxtstr6TxDsFjKhb0kLjVD0bjbo
         yX3N4OpGmvYbe5Dy4zAPPEsNU/7OIf86d9cUJ6gbCARDpIlqI1UmdSRLDpAA8L6ZAfES
         welOFnBo6ZX33OrwioPCY92eVd1QtcCSYRDtj8Zzbv0gyHiybOzfJ2ocFE761lSXO0t+
         Ej5TLJ5nt+OW2vIL3p1l86Cxi/+Vru8Fj6zyi5CQZPzlJmbCi6AKbOsEuEXSOHNH1RPm
         4YzA==
X-Gm-Message-State: AGi0Pua5Tp01lOaov2YSgs4TRTKXmqzvS+A4v1xbocAyLbkqzvEuS4zv
        8HN4/xiyuatTm6p62Tkl22E9O6uNir5WlZi8kek=
X-Google-Smtp-Source: APiQypJnUo4uwgtS1g9yU7Bk0lrPGmYugPhbKHnO907ATbaaQs+jEqpVaMdl34GTTkUaypnqbRf9pMbdNEsZvV3eDB4=
X-Received: by 2002:a92:8c4c:: with SMTP id o73mr12333010ild.172.1589340304245;
 Tue, 12 May 2020 20:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190906185931.19288-1-navid.emamdoost@gmail.com> <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
In-Reply-To: <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Tue, 12 May 2020 22:24:53 -0500
Message-ID: <CAEkB2EQf-Q+q9QSwwj=Q208yAJj5hhSDrDiHqyU3WeSod2Bo+Q@mail.gmail.com>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
To:     Brian Norris <briannorris@chromium.org>
Cc:     Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Brian,

On Tue, May 12, 2020 at 11:57 AM Brian Norris <briannorris@chromium.org> wrote:
>
> On Fri, Sep 6, 2019 at 11:59 AM Navid Emamdoost
> <navid.emamdoost@gmail.com> wrote:
> >
> > In ath9k_wmi_cmd, the allocated network buffer needs to be released
> > if timeout happens. Otherwise memory will be leaked.
> >
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
>
> I wonder, did you actually test your patches? I ask, because it seems
> that all your patches are of the same mechanical variety (produced by
> some sort of research project?), and if I look around a bit, I see
I found this via static analysis and as a result, did had the inputs
to test it with (like the way fuzzing works).
It may be beneficial if you could point me to any testing
infrastructure that you use or are aware of for future cases.

> several mistakes and regressions noted on your other patches. And
> recently, I see someone reporting a 5.4 kernel regression, which looks
> a lot like it was caused by this patch:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=207703#c1
>
> I'll propose a revert, if there's no evidence this was actually tested
> or otherwise confirmed to fix a real bug.
>
> Brian



-- 
Navid.
