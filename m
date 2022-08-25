Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904D25A0B00
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbiHYIEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiHYIE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:04:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E86CD0D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z8so4429188edb.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=kZCG6mr5prEgDLM6IFNP8WNgtzlDBGEApnkHijsP2bc=;
        b=vAqO/8Oq4twh+T5xQqNeNvZkgWO0+/WIaiYga8GqeKSkUTxh3iaHBfObmYFbWwWAht
         lBSxjx5N3Jl8gIA5G4rk3Wzv1E2Tf236reR1QowL/Wzbu1sBGETvLEd5DZV6tuQRHvsK
         z9wN3II/OIaDbH3hW6quEHdqL0JsGO2mZzg15OC07agdlxypDfM/UF1dPWIsuqsiiLKR
         ciuy3maHHSuwCZE0I8QRnGYA8eTTiau6AlDZM1ksHMU/k/r1o9jQeNesI4gS+YkaQ3pj
         cz7LmUyh9TjqQS6YzrTuCUDSQCVg5H8VYhcUpf8QF6rKOzJzNVg6I0ec9oePMj2kpGNq
         3fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=kZCG6mr5prEgDLM6IFNP8WNgtzlDBGEApnkHijsP2bc=;
        b=1bZZD+njfP/n8Zvfl5oVcTtzvNOzkvRD41Tk6Gw3hvqsADRxJ8PCefMrXs0vMyr7Zx
         jzPr938L1zR2h9T/t+IwuoG3yR9Uvl7vM2UW0iZtLesPhHiaBQdJ1x3kh+MO+/H269Gs
         5cQiB6mO1xGeBF+Dz34DC01xOeTOHrIilx1jFu3TKfzDXimfUA+Xjz8APxFU0zhTUKZY
         /TnDbPJQTJ4/4q/7+2p0muahMtvLd8Z8P6FxHwAxOk0roj0IHl204yWa6CShNeTBWrJR
         PqG23fJoppja3YFtA6V2WwsaUJe7QfLOCzQbc+uy6kS2wJYqVR8NjABTjV8RHRzZDGtH
         n8UA==
X-Gm-Message-State: ACgBeo315kMKkIWxREdhnjVwc/+9buFRN+rUozhbTCxFoa/CfYir28Hw
        ea/UhNqbm1coMhGCO1G9oRg3EOZ99bSKKHxu
X-Google-Smtp-Source: AA6agR7EIOjZrae4EUVp9wcHvGsG1BYyDCETn7LKOGdU7e0ruEGJqEdomEGrPwbVdrVF77ZyNyBarA==
X-Received: by 2002:a05:6402:524e:b0:446:9ebb:7134 with SMTP id t14-20020a056402524e00b004469ebb7134mr2123143edd.284.1661414661830;
        Thu, 25 Aug 2022 01:04:21 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 14-20020a170906318e00b0073d6ab5bcaasm2057702ejy.212.2022.08.25.01.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:04:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com,
        vikas.gupta@broadcom.com, jacob.e.keller@intel.com,
        kuba@kernel.org, moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2-next 0/2] devlink: allow parallel commands
Date:   Thu, 25 Aug 2022 10:04:18 +0200
Message-Id: <20220825080420.1282569-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
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

This patchset contains couple of small patches that allow user to run
devlink commands in parallel, if kernel is capable of doing so.

Jiri Pirko (2):
  devlink: load port-ifname map on demand
  devlink: fix parallel flash notifications processing

 devlink/devlink.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

-- 
2.37.1

