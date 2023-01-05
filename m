Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9965F2E3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjAERhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjAERhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:37:36 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75A6A195
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:37:35 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e76so4429594ybh.11
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 09:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LEe8LTVp6m/fM8HWc7MuZNc0hbwgXvDbUrSPuW0bCiA=;
        b=iRu46Ch0OWzuSwZRMenxtchb+7sHIFgDd9lV5cxXbDL0lVoRdMh47fR+2njDiistkk
         8YNMaizPlvfpE8raxnRMCSwJOnnDNX2KbQIUSfjj9fR2FmytN2Qo5PEKd0uyuT8pR8Me
         V7RgoGOLi1ujpBQV9eJpV9RN5tzhY9IcjfL4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LEe8LTVp6m/fM8HWc7MuZNc0hbwgXvDbUrSPuW0bCiA=;
        b=VthJw1ZhNlpa6creYmAeZlrlPauLoVOJH9RpKcoB/GUkJZPvDoQiX8C0EB8aElni0m
         2x9bn2oNbtdXlXVxtSIB9GI+zuNnNYPsqfytfeamsl0325oCOd8jceZZK637bjfr0Lba
         6STZ7qi6fDkSVHjOW+K5vVVLEEo0eCniZdfjIfVstvdKM3gv2V02F1yLOHLELG2MfQKu
         Nu3jvidtBLnZE2/vjIAVy5pn8AlWa2pCuGqLrDLrdEK/6XA+CiVGVivjCFpBV4NJ3yh0
         uXCGHJT4ZIsl9Z3/reT28PgqzZgC5ode+4WqDBD+z3JMTT0oyj+AWDeInSIDQOAkzAuq
         kyuQ==
X-Gm-Message-State: AFqh2kp/k1x2pXfGViQwH7XrJCS3PEmD/fKow3GA+tihtB/6JBv19uVZ
        ZF771Siiqqm08MD/FLvIqnc2JsQ2537KnqZToUW7FCzqKjKorg==
X-Google-Smtp-Source: AMrXdXt5L8b4mTGCrM1Hoy2fE2RD+0ONJXSfjWxSLe92+rV7sdb4Nai0UupEWWyHlaZe3fi7jLbdHVHQkAopMo1Ha60=
X-Received: by 2002:a25:73d3:0:b0:700:1dd4:bbfa with SMTP id
 o202-20020a2573d3000000b007001dd4bbfamr7081826ybc.455.1672940255072; Thu, 05
 Jan 2023 09:37:35 -0800 (PST)
MIME-Version: 1.0
From:   Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date:   Thu, 5 Jan 2023 18:37:09 +0100
Message-ID: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
Subject: Network performance regression with linux 6.1.y. Issue bisected to
 "5eddb24901ee49eee23c0bfce6af2e83fd5679bd" (gro: add support of (hw)gro
 packets to gro stack)
To:     edumazet@google.com, netdev@vger.kernel.org, lixiaoyan@google.com,
        pabeni@redhat.com, davem@davemloft.net
Cc:     Igor Raits <igor.raits@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I would like to report a 6.1,y regression in a network performance
observed when using "git clone".

BAD: "git clone" speed with kernel 6.1,y:
   # git clone git@github.com:..../.....git
   ...
   Receiving objects:   8% (47797/571306), 20.69 MiB | 3.27 MiB/s

GOOD: "git clone" speed with kernel 6.0,y:
   # git clone git@github.com:..../.....git
   ...
   Receiving objects:  72% (411341/571306), 181.05 MiB | 60.27 MiB/s

I bisected the issue to a commit
5eddb24901ee49eee23c0bfce6af2e83fd5679bd "gro: add support of (hw)gro
packets to gro stack". Reverting it from 6.1.y branch makes the git
clone fast like with 6.0.y.

Best regards,
--
Jaroslav Pulchart
Sr. Principal SW Engineer
GoodData
