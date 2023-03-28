Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF556CCDE1
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjC1XIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjC1XIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:08:48 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDE32683
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:08:46 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5419d4c340aso260318267b3.11
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1680044925;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZSQMHyUAqVGVS2BQigz/A6ja8dJSfiSf613vf2Qfabc=;
        b=cVQt9bu7I3EGZHXeNHx3U4o57jcXzPIJjBZMjpKHD/FUnKowQFmQs2AQ4+hk0TZMLe
         9ooVdivzmNZBQPN6C6EW8Zzx/Jh7uVO7Gb+BuedaxYeBCliIHiFPN4eAL10XC92aj7vH
         +e9wUppKga8bQydQE3lwD6FMYb/oQoPDMBPXAOypC+IHg8WnBgQiShkQTltg/fpzFEy2
         BGTYNjh9fqOjAGqkDlBQ8UBUiyYGELN85aHNIBkI/vOhS8mmlYPf6ympIB+hRvNaHq8T
         QbWO1ipKw76wtjrPGos+97NgT9jJ7EW3fweMyFv3HyIGs0YvJncejNxkp0FgeymH/0Ze
         AaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680044925;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZSQMHyUAqVGVS2BQigz/A6ja8dJSfiSf613vf2Qfabc=;
        b=29S5U0IZIs8x8inhHZO5B+3Q7DbTQNjsLFp/rrkKo2S2xDEC2eOruc25LMxubc0JB8
         m3gWXlwqX6leEQCkUg/jlcmLmomZRA5SSil9cAiUWv94a8o4X5rRqGlea5RzIG3U6Ozc
         0cZO/plieFTeML070QwiAOoffbzhphxmUlXgzjmLP1ezvlGX12CizGrSPP6/CagmVYC+
         0f+VUCIvn3uYamXhORezxMS/yOVaoosIIGQNVVKkR3cXcTCdF0wjUNTzqMLV0z1spOEi
         PIuyfNNi3gK1S794xJZZlcPWklxk9PLW5B54ZHVXw3U+zzuKLy7h+evP9xVNWwltC4iD
         gYIQ==
X-Gm-Message-State: AAQBX9fNBnaR2CAhYGtbSnbSfW05rZd/ML3fhxquJ7okTnF2jacp7beq
        VlJ8mmfkPOMrOwRn8xRiCdLEG4D/46xsazAdD3a7
X-Google-Smtp-Source: AKy350abK8FdRjqum0rkpK7dFO74Ka6qWR1lzCgORAvXYVmNk4vPUiF0YnEYgjzDVu8XJA0CXmwa6+vQTcGj4938tKo=
X-Received: by 2002:a81:af18:0:b0:541:7f7b:a2ff with SMTP id
 n24-20020a81af18000000b005417f7ba2ffmr8217177ywh.8.1680044925502; Tue, 28 Mar
 2023 16:08:45 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 Mar 2023 19:08:34 -0400
Message-ID: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
Subject: Potential regression/bug in net/mlx5 driver
To:     Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

Starting with the v6.3-rcX kernel releases I noticed that my
InfiniBand devices were no longer present under /sys/class/infiniband,
causing some of my automated testing to fail.  It took me a while to
find the time to bisect the issue, but I eventually identified the
problematic commit:

  commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
  Author: Shay Drory <shayd@nvidia.com>
  Date:   Wed Jun 29 11:38:21 2022 +0300

   net/mlx5: Enable management PF initialization

   Enable initialization of DPU Management PF, which is a new loopback PF
   designed for communication with BMC.
   For now Management PF doesn't support nor require most upper layer
   protocols so avoid them.

   Signed-off-by: Shay Drory <shayd@nvidia.com>
   Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
   Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
   Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

I'm not a mlx5 driver expert so I can't really offer much in the way
of a fix, but as a quick test I did remove the
'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
everything seemed to work okay on my test system (or rather the tests
ran without problem).

If you need any additional information, or would like me to test a
patch, please let me know.

-- 
paul-moore.com
