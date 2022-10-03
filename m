Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42615F2CF9
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJCJNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJCJNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:13:21 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC0060D6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:12:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w18so6986885wro.7
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=yZTzwfKfVqbxxnj9yy3H3+bbGe++jpeOf58FHnc0Er0=;
        b=SvQhmMiuLGhALkZOJD7QJwcld/W8GPw5NkMLaPfPmW54iF9tGbHNYZD/fvey9LFiTw
         0sCe3p+WFbeKavUE/W805/Z25uf6hw8cYf+MM3uJA7zx4V1iciG2+P5fGGLUN77TISjA
         NAEYd+JBk/eatewCsaIC0NbYlkBID48TyBBbxedm4/g1tkv5pTaGtIeCUzAAg1S/gy6K
         QUeoHSCS4OHf1a8EVNLkg6G9EDJicgjqsQplFjRxiNjy++dDPs6PSkXsoRXTp/6Z7KOT
         Trw3fd+T0gfIrpws+bUg2BJFhZVZ8WcBtDb76VhCMy1RDt+uvlwTHLhKX7v6unnWw7xn
         IcWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=yZTzwfKfVqbxxnj9yy3H3+bbGe++jpeOf58FHnc0Er0=;
        b=PkP/O7DKJMiSlRr8PU/9E+pdw4MII6I68nf4yEXqmDSGb3GXuodY1Xzp0sdY/QFVoe
         RNIOBFuTgjpHxGxQ46gRyJC1sS6BDHobJ+xjsWh8JCFrZjLFYL2Q66761HhReOIbFO6N
         9bkYZSgMzDKAbATFliX2BvlHZBpIJW3RY7MrWjdDC0+1PsnnJRJZMJtS4LKieyBCkE90
         VwV6rd+MkI78tGs6xqVXjF5B9YyofRNsaG5lN7aZU5QhQraJ2eFGzThRBp3Dx5QQgfp9
         p96IIEDzN3URlwJ9M4XAZLiKhsaHZ+wwSM3VSRfO7j0LdMuBQfDo/N85RatBxe7u7u3A
         EbHw==
X-Gm-Message-State: ACrzQf2eQA2y9ZwI5cXWxTr0ExptwxAUXl89/nM+q5sifBNBcOPPtrNg
        a+N6Y0EXqLc61kS7nmyPdThWDJkLyLA=
X-Google-Smtp-Source: AMsMyM5wLis3XGw9paHG7RPGnzzxB4D0uu+0FxBChsdahWSQY9cESPmsFunwfKw6kywfZRxB4xU6Mw==
X-Received: by 2002:adf:fe4e:0:b0:22e:3245:55ae with SMTP id m14-20020adffe4e000000b0022e324555aemr5099683wrs.395.1664788351965;
        Mon, 03 Oct 2022 02:12:31 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id bx10-20020a5d5b0a000000b00228fa832b7asm9512887wrb.52.2022.10.03.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:12:31 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        steffen.klassert@secunet.com, nicolas.dichtel@6wind.com,
        razor@blackwall.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2-next 0/2] ip: xfrm: support "external" mode for xfrm interfaces
Date:   Mon,  3 Oct 2022 12:12:10 +0300
Message-Id: <20221003091212.4017603-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for configuring XFRM interfaces in "external"
mode as recently merged.

Eyal Birger (2):
  ip: xfrm: support "external" (`collect_md`) mode in xfrm interfaces
  ip: xfrm: support adding xfrm metadata as lwtunnel info in routes

 include/uapi/linux/if_link.h  |  1 +
 include/uapi/linux/lwtunnel.h | 10 +++++
 ip/iproute.c                  |  5 ++-
 ip/iproute_lwtunnel.c         | 83 +++++++++++++++++++++++++++++++++++
 ip/link_xfrm.c                | 18 ++++++++
 man/man8/ip-link.8.in         |  7 +++
 man/man8/ip-route.8.in        | 11 +++++
 7 files changed, 133 insertions(+), 2 deletions(-)

-- 
2.34.1

