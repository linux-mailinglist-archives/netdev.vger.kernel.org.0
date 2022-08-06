Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7219658B3DA
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 06:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiHFEn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 00:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFEnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 00:43:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B237911154
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 21:43:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f13-20020a170902ce8d00b0016eebfe70fcso2651831plg.7
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 21:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=hL4+dcIAykWvL5B8b05LO9+AgXsm+UEWm/9mz+cYd78=;
        b=kRzXtu9QrhmuaqDdJ5nX3ZOPVgHn9In4oFu881sSeJ5OsTwKsGMz1QNIIVBYnzFiDY
         O6w1nw4C49Dx+NeEzJvEfGeGn3wQd4BLKN/h0AyNOh1iRcJXW4ym2w/A1t5zprwfYUvS
         U1oki6T5dF5y8sc1lwBP/jB/So0Ghbt/C7j7oW0W+tc/E+GEq7wiBcI31cN7CDhUML7x
         2yp7auWgxrRRtPFbp7bk8FZmlGKXdoqCkyrP9Vb6tmIUHGKjUvJZAhKBuYNr8So81Fh/
         2h0FkV9zmuwY7GGhCN3CmeH5di285dCy7tbMZ0b3qMF/NcGFM0RhNJQWsViY5Nekl+Dh
         qvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc:content-transfer-encoding;
        bh=hL4+dcIAykWvL5B8b05LO9+AgXsm+UEWm/9mz+cYd78=;
        b=wqAKxFQ3DdfSoGmd0TstVzdJEySaerY8da8fve6iOIGBTCjzCIO3Y+aKEhzEmbhF/4
         zg1+SQ9EAJEWK2g6EHj0oM6RxWiGfP9AAT5AdxAoYdtGOtM3gfEQJ7T6CRA+4Ev9m+AS
         C+FSqPYI74UTtik2P2q6ezGmJdQr/bOtjLXdtgJVUO6ZLKCO+3HoSn7BB2KXJ+sOkJut
         gq1W04ikNiu1A5wZw0PDJtj92fwa07k/IBERJGyo3ynGD+cyTBaviJyUGFRbznDtkc5B
         T35Hxm5NCC7MnvCVfxMFAt2z5kv/MjjAbTewVtBcpBMUAG68EooV5AV9EV4nJ9+4ZBF1
         9jEQ==
X-Gm-Message-State: ACgBeo1Rb2c9dyOsy7Hx1+bhWUf/JC29pUpy2IJaFJqxBtTdWCur8G/R
        HW/KI6V3TbSRZW9DpB6Y9spJh9HPX2SmssZm5iRpU7BWnNw68LKVXQIZ0i9rUI2JD9M43lGBbgN
        DqVOx/zFHqX0R/JrzVTHP1ImLVbvv4aFYobVjFFuRR7A0h9Y85qUzlDA2tSfjBHkLgsdt+YS/DR
        mxeg==
X-Google-Smtp-Source: AA6agR46SUkZ0LjERQiXdfUQO0MlKGKvwqJRM6RwGMqgxl8APqGZZE5uJ9rClawYtX2bDbdnOZ0LSm/lDrOGiKXufb8=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a63:ec04:0:b0:41c:1149:4523 with SMTP
 id j4-20020a63ec04000000b0041c11494523mr7971515pgh.62.1659761004187; Fri, 05
 Aug 2022 21:43:24 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Sat,  6 Aug 2022 04:43:05 +0000
Message-Id: <20220806044307.4007851-1-benedictwong@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC ipsec 0/2] xfrm: Fix bugs in supporting stacked XFRM-I tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes bugs that prevent stacked IPsec tunnels (via XFRM
interfaces) from receiving packets properly. The apparent cause of the issu=
es
is that the inner tunnel=E2=80=99s policy checks fail to validate the outer=
 tunnel=E2=80=99s
secpath entries (since it no longer has a reference to the outer tunnel
policies, and each call validates ALL secpath entries) prior to verifying t=
he
inner tunnel=E2=80=99s. This patch set fixes this by caching the list of ve=
rified
secpath entries, and skipping them upon future validation runs.

PATCH 1/2 Ensures that policies for nested tunnel mode transforms are check=
ed
before additional decapsulation. This ensures that entries in the secpath a=
re
verified while the context (intermediate IP addresses, marks, etc) can be
appropriately matched.

PATCH 2/2 Skips template matching for previously verified entries in the
secpath. This ensures that each tunnel is responsible for incrementally
verifying the secpath entries associated with it.



