Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF8E2FE077
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAUEPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbhAUENE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:13:04 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592DDC0613CF;
        Wed, 20 Jan 2021 20:12:22 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id w24so795821ybi.7;
        Wed, 20 Jan 2021 20:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jRWL8RMQmOb+NK0KxjY4VJa2Y3woZ+g4NcmUpul4cuY=;
        b=FVFFSomFFdZOotqwqujg6k7iPgR5/A7DOzndp5HTnKP7sF7Xljgyk2Hzajc3ogDukj
         EscElBIorsCCnJt3ObCJPPG44OkmsyNJZDgb9/NqqZIPcajIUls6MIclI5BbFlIfCFD4
         MJimW7eKEQOy4NRnnoWlPTk407ewkAbiTiQIML0Y47qjL37Ju/v5kxZf3J0t8/TvOave
         CsdYCc3s9GaW53f9/lYWj+E6V2ufc2I4EJRjHwdbcLm0KyHaw95M75JchN2VOVEObpFD
         JJe/Wg/z0+X+3Ys9nnbp5eb319Mnq6s2UQRawE2MKL9cclGNploSGQFsz9aUjSt56Xuo
         sTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jRWL8RMQmOb+NK0KxjY4VJa2Y3woZ+g4NcmUpul4cuY=;
        b=isq7afb8wuiUgfFrZpVSTElk8SbydBIP1oT9L9gz3EzsqkaBZT830abZf6J6RGxxXe
         trHl1ZzcIkWOJo4XNN0fnvdLQiIeYrxHZ4nP+Yv6OCDFwXFsGwEtQVK9GWHK4/ks4TlN
         jUUGZm85iDZ+FQTX8KFnOrnChJlhs9l+KGuS40Yl3UBwww5TpFmcFMjeVT48I0TUQ72C
         eUVzHYA0o17vdPcMVB16Ve1ODh2mot8BF0qrAOO/6EliEXbQJdJMwGycZWw3qYPSTy1B
         oEF4Q3qnbb/yumd98XtxoN65y0i772Ze/hddS3e/mQTdSyh5duTnYAZAbkyEvr8aP2V8
         YDVQ==
X-Gm-Message-State: AOAM530FLJvEzOiQwMqw79shlo+Y+dC4N6fa8mhHO/tVJgDCsgAo3MHW
        7bYknpYD0sCz4c61csAZHfybSdVQlWt7NyB78Za1vCui9rzpoA==
X-Google-Smtp-Source: ABdhPJyoULoeLJHGxuoJKsAUCfelHmBHl/UCgPfOLXHYIgLzWIdKD6gFzo9sFMkfFxkFp5uOG5/VCU0DgfRCeuEo+Og=
X-Received: by 2002:a25:ea53:: with SMTP id o19mr7554881ybe.94.1611202341626;
 Wed, 20 Jan 2021 20:12:21 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 12:11:55 +0800
Message-ID: <CAD-N9QUK-wHnXaWkUiwOLFaQH_P+aHCC79UkB7Zs9OuB93dxfg@mail.gmail.com>
Subject: "WARNING: refcount bug in qrtr_node_lookup" and "WARNING: refcount
 bug in qrtr_recvmsg" should share the same root cause
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear kernel developers,

I found that on the syzbot dashboard, =E2=80=9CWARNING: refcount bug in
qrtr_node_lookup=E2=80=9D[1] and "WARNING: refcount bug in qrtr_recvmsg"[2]
should share the same root cause.

The reasons for the above statement:
1) the stack trace is the same, and this title difference is due to
the inline property of "qrtr_node_lookup";
2) their PoCs are the same as each other;

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

[1] =E2=80=9CWARNING: refcount bug in qrtr_node_lookup=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3De10e2fe9023e90256a35bfd34c181910bf7a=
874d

[2] =E2=80=9CWARNING: refcount bug in qrtr_recvmsg=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3D6532173a22405c4e16c79f35609b71a0e19e=
29ae

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
