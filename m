Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04A55DAB3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiF0NzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiF0NzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:55:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D56631F
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:04 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id pk21so19384872ejb.2
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SfoYsWd57yKqNv7iQd6/6QquGaCdlwXHJFF4B/euNcI=;
        b=3Kp1pjScC8HuywBFZbsdkwqLjKjnP6fYIAJHwCWgne+582a9ald4AUpC4zbVx1FaH2
         mzZrQsAuhu/I7XlYm3Rvs3r4PLK9J153fzSFQ2vnA/kUtYZL1kZoQnTTav4dxzy84zdn
         lH51ZkAtMROnJvqPj0trTbho4y7FvCmAVvj2fx4neD200uu8kJkD9N+I0U3m/eS+i1kI
         mnu1xxq0M01hr5bYyS733uSR2qnfVDB764Febv9Hi416ocoR3sm/wg0/hKILtHavh4ww
         Ob7TIfXqPZO9Lo1t6FIKMvQA4/hEfe3CULMP7CYtik/M/yUQF6rA5zMshIX4ZCXA8uXt
         SSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SfoYsWd57yKqNv7iQd6/6QquGaCdlwXHJFF4B/euNcI=;
        b=0K30XT4rNZAG2mOnoRYuTgmLd6qPUAXRGiSLEfsX54YV1tTWjOVkEKO7ec5F/aGpOb
         eFWYlBA2HTHHpzeUYdCHTrin0AvNJ7DeBVehiXTJuv4sbGEmK2BVYVIE13Qf6+x7stDk
         eFJX8bOtkY8mPK1ALGuKWquRTz0LEAlhaNzRSY1A1R882SKaJ1u4MqeewgVig5VbjnO2
         49evegPo/7bYwfbA8l8Du5soqrZQfJviqPt2kbKZY+OCL4uLOFwF5GtGQgp3EJHIdxKf
         CRYZ9gMeopnbJrGxjFHXNbKfbHAofwYpoi0Remvzft1fhHMbvcwO+mCvNtUbQedQJNAh
         gedw==
X-Gm-Message-State: AJIora/ahW9hgVCVB9tJzsuv1m8WKUJ4o4qYBX2mjDyEyQ1obQ45YXgL
        CqCdnDUtL64YmVkHa1AAYVFJrJ/sIfDkcecc1GI=
X-Google-Smtp-Source: AGRyM1tX7p+9lyfpNxHW1PsgH2chAR9R1IkclT5D0fjqcTwVb/aCybiaOpi/q/me2ltfULbfYti3Jg==
X-Received: by 2002:a17:906:7955:b0:726:a858:5a75 with SMTP id l21-20020a170906795500b00726a8585a75mr3939770ejo.764.1656338102696;
        Mon, 27 Jun 2022 06:55:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d25-20020a50fe99000000b004355998ec1asm7555305edt.14.2022.06.27.06.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 06:55:02 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Date:   Mon, 27 Jun 2022 15:54:59 +0200
Message-Id: <20220627135501.713980-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This is an attempt to remove use of devlink_mutex. This is a global lock
taken for every user command. That causes that long operations performed
on one devlink instance (like flash update) are blocking other
operations on different instances.

The first patch makes sure that the xarray that holds devlink pointers
is possible to be safely iterated.

The second patch moves the user command mutex to be per-devlink.

Jiri Pirko (2):
  net: devlink: make sure that devlink_try_get() works with valid
    pointer during xarray iteration
  net: devlink: replace devlink_mutex by per-devlink lock

 net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
 1 file changed, 161 insertions(+), 95 deletions(-)

-- 
2.35.3

