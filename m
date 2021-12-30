Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363424818EB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhL3D0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhL3D0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:26:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF7DC061574;
        Wed, 29 Dec 2021 19:26:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id co15so20215513pjb.2;
        Wed, 29 Dec 2021 19:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :mime-version:content-transfer-encoding;
        bh=ofv+ig4Wx8qebQrDZMDFO2CVtyMzGrEQqhqLdwrpW0c=;
        b=HD+KqXgpG8pfB7vBU++LgKNfwUuQ5b1VxU3eU0WuvdLaV6+fI50k5HLH77kGvFRQ/5
         UQvL/6IvwXFzgn+g2UZcEq2ScNz7Xcp3ufpzT4m0dCEvf0WKFOJqMdKk1R3Qv1zEkflz
         oxI8nFEHVnpzd+5bG9CMtG7L8ZTkgEnUMyl9WHSv78HSaAMvJtrkjLTrVXft3fwnnCrF
         ++dv8XzMBtwiRtgihk9FLZnnbkfc+seFvMO6DbbGQAgXYA4UbbaFkftIywXV2ifLl1BX
         ILKiRydbJitxcBt+Lty8TRtxdDHzfbEye46lriKBEMkaSiZE6RyLoTx6MC6JSFGqjT6e
         +1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:mime-version:content-transfer-encoding;
        bh=ofv+ig4Wx8qebQrDZMDFO2CVtyMzGrEQqhqLdwrpW0c=;
        b=ZtjcaAHQITzjgvT10vx3hu9RBk2T+ugDSj15uUdhBHff/ZL1RWB8kpqGnKV+ED57pH
         1AriIsn385Dr48oztga3E/dTwzGGmCwq25f94qtz4OrQzktvMmO6r4CpyUja/naRk2ym
         E/qH5T0NERwh7cdW6km9tcObAdGu26rlcTQfGZIxU977UfMlfWQ735Kz/kc2MvksxB+o
         dMixHyypZm3HS8+8Yr77FAXhXslgMqYJCwBfTo+ei54cx9d9+WqYw+7Bb42aJy8CA0Hd
         ZkrBixg5orqHAn8Rpes2rO0F0X9MsydDKbLQj1XKbCpvMlXnlpr8FWkjmxa4pJ1x/6AJ
         0Iog==
X-Gm-Message-State: AOAM533Hx+G+LmmfJc2J/68aOKK98F5w81yoeAJp0QECWrLv6bciDRk+
        GtzvSgwY/p1hoh/TePS4qqA=
X-Google-Smtp-Source: ABdhPJw1+yT647+Cuhggz5IWtq1YkOVficr513yqN86w73A2+KpxsXE03kS2+ZY/ZTPcvN4yqTQULw==
X-Received: by 2002:a17:90b:3b85:: with SMTP id pc5mr35764489pjb.15.1640834796055;
        Wed, 29 Dec 2021 19:26:36 -0800 (PST)
Received: from [30.135.82.251] ([23.98.35.75])
        by smtp.gmail.com with ESMTPSA id c13sm25719923pfv.20.2021.12.29.19.26.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Dec 2021 19:26:35 -0800 (PST)
User-Agent: Microsoft-MacOutlook/16.56.21121100
Date:   Thu, 30 Dec 2021 11:26:31 +0800
Subject: [Resource Leak] Missing closing files in samples/bpf/hbm.c
From:   Ryan Cai <ycaibb@gmail.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <BCA4C02F-0238-4818-BDF1-2F0411CD95A6@gmail.com>
Thread-Topic: [Resource Leak] Missing closing files in samples/bpf/hbm.c
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kernel maintainers,

          1. In run_bpf_prog, the file opened at Line 308 may not closed when going to Line 310.
          Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/samples/bpf/hbm.c#L302-L310

         2. In read_trace_pipe2, the file opened at Line 91 may not closed in the function.
         Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/samples/bpf/hbm.c#L91-L109

           Should it be a bug? I can send a patch for these.

Best,
Ryan


