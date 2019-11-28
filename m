Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6B810C107
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 01:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfK1AlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 19:41:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38417 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfK1AlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 19:41:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id k8so15940894ljh.5;
        Wed, 27 Nov 2019 16:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvu64NikACq5/BZpMK0YEoaDtqoElFVQ0FT0sMi/njQ=;
        b=k02EbuSANwSzijDzWvcSI+MBHbc0Sz/o/04hKRvzCmsOgarPlk1ySZluajsMW5tdRF
         TSc9KloKYiah+bBXqzKbXVmV+hAWTGpEc1SR/GcDObSib1UPw3oXWJ1Xiph9GVQptcfs
         juB4I8gqkmiVJC1G34ijKdK9G7VvR1i6JarusZicJoiXLADIG22+fpwCJnYJwn71J/p/
         PBsV53KuYeIx4c5vc3UYAPU1VS97K+LgsgwTbmTe7dnlf74BF1DQf48fsGhMWmYBbXLU
         Zal5EtcFxatij3+3fK2xRa/Eyp4zeyFwHW6EOfSJlAVAt/3IFB2aDfLaeOohNA1+srAL
         Md3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvu64NikACq5/BZpMK0YEoaDtqoElFVQ0FT0sMi/njQ=;
        b=YvnZo320My6yo8M2XUCDnrde9Z3RWBx4Az3zZILBWxJU+kBS3giu6AvGKEG7J4GgN+
         TC2Dcr9+kdm2kuNyMZemgRl0Ebl/nt3pKnO6hshscXB5imT44y/mB8vTLXDpgXSXbVBy
         b27KsN5zFDujLDVjIFjlz/Pc21Iu35x+FfaH4PTgtYEKAlkCNe/Hh9AsTfA7UTBtqW0d
         ru3wMBde3Jtt0OWZQd1CVwKKuhLcnIa9LPRQKq8+P3+H/ml9YwMTw6XT1P27vlEbERPX
         9xMyMnFLk8XAHAPSgmC5o8atHFxYx13a7cm5RgFVAzJjgQ2aznsiJ7QivCnRAgbMQwvY
         bXJA==
X-Gm-Message-State: APjAAAVdZ1X9bCn2FyZzEeMKj1uST+Gv7Oj2wyX5VldMJm41UpwNQVQz
        JbUXX+/rkhStzu8Z98mTigKEHM82f6l23SzDu3c=
X-Google-Smtp-Source: APXvYqxs50oxQLtQjGRbHCo2hcWkeU9KhQC6u7WCDsbmA6yfzK9ustOL2DF7yN6airdg1pcbzs+Lgs7SQTf42poiaAk=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr31755680ljn.188.1574901666523;
 Wed, 27 Nov 2019 16:41:06 -0800 (PST)
MIME-Version: 1.0
References: <20191127200651.1381348-1-andriin@fb.com>
In-Reply-To: <20191127200651.1381348-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 16:40:55 -0800
Message-ID: <CAADnVQ+A-Phuzir80BskhVug6YOuuT0qNiA0Vpn_pbbeT5BM3g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] libbpf: fix global variable relocation
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 12:07 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Similarly to a0d7da26ce86 ("libbpf: Fix call relocation offset calculation
> bug"), relocations against global variables need to take into account
> referenced symbol's st_value, which holds offset into a corresponding data
> section (and, subsequently, offset into internal backing map). For static
> variables this offset is always zero and data offset is completely described
> by respective instruction's imm field.
>
> Convert a bunch of selftests to global variables. Previously they were relying
> on `static volatile` trick to ensure Clang doesn't inline static variables,
> which with global variables is not necessary anymore.
>
> Fixes: 393cdfbee809 ("libbpf: Support initialized global variables")
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
