Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37056DFD28
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 07:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfJVFig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 01:38:36 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42991 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfJVFig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 01:38:36 -0400
Received: by mail-yw1-f65.google.com with SMTP id d5so203222ywk.9
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 22:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXG0saMzEAzsEAgaV8rYsByMH+2UbxiUV4+dpUl0nLE=;
        b=eN7xmGZHLCfDrVXJtpRfi8Y7Ys0nL+E4/MtRM9X6UquLtQi12hifLK6cE17za88p2l
         Eadgc/023SLO9ihkJJ4eypsJ3X/pwvoUKVJP45tGaE52ZR9CaaOus8JDEc47+mJmGQMz
         JxIjFKM5kHRnHDAQMfbvgx6XicR6AM1yLq7hU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXG0saMzEAzsEAgaV8rYsByMH+2UbxiUV4+dpUl0nLE=;
        b=B2X56bd7zYAehCqQnyVCrV9UGBrVMoPT7rwTaHnMIov5XjCsnpDyUpCN3tefIIvM3U
         mVdO/7MXOA91gL7xfquwtLyif+HiMo2/Lu3ZBcdNMOIV6wZDaqgB71VuQqmbfB2IL4w4
         +C6tXz10KvCMPbM8gyqrdRW/Dn2D+3rnKjnoO4kEnogYKVre/t8uEaGjRf6Dnr+Kl9qP
         NKpcOxh478BysMq6aOEpJ+FBokpmgNaYzvCax8SYdle3igSrBQGSbapJFjg0LaVAxkLU
         iCYOUfejAh75Beun9MbQtoxER+rpwsR8d/guWoHtPTEsZQv4Nt9WPQeju5oyEsja9n0y
         9F4Q==
X-Gm-Message-State: APjAAAXNEihOO95Lcr0RM9tZUPsF/pvickhd3rpmlLds0tMXlR1goUAY
        pfqHcoaEz4iteX9q+t+gZOH5fiCtNNhUkeBJyKCXwA==
X-Google-Smtp-Source: APXvYqyCyO0Kbn4J/DuWJrEekTH7ePzXTWEbXqMKdJKkG2SWMOdEuB1lfM7fI0n77mSCjBnfG4l9kMbRTtdY6ZOtpj0=
X-Received: by 2002:a81:30cd:: with SMTP id w196mr1080202yww.204.1571722714337;
 Mon, 21 Oct 2019 22:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
 <1571636069-14179-3-git-send-email-michael.chan@broadcom.com> <20191021211425.242beb0e@cakuba.netronome.com>
In-Reply-To: <20191021211425.242beb0e@cakuba.netronome.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 21 Oct 2019 22:38:22 -0700
Message-ID: <CACKFLi=b6XHEaJxF20hQBOuPQO5sdLVd65DgECqMUndsub-5_A@mail.gmail.com>
Subject: Re: [PATCH net 2/5] bnxt_en: Fix devlink NVRAM related byte order
 related issues.
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 9:14 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 21 Oct 2019 01:34:26 -0400, Michael Chan wrote:
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > index 68f74f5..bd4b9f3 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> > @@ -226,12 +226,55 @@ static const struct bnxt_dl_nvm_param nvm_params[] = {
> >        BNXT_NVM_SHARED_CFG, 1, 1},
> >  };
> >
> > +union bnxt_nvm_data {
> > +     u8      val8;
> > +     __le32  val32;
> > +};
> > +
> > +static void bnxt_copy_to_nvm_data(union bnxt_nvm_data *dst,
> > +                               union devlink_param_value *src,
> > +                               int nvm_num_bits, int dl_num_bytes)
> > +{
> > +     u32 val32 = 0;
> > +
> > +     if (nvm_num_bits == 1) {
> > +             dst->val8 = src->vbool;
> > +             return;
> > +     }
>
> Why do you special case the num_bits == 1? If val32 is __le32 the low
> byte would have landed on the first byte anyway, no?
>
> just curious

Just so that I don't have to do any casting.  Otherwise if I assign it
to the __le32, I believe I have to cast to avoid the warning.

>
> > +     if (dl_num_bytes == 4)
> > +             val32 = src->vu32;
> > +     else if (dl_num_bytes == 2)
> > +             val32 = (u32)src->vu16;
> > +     else if (dl_num_bytes == 1)
> > +             val32 = (u32)src->vu8;
> > +     dst->val32 = cpu_to_le32(val32);
> > +}
