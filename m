Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B22D6465
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403968AbgLJRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392571AbgLJRLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:11:14 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F80C0617A6;
        Thu, 10 Dec 2020 09:10:21 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id v14so5294164wml.1;
        Thu, 10 Dec 2020 09:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cMIbkw8ToNIRCP5ibpvh5XChPbgC3AeOsLNE8THfWBw=;
        b=lmotrk1DLgtc1ntuVGmQPF+tU/pfVAgXRw3yPneG2vtnDYIcwj1kIG/x92rtSD2a2M
         ixH2yjJDD/rSE6xUz1V8xyRPuR6P0zu86P2kg0My5qmL+EGnbm3sjAWWUb+lHrmJTbWi
         lVFy5ONWJS7/cTQaJEMXFyHSPIVjOHAApfzy7+Br7yVj5fWMgIawiQ6BWXG7aLgP9kbJ
         OPSv71Ff4LgylmLljK6LaZZX2pn0G2ohnYge41hMPShULtK2ABVPwtkTmBm5oGo8+vgP
         X8W4CpzYOUNHgs8fxzimqtuyt2+K7wztVduWdYqIrEi16KTY2slmKFA7ZrR9llGkcS0v
         8mXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cMIbkw8ToNIRCP5ibpvh5XChPbgC3AeOsLNE8THfWBw=;
        b=BvCTQI+TAnOImhCkFo+EK2nI6ujsHV45lwOPWRrMIczh1jzW+WGay9DugFb9IUbrWc
         iZP0Yej/kOhgzEE23H/jH80oYtVvE3kQAX812eZl+VOz/GRc9INbchbkcNhwPsP3v0sV
         otTHsW3MB+z21pnt8UwJSor7sEnC4B30pvYaK/MLuXjB/UJZDb40SBnOCUFas9LoZQ7H
         OihH2yGsz14xuHgqTmrCGW+zb8QXPjIV6Sr/I4O/bX8YyQCCVZ/uIVANt8M6Y4ZyVOPl
         rkXRG6KigqX9fr0mSOclkZICXGcRFabwQ6VQmyUs9aVpau1OxL/7bfnKAv7FImoiUpPD
         7HuQ==
X-Gm-Message-State: AOAM530qcIh9pRnX50ODIYnj+7gSuwBSAgy569TPlStl5Z85htNWdOyu
        mqjrlxPMUgFa3Vl6dc9lYaaPWZG4QO1Gvh/k/dc=
X-Google-Smtp-Source: ABdhPJxjeI41+J/a/a5jp41VltkB46BgA1Q0hs5Mz+qXXaPi74197M+NShjlBtggg+MD7LWdnkEc5vWRSJMxXriyP+s=
X-Received: by 2002:a1c:5506:: with SMTP id j6mr9449234wmb.30.1607620220071;
 Thu, 10 Dec 2020 09:10:20 -0800 (PST)
MIME-Version: 1.0
References: <20201210121915.14412-1-bjorn.topel@gmail.com> <20201210161105.GD45760@ranger.igk.intel.com>
In-Reply-To: <20201210161105.GD45760@ranger.igk.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 10 Dec 2020 18:10:08 +0100
Message-ID: <CAJ+HfNh4LS-25LH0gE0Pun7v=q=8zChmKUaN+hQA_58gwtbZ-g@mail.gmail.com>
Subject: Re: [PATCH net-next] ice, xsk: Move Rx alloction out of while-loop
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 at 17:20, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Dec 10, 2020 at 01:19:15PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Instead of trying to allocate for each packet, move it outside the
> > while loop and try to allocate once every NAPI loop.
>
> To rectify above, it wasn't for each packet but per ICE_RX_BUF_WRITE
> cleaned frames (16).
>
> You also have a typo in subject (alloction).
>
> Is spinning a v2 worth it?
>

Sure! I'll rephrase, and resend!

Thanks,
Bj=C3=B6rn
