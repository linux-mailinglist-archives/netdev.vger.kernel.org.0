Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED234D674D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349557AbiCKRNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237571AbiCKRNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:13:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA8E17ABD
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:12:27 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m22so8750277pja.0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=dZsrMTVQdfC9r5+u2q1ukpbsssyItRQi/vxxu0QZF3o=;
        b=aAOgAy0/a4JVYu3+5AHT0hfihewyjTOYdTs+OJG5+EgVjDI6FwoHx3ujzP1v93Rpuq
         HZeE2PEFLPNgcRo1M/xK0g2snVzYJXGntuTss09oMzxCfrynQ9vOFFV39RnU9uxlYtG9
         IOEcaX1Ob9uQg8eq4vMMmiQzQNjNcylt3AJRURvF/qLOwRrmkPqZeFjOmnIXetpfAg0C
         LNfAN7yQ0Gy1wIn7ALRFmaTH391XV8CSLparansKuyuHCT6SjDIZJ1IptppnG8exbIAG
         dMEcr5jC1LykrZGZuMOy1KjK1P4B41pYWe5zYsR3FsuFAefjw7UqPPGyYv4wKHzm3cDJ
         EhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=dZsrMTVQdfC9r5+u2q1ukpbsssyItRQi/vxxu0QZF3o=;
        b=Bczq9AyAFGJcPEu1745jO0Gkpu9OJYdASwLRxwYoycBPsE+r4VzMhkeAuijt2zMs/n
         sfZSdgM6Qj3XGAQg65H8XvQS6kJiUoRLBxii7bxux7wvQM4K7rR44QWQDsMOSgnAJgPo
         1aERU1aPpcL9YVOEsJ7vQVR5p4se7kaj3YAPjawjZuugU1nQtePvHBJzo5gzcHd/d2Uc
         wCLXFiQq4Z2rosqaQMc+PWHsPqKmy4EQqQBxUHCK0frapXzP9/HzP9HCZgfoD74Y4+fX
         X/jB+Axe6Pqe/jj/iDaw9/LLGBg93A7KZYGVAEADt+Ro2/VhH0Obxn/YpQCpXWUU3hlp
         9nNw==
X-Gm-Message-State: AOAM533mvjmLqczu+wWUDrnP4g+JdtYNqf/80/BMCX1DbQy4fcKyJfME
        MSlWwSN4MRinbqIb4cntfmH7UBggbWU/Zg==
X-Google-Smtp-Source: ABdhPJxkt5aZs/8B/xjMfWeZgLOK/zSPtCqNDAJvMJFErBNL5dRVzX2IR6fUARYHEQDqrky6RGKSeg==
X-Received: by 2002:a17:902:6ac7:b0:150:24d6:b2ee with SMTP id i7-20020a1709026ac700b0015024d6b2eemr11590094plt.168.1647018746755;
        Fri, 11 Mar 2022 09:12:26 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aa38600b001bce781ce03sm9607970pjp.18.2022.03.11.09.12.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:12:26 -0800 (PST)
Date:   Fri, 11 Mar 2022 09:12:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215674] New: ip_compute_csum computes illegal zero
 checksum, should return ffff in such a case
Message-ID: <20220311091223.477970e6@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are not of uses of ip_compute_csum.

Begin forwarded message:

Date: Fri, 11 Mar 2022 11:47:49 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215674] New: ip_compute_csum computes illegal zero checksum, should return ffff in such a case


https://bugzilla.kernel.org/show_bug.cgi?id=215674

            Bug ID: 215674
           Summary: ip_compute_csum computes illegal zero checksum, should
                    return ffff in such a case
           Product: Networking
           Version: 2.5
    Kernel Version: 4.14.268
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: eyal.lotem@gmail.com
        Regression: No

A 0 checksum indicates the checksum is to not be validated, and an 0xffff
checksum indicates a zero result.

If the sum is computed to be 0, it should be substituted for 0xffff, to
indicate the actual zero checksum.

This bug went unnoticed for a long time, because in 2^-16 of computed
checksums, the incorrect result merely foregoes checksum validation, which is
likely to not trigger any noticeable errors.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
