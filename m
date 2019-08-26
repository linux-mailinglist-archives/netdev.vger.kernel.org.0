Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666649C8EF
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfHZGGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:06:47 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37780 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHZGGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:06:46 -0400
Received: by mail-yw1-f65.google.com with SMTP id u141so6286245ywe.4
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 23:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BludPFyajD0FwyVVwHKkkSGs5+iSTY2cpfg9REmZMm4=;
        b=f2F95r5sfJTTrnBo96INOIYGLLI4YXlCGzjBzySslcl59Z6p0+dcrVhBuAWYMctedf
         095/habOFSjvsGfJF7Nlt58HAae+TxsDcPIfIWyjoHEPmEn+Lfj5E8lR8LeunSmLUUa5
         o/KJ6VGxV7xgpahSzFuIv6rW8j1x287AHRU8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BludPFyajD0FwyVVwHKkkSGs5+iSTY2cpfg9REmZMm4=;
        b=oqQ48kvooGS4w9SkGGg97fYIDLeFOhfsXelxBZWRq7oFZyvjKw3WK75MYv2Wmwb7mx
         oTlPlIdl3lO2vliJdc93+rOQxGnbqBJSAJazjpgZsBt72GIejq9o2nphYfsh4Zw9mBC6
         avIoC9D0bcFwEq9lBwzzCWV9Wi10+2Ka87Px0QXMYe9CcyAY0G6fSMvY3mwGg6//5nGi
         yF1kbSer9qlCl/CSvu7QLXUjoUez4nsW6rVCFk3XY/jDtvx1SWPxROj/3jxMGD76crFA
         7bRHwX0YHDY9r5y79emfAjBpicY9YyzOeZTqFPa0tYqO9lzWQoZO8HWKzmQn2O9OgWcS
         hIlA==
X-Gm-Message-State: APjAAAXLzmNMiFhEATFkdsQEghQIhpOmGbXd/rQ4qYg3HRH11Hpjj2WA
        k9sF5cWZHuhPmzPemx6cA2CYZxdzOFCMKiH5rn/E2A==
X-Google-Smtp-Source: APXvYqy1T0AGKoExqtSm4CTji+lnlexGuaOoTVf+KEam15STnFrJF+aUU5j4wgVWYUqXPSwVTzlcHbeO77KmjVxtDMw=
X-Received: by 2002:a81:456:: with SMTP id 83mr12402938ywe.204.1566799605812;
 Sun, 25 Aug 2019 23:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-4-git-send-email-michael.chan@broadcom.com> <20190825.223603.2113058192469260500.davem@davemloft.net>
In-Reply-To: <20190825.223603.2113058192469260500.davem@davemloft.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 25 Aug 2019 23:06:34 -0700
Message-ID: <CACKFLim5F0c+YnOhR+3rv6J3pq-GQUX+6a4WK9F1LZorOG81yw@mail.gmail.com>
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, Ray Jui <ray.jui@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 10:36 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Sun, 25 Aug 2019 23:54:54 -0400
>
> > @@ -687,6 +687,32 @@ static int bnxt_func_cfg(struct bnxt *bp, int num_vfs)
> >               return bnxt_hwrm_func_cfg(bp, num_vfs);
> >  }
> >
> > +int bnxt_cfg_hw_sriov(struct bnxt *bp, int *num_vfs)
> > +{
> > +     int rc;
> > +
> > +     /* Register buffers for VFs */
> > +     rc = bnxt_hwrm_func_buf_rgtr(bp);
> > +     if (rc)
> > +             return rc;
> > +
> > +     /* Reserve resources for VFs */
> > +     rc = bnxt_func_cfg(bp, *num_vfs);
> > +     if (rc != *num_vfs) {
>
> I notice that these two operations are reversed here from where they were in the
> bnxt_sriov_enable() function.  Does the BUF_RGTR operation have to be undone if
> the bnxt_func_cfg() fails?
>
> When it's not a straight extraction of code into a helper function one really
> should do one of two things in my opinion:
>
> 1) Explain the differences in the commit message.
>
> 2) Do a straight extration in one commit, change the ordering in another.

OK.  Will break it up into 2 commits with explanations.  The reason is
that during normal init, the PF is always initialized first and the
exact bring-up sequence does not matter too much.  During error
recovery, the PF and VFs can be all trying to recover at about the
same time and the sequence matters more.  Will explain all of this
again in v2.  Thanks.
