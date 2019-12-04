Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A131130CA
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfLDRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:30:08 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44478 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:30:08 -0500
Received: by mail-pj1-f66.google.com with SMTP id w5so82847pjh.11
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 09:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQiqrl+Hf9nh6yjqsNO29WDHQri21nv5UIyJmlJHpa0=;
        b=flBwRlJsmgANom0y6S5hRTA9gO2lPGKd5B/m/VAbFI3UPFcv45gxt9zdMNpqKRl1Cl
         tQyVVYZybVHjKeHrhMbSs3uys9pvKyBQsrQXUSfRSbpmsJ1oSlPwgOYetr1UbD1Teo03
         mJu7o+vEIUzf7ui3rmvg2XSYuE/2CCzexy02it0Y2OeAeqEggHQfOVnAM7Tao2fWR0BZ
         B+9g9tvTdf/g5NPSha2LJZdiy8sNp7sdFLpWo9GEtKWFIelkHANIbW+yv1JumyArEUCs
         bkGZeABtybLimbWk5HIu7m6pT8EOTjkKogbj590Rz2dIOCR2g+9xrWuhjU0XY1LRL02+
         NncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQiqrl+Hf9nh6yjqsNO29WDHQri21nv5UIyJmlJHpa0=;
        b=tO/I4VL9rjQo+tOOBHS3eW+C4wlIEbHU/lWNYugN7A5e1t3kFQOIx2wrg8y2Jhku0e
         A2d6HMNMOPTzcCemRkxFBX4Tm57WZRZCBrw1Aqz/u6BMWw8+Ik7efGsMekkxQqGutX6j
         Jhi5aUUSPQsD/7HVpM30dwaOVbdlrLtNoyGLqc9g4YHuy4XjvSP4gk5m4n0xcwBQ3CP7
         fZry/2fs4H4W4paKbRtUuwziqK/2fbNsBDJWmn+wEoUSwoFmFsAY32SAI7ZiDa7S0YqL
         96IW/CsCiEfawM6Jj67u78xbsgB97vhR0DXUW77YIMa9jR5gKPo/wR0juKDG1W6G/7PO
         94iw==
X-Gm-Message-State: APjAAAUG/cnGqKRWeyRJ1ZBR3PcOp+9URKr+GTPh3xXWA2oqrPT+snJp
        T9ogM9vssDqUBAqW6zWY2cW+VspbfMYHOje9EOE=
X-Google-Smtp-Source: APXvYqx40PpZmZvjaHnnsE4MiqK8Si+zDKBShNd9CO1rePkfy0vizYECT0SnWoTuCRZO6Ct0yk5IJPLahXzMm2eQL88=
X-Received: by 2002:a17:902:9a03:: with SMTP id v3mr4506943plp.61.1575480607585;
 Wed, 04 Dec 2019 09:30:07 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com>
In-Reply-To: <20191130142400.3930-1-ap420073@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Dec 2019 09:29:56 -0800
Message-ID: <CAM_iQpXG-3XBxKxPR5s8jyZEZthaBaG73No3DOqr78aWNn1c3w@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 6:24 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
> return NULL if master node is not existing in the list.
> But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
> could occur.
>
> In the TX datapath, there is no rcu_read_lock() so this patch adds missing
> rcu_read_lock() in the hsr_dev_xmit() too.

Just a correction:
The TX path _has_ RCU read lock, but it harms nothing to take it again.

[...]
>
> Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

This fix is correct. There is no other way to workaround this RCU
rule, checking against NULL is the only way to fix RCU reader
races, so:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>


Taehee, you might have to resend this with my Acked-by as David
probably already drops it from patchwork.

Thanks.
