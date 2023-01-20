Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B5A67551F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjATNAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjATM77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:59:59 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1733F9AA94
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:59:58 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4d5097a95f5so49251427b3.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZBoALcB10lksUkFczXWPKEYnMtzexv2Nczt6VtbfSDc=;
        b=XBziqNruH8D85pt4BBwC1q9npq1EEUdwQtgghgpdrsGDkTDYGXf2HEr2eLWUKITWKN
         ARuNcFdbX9Nbnv1VgYkZYZtYaLW5y8zdj8igaDyvwlM9GZdmPh4Wn0OHoGQGGFn4zKqJ
         +LAH0H9fq0RZq5lMtVfUx+Cmq5Bgq2eSqQW7oxpM8pB+hSbXOatsB3HcjwpyqvUO51SD
         Xhf6boZ5/S43nelqlL2jYS2jdYL7QALo8mqAzZ/gZ+kvLrOpfElOOnL5C6NmKhJGrGsk
         CLWfiL8gpso//JBsLPk2wjWqJhzMyHxFQq0nqn9OqNYMAdBlyfsZBLHA7J4BnNrUtem2
         UAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZBoALcB10lksUkFczXWPKEYnMtzexv2Nczt6VtbfSDc=;
        b=uMW+ReFVepFHPX4F+7rP3ZbcK3k4d/g2dd59Tif0/uAUqNda3Ub27QKYshwafBCcdj
         5jr0qNBAgsUDfFEjXCMnJyfTaG0jvow7BhYAKnOP/4Yf+c9XiHY56K8ofHbrLCmUv72t
         JG2V9/TC58Dv38JD94TUpHYx4Uk2fm/TeEyd1IRohMDtjJ9bPiI3TehitPJ+Oj50YQCW
         90A15yjbFTuUXKv1UJFyIKr6+m3yp12eejQ1VV0FXi1Ey4RhtCRJcHNqHm7JW4epI9Zi
         cX/1meWvS3Ao+vIQlMs+v+cT4XYbICWvavSe5JKjitqq+fb1wpRPFKfpka4/a71uGqDx
         FoQw==
X-Gm-Message-State: AFqh2kppqKZOP8VoLhsdKemZQtlV+SxflEkoar51VuvTZEC208NJL38X
        KEdEr3c4t1xAAZT0ZwF/kqdRYG4BKAMLBw==
X-Google-Smtp-Source: AMrXdXtqFzEOIqXbcHUWQoco2kVJSDoRfvCgyLJrToPLXvi178jhopoT1OPkYoQhXz4E0zagcRYYo8XRfCMm9w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1951:0:b0:4fe:8186:e5fa with SMTP id
 78-20020a811951000000b004fe8186e5famr319964ywz.140.1674219597333; Fri, 20 Jan
 2023 04:59:57 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:59:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120125955.3453768-1-edumazet@google.com>
Subject: [PATCH net 0/3] netlink: annotate various data races
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent syzbot report came to my attention.

After addressing it, I also fixed other related races.

Eric Dumazet (3):
  netlink: annotate data races around nlk->portid
  netlink: annotate data races around dst_portid and dst_group
  netlink: annotate data races around sk_state

 net/netlink/af_netlink.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

-- 
2.39.1.405.gd4c25cc71f-goog

