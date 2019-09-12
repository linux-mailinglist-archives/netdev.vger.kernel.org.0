Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FC1B0664
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 03:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfILBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 21:10:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33738 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfILBKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 21:10:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so14822080pfl.0
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 18:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idQ02JeU5b91cS+g4Ftx+18xaLuVeqV/HzOrYNwWuRE=;
        b=KO4J2h85AQb0ZcNe//CsmR9JRv7sMg1F2uWDmleiLDrErlv4PajEJLnK1upglqvnCK
         Bb4mkW5QTx74KIzcNms/uDSfTRw2/U05n5xGmq5EMEtw/2YE/nfjMFLV/AfF/fZAv7FW
         aQ6jRKwzkzfdNq1n42kZ4tXt3w8Irt4y6KUAwrac/vQsiZsrE7vuQJ1smwNgfdqh6djq
         YR0ibbinbm3zx1Y6bg34cSPCk2lZWZfF8SaVvLECdqmgNkKFn5o6+4zp6zq8RcHxj9bj
         iNhIjG+2HaTBFKbtkFK2UlziVpmNJkZFB4TCnGkIG946sLMk6iBYm0MQI9a/dftVxeOf
         mJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idQ02JeU5b91cS+g4Ftx+18xaLuVeqV/HzOrYNwWuRE=;
        b=q1CYlhhIRtVhHRQqgMeWN0XlxG9Bk5YsTqTwfh12l5NYNNaZoVpaRjuQyeBsuIIOEt
         j5YU+BI4YTP4rR/R885ukln6bcKp4QN4bLxa8VqOphG/exlNaEmpkLwve6g+Ebkt3Pp7
         HFqP+F8vbsXkkK1PzuMBA3TOdwKP/rWg49jGW1K7D7+fmZL3N6hwYJUOOnE1Gd9J/zbS
         SRbmiHvDpbxhOJr3GEKCYqf3NtxQOqAv0SDhbK96YnqOhBBek2eDxBhEXyNTnWelzi8w
         qG78Xnu/4ARMmNuf3disYV0yF//vV+IISm0AZOWeYB7eAmy4xGolaThXdGYT2nuy8GHh
         RBWg==
X-Gm-Message-State: APjAAAXytXBLrxjC/xemcqeYdHA+7kNeiF/OAhs7Vf7V0Or48lWf9+se
        ZpspbJ5xL3TprbRvja4+eAUh2JAvzAXEwqn+ShZURCEB
X-Google-Smtp-Source: APXvYqwqZ+gGsi9LTkzMybKowcO9B/FN2WIgPhxhtBOrYp7sjBjJkl3dCRRkPPz2xK07sa8vxBVanuFNheJmm7W5X7Y=
X-Received: by 2002:aa7:9117:: with SMTP id 23mr45368584pfh.94.1568250622350;
 Wed, 11 Sep 2019 18:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190911183445.32547-1-xiyou.wangcong@gmail.com> <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com>
In-Reply-To: <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 11 Sep 2019 18:10:10 -0700
Message-ID: <CAM_iQpVP6qVbWmV+kA8UGXG6r1LJftyV32UjUbqryGrX5Ud8Nw@mail.gmail.com>
Subject: Re: [Patch net] sch_sfb: fix a crash in sfb_destroy()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 2:36 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> It seems a similar fix would be needed in net/sched/sch_dsmark.c ?
>

Yeah, or just add a NULL check in dsmark_destroy().

Anyway, I will send a separate patch for it.

Thanks.
