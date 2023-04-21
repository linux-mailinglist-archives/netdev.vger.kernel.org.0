Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A86EA527
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjDUHr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjDUHr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:47:27 -0400
Received: from mail-ej1-x663.google.com (mail-ej1-x663.google.com [IPv6:2a00:1450:4864:20::663])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896F42D56
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
Received: by mail-ej1-x663.google.com with SMTP id a640c23a62f3a-94eff00bcdaso212208066b.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VZZP5lnWV83niQ0DLV1V/6BEdL8d4wfdJggAdOPFhLg=;
        b=a2tyqbFYxNgoPW+JV9ldTZ3kcY9UDyWzHP0jLNNPUR67fLMMD9UuRw1xeDWpVhm09J
         sioBBZE/Fuq3XzQTNP7aydkCEUwbpE7yPvuYWVS/KXMcZ3zVw2uOd08PBhCKmlD3vkhG
         zKGEyc9syd8BQVIZNWdYLE1R/FUHM+hT2XIDR+FGi/PJlrGqS8LpdWXDrS5oDyYcAXKf
         a1xwjly7CEn7B53fDqLl9QKjvQ2GxzlzncbpN1oj8yvZ4lB3bLCGCzij1WqYKhO7KhD0
         qa/YEHNQuHHZsxGzwHLyGIeyT2zQbF5T/N1QgHH1ttubrYeStZuX6/Fy0UjS/w/2I+y1
         C/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682063243; x=1684655243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VZZP5lnWV83niQ0DLV1V/6BEdL8d4wfdJggAdOPFhLg=;
        b=YoJC+TbDxefjhWNyCbeVitZLOkocqNAtXA5PEFVGCFbtW7/VRanS7RSsQXG4PU8t5i
         G+uAOEZ0Oz0qRplqOwGZbo5kjwKNRhzKJsf4z8HmLceLKCCb1Kq0GGTv57TEFZy0MZth
         +rrsSEmXtTEqXwR8jZeQ4gqMpBY5euRXXWA1M98PhQ5Rzc27nAj8hb37/FpM1EEgfCJW
         vPlNZMVQHMMrI/jEiRNRguCSiYwAMQFnJJCHmRQHEu66L9ZcwFcm8wJEagJ8RQ5Qr+NX
         JxR2Try6mzYWDsIMoViWU2NEscBalMzptYguTru/EPbm3g3shOpePFMO4Bu1TdhZZVIt
         gFZQ==
X-Gm-Message-State: AAQBX9eAOwGAu3M21cmLv+lyTbRjbv9zgN5Mc3OB55bw1K9Kgd6B4VWe
        7IM31pcRJPgeX1Jfh8xLWfhOZRge/N84ax+TuxmtxLB+KiD9hg==
X-Google-Smtp-Source: AKy350bGUP4HYMUh7pmc8K085XmxwicngGUMgWjjt3JFm5RONg4A67PcDS+lAuDUxJLlE/H1ICUez6ojDjxE
X-Received: by 2002:a17:906:d72:b0:94e:ec0f:455 with SMTP id s18-20020a1709060d7200b0094eec0f0455mr1662771ejh.54.1682063242843;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id h12-20020a17090619cc00b00947a7598568sm627994ejd.108.2023.04.21.00.47.22;
        Fri, 21 Apr 2023 00:47:22 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 89F056011D;
        Fri, 21 Apr 2023 09:47:22 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1pplUI-00089b-Ep; Fri, 21 Apr 2023 09:47:22 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH iproute2 v3 0/2] iplink: update doc related to the 'netns' arg
Date:   Fri, 21 Apr 2023 09:47:18 +0200
Message-Id: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 -> v3:
 - make doc about netns arg consistent between 'add' and 'set'

v1 -> v2:
 - add patch 1/2
 - s/NETNS_FILE/NETNSFILE
 - describe NETNSNAME in the DESCRIPTION section of man pages

 ip/iplink.c           |  4 ++--
 man/man8/ip-link.8.in | 26 +++++++++++++++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

Regards,
Nicolas

