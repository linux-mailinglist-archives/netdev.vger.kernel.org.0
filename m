Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBC7634E60
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiKWDgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiKWDgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:36:09 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5745D288B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:36:08 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b2-20020a170902d50200b001871a3c51afso12753190plg.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g6AFeiTfgPbT4isfR1/ptvsdMSk8ycycNtD2Jh7nuVI=;
        b=PCe8DMtFplBHmy4nm0tzBvhcdLE5WI7KZL8faVDpWSIR85ffm/ohsNJEyZb7WEYA6o
         m3LDXHXGRBvwipGnLxcXuVGrE7Rz/hCk3Fo4DQ9FPQ5n4B1+lXAQ+1QIG/5DzmTxXaSN
         kEp5lzrp3/dSBmrmtLW6hA5VtKXVt0mAod7QOLi4tkoJXCLTBmL6liNjJJ7ObD5BvGV0
         aJVls9rYvgS81LVDnsqTW2nUmKAMb5BNtoz8nkmZEJc0pj+uFck0wBiipYS5nkWptDbc
         lOVl0oabE0b7136aGD0o2GvK5Pgu4jx7s7at5k9MDI4mVG2rmaxbEAlDJW+8jnGZKszR
         W+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g6AFeiTfgPbT4isfR1/ptvsdMSk8ycycNtD2Jh7nuVI=;
        b=sNyg1z6nAjTRVRLtlBunbn/oaZhD9W6ow3BINaScykH4Vp0bVO4+XfUORSwYCGjzQ6
         6LyBm8Cs/idVDtxVjzhuu9lvpPbqeT5tuq66g3hNyPtzY3TrZc9pClajo3K4QSgjbeRk
         F9rDzGBdu2J4D1WD6XpD4dQxTZ/HIp0ZI+HwAICa30eGuF91QeRDvGWwo3xAhae4SxuO
         yPaqiEITlE0WzhDTnVWK0VLxwqvc50rdTAgLP7LRdJtcFVyJFkOjBVOAbm3HYhV4kBok
         JZc4f+FH9sX67PUZ8ajTa+pljp+5AHE+nbPP3TnxQsy65U2LAnxfSKnIp6VFDjHI3547
         Sl8Q==
X-Gm-Message-State: ANoB5pk0q/HPoJxYehN0RlE4Ukuty8tqmVXAHm8Ukh65xuvhaAIB4Ivt
        gzDACLyWg8tIqHv7EKTGUaQYVrhEU+EEFIo5TNFmi72C2GMvrw5Gq/KTqvMzsTltItlDHZXXIrg
        c2/6LbGgg7Dh+Q3wTlWu1Fbu+chISi6PrvTnTbhugTA23W3DNKGz8rcoSSxe4RGNYTQWHQrZUn0
        4UAg==
X-Google-Smtp-Source: AA0mqf676df6Wx5XlgBEaXk4QfL66shqR1g4Sl1LlbvDmIKOJrsWP4BzF9s157RMNROO4VbIz8lcHsXzlZ7VsIVT64o=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:90a:fa8b:b0:213:2708:8dc3 with
 SMTP id cu11-20020a17090afa8b00b0021327088dc3mr2576558pjb.2.1669174567750;
 Tue, 22 Nov 2022 19:36:07 -0800 (PST)
Date:   Wed, 23 Nov 2022 03:34:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123033456.1187746-1-benedictwong@google.com>
Subject: [PATCH v2 ipsec] Fixing support for nested XFRM-I tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
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

v1 -> v2: Rebased; reference to xi removed, updated patch to check if_id


