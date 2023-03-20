Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A196C110F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCTLpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjCTLpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:45:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF8158AC;
        Mon, 20 Mar 2023 04:45:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id le6so12081717plb.12;
        Mon, 20 Mar 2023 04:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679312713;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2EdCdWaxl6aSDm2/QNnErzsl1SoS7RrMeG7Y44iKUtc=;
        b=C8obbCNO7LejGk5rUhOzu1LitH8G2CvYqXpW3dW3Oedqzodtr0rk41gi7CdYDAge5j
         oVRhkfHNTWVF07feFWtcK4fjvG1Cw8xPjJ/yb+jwE9eQmxViwPZfCvWGAuSHWMEnGQyh
         w2nkV8EndlS0GjJNT/xy16JZhB9KQE9tqA8EwY5UajOpBYbi8M6u3UCtR9BTu8sQR030
         v48qDfGg0zjHpIl1yLuMfT44LUxd8c/BOvTMkR7myfFgdhFt1oll9MAwbyP8j1s9Wv2+
         +ta6yfTTS9m0S57Yxsl5jpMXMUs+tzI3oQdq/xwBLpeDdbYvBcVY6KwZnC1nE9NrOi6m
         3rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679312713;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2EdCdWaxl6aSDm2/QNnErzsl1SoS7RrMeG7Y44iKUtc=;
        b=U5XZxMI7NBnxk71R/2tX0UD8i8gfy7AS6csbFws6qsBHZaEGhvZaJQE4E1PTtSyqRW
         YbEklYEIV51QwZ22dUxF5YTzTSznaweG9fsw5T2izTJ16qQl/ZvcWKh8sNBLj48Ux3Jt
         uC0E7QS9iOl1t1kDykh0kBRlFEAcAYkwbxb1D5MFRC/L12lV2r2GYY4kbitehpLU8TwJ
         QKDRQPwiOvSGVyiNq/c7Gr/AHg1sYbb7Vm6WADckUcbFPACqk6xOvGn1yw3PHq1UQoWA
         MKqBdM/3toyPh8K9isalpfZOcYs3vbwuHqPvIfg6bpwxVQDRndLKJprzWIDPpTOPU4JQ
         suDQ==
X-Gm-Message-State: AO0yUKVhieuCSH4hli+KnDKFIlC805WJ6/fPV5AVB+m8ZZmf7RsXpEqU
        DXk315g9bBb3dTfCEP9ApMoEV7z7kHEJwxYfHJwAhPDwLvuqBw==
X-Google-Smtp-Source: AK7set9lsKgECwAaF4Mi4ekuWPRLfs3oBAOMq5N51WI+PAYsScCs3n44HDIOR65QZyUd8NRcpIYl4X0qyGp2Zd9869A=
X-Received: by 2002:a17:90a:e38b:b0:23d:33e5:33ec with SMTP id
 b11-20020a17090ae38b00b0023d33e533ecmr4781688pjz.1.1679312712605; Mon, 20 Mar
 2023 04:45:12 -0700 (PDT)
MIME-Version: 1.0
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Mon, 20 Mar 2023 17:15:00 +0530
Message-ID: <CAE2MWkm=zvkF_Ge1MH7vn+dmMboNt+pOEEVSgSeNNPRY5VmroA@mail.gmail.com>
Subject: Multicast: handling of STA disconnect
To:     roopa@nvidia.com, razor@blackwall.org, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, Kernel <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

I have some query on multicast. When streams running on an STA and STA
disconnected due to some reason. So, until the MDB is timed out the
stream will be forwarded to the port and in turn to the driver and
dropps there as no such STA.

So, is the multicast_eht handling this scenario to take any action
immediately? If not, can we do this to take quick action to reduce
overhead of memory and driver?

I have an idea on this. Can we mark this port group (MDB entry) as
INACTIVE from the WiFi disconnect event and skip forwarding the stream
to this port in br_multicast_flood by applying the check? I can share
the patch on this.

Thanks,
UjjaL Roy
