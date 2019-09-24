Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820E9BC0E2
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 06:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391377AbfIXEWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 00:22:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33883 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfIXEWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 00:22:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so444079pfa.1
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 21:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zkjb+SArzMj9wgG8LvOYEvfbWfiagJWbV3mxzAW6qOs=;
        b=MCqlY3v74Nv2Cg8yibjB6s0bKWtsixTQtq6hlVKm6O/TnJhvgIs+24630Jts8eGlIE
         FmfXOuyld679A1KYjc4Z5wbNuAnkoCyDZJV8/L9dlgllUSig2mrwTzutir4BRDYusNYh
         Tpc0nWHghBcsvJNPU1CUDSNhgzSu4I0NjFXK8qrRYpOrox2CdblzIOUpSQT04W8BtppJ
         yhaHxLWP/I9kwGoE7nPtED0p5WPGuWslKmqbn+OTI7DA8xynxaDYZKFhq+1Tgq6jk0rw
         peFtC5658crg6Ox7bU1e/Jc5pfxJuQgQkeyaiLSCb3BPfR2qho2ekFJ+MNG8GCBR9/+N
         hMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zkjb+SArzMj9wgG8LvOYEvfbWfiagJWbV3mxzAW6qOs=;
        b=kP1svUzaSxuH/Umpr93gR+fdDY0dVie9bv/g4veDZYmz5UgzaQYAkWnq5pFA03zY4R
         a+11PaIUtqn6Yl/xIutF/T65K09blfIjftb97iSIUzZJw6Ic8Z9vAHemJcm65rR0oNZ8
         oaVo0KHfg2WT6DoM4fVlTptyidTI3Fo3qbNL9FOckvMAvYl518g9QF0YobWnlRmeLdNj
         ta+Yp+kHF8osxeUNDGf3lhaCDM24TuzuxcNp12kfT+RdpZhwaWlYx1i3tg0v5QPU6s4i
         p86SMG3piAKlWtPAXNH8YuFT0il5Br3biWDV1tHD6+oWMiOKiNGEJWHV6Yl7Xth1yr2X
         ms3w==
X-Gm-Message-State: APjAAAWG6QGBpaj77ke+RC3sMboWA4tuzklZaZxgxt82UXEjbOJ/OISU
        McEuPkyD28gfCwr0KNTPzGvTxRIl5mr2XycmhvM=
X-Google-Smtp-Source: APXvYqwswdaBzMVn3P7LzxaL3gtX2ajzAklaAAMzW004kKwi9iCYuOciMvDAn6bc65fUHNP1PYhZbiJGAg4ZgmodU/U=
X-Received: by 2002:a63:ca43:: with SMTP id o3mr1130173pgi.104.1569298933610;
 Mon, 23 Sep 2019 21:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190924001502.22384-1-vinicius.gomes@intel.com>
In-Reply-To: <20190924001502.22384-1-vinicius.gomes@intel.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Sep 2019 21:22:02 -0700
Message-ID: <CAM_iQpVsNdqQPY5p8ZaN6_soBx+TuTT_vjfYWod7LrSuw3ufeA@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: cbs: Fix not adding cbs instance to list
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

On Mon, Sep 23, 2019 at 5:14 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
> @@ -417,12 +421,6 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
>         if (err)
>                 return err;
>
> -       if (!q->offload) {
> -               spin_lock(&cbs_list_lock);
> -               list_add(&q->cbs_list, &cbs_list);
> -               spin_unlock(&cbs_list_lock);
> -       }
> -
>         return 0;

These two return's now can be folded into one, right?
