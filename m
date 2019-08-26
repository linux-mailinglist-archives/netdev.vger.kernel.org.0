Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D79C962
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfHZGYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:24:08 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36400 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHZGYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:24:08 -0400
Received: by mail-yb1-f194.google.com with SMTP id m9so6616320ybm.3
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PlQj5PBx8xMn441J3+FavvXyg9bHgoJljFyChzijmbo=;
        b=AkmT9fxZT7kiiFXuGUknHNUKoS0cNUuuu1D1PLOdpmVzvisq25/nDEM2HHRwHLO+86
         ON+kgUn+Lt+tXYluuc8oKefIyR29QJK+oFM+538KnfKkHQ0qCH5kux6Ut6f/8FaP/e03
         CnfQ6gwxEwkhNywDn4E3wOSkB64YjjiwPoVr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PlQj5PBx8xMn441J3+FavvXyg9bHgoJljFyChzijmbo=;
        b=Et9nIeKCSdfYtnDE0s3+7TnmU5QOddCgkeI+U1U9jaZNZ2AB2598fBtz0LvmA+ifg9
         XncmQRyoBkzMlV/BcsazdJ91ZEldn7T72KGfLP4j1V+mvmItxnI1lI6uACVu4XU8ng+A
         iumHB2CwoHMp/i3yDed3uM2gFJSedCpTgUcG+mXzMKuUY+AC0Jn0/OhvcS8g6gdjOPRB
         KfWnBwXXvEXuvQeEYPhU8NJtBgbcOn3N872CKRVVPNFnBnYdp2lyK5NpNyntBktEF+gr
         dTSXpKJfV191be1YcbxAST6X+vs6fs8eXbXh/j22Yp6fj9UzLNP4srLB33g6GnaBqMmm
         8kpg==
X-Gm-Message-State: APjAAAVqTjGQ8Je3nT516QhPHItPvVt0ttILKOJoRgPuh6Kf4w/VITPJ
        o/i9AVebUxZrzD2FMn9EWbNO76GDJ+pZQ/4ss/UKgA==
X-Google-Smtp-Source: APXvYqxjdcvz2m4TxLOhsZDOCcNEBJQreGO0EfyKgMj+M23MQQPrvm4k+lH5T1+S/iUIFaVAcZEAkGSkOQ4THhdaYWQ=
X-Received: by 2002:a25:3557:: with SMTP id c84mr11581955yba.298.1566800647671;
 Sun, 25 Aug 2019 23:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-6-git-send-email-michael.chan@broadcom.com> <20190825.224913.1760774642952210371.davem@davemloft.net>
In-Reply-To: <20190825.224913.1760774642952210371.davem@davemloft.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 25 Aug 2019 23:23:56 -0700
Message-ID: <CACKFLi=j=zzUnWS2_Bf8iW_q==AR9rkQZNo90RJc8zMjwoaDxA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/14] bnxt_en: Discover firmware error recovery capabilities.
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, Ray Jui <ray.jui@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 10:49 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Sun, 25 Aug 2019 23:54:56 -0400
>
> > +static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
> > +{
> > +     struct hwrm_error_recovery_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
> > +     struct bnxt_fw_health *fw_health = bp->fw_health;
> > +     struct hwrm_error_recovery_qcfg_input req = {0};
> > +     int rc, i;
> > +
> > +     if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
> > +             return 0;
> > +
> > +     bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_ERROR_RECOVERY_QCFG, -1, -1);
> > +     mutex_lock(&bp->hwrm_cmd_lock);
> > +     rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
> > +     if (rc) {
> > +             rc = -EOPNOTSUPP;
> > +             goto err_recovery_out;
> > +     }
>
> How is this logically an unsupported operation if you're guarding it's use
> with an appropriate capability check?

The BNXT_FW_CAP_ERROR_RECOVERY flag says that error recovery should be
supported, but if the firmware call to get the recovery parameters
fails, we return -EOPNOTSUPP to let the caller know that error
recovery cannot be supported.  Again, I will try to clean up the error
codes in v2.
